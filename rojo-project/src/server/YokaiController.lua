-- YokaiController.lua
-- 妖怪の動きと行動を制御するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- 共有設定の読み込み
local MonsterConfig = require(ReplicatedStorage.Shared.MonsterConfig)
local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

local YokaiController = {}
YokaiController.ActiveYokais = {}

-- 妖怪を生成する関数
function YokaiController.SpawnYokai(yokaiType, position)
    yokaiType = yokaiType or MonsterConfig.GetRandomType()
    position = position or MonsterConfig.GetRandomSpawnLocation()
    
    local settings = MonsterConfig.Settings[yokaiType]
    if not settings then
        warn("無効な妖怪タイプ: " .. tostring(yokaiType))
        return nil
    end
    
    -- 難易度に基づく設定の調整
    local difficultySettings = GameConfig.GetDifficultySettings()
    local adjustedSpeed = settings.speed * difficultySettings.MonsterSpeedMultiplier
    local adjustedDamage = settings.damage * difficultySettings.MonsterDamageMultiplier
    
    -- 妖怪モデルの取得または作成
    local yokai = nil
    
    -- モデルがServerStorageにあるか確認
    local modelFolder = ServerStorage:FindFirstChild("YokaiModels")
    if modelFolder and modelFolder:FindFirstChild(settings.model) then
        yokai = modelFolder:FindFirstChild(settings.model):Clone()
    else
        -- モデルがない場合は基本的なモデルを作成
        yokai = Instance.new("Model")
        yokai.Name = settings.model
        
        local torso = Instance.new("Part")
        torso.Name = "Torso"
        torso.Size = Vector3.new(2, 2, 1)
        torso.Position = position
        torso.Anchored = false
        torso.CanCollide = true
        torso.Parent = yokai
        
        local head = Instance.new("Part")
        head.Name = "Head"
        head.Shape = Enum.PartType.Ball
        head.Size = Vector3.new(1.2, 1.2, 1.2)
        head.Position = position + Vector3.new(0, 1.6, 0)
        head.Anchored = false
        head.CanCollide = true
        head.Parent = yokai
        
        local headWeld = Instance.new("Weld")
        headWeld.Part0 = torso
        headWeld.Part1 = head
        headWeld.C0 = CFrame.new(0, 1, 0)
        headWeld.Parent = head
        
        -- 妖怪タイプに応じた外観の調整
        if yokaiType == MonsterConfig.Types.YUREI then
            -- 幽霊
            torso.Transparency = 0.7
            head.Transparency = 0.7
            torso.Material = Enum.Material.Neon
            head.Material = Enum.Material.Neon
            torso.BrickColor = BrickColor.new("Institutional white")
            head.BrickColor = BrickColor.new("Institutional white")
            
            -- 白い着物
            local kimono = Instance.new("Part")
            kimono.Name = "Kimono"
            kimono.Size = Vector3.new(2.5, 3, 1.2)
            kimono.Position = position + Vector3.new(0, -0.5, 0)
            kimono.BrickColor = BrickColor.new("Institutional white")
            kimono.Material = Enum.Material.Fabric
            kimono.Transparency = 0.5
            kimono.Anchored = false
            kimono.CanCollide = false
            kimono.Parent = yokai
            
            local kimonoWeld = Instance.new("Weld")
            kimonoWeld.Part0 = torso
            kimonoWeld.Part1 = kimono
            kimonoWeld.C0 = CFrame.new(0, -0.5, 0)
            kimonoWeld.Parent = kimono
            
            -- 長い黒髪
            local hair = Instance.new("Part")
            hair.Name = "Hair"
            hair.Size = Vector3.new(1.5, 2, 0.2)
            hair.Position = head.Position + Vector3.new(0, 0, -0.7)
            hair.BrickColor = BrickColor.new("Really black")
            hair.Material = Enum.Material.Fabric
            hair.Anchored = false
            hair.CanCollide = false
            hair.Parent = yokai
            
            local hairWeld = Instance.new("Weld")
            hairWeld.Part0 = head
            hairWeld.Part1 = hair
            hairWeld.C0 = CFrame.new(0, 0, -0.7)
            hairWeld.Parent = hair
            
            -- 浮遊エフェクト
            local floatAttachment = Instance.new("Attachment")
            floatAttachment.Parent = torso
            
            local levitate = Instance.new("BodyPosition")
            levitate.MaxForce = Vector3.new(0, math.huge, 0)
            levitate.Position = position + Vector3.new(0, 1, 0)
            levitate.P = 10000
            levitate.D = 1000
            levitate.Parent = torso
            
            -- 幽霊の光
            local light = Instance.new("PointLight")
            light.Brightness = 1
            light.Color = Color3.fromRGB(200, 200, 255)
            light.Range = 10
            light.Parent = head
            
        elseif yokaiType == MonsterConfig.Types.KAPPA then
            -- 河童
            torso.BrickColor = BrickColor.new("Bright green")
            head.BrickColor = BrickColor.new("Bright green")
            torso.Material = Enum.Material.SmoothPlastic
            head.Material = Enum.Material.SmoothPlastic
            
            -- 甲羅
            local shell = Instance.new("Part")
            shell.Name = "Shell"
            shell.Shape = Enum.PartType.Cylinder
            shell.Size = Vector3.new(2.2, 1.5, 2.2)
            shell.CFrame = CFrame.new(position) * CFrame.Angles(0, 0, math.rad(90))
            shell.BrickColor = BrickColor.new("Brown")
            shell.Material = Enum.Material.Wood
            shell.Anchored = false
            shell.CanCollide = false
            shell.Parent = yokai
            
            local shellWeld = Instance.new("Weld")
            shellWeld.Part0 = torso
            shellWeld.Part1 = shell
            shellWeld.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
            shellWeld.Parent = shell
            
            -- 皿
            local plate = Instance.new("Part")
            plate.Name = "Plate"
            plate.Shape = Enum.PartType.Cylinder
            plate.Size = Vector3.new(0.2, 1, 1)
            plate.CFrame = CFrame.new(head.Position + Vector3.new(0, 0.6, 0)) * CFrame.Angles(0, 0, math.rad(90))
            plate.BrickColor = BrickColor.new("Bright blue")
            plate.Material = Enum.Material.SmoothPlastic
            plate.Anchored = false
            plate.CanCollide = false
            plate.Parent = yokai
            
            local plateWeld = Instance.new("Weld")
            plateWeld.Part0 = head
            plateWeld.Part1 = plate
            plateWeld.C0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90))
            plateWeld.Parent = plate
            
        elseif yokaiType == MonsterConfig.Types.ONI then
            -- 鬼
            torso.BrickColor = BrickColor.new("Really red")
            head.BrickColor = BrickColor.new("Really red")
            torso.Material = Enum.Material.SmoothPlastic
            head.Material = Enum.Material.SmoothPlastic
            torso.Size = Vector3.new(3, 3, 1.5)
            head.Size = Vector3.new(1.8, 1.8, 1.8)
            
            -- 角を追加
            local horn1 = Instance.new("Part")
            horn1.Name = "Horn1"
            horn1.Size = Vector3.new(0.5, 1.2, 0.5)
            horn1.Position = head.Position + Vector3.new(0.6, 0.8, 0)
            horn1.BrickColor = BrickColor.new("Institutional white")
            horn1.Material = Enum.Material.SmoothPlastic
            horn1.Anchored = false
            horn1.CanCollide = false
            horn1.Parent = yokai
            
            local horn1Weld = Instance.new("Weld")
            horn1Weld.Part0 = head
            horn1Weld.Part1 = horn1
            horn1Weld.C0 = CFrame.new(0.6, 0.8, 0)
            horn1Weld.Parent = horn1
            
            local horn2 = Instance.new("Part")
            horn2.Name = "Horn2"
            horn2.Size = Vector3.new(0.5, 1.2, 0.5)
            horn2.Position = head.Position + Vector3.new(-0.6, 0.8, 0)
            horn2.BrickColor = BrickColor.new("Institutional white")
            horn2.Material = Enum.Material.SmoothPlastic
            horn2.Anchored = false
            horn2.CanCollide = false
            horn2.Parent = yokai
            
            local horn2Weld = Instance.new("Weld")
            horn2Weld.Part0 = head
            horn2Weld.Part1 = horn2
            horn2Weld.C0 = CFrame.new(-0.6, 0.8, 0)
            horn2Weld.Parent = horn2
            
            -- 金棒
            local club = Instance.new("Part")
            club.Name = "Club"
            club.Size = Vector3.new(1, 5, 1)
            club.Position = position + Vector3.new(2, 0, 0)
            club.BrickColor = BrickColor.new("Really black")
            club.Material = Enum.Material.Metal
            club.Anchored = false
            club.CanCollide = false
            club.Parent = yokai
            
            local clubWeld = Instance.new("Weld")
            clubWeld.Part0 = torso
            clubWeld.Part1 = club
            clubWeld.C0 = CFrame.new(2, 0, 0)
            clubWeld.Parent = club
            
            -- 鬼の虎柄の腰巻き
            local loincloth = Instance.new("Part")
            loincloth.Name = "Loincloth"
            loincloth.Size = Vector3.new(3.2, 1.5, 1.6)
            loincloth.Position = position + Vector3.new(0, -1, 0)
            loincloth.BrickColor = BrickColor.new("Bright yellow")
            loincloth.Material = Enum.Material.Fabric
            loincloth.Anchored = false
            loincloth.CanCollide = false
            loincloth.Parent = yokai
            
            local loinclothWeld = Instance.new("Weld")
            loinclothWeld.Part0 = torso
            loinclothWeld.Part1 = loincloth
            loinclothWeld.C0 = CFrame.new(0, -1, 0)
            loinclothWeld.Parent = loincloth
            
        elseif yokaiType == MonsterConfig.Types.KITSUNE then
            -- 狐
            torso.BrickColor = BrickColor.new("Bright orange")
            head.BrickColor = BrickColor.new("Bright orange")
            torso.Material = Enum.Material.Fabric
            head.Material = Enum.Material.Fabric
            
            -- 狐の耳
            local ear1 = Instance.new("Part")
            ear1.Name = "Ear1"
            ear1.Size = Vector3.new(0.4, 0.8, 0.4)
            ear1.Position = head.Position + Vector3.new(0.5, 0.6, 0)
            ear1.BrickColor = BrickColor.new("Bright orange")
            ear1.Material = Enum.Material.Fabric
            ear1.Anchored = false
            ear1.CanCollide = false
            ear1.Parent = yokai
            
            local ear1Weld = Instance.new("Weld")
            ear1Weld.Part0 = head
            ear1Weld.Part1 = ear1
            ear1Weld.C0 = CFrame.new(0.5, 0.6, 0)
            ear1Weld.Parent = ear1
            
            local ear2 = Instance.new("Part")
            ear2.Name = "Ear2"
            ear2.Size = Vector3.new(0.4, 0.8, 0.4)
            ear2.Position = head.Position + Vector3.new(-0.5, 0.6, 0)
            ear2.BrickColor = BrickColor.new("Bright orange")
            ear2.Material = Enum.Material.Fabric
            ear2.Anchored = false
            ear2.CanCollide = false
            ear2.Parent = yokai
            
            local ear2Weld = Instance.new("Weld")
            ear2Weld.Part0 = head
            ear2Weld.Part1 = ear2
            ear2Weld.C0 = CFrame.new(-0.5, 0.6, 0)
            ear2Weld.Parent = ear2
            
            -- 狐の尻尾
            local tail = Instance.new("Part")
            tail.Name = "Tail"
            tail.Size = Vector3.new(0.8, 0.8, 3)
            tail.Position = position + Vector3.new(0, 0, 2)
            tail.BrickColor = BrickColor.new("Bright orange")
            tail.Material = Enum.Material.Fabric
            tail.Anchored = false
            tail.CanCollide = false
            tail.Parent = yokai
            
            local tailWeld = Instance.new("Weld")
            tailWeld.Part0 = torso
            tailWeld.Part1 = tail
            tailWeld.C0 = CFrame.new(0, 0, 2)
            tailWeld.Parent = tail
            
            -- 白い胸毛
            local chest = Instance.new("Part")
            chest.Name = "Chest"
            chest.Size = Vector3.new(1.5, 1.5, 0.2)
            chest.Position = position + Vector3.new(0, 0, -0.6)
            chest.BrickColor = BrickColor.new("White")
            chest.Material = Enum.Material.Fabric
            chest.Anchored = false
            chest.CanCollide = false
            chest.Parent = yokai
            
            local chestWeld = Instance.new("Weld")
            chestWeld.Part0 = torso
            chestWeld.Part1 = chest
            chestWeld.C0 = CFrame.new(0, 0, -0.6)
            chestWeld.Parent = chest
            
            -- 狐火（青い炎）
            local foxfire = Instance.new("Part")
            foxfire.Name = "Foxfire"
            foxfire.Size = Vector3.new(1, 1, 1)
            foxfire.Shape = Enum.PartType.Ball
            foxfire.Position = position + Vector3.new(0, 3, 0)
            foxfire.BrickColor = BrickColor.new("Cyan")
            foxfire.Material = Enum.Material.Neon
            foxfire.Transparency = 0.3
            foxfire.Anchored = false
            foxfire.CanCollide = false
            foxfire.Parent = yokai
            
            local foxfireWeld = Instance.new("Weld")
            foxfireWeld.Part0 = head
            foxfireWeld.Part1 = foxfire
            foxfireWeld.C0 = CFrame.new(0, 1.5, 0)
            foxfireWeld.Parent = foxfire
            
            -- 青い光
            local light = Instance.new("PointLight")
            light.Brightness = 1
            light.Color = Color3.fromRGB(0, 200, 255)
            light.Range = 15
            light.Parent = foxfire
        end
        
        -- ヒューマノイド
        local humanoid = Instance.new("Humanoid")
        humanoid.MaxHealth = settings.health
        humanoid.Health = settings.health
        humanoid.WalkSpeed = adjustedSpeed
        humanoid.Parent = yokai
        
        -- プライマリパーツの設定
        yokai.PrimaryPart = torso
    end
    
    -- 妖怪の設定
    local humanoid = yokai:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = adjustedSpeed
        humanoid.MaxHealth = settings.health
        humanoid.Health = settings.health
    end
    
    -- カスタムプロパティの設定
    local attributes = {
        Type = yokaiType,
        Damage = adjustedDamage,
        DetectionRange = settings.detectionRange,
        AttackRange = settings.attackRange,
        AttackCooldown = settings.attackCooldown,
        LastAttackTime = 0
    }
    
    for name, value in pairs(attributes) do
        yokai:SetAttribute(name, value)
    end
    
    -- 妖怪をワークスペースに配置
    yokai:SetPrimaryPartCFrame(CFrame.new(position))
    yokai.Parent = workspace
    
    -- アクティブな妖怪リストに追加
    table.insert(YokaiController.ActiveYokais, yokai)
    
    -- 妖怪が生成されたことをクライアントに通知
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("MonsterSpawned") then
        remoteEvents.MonsterSpawned:FireAllClients(yokai, yokaiType)
    end
    
    -- 妖怪の動きを制御
    spawn(function()
        YokaiController.ControlYokai(yokai)
    end)
    
    return yokai
