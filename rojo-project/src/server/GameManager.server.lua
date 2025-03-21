-- GameManager.server.lua
-- ホラーハウスゲームのメインサーバースクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Lighting = game:GetService("Lighting")

-- モジュールの読み込み
local MonsterController = require(script.Parent.MonsterController)
local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

-- 変数
local gameRunning = false
local activePlayers = {}
local gameStartTime = 0
local gameEndTime = 0
local currentPhase = "Waiting" -- Waiting, Preparation, Playing, Ending

-- RemoteEventsの作成
local function setupRemoteEvents()
    -- RemoteEventsフォルダがなければ作成
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if not remoteEvents then
        remoteEvents = Instance.new("Folder")
        remoteEvents.Name = "RemoteEvents"
        remoteEvents.Parent = ReplicatedStorage
    end
    
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
        if not remoteEvents:FindFirstChild(eventName) then
            local event = Instance.new("RemoteEvent")
            event.Name = eventName
            event.Parent = remoteEvents
        end
    end
    
    return remoteEvents
end

-- 環境設定の適用
local function setupEnvironment()
    -- 照明設定
    Lighting.Brightness = 1 - GameConfig.Settings.Darkness
    Lighting.Ambient = Color3.new(0.1, 0.1, 0.1)
    Lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3)
    
    -- フォグ設定
    Lighting.FogStart = 50 * (1 - GameConfig.Settings.FogDensity)
    Lighting.FogEnd = 200 * (1 - GameConfig.Settings.FogDensity)
    Lighting.FogColor = Color3.new(0.1, 0.1, 0.1)
    
    -- 時間設定（夜間）
    Lighting.ClockTime = 0 -- 真夜中
    
    -- 追加エフェクト
    local blur = Instance.new("BlurEffect")
    blur.Size = 3
    blur.Parent = Lighting
    
    local colorCorrection = Instance.new("ColorCorrectionEffect")
    colorCorrection.Brightness = -0.1
    colorCorrection.Contrast = 0.1
    colorCorrection.Saturation = -0.2
    colorCorrection.TintColor = Color3.new(0.8, 0.8, 1)
    colorCorrection.Parent = Lighting
end

-- ゲーム開始関数
local function startGame()
    if gameRunning then return end
    
    -- RemoteEventsのセットアップ
    local remoteEvents = setupRemoteEvents()
    
    -- 環境設定の適用
    setupEnvironment()
    
    -- ゲーム状態の初期化
    gameRunning = true
    gameStartTime = tick()
    gameEndTime = gameStartTime + GameConfig.Settings.GameDuration
    currentPhase = "Preparation"
    
    -- 全プレイヤーに通知
    remoteEvents.GameStateChanged:FireAllClients("Preparation", GameConfig.Settings.PreparationTime)
    print("準備フェーズを開始しました！ " .. GameConfig.Settings.PreparationTime .. "秒後にゲームが始まります")
    
    -- 準備時間
    for i = GameConfig.Settings.PreparationTime, 1, -1 do
        if i % 10 == 0 or i <= 5 then
            notifyAllPlayers("ゲーム開始まで " .. i .. "秒")
        end
        wait(1)
    end
    
    -- ゲーム開始
    currentPhase = "Playing"
    remoteEvents.GameStateChanged:FireAllClients("Playing", GameConfig.Settings.GameDuration)
    print("ゲームを開始しました！")
    
    -- モンスター出現タイマーの設定
    local monsterSpawnTimer = 0
    local itemSpawnTimer = 0
    
    -- ゲームループ
    while tick() < gameEndTime and gameRunning do
        -- 1秒待機
        wait(1)
        
        -- 残り時間の計算
        local timeRemaining = math.max(0, math.floor(gameEndTime - tick()))
        
        -- 残り時間の通知
        remoteEvents.TimeUpdated:FireAllClients(timeRemaining)
        if timeRemaining % 60 == 0 and timeRemaining > 0 then
            notifyAllPlayers("残り時間: " .. timeRemaining / 60 .. "分")
        end
        
        -- モンスター出現ロジック
        monsterSpawnTimer = monsterSpawnTimer + 1
        if monsterSpawnTimer >= GameConfig.Settings.MonsterSpawnInterval and 
           #MonsterController.ActiveMonsters < GameConfig.Settings.MaxMonstersActive then
            monsterSpawnTimer = 0
            spawnMonster()
        end
        
        -- アイテム出現ロジック
        itemSpawnTimer = itemSpawnTimer + 1
        if itemSpawnTimer >= GameConfig.Settings.ItemSpawnInterval then
            itemSpawnTimer = 0
            spawnItem()
        end
    end
    
    -- ゲーム終了処理
    endGame()
