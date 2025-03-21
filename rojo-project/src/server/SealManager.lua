-- SealManager.lua
-- 封印の札を管理するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local SealManager = {}

-- 封印の札の状態
SealManager.Seals = {
    {id = "Fire", collected = false, position = nil},
    {id = "Water", collected = false, position = nil},
    {id = "Earth", collected = false, position = nil}
}

-- 鳥居の封印状態
SealManager.ExitSealed = true

-- 封印の札を配置する関数
function SealManager.PlaceSeals()
    -- 既存の札を削除
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "SealTalisman" then
            obj:Destroy()
        end
    end
    
    -- 家を見つける
    local house = Workspace:FindFirstChild("TraditionalJapaneseHouse")
    if not house then
        warn("家が見つかりません。封印の札を配置できません。")
        return
    end
    
    -- 札の配置位置を設定
    local mapSize = 400 -- TraditionalJapaneseHouse.luaから取得
    local positions = {
        -- 1階の畳の部屋（左上）
        Vector3.new(-mapSize/2 + 40, 2, -mapSize/2 + 40),
        -- 2階の畳の部屋（右上）
        Vector3.new(mapSize/2 - 40, 10, -mapSize/2 + 40),
        -- 1階の廊下の中央
        Vector3.new(0, 2, 0)
    }
    
    -- 札のタイプと色
    local sealTypes = {
        {id = "Fire", color = Color3.fromRGB(255, 50, 50), emissiveColor = Color3.fromRGB(255, 100, 100)},
        {id = "Water", color = Color3.fromRGB(50, 100, 255), emissiveColor = Color3.fromRGB(100, 150, 255)},
        {id = "Earth", color = Color3.fromRGB(100, 200, 50), emissiveColor = Color3.fromRGB(150, 255, 100)}
    }
    
    -- 札を配置
    for i, sealType in ipairs(sealTypes) do
        local position = positions[i]
        
        -- 札のモデルを作成
        local talisman = Instance.new("Part")
        talisman.Name = "SealTalisman"
        talisman.Size = Vector3.new(1, 2, 0.1)
        talisman.Position = position
        talisman.Anchored = true
        talisman.CanCollide = true
        talisman.BrickColor = BrickColor.new("White")
        talisman.Material = Enum.Material.SmoothPlastic
        
        -- 札の属性を設定
        talisman:SetAttribute("SealType", sealType.id)
        
        -- 札の装飾
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://7546636894" -- 和風の模様
        decal.Face = Enum.NormalId.Front
        decal.Parent = talisman
        
        -- 札の発光効果
        local light = Instance.new("PointLight")
        light.Color = sealType.emissiveColor
        light.Range = 10
        light.Brightness = 1
        light.Parent = talisman
        
        -- 浮遊アニメーション
        local originalY = position.Y
        spawn(function()
            while talisman and talisman.Parent do
                for i = 0, 2*math.pi, 0.05 do
                    if talisman and talisman.Parent then
                        talisman.Position = Vector3.new(talisman.Position.X, originalY + math.sin(i) * 0.5, talisman.Position.Z)
                        talisman.Orientation = Vector3.new(0, i * 30, 0)
                        wait(0.05)
                    else
                        break
                    end
                end
            end
        end)
        
        -- 接触イベント
        talisman.Touched:Connect(function(hit)
            local character = hit.Parent
            local player = Players:GetPlayerFromCharacter(character)
            
            if player and not SealManager.IsSealCollected(sealType.id) then
                -- 札を収集
                SealManager.CollectSeal(sealType.id, player)
                
                -- 効果音
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://5982028147" -- 収集音
                sound.Volume = 1
                sound.Parent = talisman
                sound:Play()
                
                -- 札を消す（少し待ってから）
                delay(1, function()
                    talisman:Destroy()
                end)
            end
        end)
        
        talisman.Parent = Workspace
        
        -- 札の位置を記録
        for j, seal in ipairs(SealManager.Seals) do
            if seal.id == sealType.id then
                SealManager.Seals[j].position = position
                break
            end
        end
        
        print("封印の札を配置しました: " .. sealType.id .. " at " .. tostring(position))
    end
    
    -- 鳥居の封印を設定
    SealManager.SetupExitSeal()
end

-- 札が収集されたかどうかを確認する関数
function SealManager.IsSealCollected(sealId)
    for _, seal in ipairs(SealManager.Seals) do
        if seal.id == sealId then
            return seal.collected
        end
    end
    return false
end