end

-- 妖怪の動きを制御する関数
function YokaiController.ControlYokai(yokai)
    if not yokai or not yokai.Parent then return end
    
    local humanoid = yokai:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local yokaiType = yokai:GetAttribute("Type")
    local detectionRange = yokai:GetAttribute("DetectionRange")
    local attackRange = yokai:GetAttribute("AttackRange")
    local attackCooldown = yokai:GetAttribute("AttackCooldown")
    
    while yokai and yokai.Parent and humanoid.Health > 0 do
        -- 最も近いプレイヤーを探す
        local closestPlayer, closestDistance = YokaiController.FindClosestPlayer(yokai)
        
        if closestPlayer and closestDistance <= detectionRange then
            -- プレイヤーが検出範囲内にいる場合、追跡
            local character = closestPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = character.HumanoidRootPart.Position
                
                -- 攻撃範囲内にいるか確認
                if closestDistance <= attackRange then
                    -- 攻撃クールダウンをチェック
                    local currentTime = tick()
                    local lastAttackTime = yokai:GetAttribute("LastAttackTime")
                    
                    if currentTime - lastAttackTime >= attackCooldown then
                        -- 攻撃
                        YokaiController.AttackPlayer(yokai, closestPlayer)
                        yokai:SetAttribute("LastAttackTime", currentTime)
                    end
                else
                    -- 追跡
                    humanoid:MoveTo(targetPosition)
                end
            end
        else
            -- プレイヤーが検出範囲外の場合、ランダムな移動
            if math.random() < 0.1 then -- 10%の確率でランダムな位置に移動
                local randomOffset = Vector3.new(
                    math.random(-10, 10),
                    0,
                    math.random(-10, 10)
                )
                
                local currentPosition = yokai.PrimaryPart.Position
                humanoid:MoveTo(currentPosition + randomOffset)
            end
        end
        
        wait(0.5) -- 0.5秒ごとに更新
    end
    
    -- 妖怪が死亡した場合、アクティブリストから削除
    for i, activeYokai in ipairs(YokaiController.ActiveYokais) do
        if activeYokai == yokai then
            table.remove(YokaiController.ActiveYokais, i)
            break
        end
    end
