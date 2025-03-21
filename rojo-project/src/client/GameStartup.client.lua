-- GameStartup.client.lua
-- ゲーム起動時のクライアント側初期化処理を行うスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 初期化処理
local function initialize()
    print("クライアント側の初期化を開始します...")
    
    -- カメラ設定
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom
    
    -- 入力設定
    setupInputHandling()
    
    print("クライアント側の初期化が完了しました")
end

-- 入力処理の設定
local function setupInputHandling()
    -- キー入力の処理
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F then
            -- 提灯のオン/オフ切り替え
            local character = player.Character
            if character then
                local flashlight = character:FindFirstChild("Flashlight")
                if flashlight then
                    local lanternBody = flashlight:FindFirstChild("LanternBody")
                    if lanternBody then
                        local light = lanternBody:FindFirstChild("Light")
                        local flame = lanternBody:FindFirstChild("Flame")
                        
                        if light and flame and flame:FindFirstChild("ParticleEmitter") then
                            local isOn = not light.Enabled
                            light.Enabled = isOn
                            flame:FindFirstChild("ParticleEmitter").Enabled = isOn
                            
                            -- 提灯の効果音
                            local sound = Instance.new("Sound")
                            sound.SoundId = isOn and "rbxassetid://142082167" or "rbxassetid://142082167" -- 点灯/消灯音
                            sound.Volume = 0.5
                            sound.Parent = lanternBody
                            sound:Play()
                            
                            game.Debris:AddItem(sound, 2)
                            
                            print("提灯を" .. (isOn and "点灯" or "消灯") .. "しました")
                        end
                    end
                end
            end
        elseif input.KeyCode == Enum.KeyCode.E then
            -- アイテム調査/収集
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {character}
                
                local rayDirection = camera.CFrame.LookVector * 5
                local rayResult = workspace:Raycast(rootPart.Position, rayDirection, rayParams)
                
                if rayResult and rayResult.Instance then
                    local hitPart = rayResult.Instance
                    print("調査: " .. hitPart.Name)
                    
                    -- アイテム収集ロジックをここに追加
                end
            end
        end
    end)
end

-- キャラクターが読み込まれたときの処理
local function onCharacterAdded(character)
    -- 提灯の作成（和風の提灯）
    local flashlight = Instance.new("Part")
    flashlight.Name = "Flashlight"
    flashlight.Size = Vector3.new(0.5, 0.5, 1.5)
    flashlight.CanCollide = false
    flashlight.Transparency = 0.2
    flashlight.BrickColor = BrickColor.new("Reddish brown")
    flashlight.Material = Enum.Material.Wood
    
    -- 提灯の本体（円筒形）
    local lanternBody = Instance.new("Part")
    lanternBody.Name = "LanternBody"
    lanternBody.Size = Vector3.new(2.5, 3, 2.5)
    lanternBody.CanCollide = false
    lanternBody.Transparency = 0.3
    lanternBody.BrickColor = BrickColor.new("Bright red")
    lanternBody.Material = Enum.Material.Fabric
    lanternBody.Shape = Enum.PartType.Cylinder
    
    -- 提灯の持ち手との接続
    local bodyWeld = Instance.new("Weld")
    bodyWeld.Part0 = flashlight
    bodyWeld.Part1 = lanternBody
    bodyWeld.C0 = CFrame.new(0, 0, -1) * CFrame.Angles(0, 0, math.rad(90))
    bodyWeld.Parent = lanternBody
    
    -- 提灯の模様
    local texture = Instance.new("Texture")
    texture.Texture = "rbxassetid://7546636894" -- 和風模様
    texture.StudsPerTileU = 2.5
    texture.StudsPerTileV = 3
    texture.Face = Enum.NormalId.Right
    texture.Parent = lanternBody
    
    local texture2 = Instance.new("Texture")
    texture2.Texture = "rbxassetid://7546636894" -- 和風模様
    texture2.StudsPerTileU = 2.5
    texture2.StudsPerTileV = 3
    texture2.Face = Enum.NormalId.Left
    texture2.Parent = lanternBody
    
    lanternBody.Parent = flashlight
    
    -- 提灯の上下の木製部分
    local topWood = Instance.new("Part")
    topWood.Name = "TopWood"
    topWood.Size = Vector3.new(2.7, 0.3, 2.7)
    topWood.CanCollide = false
    topWood.BrickColor = BrickColor.new("Reddish brown")
    topWood.Material = Enum.Material.Wood
    topWood.Shape = Enum.PartType.Cylinder
    
    local topWoodWeld = Instance.new("Weld")
    topWoodWeld.Part0 = lanternBody
    topWoodWeld.Part1 = topWood
    topWoodWeld.C0 = CFrame.new(0, 1.5, 0)
    topWoodWeld.Parent = topWood
    
    topWood.Parent = lanternBody
    
    local bottomWood = Instance.new("Part")
    bottomWood.Name = "BottomWood"
    bottomWood.Size = Vector3.new(2.7, 0.3, 2.7)
    bottomWood.CanCollide = false
    bottomWood.BrickColor = BrickColor.new("Reddish brown")
    bottomWood.Material = Enum.Material.Wood
    bottomWood.Shape = Enum.PartType.Cylinder
    
    local bottomWoodWeld = Instance.new("Weld")
    bottomWoodWeld.Part0 = lanternBody
    bottomWoodWeld.Part1 = bottomWood
    bottomWoodWeld.C0 = CFrame.new(0, -1.5, 0)
    bottomWoodWeld.Parent = bottomWood
    
    bottomWood.Parent = lanternBody
    
    -- 提灯の光源
    local light = Instance.new("PointLight")
    light.Name = "Light"
    light.Brightness = 1
    light.Color = Color3.fromRGB(255, 223, 186)
    light.Range = 15
    light.Shadows = true
    light.Enabled = false
    light.Parent = lanternBody
    
    -- 提灯の炎
    local flame = Instance.new("Part")
    flame.Name = "Flame"
    flame.Size = Vector3.new(0.5, 0.5, 0.5)
    flame.CanCollide = false
    flame.Transparency = 0.2
    flame.BrickColor = BrickColor.new("Bright orange")
    flame.Material = Enum.Material.Neon
    flame.Shape = Enum.PartType.Ball
    
    -- 炎の接続
    local flameWeld = Instance.new("Weld")
    flameWeld.Part0 = lanternBody
    flameWeld.Part1 = flame
    flameWeld.C0 = CFrame.new(0, 0, 0)
    flameWeld.Parent = flame
    
    -- 炎のパーティクル
    local fireParticle = Instance.new("ParticleEmitter")
    fireParticle.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    fireParticle.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 0)
    })
    fireParticle.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    fireParticle.Rate = 20
    fireParticle.Lifetime = NumberRange.new(0.5, 1)
    fireParticle.Speed = NumberRange.new(1, 3)
    fireParticle.Enabled = false
    fireParticle.Parent = flame
    
    flame.Parent = lanternBody
    
    -- 提灯をキャラクターの右手に取り付け
    local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
    if rightHand then
        local weld = Instance.new("Weld")
        weld.Part0 = rightHand
        weld.Part1 = flashlight
        weld.C0 = CFrame.new(0, -0.5, 0)
        weld.Parent = flashlight
        
        flashlight.Parent = character
    end
end

-- プレイヤーのキャラクターが読み込まれたときのイベント
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

-- 初期化処理の実行
initialize()

print("GameStartup client initialized")