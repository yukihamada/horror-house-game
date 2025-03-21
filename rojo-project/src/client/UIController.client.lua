-- UIController.client.lua
-- ゲームのUI要素を制御するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local gameStateChangedEvent = remoteEvents:WaitForChild("GameStateChanged")
local playerDamagedEvent = remoteEvents:WaitForChild("PlayerDamaged")
local monsterSpawnedEvent = remoteEvents:WaitForChild("MonsterSpawned")
local itemCollectedEvent = remoteEvents:WaitForChild("ItemCollected")
local timeUpdatedEvent = remoteEvents:WaitForChild("TimeUpdated")
local gameEndedEvent = remoteEvents:WaitForChild("GameEnded")

-- メインUIの作成
local function createMainUI()
    -- 既存のUIを削除
    if playerGui:FindFirstChild("MainUI") then
        playerGui.MainUI:Destroy()
    end
    
    -- メインUIの作成
    local mainUI = Instance.new("ScreenGui")
    mainUI.Name = "MainUI"
    mainUI.ResetOnSpawn = false
    mainUI.Parent = playerGui
    
    -- ヘッダーフレーム（時間、体力など）
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "HeaderFrame"
    headerFrame.Size = UDim2.new(1, 0, 0.1, 0)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundTransparency = 0.5
    headerFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainUI
    
    -- 時間表示
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(0.2, 0, 0.8, 0)
    timeLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    timeLabel.BackgroundTransparency = 1
    timeLabel.TextColor3 = Color3.new(1, 1, 1)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.SourceSansBold
    timeLabel.Text = "残り時間: 5:00"
    timeLabel.Parent = headerFrame
    
    -- 体力表示
    local healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    healthFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    healthFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = headerFrame
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.new(1, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthFrame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.Text = "100/100"
    healthLabel.Parent = healthFrame
    
    -- フラッシュライト表示
    local flashlightFrame = Instance.new("Frame")
    flashlightFrame.Name = "FlashlightFrame"
    flashlightFrame.Size = UDim2.new(0.2, 0, 0.4, 0)
    flashlightFrame.Position = UDim2.new(0.75, 0, 0.3, 0)
    flashlightFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    flashlightFrame.BorderSizePixel = 0
    flashlightFrame.Visible = false
    flashlightFrame.Parent = headerFrame
    
    local flashlightBar = Instance.new("Frame")
    flashlightBar.Name = "FlashlightBar"
    flashlightBar.Size = UDim2.new(1, 0, 1, 0)
    flashlightBar.BackgroundColor3 = Color3.new(1, 1, 0)
    flashlightBar.BorderSizePixel = 0
    flashlightBar.Parent = flashlightFrame
    
    local flashlightLabel = Instance.new("TextLabel")
    flashlightLabel.Name = "FlashlightLabel"
    flashlightLabel.Size = UDim2.new(1, 0, 1, 0)
    flashlightLabel.BackgroundTransparency = 1
    flashlightLabel.TextColor3 = Color3.new(0, 0, 0)
    flashlightLabel.TextScaled = true
    flashlightLabel.Font = Enum.Font.SourceSansBold
    flashlightLabel.Text = ""
    flashlightLabel.Parent = flashlightFrame
    
    -- 通知フレーム
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "NotificationFrame"
    notificationFrame.Size = UDim2.new(0.5, 0, 0.2, 0)
    notificationFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
    notificationFrame.BackgroundTransparency = 0.5
    notificationFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Visible = false
    notificationFrame.Parent = mainUI
    
    local notificationText = Instance.new("TextLabel")
    notificationText.Name = "NotificationText"
    notificationText.Size = UDim2.new(1, 0, 1, 0)
    notificationText.BackgroundTransparency = 1
    notificationText.TextColor3 = Color3.new(1, 1, 1)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.SourceSansBold
    notificationText.Text = ""
    notificationText.Parent = notificationFrame
    
    -- アイテム収集通知
    local itemNotificationFrame = Instance.new("Frame")
    itemNotificationFrame.Name = "ItemNotificationFrame"
    itemNotificationFrame.Size = UDim2.new(0.3, 0, 0.1, 0)
    itemNotificationFrame.Position = UDim2.new(0.7, 0, 0.8, 0)
    itemNotificationFrame.BackgroundTransparency = 0.5
    itemNotificationFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    itemNotificationFrame.BorderSizePixel = 0
    itemNotificationFrame.Visible = false
    itemNotificationFrame.Parent = mainUI
    
    local itemNotificationText = Instance.new("TextLabel")
    itemNotificationText.Name = "ItemNotificationText"
    itemNotificationText.Size = UDim2.new(1, 0, 1, 0)
    itemNotificationText.BackgroundTransparency = 1
    itemNotificationText.TextColor3 = Color3.new(1, 1, 1)
    itemNotificationText.TextScaled = true
    itemNotificationText.Font = Enum.Font.SourceSansBold
    itemNotificationText.Text = ""
    itemNotificationText.Parent = itemNotificationFrame
    
    -- モンスター警告
    local monsterWarningFrame = Instance.new("Frame")
    monsterWarningFrame.Name = "MonsterWarningFrame"
    monsterWarningFrame.Size = UDim2.new(1, 0, 1, 0)
    monsterWarningFrame.BackgroundTransparency = 0.8
    monsterWarningFrame.BackgroundColor3 = Color3.new(1, 0, 0)
    monsterWarningFrame.BorderSizePixel = 0
    monsterWarningFrame.Visible = false
    monsterWarningFrame.Parent = mainUI
    
    local monsterWarningText = Instance.new("TextLabel")
    monsterWarningText.Name = "MonsterWarningText"
    monsterWarningText.Size = UDim2.new(0.5, 0, 0.2, 0)
    monsterWarningText.Position = UDim2.new(0.25, 0, 0.4, 0)
    monsterWarningText.BackgroundTransparency = 1
    monsterWarningText.TextColor3 = Color3.new(1, 1, 1)
    monsterWarningText.TextScaled = true
    monsterWarningText.Font = Enum.Font.SourceSansBold
    monsterWarningText.Text = "危険！モンスターが近くにいます！"
    monsterWarningText.Parent = monsterWarningFrame
    
    -- ゲーム終了画面
    local gameOverFrame = Instance.new("Frame")
    gameOverFrame.Name = "GameOverFrame"
    gameOverFrame.Size = UDim2.new(1, 0, 1, 0)
    gameOverFrame.BackgroundTransparency = 0.5
    gameOverFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    gameOverFrame.BorderSizePixel = 0
    gameOverFrame.Visible = false
    gameOverFrame.Parent = mainUI
    
    local gameOverText = Instance.new("TextLabel")
    gameOverText.Name = "GameOverText"
    gameOverText.Size = UDim2.new(0.8, 0, 0.3, 0)
    gameOverText.Position = UDim2.new(0.1, 0, 0.3, 0)
    gameOverText.BackgroundTransparency = 1
    gameOverText.TextColor3 = Color3.new(1, 1, 1)
    gameOverText.TextScaled = true
    gameOverText.Font = Enum.Font.SourceSansBold
    gameOverText.Text = "ゲーム終了"
    gameOverText.Parent = gameOverFrame
    
    return mainUI
end

-- 通知を表示する関数
local function showNotification(message, duration)
    duration = duration or 3
    
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local notificationFrame = mainUI:FindFirstChild("NotificationFrame")
    local notificationText = notificationFrame and notificationFrame:FindFirstChild("NotificationText")
    
    if notificationFrame and notificationText then
        notificationText.Text = message
        notificationFrame.Visible = true
        
        -- フェードインアニメーション
        notificationFrame.BackgroundTransparency = 1
        local fadeInTween = TweenService:Create(
            notificationFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.5}
        )
        fadeInTween:Play()
        
        -- 表示時間後にフェードアウト
        delay(duration, function()
            local fadeOutTween = TweenService:Create(
                notificationFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            )
            fadeOutTween:Play()
            
            fadeOutTween.Completed:Connect(function()
                notificationFrame.Visible = false
            end)
        end)
    end
