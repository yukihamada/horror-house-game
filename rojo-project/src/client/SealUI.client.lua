-- SealUI.client.lua
-- 封印の札の収集状況を表示するUIを管理するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local itemCollectedEvent = remoteEvents:WaitForChild("ItemCollected")
local gameStateChangedEvent = remoteEvents:WaitForChild("GameStateChanged")
local gameEndedEvent = remoteEvents:WaitForChild("GameEnded")

-- 封印の札の状態
local seals = {
    {id = "Fire", collected = false, color = Color3.fromRGB(255, 50, 50)},
    {id = "Water", collected = false, color = Color3.fromRGB(50, 100, 255)},
    {id = "Earth", collected = false, color = Color3.fromRGB(100, 200, 50)}
}

-- 封印の札UIの作成
local function createSealUI()
    -- 既存のUIを削除
    if playerGui:FindFirstChild("SealUI") then
        playerGui.SealUI:Destroy()
    end
    
    -- メインUIの作成
    local sealUI = Instance.new("ScreenGui")
    sealUI.Name = "SealUI"
    sealUI.ResetOnSpawn = false
    sealUI.Parent = playerGui
    
    -- 封印の札フレーム
    local sealFrame = Instance.new("Frame")
    sealFrame.Name = "SealFrame"
    sealFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
    sealFrame.Position = UDim2.new(0.01, 0, 0.35, 0)
    sealFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sealFrame.BackgroundTransparency = 0.2
    sealFrame.BorderSizePixel = 0
    sealFrame.Parent = sealUI
    
    -- 角丸
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sealFrame
    
    -- タイトル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "封印の札"
    titleLabel.Parent = sealFrame
    
    -- 札のリスト
    for i, seal in ipairs(seals) do
        local sealItem = Instance.new("Frame")
        sealItem.Name = seal.id .. "Item"
        sealItem.Size = UDim2.new(0.9, 0, 0.2, 0)
        sealItem.Position = UDim2.new(0.05, 0, 0.25 + (i-1) * 0.25, 0)
        sealItem.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        sealItem.BackgroundTransparency = 0.2
        sealItem.BorderSizePixel = 0
        sealItem.Parent = sealFrame
        
        -- 角丸
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 8)
        itemCorner.Parent = sealItem
        
        -- アイコン
        local icon = Instance.new("Frame")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0.15, 0, 0.8, 0)
        icon.Position = UDim2.new(0.05, 0, 0.1, 0)
        icon.BackgroundColor3 = seal.color
        icon.BorderSizePixel = 0
        icon.Parent = sealItem
        
        -- アイコンの角丸
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 4)
        iconCorner.Parent = icon
        
        -- ラベル
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0.7, 0, 0.8, 0)
        label.Position = UDim2.new(0.25, 0, 0.1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 18
        label.Font = Enum.Font.GothamSemibold
        label.Text = seal.id .. "の札"
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sealItem
        
        -- 状態アイコン
        local statusIcon = Instance.new("ImageLabel")
        statusIcon.Name = "StatusIcon"
        statusIcon.Size = UDim2.new(0.1, 0, 0.8, 0)
        statusIcon.Position = UDim2.new(0.85, 0, 0.1, 0)
        statusIcon.BackgroundTransparency = 1
        statusIcon.Image = "rbxassetid://7733658504" -- ✓アイコン
        statusIcon.ImageColor3 = Color3.fromRGB(100, 255, 100)
        statusIcon.Visible = seal.collected
        statusIcon.Parent = sealItem
    end
    
    return sealUI
end

-- 封印の札の状態を更新する関数
local function updateSealStatus(sealId, collected)
    -- 札の状態を更新
    for i, seal in ipairs(seals) do
        if seal.id == sealId then
            seals[i].collected = collected
            break
        end
    end
    
    -- UIを更新
    local sealUI = playerGui:FindFirstChild("SealUI")
    if not sealUI then return end
    
    local sealFrame = sealUI:FindFirstChild("SealFrame")
    if not sealFrame then return end
    
    local sealItem = sealFrame:FindFirstChild(sealId .. "Item")
    if not sealItem then return end
    
    local statusIcon = sealItem:FindFirstChild("StatusIcon")
    if statusIcon then
        statusIcon.Visible = collected
        
        -- アニメーション
        if collected then
            statusIcon.Size = UDim2.new(0.2, 0, 1.6, 0)
            statusIcon.ImageTransparency = 0.5
            
            local tween = TweenService:Create(
                statusIcon,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0.1, 0, 0.8, 0), ImageTransparency = 0}
            )
            tween:Play()
            
            -- 効果音
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://6333823613" -- 収集音
            sound.Volume = 0.5
            sound.Parent = sealItem
            sound:Play()
            
            game.Debris:AddItem(sound, 2)
        end
    end
    
    -- すべての札が集まったかチェック
    local allCollected = true
    for _, seal in ipairs(seals) do
        if not seal.collected then
            allCollected = false
            break
        end
    end
    
    -- すべて集まった場合
    if allCollected then
        -- タイトルを更新
        local titleLabel = sealFrame:FindFirstChild("TitleLabel")
        if titleLabel then
            titleLabel.Text = "封印解除完了！"
            titleLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            -- アニメーション
            local originalSize = titleLabel.TextSize
            titleLabel.TextSize = originalSize * 1.5
            
            local tween = TweenService:Create(
                titleLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                {TextSize = originalSize}
            )
            tween:Play()
        end
    end