-- 札を収集する関数
function SealManager.CollectSeal(sealId, player)
    for i, seal in ipairs(SealManager.Seals) do
        if seal.id == sealId then
            SealManager.Seals[i].collected = true
            
            -- クライアントに通知
            local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvents and remoteEvents:FindFirstChild("ItemCollected") then
                remoteEvents.ItemCollected:FireAllClients(player.Name, "SealTalisman_" .. sealId)
            end
            
            -- 全プレイヤーに通知
            for _, p in pairs(Players:GetPlayers()) do
                local message = player.Name .. "が" .. sealId .. "の封印の札を見つけました！"
                local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remoteEvents and remoteEvents:FindFirstChild("GameStateChanged") then
                    remoteEvents.GameStateChanged:FireClient(p, "Message", message)
                end
            end
            
            print(player.Name .. "が封印の札を収集しました: " .. sealId)
            
            -- すべての札が集まったかチェック
            if SealManager.AreAllSealsCollected() then
                SealManager.UnsealExit()
            end
            
            break
        end
    end
end

-- すべての札が収集されたかどうかを確認する関数
function SealManager.AreAllSealsCollected()
    for _, seal in ipairs(SealManager.Seals) do
        if not seal.collected then
            return false
        end
    end
    return true
end

-- 鳥居の封印を設定する関数
function SealManager.SetupExitSeal()
    -- 家を見つける
    local house = Workspace:FindFirstChild("TraditionalJapaneseHouse")
    if not house then
        warn("家が見つかりません。鳥居の封印を設定できません。")
        return
    end
    
    -- 鳥居を見つける
    local torii = house:FindFirstChild("Torii")
    if not torii then
        warn("鳥居が見つかりません。封印を設定できません。")
        return
    end
    
    -- 封印のバリアを作成
    local barrier = Instance.new("Part")
    barrier.Name = "SealBarrier"
    barrier.Size = Vector3.new(20, 20, 1)
    barrier.Position = Vector3.new(0, 10, -400/2 - 10) -- 鳥居の位置
    barrier.Anchored = true
    barrier.CanCollide = true
    barrier.Transparency = 0.7
    barrier.BrickColor = BrickColor.new("Really red")
    barrier.Material = Enum.Material.ForceField
    
    -- 封印の効果
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    particleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    particleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    particleEmitter.Rate = 50
    particleEmitter.Speed = NumberRange.new(1, 3)
    particleEmitter.Lifetime = NumberRange.new(1, 2)
    particleEmitter.Parent = barrier
    
    barrier.Parent = torii
    
    SealManager.ExitSealed = true
    print("鳥居に封印を設定しました")
end

-- 鳥居の封印を解除する関数
function SealManager.UnsealExit()
    -- 家を見つける
    local house = Workspace:FindFirstChild("TraditionalJapaneseHouse")
    if not house then
        warn("家が見つかりません。鳥居の封印を解除できません。")
        return
    end
    
    -- 鳥居を見つける
    local torii = house:FindFirstChild("Torii")
    if not torii then
        warn("鳥居が見つかりません。封印を解除できません。")
        return
    end
    
    -- 封印のバリアを見つける
    local barrier = torii:FindFirstChild("SealBarrier")
    if barrier then
        -- 封印解除のエフェクト
        local explosion = Instance.new("Explosion")
        explosion.Position = barrier.Position
        explosion.BlastRadius = 10
        explosion.BlastPressure = 0 -- ダメージなし
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.DestroyJointRadiusPercent = 0
        explosion.Parent = Workspace
        
        -- バリアを消す
        barrier:Destroy()
    end
    
    -- 全プレイヤーに通知
    for _, player in pairs(Players:GetPlayers()) do
        local message = "すべての封印の札が集まりました！鳥居の封印が解かれました！"
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("GameStateChanged") then
            remoteEvents.GameStateChanged:FireClient(player, "Message", message)
        end
    end
    
    SealManager.ExitSealed = false
    print("鳥居の封印を解除しました")
end

-- 鳥居に到達したかどうかを確認する関数
function SealManager.CheckPlayerAtExit(player)
    if SealManager.ExitSealed then
        return false
    end
    
    -- 家を見つける
    local house = Workspace:FindFirstChild("TraditionalJapaneseHouse")
    if not house then
        return false
    end
    
    -- 鳥居を見つける
    local torii = house:FindFirstChild("Torii")
    if not torii then
        return false
    end
    
    -- プレイヤーのキャラクターを取得
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    -- 鳥居との距離を計算
    local toriiPosition = Vector3.new(0, 0, -400/2 - 10) -- 鳥居の位置
    local playerPosition = character.HumanoidRootPart.Position
    local distance = (playerPosition - toriiPosition).Magnitude
    
    -- 鳥居に十分近いかどうか
    return distance < 10
end

-- 状態をリセットする関数
function SealManager.Reset()
    -- 札の状態をリセット
    for i, _ in ipairs(SealManager.Seals) do
        SealManager.Seals[i].collected = false
    end
    
    -- 鳥居の封印状態をリセット
    SealManager.ExitSealed = true
    
    -- 札を再配置
    SealManager.PlaceSeals()
    
    print("SealManagerの状態をリセットしました")
end

return SealManager