end

-- 最も近いプレイヤーを見つける関数
function YokaiController.FindClosestPlayer(yokai)
    if not yokai or not yokai.PrimaryPart then return nil, math.huge end
    
    local yokaiPosition = yokai.PrimaryPart.Position
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
            local distance = (character.HumanoidRootPart.Position - yokaiPosition).Magnitude
            
            if distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end

-- プレイヤーを攻撃する関数
function YokaiController.AttackPlayer(yokai, player)
    if not yokai or not player then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid.Health <= 0 then return end
    
    -- ダメージを与える
    local damage = yokai:GetAttribute("Damage")
    humanoid:TakeDamage(damage)
    
    -- 攻撃エフェクト
    local yokaiType = yokai:GetAttribute("Type")
    local effectColor = Color3.new(1, 0, 0) -- デフォルトは赤
    
    if yokaiType == MonsterConfig.Types.YUREI then
        effectColor = Color3.new(0.8, 0.8, 1) -- 薄い青
    elseif yokaiType == MonsterConfig.Types.KAPPA then
        effectColor = Color3.new(0, 0.8, 0.2) -- 緑
    elseif yokaiType == MonsterConfig.Types.ONI then
        effectColor = Color3.new(1, 0, 0) -- 赤
    elseif yokaiType == MonsterConfig.Types.KITSUNE then
        effectColor = Color3.new(1, 0.5, 0) -- オレンジ
    end
    
    -- 攻撃エフェクトの作成
    local effect = Instance.new("Part")
    effect.Name = "AttackEffect"
    effect.Shape = Enum.PartType.Ball
    effect.Size = Vector3.new(2, 2, 2)
    effect.Position = character.HumanoidRootPart.Position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Material = Enum.Material.Neon
    effect.BrickColor = BrickColor.new(effectColor)
    effect.Transparency = 0.5
    effect.Parent = workspace
    
    -- エフェクトの消滅
    spawn(function()
        for i = 0, 10 do
            effect.Transparency = 0.5 + (i / 20)
            effect.Size = Vector3.new(2 + i, 2 + i, 2 + i)
            wait(0.05)
        end
        effect:Destroy()
    end)
    
    -- 攻撃イベントをクライアントに通知
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("PlayerDamaged") then
        remoteEvents.PlayerDamaged:FireClient(player, damage, yokaiType)
    end
