-- GameStartup.server.lua
-- ゲーム起動時の初期化処理を行うサーバースクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- ゲーム開始時の初期化
local function initializeGame()
    print("ゲームの初期化を開始します...")
    
    -- 既存のマップをクリア
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "TraditionalJapaneseHouse" then
            child:Destroy()
        end
    end
    
    -- 伝統的な日本家屋のマップ作成
    local TraditionalJapaneseHouse = require(script.Parent.TraditionalJapaneseHouse)
    local map = TraditionalJapaneseHouse.Create(Workspace)
    
    -- 環境設定
    setupEnvironment()
    
    print("ゲームの初期化が完了しました")
end

-- 環境設定の適用
local function setupEnvironment()
    -- 照明設定
    Lighting.Brightness = 0.1
    Lighting.Ambient = Color3.new(0.05, 0.05, 0.1)
    Lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.2)
    
    -- フォグ設定
    Lighting.FogStart = 30
    Lighting.FogEnd = 150
    Lighting.FogColor = Color3.new(0.05, 0.05, 0.1)
    
    -- 時間設定（夜間）
    Lighting.ClockTime = 0 -- 真夜中
    
    -- 追加エフェクト
    local blur = Instance.new("BlurEffect")
    blur.Size = 4
    blur.Parent = Lighting
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Brightness = -0.15
    colorCorrection.Contrast = 0.15
    colorCorrection.Saturation = -0.3
    colorCorrection.TintColor = Color3.new(0.7, 0.7, 1)
    colorCorrection.Parent = Lighting
    
    -- 大気効果
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.5
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(110, 110, 150)
    atmosphere.Decay = Color3.fromRGB(30, 30, 50)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 2
    atmosphere.Parent = Lighting
    
    -- 雨の効果
    local rain = Instance.new("ParticleEmitter")
    rain.Name = "Rain"
    rain.EmissionDirection = Enum.NormalId.Top
    rain.Lifetime = NumberRange.new(5, 8)
    rain.Rate = 100
    rain.Speed = NumberRange.new(50, 70)
    rain.SpreadAngle = Vector2.new(30, 30)
    rain.Texture = "rbxassetid://7071564220" -- 雨のテクスチャ
    rain.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    rain.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.1)
    })
    rain.Acceleration = Vector3.new(0, -100, 0)
    rain.Drag = 1
    rain.LockedToPart = true
    rain.Parent = Workspace.Terrain
    
    -- 雷の効果
    spawn(function()
        while true do
            wait(math.random(20, 60))
            
            -- 雷の光
            local lightning = Instance.new("ColorCorrectionEffect")
            lightning.Brightness = 0.5
            lightning.Contrast = 0.1
            lightning.Saturation = -0.1
            lightning.TintColor = Color3.new(1, 1, 1)
            lightning.Parent = Lighting
            
            -- 雷の音
            local thunderSound = Instance.new("Sound")
            thunderSound.SoundId = "rbxassetid://5982028147" -- 雷の音
            thunderSound.Volume = 1
            thunderSound.PlaybackSpeed = math.random(80, 120) / 100
            thunderSound.Parent = Workspace
            thunderSound:Play()
            
            -- 効果を一瞬だけ表示
            wait(0.1)
            lightning:Destroy()
            
            -- 音が終わったら削除
            thunderSound.Ended:Connect(function()
                thunderSound:Destroy()
            end)
        end
    end)
end

-- プレイヤーが参加したときの処理
local function onPlayerAdded(player)
    print("プレイヤーが参加しました: " .. player.Name)
    
    -- キャラクターが読み込まれたときの処理
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        
        -- スポーン位置の設定
        local spawnPoint = Vector3.new(0, 5, 0)
        character:SetPrimaryPartCFrame(CFrame.new(spawnPoint))
    end)
end

-- 初期化処理の実行
initializeGame()

-- プレイヤー参加イベントの登録
Players.PlayerAdded:Connect(onPlayerAdded)

print("GameStartup initialized")