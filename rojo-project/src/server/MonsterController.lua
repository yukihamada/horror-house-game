-- MonsterController.lua
-- モンスターの動きと行動を制御するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- 共有設定の読み込み
local MonsterConfig = require(ReplicatedStorage.Shared.MonsterConfig)
local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

local MonsterController = {}
MonsterController.ActiveMonsters = {}

-- モンスターを生成する関数
function MonsterController.SpawnMonster(monsterType, position)
    monsterType = monsterType or MonsterConfig.GetRandomType()
    position = position or MonsterConfig.GetRandomSpawnLocation()
    
    local settings = MonsterConfig.Settings[monsterType]
    if not settings then
        warn("無効なモンスタータイプ: " .. tostring(monsterType))
        return nil
    end
    
    -- 難易度に基づく設定の調整
    local difficultySettings = GameConfig.GetDifficultySettings()
    local adjustedSpeed = settings.speed * difficultySettings.MonsterSpeedMultiplier
    local adjustedDamage = settings.damage * difficultySettings.MonsterDamageMultiplier
    
    -- モンスターモデルの取得または作成
    local monster = nil
    
    -- モデルがServerStorageにあるか確認
    local modelFolder = ServerStorage:FindFirstChild("MonsterModels")
    if modelFolder and modelFolder:FindFirstChild(settings.model) then
        monster = modelFolder:FindFirstChild(settings.model):Clone()
    else
        -- モデルがない場合は基本的なモデルを作成
        monster = Instance.new("Model")
        monster.Name = settings.model
        
        local torso = Instance.new("Part")
        torso.Name = "Torso"
        torso.Size = Vector3.new(2, 2, 1)
        torso.Position = position
        torso.BrickColor = BrickColor.new("Really black")
        torso.Anchored = false
        torso.CanCollide = true
        torso.Parent = monster
        
        local head = Instance.new("Part")
        head.Name = "Head"
        head.Size = Vector3.new(1, 1, 1)
        head.Position = position + Vector3.new(0, 1.5, 0)
        head.BrickColor = BrickColor.new("Really red")
        head.Anchored = false
        head.CanCollide = true
        head.Parent = monster
        
        -- 首のウェルド
        local neckWeld = Instance.new("Weld")
        neckWeld.Part0 = torso
        neckWeld.Part1 = head
        neckWeld.C0 = CFrame.new(0, 1, 0)
        neckWeld.Parent = torso
        
        -- ヒューマノイドの追加
        local humanoid = Instance.new("Humanoid")
        humanoid.Parent = monster
        
        -- プライマリパーツの設定
        monster.PrimaryPart = torso
    end
    
    -- モンスターの設定
    local humanoid = monster:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = adjustedSpeed
        humanoid.MaxHealth = settings.health
        humanoid.Health = settings.health
    end
    
    -- カスタムプロパティの設定
    local attributes = {
        Type = monsterType,
        Damage = adjustedDamage,
        DetectionRange = settings.detectionRange,
        AttackRange = settings.attackRange,
        AttackCooldown = settings.attackCooldown,
        LastAttackTime = 0
    }
    
    for name, value in pairs(attributes) do
        monster:SetAttribute(name, value)
    end
    
    -- モンスターをワークスペースに配置
    monster:SetPrimaryPartCFrame(CFrame.new(position))
    monster.Parent = workspace
    
    -- アクティブモンスターリストに追加
    table.insert(MonsterController.ActiveMonsters, monster)
    
    -- モンスターの動きを開始
    MonsterController.StartBehavior(monster)
    
    return monster
end