end

-- 複数の妖怪をスポーンする関数
function YokaiController.SpawnMultipleYokais(count, types)
    count = count or 4
    types = types or {
        MonsterConfig.Types.YUREI,
        MonsterConfig.Types.KAPPA,
        MonsterConfig.Types.ONI,
        MonsterConfig.Types.KITSUNE
    }
    
    local spawnedYokais = {}
    
    for i = 1, count do
        local yokaiType = types[((i - 1) % #types) + 1]
        local position = MonsterConfig.GetRandomSpawnLocation()
        
        local yokai = YokaiController.SpawnYokai(yokaiType, position)
        if yokai then
            table.insert(spawnedYokais, yokai)
        end
        
        wait(0.5) -- 0.5秒間隔でスポーン
    end
    
    return spawnedYokais
end

-- すべての妖怪を削除する関数
function YokaiController.RemoveAllYokais()
    for i = #YokaiController.ActiveYokais, 1, -1 do
        local yokai = YokaiController.ActiveYokais[i]
        if yokai and yokai.Parent then
            yokai:Destroy()
        end
        table.remove(YokaiController.ActiveYokais, i)
    end
end

-- 初期化
function YokaiController.Initialize()
    print("妖怪コントローラーを初期化中...")
    
    -- 既存の妖怪を削除
    YokaiController.RemoveAllYokais()
    
    -- 妖怪モデルフォルダの作成
    if not ServerStorage:FindFirstChild("YokaiModels") then
        local modelsFolder = Instance.new("Folder")
        modelsFolder.Name = "YokaiModels"
        modelsFolder.Parent = ServerStorage
    end
    
    print("妖怪コントローラーの初期化が完了しました")
end

return YokaiController