end

-- アイテム通知を表示する関数
local function showItemNotification(itemType)
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local itemNotificationFrame = mainUI:FindFirstChild("ItemNotificationFrame")
    local itemNotificationText = itemNotificationFrame and itemNotificationFrame:FindFirstChild("ItemNotificationText")
    
    if itemNotificationFrame and itemNotificationText then
        local itemNames = {
            HealthPack = "回復キット",
            Battery = "バッテリー",
            SpeedBoost = "スピードブースト",
            Shield = "シールド"
        }
        
        local itemName = itemNames[itemType] or itemType
        itemNotificationText.Text = itemName .. "を入手しました！"
        itemNotificationFrame.Visible = true
        
        -- フェードインアニメーション
        itemNotificationFrame.BackgroundTransparency = 1
        local fadeInTween = TweenService:Create(
            itemNotificationFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.5}
        )
        fadeInTween:Play()
        
        -- 3秒後にフェードアウト
        delay(3, function()
            local fadeOutTween = TweenService:Create(
                itemNotificationFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {BackgroundTransparency = 1}
            )
            fadeOutTween:Play()
            
            fadeOutTween.Completed:Connect(function()
                itemNotificationFrame.Visible = false
            end)
        end)
    end
end

-- モンスター警告を表示する関数
local function showMonsterWarning(duration)
    duration = duration or 2
    
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local monsterWarningFrame = mainUI:FindFirstChild("MonsterWarningFrame")
    
    if monsterWarningFrame then
        monsterWarningFrame.Visible = true
        
        -- 点滅アニメーション
        local isVisible = true
        for i = 1, duration * 2 do
            isVisible = not isVisible
            monsterWarningFrame.BackgroundTransparency = isVisible and 1 or 0.8
            wait(0.5)
        end
        
        monsterWarningFrame.Visible = false
    end