-- モンスターの行動を開始する関数
function MonsterController.StartBehavior(monster)
    if not monster or not monster.Parent then return end
    
    local humanoid = monster:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- モンスターの状態
    local state = "Idle" -- Idle, Chasing, Attacking
    local targetPlayer = nil
    local lastAttackTime = 0
    
    -- 行動ループ
    spawn(function()
        while monster and monster.Parent and humanoid.Health > 0 do
            -- 最も近いプレイヤーを探す
            local closestPlayer, closestDistance = MonsterController.FindClosestPlayer(monster)
            
            -- 状態の更新
            if closestPlayer and closestDistance <= monster:GetAttribute("AttackRange") then
                -- 攻撃範囲内
                state = "Attacking"
                targetPlayer = closestPlayer
            elseif closestPlayer and closestDistance <= monster:GetAttribute("DetectionRange") then
                -- 検知範囲内
                state = "Chasing"
                targetPlayer = closestPlayer
            else
                -- 範囲外
                state = "Idle"
                targetPlayer = nil
            end
            
            -- 状態に基づく行動
            if state == "Attacking" and targetPlayer then
                -- 攻撃
                local currentTime = tick()
                if currentTime - lastAttackTime >= monster:GetAttribute("AttackCooldown") then
                    MonsterController.AttackPlayer(monster, targetPlayer)
                    lastAttackTime = currentTime
                end
            elseif state == "Chasing" and targetPlayer then
                -- 追跡
                local targetPosition = targetPlayer.Character and targetPlayer.Character:GetPrimaryPartCFrame().Position
                if targetPosition then
                    humanoid:MoveTo(targetPosition)
                end
            else
                -- 徘徊
                MonsterController.Wander(monster)
            end
            
            -- 少し待機
            wait(0.5)
        end
        
        -- モンスターが死亡または削除された場合
        MonsterController.RemoveMonster(monster)
    end)
end

-- プレイヤーを攻撃する関数
function MonsterController.AttackPlayer(monster, player)
    if not monster or not player or not player.Character then return end
    
    local damage = monster:GetAttribute("Damage") or 10
    local playerHumanoid = player.Character:FindFirstChild("Humanoid")
    
    if playerHumanoid and playerHumanoid.Health > 0 then
        playerHumanoid:TakeDamage(damage)
        print(monster.Name .. "が" .. player.Name .. "に" .. damage .. "ダメージを与えました")
        
        -- 攻撃エフェクト（サーバーサイド）
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        if torso then
            local attackEffect = Instance.new("ParticleEmitter")
            attackEffect.Color = ColorSequence.new(Color3.new(1, 0, 0))
            attackEffect.Size = NumberSequence.new(0.5)
            attackEffect.Lifetime = NumberRange.new(0.5)
            attackEffect.Rate = 50
            attackEffect.Speed = NumberRange.new(3)
            attackEffect.Parent = torso
            
            -- 0.3秒後にエフェクトを削除
            delay(0.3, function()
                attackEffect:Destroy()
            end)
        end
        
        -- 攻撃イベントの発火（クライアントサイドエフェクト用）
        -- ここにRemoteEventを使った実装を追加
    end
end

-- 最も近いプレイヤーを見つける関数
function MonsterController.FindClosestPlayer(monster)
    if not monster or not monster.PrimaryPart then return nil, math.huge end
    
    local monsterPosition = monster.PrimaryPart.Position
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character.PrimaryPart then
            local playerPosition = player.Character.PrimaryPart.Position
            local distance = (playerPosition - monsterPosition).Magnitude
            
            if distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

-- モンスターをランダムに徘徊させる関数
function MonsterController.Wander(monster)
    if not monster or not monster.PrimaryPart or not monster:FindFirstChild("Humanoid") then return end
    
    local currentPosition = monster.PrimaryPart.Position
    local wanderRadius = 20 -- 徘徊半径
    
    -- ランダムな方向と距離
    local angle = math.random() * math.pi * 2
    local distance = math.random(5, wanderRadius)
    
    -- 新しい位置を計算
    local newPosition = currentPosition + Vector3.new(
        math.cos(angle) * distance,
        0, -- Y座標は変更しない
        math.sin(angle) * distance
    )
    
    -- 移動
    monster.Humanoid:MoveTo(newPosition)
end

-- モンスターを削除する関数
function MonsterController.RemoveMonster(monster)
    if not monster then return end
    
    -- アクティブモンスターリストから削除
    for i, m in ipairs(MonsterController.ActiveMonsters) do
        if m == monster then
            table.remove(MonsterController.ActiveMonsters, i)
            break
        end
    end
    
    -- モンスターを削除
    if monster.Parent then
        monster:Destroy()
    end
end

-- すべてのモンスターを削除する関数
function MonsterController.RemoveAllMonsters()
    for i = #MonsterController.ActiveMonsters, 1, -1 do
        local monster = MonsterController.ActiveMonsters[i]
        if monster and monster.Parent then
            monster:Destroy()
        end
        table.remove(MonsterController.ActiveMonsters, i)
    end
end

return MonsterController