-- GameStartup.server.lua
-- ゲーム起動時に自動的に実行されるスクリプト

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

print("日本の古民家 - 謎解きと妖怪ゲームを起動中...")

-- 共有フォルダの設定
if not ReplicatedStorage:FindFirstChild("Shared") then
    local sharedFolder = Instance.new("Folder")
    sharedFolder.Name = "Shared"
    sharedFolder.Parent = ReplicatedStorage
    
    -- 既存の共有モジュールを移動
    for _, module in pairs(ReplicatedStorage:GetChildren()) do
        if module:IsA("ModuleScript") then
            module.Parent = sharedFolder
        end
    end
end

-- RemoteEventsフォルダの作成
if not ReplicatedStorage:FindFirstChild("RemoteEvents") then
    local remoteEvents = Instance.new("Folder")
    remoteEvents.Name = "RemoteEvents"
    remoteEvents.Parent = ReplicatedStorage
    
    -- 必要なRemoteEventsを作成
    local events = {
        "GameStateChanged",
        "PlayerDamaged",
        "MonsterSpawned",
        "ItemCollected",
        "TimeUpdated",
        "GameEnded"
    }
    
    for _, eventName in ipairs(events) do
        local event = Instance.new("RemoteEvent")
        event.Name = eventName
        event.Parent = remoteEvents
    end
end

-- 初期環境設定（和風の雰囲気）
local function setupInitialEnvironment()
    -- 照明設定（夕暮れの和風の雰囲気）
    Lighting.Ambient = Color3.fromRGB(40, 40, 60)
    Lighting.Brightness = 0.5
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(60, 60, 100)
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 70)
    Lighting.ShadowSoftness = 0.8
    Lighting.ClockTime = 18.5 -- 夕暮れ時
    Lighting.GeographicLatitude = 36 -- 日本の緯度に近い
    
    -- 霧の設定
    Lighting.FogColor = Color3.fromRGB(40, 40, 60)
    Lighting.FogEnd = 200
    Lighting.FogStart = 50
    
    -- 大気効果
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 210)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2
    atmosphere.Haze = 1.5
    atmosphere.Parent = Lighting
    
    -- 空の設定
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://271042516"
    sky.SkyboxDn = "rbxassetid://271077243"
    sky.SkyboxFt = "rbxassetid://271042556"
    sky.SkyboxLf = "rbxassetid://271042310"
    sky.SkyboxRt = "rbxassetid://271042467"
    sky.SkyboxUp = "rbxassetid://271077958"
    sky.StarCount = 3000
    sky.SunAngularSize = 10
    sky.MoonAngularSize = 11
    sky.Parent = Lighting
    
    -- 音響効果
    local ambientSound = Instance.new("Sound")
    ambientSound.Name = "AmbientSound"
    ambientSound.SoundId = "rbxassetid://169736440" -- 和風の環境音
    ambientSound.Volume = 0.5
    ambientSound.Looped = true
    ambientSound.Parent = Workspace
    ambientSound:Play()
    
    -- 風の音
    local windSound = Instance.new("Sound")
    windSound.Name = "WindSound"
    windSound.SoundId = "rbxassetid://5977154884" -- 風の音
    windSound.Volume = 0.3
    windSound.Looped = true
    windSound.Parent = Workspace
    windSound:Play()
    
    print("環境設定が完了しました")
end

-- モンスターモデルの準備
local function setupMonsterModels()
    -- ServerStorageにモンスターモデルフォルダを作成
    local monsterModels = ServerStorage:FindFirstChild("MonsterModels")
    if not monsterModels then
        monsterModels = Instance.new("Folder")
        monsterModels.Name = "MonsterModels"
        monsterModels.Parent = ServerStorage
    end
    
    -- 基本的なモンスターモデルを作成（後で詳細なモデルに置き換え可能）
    local modelNames = {"Yurei", "Kappa", "Oni", "Kitsune"}
    
    for _, name in ipairs(modelNames) do
        if not monsterModels:FindFirstChild(name) then
            local model = Instance.new("Model")
            model.Name = name
            
            -- 基本的な形状のモンスター
            local torso = Instance.new("Part")
            torso.Name = "Torso"
            torso.Size = Vector3.new(2, 2, 1)
            torso.Position = Vector3.new(0, 1, 0)
            torso.BrickColor = BrickColor.new("Really black")
            torso.Parent = model
            
            local head = Instance.new("Part")
            head.Name = "Head"
            head.Shape = Enum.PartType.Ball
            head.Size = Vector3.new(1, 1, 1)
            head.Position = Vector3.new(0, 2.5, 0)
            head.BrickColor = BrickColor.new("Really red")
            head.Parent = model
            
            -- ヒューマノイド
            local humanoid = Instance.new("Humanoid")
            humanoid.Parent = model
            
            -- プライマリパーツの設定
            model.PrimaryPart = torso
            
            model.Parent = monsterModels
        end
    end