end

-- アイテム収集イベント
itemCollectedEvent.OnClientEvent:Connect(function(playerName, itemType)
    -- 封印の札かどうかをチェック
    if string.find(itemType, "SealTalisman_") then
        local sealId = string.gsub(itemType, "SealTalisman_", "")
        updateSealStatus(sealId, true)
    end
end)

-- ゲーム状態変更イベント
gameStateChangedEvent.OnClientEvent:Connect(function(state, data)
    if state == "Playing" then
        -- ゲーム開始時にUIを作成
        createSealUI()
        
        -- 札の状態をリセット
        for i, _ in ipairs(seals) do
            seals[i].collected = false
        end
    end
end)

-- ゲーム終了イベント
gameEndedEvent.OnClientEvent:Connect(function(isVictory, winnerName)
    -- ゲーム終了時の処理
    if isVictory then
        -- 勝利メッセージ
        local victoryFrame = Instance.new("Frame")
        victoryFrame.Name = "VictoryFrame"
        victoryFrame.Size = UDim2.new(0.5, 0, 0.3, 0)
        victoryFrame.Position = UDim2.new(0.25, 0, 0.35, 0)
        victoryFrame.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
        victoryFrame.BackgroundTransparency = 0.2
        victoryFrame.BorderSizePixel = 0
        
        -- 角丸
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 15)
        corner.Parent = victoryFrame
        
        -- メッセージ
        local message = Instance.new("TextLabel")
        message.Name = "Message"
        message.Size = UDim2.new(0.9, 0, 0.8, 0)
        message.Position = UDim2.new(0.05, 0, 0.1, 0)
        message.BackgroundTransparency = 1
        message.TextColor3 = Color3.new(1, 1, 1)
        message.TextSize = 36
        message.Font = Enum.Font.GothamBold
        
        if winnerName then
            message.Text = winnerName .. "が鳥居に到達し、ゲームをクリアしました！"
        else
            message.Text = "ゲームクリア！おめでとうございます！"
        end
        
        message.Parent = victoryFrame
        
        -- UIに追加
        local sealUI = playerGui:FindFirstChild("SealUI")
        if sealUI then
            victoryFrame.Parent = sealUI
            
            -- アニメーション
            victoryFrame.Position = UDim2.new(0.25, 0, -0.5, 0)
            
            local tween = TweenService:Create(
                victoryFrame,
                TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.25, 0, 0.35, 0)}
            )
            tween:Play()
            
            -- 効果音
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://6518811702" -- 勝利音
            sound.Volume = 0.8
            sound.Parent = victoryFrame
            sound:Play()
        end
    end
end)

-- 初期化
print("SealUI initialized")