end

-- 時間表示を更新する関数
local function updateTimeDisplay(timeRemaining)
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local headerFrame = mainUI:FindFirstChild("HeaderFrame")
    local timeLabel = headerFrame and headerFrame:FindFirstChild("TimeLabel")
    
    if timeLabel then
        local minutes = math.floor(timeRemaining / 60)
        local seconds = timeRemaining % 60
        timeLabel.Text = string.format("残り時間: %d:%02d", minutes, seconds)
    end
end

-- 体力表示を更新する関数
local function updateHealthDisplay()
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local headerFrame = mainUI:FindFirstChild("HeaderFrame")
    local healthFrame = headerFrame and headerFrame:FindFirstChild("HealthFrame")
    local healthBar = healthFrame and healthFrame:FindFirstChild("HealthBar")
    local healthLabel = healthFrame and healthFrame:FindFirstChild("HealthLabel")
    
    if healthBar and healthLabel and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        healthLabel.Text = string.format("%d/%d", math.floor(humanoid.Health), humanoid.MaxHealth)
        
        -- 体力に応じて色を変更
        if healthPercent > 0.5 then
            healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- 赤
        elseif healthPercent > 0.2 then
            healthBar.BackgroundColor3 = Color3.new(1, 0.5, 0) -- オレンジ
        else
            healthBar.BackgroundColor3 = Color3.new(1, 0, 0) -- 赤
        end
    end
end

-- フラッシュライト表示を更新する関数
local function updateFlashlightDisplay(batteryPercent)
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local headerFrame = mainUI:FindFirstChild("HeaderFrame")
    local flashlightFrame = headerFrame and headerFrame:FindFirstChild("FlashlightFrame")
    local flashlightBar = flashlightFrame and flashlightFrame:FindFirstChild("FlashlightBar")
    local flashlightLabel = flashlightFrame and flashlightFrame:FindFirstChild("FlashlightLabel")
    
    if flashlightBar and flashlightLabel then
        flashlightBar.Size = UDim2.new(batteryPercent / 100, 0, 1, 0)
        flashlightLabel.Text = string.format("%d%%", batteryPercent)
        
        -- バッテリー残量に応じて色を変更
        if batteryPercent > 50 then
            flashlightBar.BackgroundColor3 = Color3.new(1, 1, 0) -- 黄色
        elseif batteryPercent > 20 then
            flashlightBar.BackgroundColor3 = Color3.new(1, 0.5, 0) -- オレンジ
        else
            flashlightBar.BackgroundColor3 = Color3.new(1, 0, 0) -- 赤
        end
    end
