-- ItemUI.client.lua
-- アイテム関連のUI表示を管理するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local itemCollectedEvent = remoteEvents:WaitForChild("ItemCollected")
local showItemInfoEvent = remoteEvents:WaitForChild("ShowItemInfo")
local showItemNameEvent = remoteEvents:WaitForChild("ShowItemName")
local hideItemNameEvent = remoteEvents:WaitForChild("HideItemName")

-- アイテムUI用のScreenGuiを作成
local function createItemUI()
    -- メインのScreenGui
    local itemGui = Instance.new("ScreenGui")
    itemGui.Name = "ItemUI"
    itemGui.ResetOnSpawn = false
    itemGui.Parent = playerGui
    
    -- アイテム名表示用のフレーム
    local itemNameFrame = Instance.new("Frame")
    itemNameFrame.Name = "ItemNameFrame"
    itemNameFrame.Size = UDim2.new(0, 300, 0, 50)
    itemNameFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
    itemNameFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    itemNameFrame.BackgroundTransparency = 0.5
    itemNameFrame.BorderSizePixel = 0
    itemNameFrame.Visible = false
    itemNameFrame.Parent = itemGui
    
    -- 角を丸くする
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = itemNameFrame
    
    -- アイテム名表示用のテキストラベル
    local itemNameLabel = Instance.new("TextLabel")
    itemNameLabel.Name = "ItemNameLabel"
    itemNameLabel.Size = UDim2.new(1, 0, 1, 0)
    itemNameLabel.Position = UDim2.new(0, 0, 0, 0)
    itemNameLabel.BackgroundTransparency = 1
    itemNameLabel.Font = Enum.Font.GothamBold
    itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemNameLabel.TextSize = 20
    itemNameLabel.Text = ""
    itemNameLabel.Parent = itemNameFrame
    
    -- アイテム情報表示用のフレーム
    local itemInfoFrame = Instance.new("Frame")
    itemInfoFrame.Name = "ItemInfoFrame"
    itemInfoFrame.Size = UDim2.new(0, 400, 0, 300)
    itemInfoFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    itemInfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    itemInfoFrame.BackgroundTransparency = 0.2
    itemInfoFrame.BorderSizePixel = 0
    itemInfoFrame.Visible = false
    itemInfoFrame.Parent = itemGui
    
    -- 角を丸くする
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 10)
    infoCorner.Parent = itemInfoFrame
    
    -- アイテムタイトル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Text = ""
    titleLabel.Parent = itemInfoFrame
    
    -- アイテムタイプ
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(1, 0, 0, 30)
    typeLabel.Position = UDim2.new(0, 0, 0, 50)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Font = Enum.Font.Gotham
    typeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    typeLabel.TextSize = 18
    typeLabel.Text = ""
    typeLabel.Parent = itemInfoFrame
    
    -- 区切り線
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(0.9, 0, 0, 2)
    divider.Position = UDim2.new(0.05, 0, 0, 90)
    divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    divider.BorderSizePixel = 0
    divider.Parent = itemInfoFrame
    
    -- アイテム説明
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "DescriptionLabel"
    descriptionLabel.Size = UDim2.new(0.9, 0, 0, 100)
    descriptionLabel.Position = UDim2.new(0.05, 0, 0, 100)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    descriptionLabel.TextSize = 16
    descriptionLabel.Text = ""
    descriptionLabel.TextWrapped = true
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    descriptionLabel.Parent = itemInfoFrame
    
    -- 読める文書の内容
    local readableTextLabel = Instance.new("TextLabel")
    readableTextLabel.Name = "ReadableTextLabel"
    readableTextLabel.Size = UDim2.new(0.9, 0, 0, 100)
    readableTextLabel.Position = UDim2.new(0.05, 0, 0, 180)
    readableTextLabel.BackgroundTransparency = 1
    readableTextLabel.Font = Enum.Font.GothamItalic
    readableTextLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    readableTextLabel.TextSize = 14
    readableTextLabel.Text = ""
    readableTextLabel.TextWrapped = true
    readableTextLabel.TextXAlignment = Enum.TextXAlignment.Left
    readableTextLabel.TextYAlignment = Enum.TextYAlignment.Top
    readableTextLabel.Visible = false
    readableTextLabel.Parent = itemInfoFrame
    
    -- 閉じるボタン
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 100, 0, 40)
    closeButton.Position = UDim2.new(0.5, -50, 1, -60)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    closeButton.BorderSizePixel = 0
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 18
    closeButton.Text = "閉じる"
    closeButton.Parent = itemInfoFrame
    
    -- 閉じるボタンの角を丸くする
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = closeButton
    
    -- 閉じるボタンのクリックイベント
    closeButton.MouseButton1Click:Connect(function()
        -- アニメーションで消す
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(itemInfoFrame, tweenInfo, {Position = UDim2.new(0.5, -200, 1.5, 0)})
        tween:Play()
        
        tween.Completed:Connect(function()
            itemInfoFrame.Visible = false
            itemInfoFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        end)
    end)
    
    return itemGui
end

-- アイテム名の表示
local function showItemName(itemName)
    local itemUI = playerGui:FindFirstChild("ItemUI") or createItemUI()
    local itemNameFrame = itemUI.ItemNameFrame
    local itemNameLabel = itemNameFrame.ItemNameLabel
    
    itemNameLabel.Text = itemName
    
    -- アニメーションで表示
    itemNameFrame.Position = UDim2.new(0.5, -150, 0.9, 0)
    itemNameFrame.Transparency = 1
    itemNameFrame.Visible = true
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(itemNameFrame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.8, 0), BackgroundTransparency = 0.5})
    tween:Play()
end

-- アイテム名の非表示
local function hideItemName()
    local itemUI = playerGui:FindFirstChild("ItemUI")
    if not itemUI then return end
    
    local itemNameFrame = itemUI.ItemNameFrame
    
    -- アニメーションで非表示
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(itemNameFrame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.9, 0), BackgroundTransparency = 1})
    tween:Play()
    
    tween.Completed:Connect(function()
        itemNameFrame.Visible = false
    end)
end

-- アイテム情報の表示
local function showItemInfo(itemData)
    local itemUI = playerGui:FindFirstChild("ItemUI") or createItemUI()
    local itemInfoFrame = itemUI.ItemInfoFrame
    local titleLabel = itemInfoFrame.TitleLabel
    local typeLabel = itemInfoFrame.TypeLabel
    local descriptionLabel = itemInfoFrame.DescriptionLabel
    local readableTextLabel = itemInfoFrame.ReadableTextLabel
    
    titleLabel.Text = itemData.name
    typeLabel.Text = "種類: " .. itemData.type
    descriptionLabel.Text = itemData.description
    
    if itemData.readableText then
        readableTextLabel.Text = itemData.readableText
        readableTextLabel.Visible = true
    else
        readableTextLabel.Visible = false
    end
    
    -- アニメーションで表示
    itemInfoFrame.Position = UDim2.new(0.5, -200, 1.5, 0)
    itemInfoFrame.Visible = true
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(itemInfoFrame, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, -150)})
    tween:Play()
end

-- イベントの接続
showItemNameEvent.OnClientEvent:Connect(showItemName)
hideItemNameEvent.OnClientEvent:Connect(hideItemName)
showItemInfoEvent.OnClientEvent:Connect(showItemInfo)

-- アイテム収集イベント
itemCollectedEvent.OnClientEvent:Connect(function(itemId)
    -- ここでインベントリに追加する処理を実装
    print("アイテムを収集しました: " .. itemId)
end)

print("ItemUI initialized")