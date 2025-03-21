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
    
    -- アイテムの生成（アイテムシステムが有効な場合のみ）
    if script.Parent:FindFirstChild("ItemSpawner") then
        local ItemSpawner = require(script.Parent.ItemSpawner)
        ItemSpawner.SpawnAllItems()
    end
    
    print("ゲームの初期化が完了しました")
end

-- 環境設定の適用
local function setupEnvironment()
    -- 照明設定（和風ホラーの雰囲気）
    Lighting.Brightness = 0.2
    Lighting.Ambient = Color3.new(0.1, 0.1, 0.15)
    Lighting.OutdoorAmbient = Color3.new(0.2, 0.2, 0.3)
    
    -- フォグ設定（ほどよい霧）
    Lighting.FogStart = 50
    Lighting.FogEnd = 200
    Lighting.FogColor = Color3.new(0.1, 0.1, 0.15)
    
    -- 時間設定（夕暮れ時）
    Lighting.ClockTime = 18.5 -- 夕暮れ
    
    -- 追加エフェクト
    local blur = Instance.new("BlurEffect")
    blur.Size = 2
    blur.Parent = Lighting
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Brightness = -0.05
    colorCorrection.Contrast = 0.1
    colorCorrection.Saturation = -0.1
    colorCorrection.TintColor = Color3.new(0.9, 0.8, 0.7) -- 夕暮れの暖かい色調
    colorCorrection.Parent = Lighting
    
    -- 大気効果（軽い霞）
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 170, 107) -- 夕焼け色
    atmosphere.Decay = Color3.fromRGB(92, 60, 13)
    atmosphere.Glare = 0.3
    atmosphere.Haze = 1.5
    atmosphere.Parent = Lighting
    
    -- 環境音（虫の音、風の音）
    local ambientSound = Instance.new("Sound")
    ambientSound.Name = "AmbientSound"
    ambientSound.SoundId = "rbxassetid://142376088" -- 虫の音
    ambientSound.Volume = 0.3
    ambientSound.Looped = true
    ambientSound.Parent = Workspace
    ambientSound:Play()
    
    local windSound = Instance.new("Sound")
    windSound.Name = "WindSound"
    windSound.SoundId = "rbxassetid://5977154884" -- 風の音
    windSound.Volume = 0.2
    windSound.Looped = true
    windSound.Parent = Workspace
    windSound:Play()
    
    -- 不気味な音を時々再生
    spawn(function()
        local creepySounds = {
            "rbxassetid://9125626120", -- うめき声
            "rbxassetid://5567523997", -- 叫び声
            "rbxassetid://1565473107"  -- 囁き声
        }
        
        while true do
            wait(math.random(30, 120)) -- 30秒〜2分ごとにランダムに再生
            
            local randomSound = Instance.new("Sound")
            randomSound.SoundId = creepySounds[math.random(1, #creepySounds)]
            randomSound.Volume = 0.2
            randomSound.PlaybackSpeed = math.random(80, 120) / 100
            randomSound.Parent = Workspace
            randomSound:Play()
            
            -- 音が終わったら削除
            randomSound.Ended:Connect(function()
                randomSound:Destroy()
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