end

-- ゲーム終了画面を表示する関数
local function showGameOver()
    local mainUI = playerGui:FindFirstChild("MainUI")
    if not mainUI then return end
    
    local gameOverFrame = mainUI:FindFirstChild("GameOverFrame")
    
    if gameOverFrame then
        gameOverFrame.Visible = true
        
        -- フェードインアニメーション
        gameOverFrame.BackgroundTransparency = 1
        local fadeInTween = TweenService:Create(
            gameOverFrame,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.5}
        )
        fadeInTween:Play()
    end
end

-- イベントハンドラーの設定
gameStateChangedEvent.OnClientEvent:Connect(function(state, data)
    if state == "Preparation" then
        showNotification("準備フェーズ: " .. data .. "秒後にゲーム開始", 5)
    elseif state == "Playing" then
        showNotification("ゲーム開始！", 3)
    elseif state == "Message" then
        showNotification(data, 3)
    end
end)

playerDamagedEvent.OnClientEvent:Connect(function(damage)
    showNotification("ダメージを受けました: " .. damage, 2)
    updateHealthDisplay()
end)

monsterSpawnedEvent.OnClientEvent:Connect(function(monsterName, position)
    -- プレイヤーとモンスターの距離を計算
    local character = player.Character
    if character and character.PrimaryPart then
        local distance = (character.PrimaryPart.Position - position).Magnitude
        
        -- 近くにモンスターが出現した場合は警告
        if distance < 50 then
            showMonsterWarning(2)
        end
    end
end)

itemCollectedEvent.OnClientEvent:Connect(function(playerName, itemType, value)
    if playerName == player.Name then
        showItemNotification(itemType)
        
        -- バッテリーの場合はフラッシュライト表示を更新
        if itemType == "Battery" and value then
            -- 現在のバッテリー残量を取得（プレイヤーの属性から）
            local currentBattery = player:GetAttribute("FlashlightBattery") or 100
            local newBattery = math.min(currentBattery + value, 100)
            
            -- バッテリー残量を更新
            player:SetAttribute("FlashlightBattery", newBattery)
            updateFlashlightDisplay(newBattery)
        end
    end
end)

timeUpdatedEvent.OnClientEvent:Connect(function(timeRemaining)
    updateTimeDisplay(timeRemaining)
end)

gameEndedEvent.OnClientEvent:Connect(function()
    showGameOver()
end)

-- キャラクターが変わったときの処理
player.CharacterAdded:Connect(function(character)
    -- 体力表示の更新
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(function()
        updateHealthDisplay()
    end)
    
    -- 初期表示の更新
    updateHealthDisplay()
end)

-- フラッシュライトのバッテリー消費（定期的に減少）
spawn(function()
    while wait(1) do
        -- フラッシュライトがオンの場合のみバッテリーを消費
        local isFlashlightOn = player:GetAttribute("FlashlightOn") or false
        if isFlashlightOn then
            local currentBattery = player:GetAttribute("FlashlightBattery") or 100
            local newBattery = math.max(currentBattery - 1, 0) -- 1秒ごとに1%減少
            
            player:SetAttribute("FlashlightBattery", newBattery)
            updateFlashlightDisplay(newBattery)
            
            -- バッテリーが切れたらフラッシュライトをオフ
            if newBattery <= 0 then
                player:SetAttribute("FlashlightOn", false)
                
                -- クライアントスクリプトでフラッシュライトをオフにする処理
                -- （PlayerControllerスクリプトと連携）
            end
        end
    end
end)

-- 初期化
local mainUI = createMainUI()
updateTimeDisplay(300) -- 初期値: 5分
updateHealthDisplay()
-- 提灯表示は非表示に設定

-- 初期属性の設定
player:SetAttribute("FlashlightBattery", 100)
player:SetAttribute("FlashlightOn", false)

print("UIController initialized")