end

-- モンスター出現関数
local function spawnMonster()
    -- MonsterControllerを使用してモンスターを生成
    local monsterType = MonsterController.GetRandomType and MonsterController.GetRandomType() or nil
    local spawnPosition = MonsterController.GetRandomSpawnLocation and MonsterController.GetRandomSpawnLocation() or nil
    
    local monster = MonsterController.SpawnMonster(monsterType, spawnPosition)
    if monster then
        print("モンスターが出現しました: " .. monster.Name)
        
        -- クライアントに通知
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("MonsterSpawned") then
            remoteEvents.MonsterSpawned:FireAllClients(monster.Name, monster:GetPrimaryPartCFrame().Position)
        end
    end
end

-- アイテム出現関数
local function spawnItem()
    -- アイテムタイプをランダムに選択
    local itemTypes = {}
    for itemType, _ in pairs(GameConfig.Items) do
        table.insert(itemTypes, itemType)
    end
    
    local randomIndex = math.random(1, #itemTypes)
    local itemType = itemTypes[randomIndex]
    local itemConfig = GameConfig.Items[itemType]
    
    if not itemConfig then return end
    
    -- スポーン位置をランダムに選択
    local mapSize = GameConfig.Map.Size
    local x = math.random(-mapSize.X/2, mapSize.X/2)
    local z = math.random(-mapSize.Z/2, mapSize.Z/2)
    local position = Vector3.new(x, 5, z)
    
    -- アイテムの作成
    local item = Instance.new("Part")
    item.Name = itemType
    item.Size = Vector3.new(1, 1, 1)
    item.Position = position
    item.Anchored = true
    item.CanCollide = true
    
    -- アイテムの外観設定
    if itemType == "HealthPack" then
        item.BrickColor = BrickColor.new("Bright red")
        item.Material = Enum.Material.Neon
    elseif itemType == "Battery" then
        item.BrickColor = BrickColor.new("Bright yellow")
        item.Material = Enum.Material.Metal
    elseif itemType == "SpeedBoost" then
        item.BrickColor = BrickColor.new("Bright blue")
        item.Material = Enum.Material.Neon
    elseif itemType == "Shield" then
        item.BrickColor = BrickColor.new("Bright green")
        item.Material = Enum.Material.ForceField
    end
    
    -- アイテム情報の設定
    item:SetAttribute("ItemType", itemType)
    for propName, propValue in pairs(itemConfig) do
        if propName ~= "Model" and propName ~= "SpawnChance" then
            item:SetAttribute(propName, propValue)
        end
    end
    
    -- 回転アニメーション
    local bodyVelocity = Instance.new("BodyAngularVelocity")
    bodyVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyVelocity.AngularVelocity = Vector3.new(0, 1, 0)
    bodyVelocity.Parent = item
    
    -- 浮遊アニメーション
    local originalY = position.Y
    spawn(function()
        while item and item.Parent do
            for i = 0, 2*math.pi, 0.1 do
                if item and item.Parent then
                    item.Position = Vector3.new(item.Position.X, originalY + math.sin(i) * 0.5, item.Position.Z)
                    wait(0.05)
                else
                    break
                end
            end
        end
    end)
    
    -- 接触イベント
    item.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = Players:GetPlayerFromCharacter(character)
        
        if player then
            -- アイテム効果の適用
            applyItemEffect(player, itemType, itemConfig)
            
            -- クライアントに通知
            local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvents and remoteEvents:FindFirstChild("ItemCollected") then
                remoteEvents.ItemCollected:FireAllClients(player.Name, itemType)
            end
            
            -- アイテムの削除
            item:Destroy()
        end
    end)
    
    -- アイテムをワークスペースに配置
    item.Parent = workspace
    
    print("アイテムが出現しました: " .. itemType)
end