end

-- マップの設定
local function setupMap()
    -- 既存のマップを削除
    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "HorrorMap" or child.Name == "ModernJapaneseHouse" or child.Name == "JapaneseHorrorHouse" or child.Name == "TraditionalJapaneseHouse" then
            child:Destroy()
        end
    end
    
    -- 伝統的な日本家屋のマップ作成
    local TraditionalJapaneseHouse = require(script.Parent.TraditionalJapaneseHouse)
    local map = TraditionalJapaneseHouse.Create(Workspace)
end

-- プレイヤーが鳥居（脱出ポイント）に触れたときの処理
local function setupExitTrigger()
    -- 鳥居の位置を監視
    local function checkPlayerNearTorii()
        local torii = Workspace:FindFirstChild("TraditionalJapaneseHouse") and Workspace.TraditionalJapaneseHouse:FindFirstChild("Torii")
        if not torii then return end
        
        -- 鳥居の位置
        local toriiPosition = torii:GetModelCFrame().Position
        
        -- すべてのプレイヤーをチェック
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - toriiPosition).Magnitude
                
                -- プレイヤーが鳥居に近づいたら脱出成功
                if distance < 10 then
                    -- RemoteEventsを使用して脱出イベントを発火
                    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remoteEvents and remoteEvents:FindFirstChild("GameEnded") then
                        remoteEvents.GameEnded:FireClient(player)
                        print(player.Name .. "が脱出しました！")
                    end
                end
            end
        end
    end
    
    -- 定期的にプレイヤーの位置をチェック
    spawn(function()
        while wait(1) do
            checkPlayerNearTorii()
        end
    end)
end

-- 環境設定の適用
setupInitialEnvironment()

-- マップの設定
setupMap()

-- 各コントローラーの読み込み
local PuzzleController = require(script.Parent.PuzzleController)
local YokaiController = require(script.Parent.YokaiController)
local GameTimer = require(script.Parent.GameTimer)

-- GameManagerスクリプトの実行
local gameManager = ServerScriptService:FindFirstChild("GameManager")
if gameManager and gameManager:IsA("Script") then
    print("GameManagerスクリプトを実行中...")
else
    print("警告: GameManagerスクリプトが見つかりません")
    
    -- GameManagerが見つからない場合は、直接ゲームを開始
    -- RemoteEventsを使用してゲーム開始を通知
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("GameStateChanged") then
        wait(3) -- プレイヤーのロードを待機
        remoteEvents.GameStateChanged:FireAllClients("Preparation", 30)
        print("ゲーム準備フェーズを開始しました")
    end
end

-- 各システムの初期化
PuzzleController.Initialize()
YokaiController.Initialize()
GameTimer.Start()

-- 妖怪を出現させる
spawn(function()
    wait(10) -- 10秒後に妖怪を出現
    YokaiController.SpawnMultipleYokais(4)
    print("妖怪を出現させました")
end)

-- 脱出トリガーの設定
setupExitTrigger()

print("日本の古民家 - 謎解きと妖怪ゲームの起動が完了しました！")

-- プレイヤーが参加したときに自動的にゲームを開始
Players.PlayerAdded:Connect(function(player)
    print("プレイヤーが参加しました: " .. player.Name)
    
    -- 最初のプレイヤーが参加したらゲーム開始
    if #Players:GetPlayers() == 1 then
        wait(5) -- 5秒待機してからゲーム開始
        
        -- RemoteEventsを使用してゲーム開始を通知
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("GameStateChanged") then
            remoteEvents.GameStateChanged:FireAllClients("Preparation", 30)
            print("ゲーム準備フェーズを開始しました")
        end
    end
end)