-- アイテム効果を適用する関数
local function applyItemEffect(player, itemType, itemConfig)
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if itemType == "HealthPack" then
        -- 体力回復
        humanoid.Health = math.min(humanoid.Health + itemConfig.HealAmount, humanoid.MaxHealth)
        print(player.Name .. "の体力が" .. itemConfig.HealAmount .. "回復しました")
    elseif itemType == "Battery" then
        -- フラッシュライト充電
        -- クライアントサイドで処理するためRemoteEventで通知
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("ItemCollected") then
            remoteEvents.ItemCollected:FireClient(player, "Battery", itemConfig.FlashlightRecharge)
        end
        print(player.Name .. "のフラッシュライトが充電されました")
    elseif itemType == "SpeedBoost" then
        -- 速度上昇
        local originalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = originalSpeed * itemConfig.SpeedMultiplier
        print(player.Name .. "の速度が" .. itemConfig.Duration .. "秒間上昇しました")
        
        -- 効果時間後に元に戻す
        delay(itemConfig.Duration, function()
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = originalSpeed
            end
        end)
    elseif itemType == "Shield" then
        -- ダメージ軽減
        player:SetAttribute("DamageReduction", itemConfig.DamageReduction)
        print(player.Name .. "が" .. itemConfig.Duration .. "秒間のシールドを獲得しました")
        
        -- 効果時間後に元に戻す
        delay(itemConfig.Duration, function()
            if player then
                player:SetAttribute("DamageReduction", 0)
            end
        end)
    end
end

-- ゲーム終了関数
local function endGame()
    if not gameRunning then return end
    
    gameRunning = false
    currentPhase = "Ending"
    
    -- 全プレイヤーに通知
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("GameEnded") then
        remoteEvents.GameEnded:FireAllClients()
    end
    
    print("ゲームが終了しました！")
    notifyAllPlayers("ゲームが終了しました！")
    
    -- モンスターの削除
    MonsterController.RemoveAllMonsters()
    
    -- アイテムの削除
    for _, item in pairs(workspace:GetChildren()) do
        if item:GetAttribute("ItemType") then
            item:Destroy()
        end
    end
    
    -- 環境設定をリセット
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    Lighting.FogStart = 0
    Lighting.FogEnd = 10000
    Lighting.ClockTime = 14 -- 昼間
    
    -- エフェクトの削除
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
            effect:Destroy()
        end
    end
    
    -- 5秒後に新しいゲームの準備
    wait(5)
    currentPhase = "Waiting"
    
    -- プレイヤーがいる場合は新しいゲームを開始
    if #Players:GetPlayers() > 0 then
        wait(5)
        startGame()
    end
end

-- 全プレイヤーに通知する関数
local function notifyAllPlayers(message)
    for _, player in pairs(Players:GetPlayers()) do
        -- メッセージ通知の実装
        print("プレイヤー " .. player.Name .. " に通知: " .. message)
        
        -- GUIメッセージの表示（RemoteEventを使用）
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("GameStateChanged") then
            remoteEvents.GameStateChanged:FireClient(player, "Message", message)
        end
    end
end

-- プレイヤー参加イベント
Players.PlayerAdded:Connect(function(player)
    print("プレイヤーが参加しました: " .. player.Name)
    activePlayers[player.UserId] = player
    
    -- プレイヤーの初期設定
    player:SetAttribute("DamageReduction", 0)
    
    -- キャラクターが読み込まれたときの処理
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = GameConfig.Settings.InitialHealth
        humanoid.Health = GameConfig.Settings.InitialHealth
        
        -- プレイヤーをランダムなスポーン位置に配置
        local spawnPoint = GameConfig.GetRandomSpawnPoint()
        character:SetPrimaryPartCFrame(CFrame.new(spawnPoint))
        
        -- プレイヤーの死亡イベント
        humanoid.Died:Connect(function()
            print("プレイヤーが死亡しました: " .. player.Name)
            
            -- リスポーン
            wait(GameConfig.Settings.RespawnTime)
            player:LoadCharacter()
        end)
    end)
    
    -- 最初のプレイヤーが参加したらゲーム開始
    if #Players:GetPlayers() == 1 and currentPhase == "Waiting" then
        wait(5) -- 5秒待機してからゲーム開始
        startGame()
    end
end)

-- プレイヤー退出イベント
Players.PlayerRemoving:Connect(function(player)
    print("プレイヤーが退出しました: " .. player.Name)
    activePlayers[player.UserId] = nil
    
    -- プレイヤーがいなくなったらゲーム終了
    if #Players:GetPlayers() == 0 and gameRunning then
        endGame()
    end
end)

-- 初期化
print("GameManager initialized")
currentPhase = "Waiting"

-- RemoteEventsのセットアップ
setupRemoteEvents()