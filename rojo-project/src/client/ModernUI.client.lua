-- ModernUI.client.lua
-- モダンなUIデザインを実装するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UIテーマ設定
local UITheme = {
    -- メインカラー
    Primary = Color3.fromRGB(45, 49, 66),       -- ダークブルー
    Secondary = Color3.fromRGB(239, 35, 60),    -- レッド
    Accent = Color3.fromRGB(237, 242, 244),     -- ライトグレー
    Background = Color3.fromRGB(25, 29, 40),    -- ダークグレー
    
    -- テキストカラー
    TextPrimary = Color3.fromRGB(255, 255, 255),    -- 白
    TextSecondary = Color3.fromRGB(200, 200, 200),  -- ライトグレー
    TextAccent = Color3.fromRGB(239, 35, 60),       -- レッド
    
    -- フォント
    FontHeader = Enum.Font.GothamBold,
    FontBody = Enum.Font.Gotham,
    FontAccent = Enum.Font.GothamSemibold,
    
    -- アニメーション
    TweenTime = 0.3,
    TweenStyle = Enum.EasingStyle.Quint,
    TweenDirection = Enum.EasingDirection.Out,
    
    -- サイズ
    CornerRadius = UDim.new(0, 8),
    ButtonHeight = UDim.new(0, 40),
    Padding = UDim.new(0, 10),
}

-- UIユーティリティ関数
local UIUtil = {}

-- 角丸の追加
function UIUtil.AddCorners(guiObject, radius)
    radius = radius or UITheme.CornerRadius
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius
    corner.Parent = guiObject
    
    return corner
end

-- 影の追加
function UIUtil.AddShadow(guiObject, transparency, offset)
    transparency = transparency or 0.7
    offset = offset or UDim2.new(0, 2, 0, 2)
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = transparency
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0) + offset
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.ZIndex = guiObject.ZIndex - 1
    shadow.Parent = guiObject
    
    UIUtil.AddCorners(shadow, UITheme.CornerRadius)
    
    return shadow
end

-- グラデーションの追加
function UIUtil.AddGradient(guiObject, color1, color2, rotation)
    color1 = color1 or UITheme.Primary
    color2 = color2 or Color3.fromRGB(color1.R * 0.8, color1.G * 0.8, color1.B * 0.8)
    rotation = rotation or 90
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation
    gradient.Parent = guiObject
    
    return gradient
end

-- パディングの追加
function UIUtil.AddPadding(guiObject, padding)
    padding = padding or UITheme.Padding
    
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingTop = padding
    uiPadding.PaddingBottom = padding
    uiPadding.PaddingLeft = padding
    uiPadding.PaddingRight = padding
    uiPadding.Parent = guiObject
    
    return uiPadding
end

-- リストレイアウトの追加
function UIUtil.AddListLayout(guiObject, padding, horizontalAlignment, verticalAlignment)
    padding = padding or UITheme.Padding
    horizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Center
    verticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = padding
    listLayout.HorizontalAlignment = horizontalAlignment
    listLayout.VerticalAlignment = verticalAlignment
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = guiObject
    
    return listLayout
end

-- ストロークの追加
function UIUtil.AddStroke(guiObject, color, thickness, transparency)
    color = color or UITheme.Secondary
    thickness = thickness or 1
    transparency = transparency or 0
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.Parent = guiObject
    
    return stroke
end

-- アニメーションの作成
function UIUtil.CreateTween(instance, properties, time, style, direction)
    time = time or UITheme.TweenTime
    style = style or UITheme.TweenStyle
    direction = direction or UITheme.TweenDirection
    
    local tweenInfo = TweenInfo.new(time, style, direction)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    
    return tween
end

-- ボタンのホバーエフェクト
function UIUtil.AddButtonEffects(button, hoverColor, clickColor)
    hoverColor = hoverColor or UITheme.Secondary
    clickColor = clickColor or Color3.fromRGB(hoverColor.R * 0.8, hoverColor.G * 0.8, hoverColor.B * 0.8)
    
    local defaultColor = button.BackgroundColor3
    
    -- ホバー時
    button.MouseEnter:Connect(function()
        local tween = UIUtil.CreateTween(button, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    -- ホバー解除時
    button.MouseLeave:Connect(function()
        local tween = UIUtil.CreateTween(button, {BackgroundColor3 = defaultColor})
        tween:Play()
    end)
    
    -- クリック時
    button.MouseButton1Down:Connect(function()
        local tween = UIUtil.CreateTween(button, {BackgroundColor3 = clickColor})
        tween:Play()
    end)
    
    -- クリック解除時
    button.MouseButton1Up:Connect(function()
        local tween = UIUtil.CreateTween(button, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
end

-- モダンなボタンの作成
function UIUtil.CreateButton(text, size, position, parent)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = size or UDim2.new(0.8, 0, 0, 40)
    button.Position = position or UDim2.new(0.1, 0, 0.5, 0)
    button.BackgroundColor3 = UITheme.Secondary
    button.TextColor3 = UITheme.TextPrimary
    button.Font = UITheme.FontAccent
    button.TextSize = 18
    button.Text = text
    button.AutoButtonColor = false
    button.Parent = parent
    
    UIUtil.AddCorners(button)
    UIUtil.AddShadow(button)
    UIUtil.AddButtonEffects(button)
    
    return button
end

-- モダンなテキストラベルの作成
function UIUtil.CreateTextLabel(text, size, position, parent, textColor, backgroundColor, font, textSize)
    textColor = textColor or UITheme.TextPrimary
    backgroundColor = backgroundColor or UITheme.Primary
    font = font or UITheme.FontBody
    textSize = textSize or 16
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = size or UDim2.new(0.8, 0, 0, 30)
    label.Position = position or UDim2.new(0.1, 0, 0.1, 0)
    label.BackgroundColor3 = backgroundColor
    label.TextColor3 = textColor
    label.Font = font
    label.TextSize = textSize
    label.Text = text
    label.TextWrapped = true
    label.Parent = parent
    
    UIUtil.AddCorners(label)
    
    return label
end

-- モダンなフレームの作成
function UIUtil.CreateFrame(name, size, position, parent, backgroundColor)
    backgroundColor = backgroundColor or UITheme.Background
    
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size or UDim2.new(0.8, 0, 0.8, 0)
    frame.Position = position or UDim2.new(0.1, 0, 0.1, 0)
    frame.BackgroundColor3 = backgroundColor
    frame.Parent = parent
    
    UIUtil.AddCorners(frame)
    UIUtil.AddShadow(frame)
    
    return frame
end

-- モダンなスクロールフレームの作成
function UIUtil.CreateScrollingFrame(name, size, position, parent, backgroundColor)
    backgroundColor = backgroundColor or UITheme.Background
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = name
    scrollFrame.Size = size or UDim2.new(0.8, 0, 0.8, 0)
    scrollFrame.Position = position or UDim2.new(0.1, 0, 0.1, 0)
    scrollFrame.BackgroundColor3 = backgroundColor
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = UITheme.Secondary
    scrollFrame.Parent = parent
    
    UIUtil.AddCorners(scrollFrame)
    UIUtil.AddPadding(scrollFrame)
    UIUtil.AddListLayout(scrollFrame)
    
    return scrollFrame
end

-- モダンなテキスト入力の作成
function UIUtil.CreateTextBox(placeholderText, size, position, parent)
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = size or UDim2.new(0.8, 0, 0, 40)
    textBox.Position = position or UDim2.new(0.1, 0, 0.5, 0)
    textBox.BackgroundColor3 = UITheme.Accent
    textBox.TextColor3 = UITheme.Primary
    textBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    textBox.PlaceholderText = placeholderText or "テキストを入力..."
    textBox.Font = UITheme.FontBody
    textBox.TextSize = 16
    textBox.Text = ""
    textBox.ClearTextOnFocus = false
    textBox.Parent = parent
    
    UIUtil.AddCorners(textBox)
    UIUtil.AddPadding(textBox, UDim.new(0, 8))
    
    return textBox
end

-- モダンなアイコンの作成
function UIUtil.CreateIcon(iconId, size, position, parent)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = size or UDim2.new(0, 30, 0, 30)
    icon.Position = position or UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.Parent = parent
    
    return icon
end

-- モダンなインベントリUIの作成
function CreateModernInventoryUI()
    local inventoryGui = Instance.new("ScreenGui")
    inventoryGui.Name = "ModernInventoryGui"
    inventoryGui.ResetOnSpawn = false
    inventoryGui.Enabled = false
    inventoryGui.Parent = playerGui
    
    -- メインフレーム
    local mainFrame = UIUtil.CreateFrame("MainFrame", UDim2.new(0.7, 0, 0.8, 0), UDim2.new(0.15, 0, 0.1, 0), inventoryGui)
    
    -- ヘッダー
    local headerFrame = UIUtil.CreateFrame("HeaderFrame", UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0, 0), mainFrame, UITheme.Primary)
    
    -- タイトル
    local titleLabel = UIUtil.CreateTextLabel("インベントリ", UDim2.new(0.7, 0, 0.8, 0), UDim2.new(0.02, 0, 0.1, 0), headerFrame, UITheme.TextPrimary, UITheme.Primary, UITheme.FontHeader, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 閉じるボタン
    local closeButton = UIUtil.CreateButton("X", UDim2.new(0, 40, 0, 40), UDim2.new(0.97, 0, 0.5, 0), headerFrame)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.Font = UITheme.FontHeader
    
    -- アイテムコンテナ
    local itemsContainer = UIUtil.CreateScrollingFrame("ItemsContainer", UDim2.new(0.98, 0, 0.88, 0), UDim2.new(0.01, 0, 0.11, 0), mainFrame)
    
    -- 閉じるボタンのクリックイベント
    closeButton.MouseButton1Click:Connect(function()
        local tween = UIUtil.CreateTween(mainFrame, {Position = UDim2.new(0.15, 0, 1.2, 0)})
        tween:Play()
        
        tween.Completed:Connect(function()
            inventoryGui.Enabled = false
            mainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
        end)
    end)
    
    -- アニメーション
    mainFrame.Position = UDim2.new(0.15, 0, 1.2, 0)
    
    return inventoryGui
end

-- モダンな謎解きUIの作成
function CreateModernPuzzleUI()
    local puzzleGui = Instance.new("ScreenGui")
    puzzleGui.Name = "ModernPuzzleGui"
    puzzleGui.ResetOnSpawn = false
    puzzleGui.Enabled = false
    puzzleGui.Parent = playerGui
    
    -- 背景オーバーレイ
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.7
    overlay.Parent = puzzleGui
    
    -- メインフレーム
    local mainFrame = UIUtil.CreateFrame("MainFrame", UDim2.new(0.8, 0, 0.8, 0), UDim2.new(0.1, 0, 0.1, 0), puzzleGui)
    
    -- ヘッダー
    local headerFrame = UIUtil.CreateFrame("HeaderFrame", UDim2.new(1, 0, 0.12, 0), UDim2.new(0, 0, 0, 0), mainFrame, UITheme.Primary)
    
    -- タイトル
    local titleLabel = UIUtil.CreateTextLabel("謎解き", UDim2.new(0.7, 0, 0.8, 0), UDim2.new(0.02, 0, 0.1, 0), headerFrame, UITheme.TextPrimary, UITheme.Primary, UITheme.FontHeader, 24)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- 閉じるボタン
    local closeButton = UIUtil.CreateButton("X", UDim2.new(0, 40, 0, 40), UDim2.new(0.97, 0, 0.5, 0), headerFrame)
    closeButton.AnchorPoint = Vector2.new(1, 0.5)
    closeButton.Font = UITheme.FontHeader
    
    -- コンテンツフレーム
    local contentFrame = UIUtil.CreateFrame("ContentFrame", UDim2.new(0.98, 0, 0.86, 0), UDim2.new(0.01, 0, 0.13, 0), mainFrame, Color3.fromRGB(35, 39, 50))
    
    -- 説明セクション
    local descriptionFrame = UIUtil.CreateFrame("DescriptionFrame", UDim2.new(0.98, 0, 0.25, 0), UDim2.new(0.01, 0, 0.01, 0), contentFrame, UITheme.Primary)
    
    local descriptionTitle = UIUtil.CreateTextLabel("説明", UDim2.new(0.98, 0, 0.25, 0), UDim2.new(0.01, 0, 0.05, 0), descriptionFrame, UITheme.TextAccent, UITheme.Primary, UITheme.FontAccent, 18)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local descriptionText = UIUtil.CreateTextLabel("謎の説明がここに表示されます。", UDim2.new(0.98, 0, 0.65, 0), UDim2.new(0.01, 0, 0.3, 0), descriptionFrame, UITheme.TextSecondary, UITheme.Primary, UITheme.FontBody, 16)
    descriptionText.BackgroundTransparency = 1
    descriptionText.TextXAlignment = Enum.TextXAlignment.Left
    descriptionText.TextWrapped = true
    
    -- ヒントセクション
    local hintFrame = UIUtil.CreateFrame("HintFrame", UDim2.new(0.98, 0, 0.15, 0), UDim2.new(0.01, 0, 0.27, 0), contentFrame, UITheme.Primary)
    
    local hintTitle = UIUtil.CreateTextLabel("ヒント", UDim2.new(0.98, 0, 0.3, 0), UDim2.new(0.01, 0, 0.05, 0), hintFrame, UITheme.TextAccent, UITheme.Primary, UITheme.FontAccent, 18)
    hintTitle.BackgroundTransparency = 1
    hintTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local hintText = UIUtil.CreateTextLabel("ヒントがここに表示されます。", UDim2.new(0.98, 0, 0.6, 0), UDim2.new(0.01, 0, 0.35, 0), hintFrame, UITheme.TextSecondary, UITheme.Primary, UITheme.FontBody, 16)
    hintText.BackgroundTransparency = 1
    hintText.TextXAlignment = Enum.TextXAlignment.Left
    hintText.TextWrapped = true
    
    -- 解答セクション
    local solutionFrame = UIUtil.CreateFrame("SolutionFrame", UDim2.new(0.98, 0, 0.55, 0), UDim2.new(0.01, 0, 0.43, 0), contentFrame, UITheme.Primary)
    
    local solutionTitle = UIUtil.CreateTextLabel("解答", UDim2.new(0.98, 0, 0.15, 0), UDim2.new(0.01, 0, 0.05, 0), solutionFrame, UITheme.TextAccent, UITheme.Primary, UITheme.FontAccent, 18)
    solutionTitle.BackgroundTransparency = 1
    solutionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local solutionTextBox = UIUtil.CreateTextBox("解答を入力してください", UDim2.new(0.7, 0, 0, 50), UDim2.new(0.15, 0, 0.3, 0), solutionFrame)
    solutionTextBox.TextSize = 18
    
    local submitButton = UIUtil.CreateButton("解答する", UDim2.new(0.3, 0, 0, 50), UDim2.new(0.35, 0, 0.7, 0), solutionFrame)
    
    -- 閉じるボタンのクリックイベント
    closeButton.MouseButton1Click:Connect(function()
        local tween = UIUtil.CreateTween(mainFrame, {Position = UDim2.new(0.1, 0, 1.2, 0)})
        tween:Play()
        
        tween.Completed:Connect(function()
            puzzleGui.Enabled = false
            mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
        end)
    end)
    
    -- アニメーション
    mainFrame.Position = UDim2.new(0.1, 0, 1.2, 0)
    
    return puzzleGui, descriptionText, hintText, solutionTextBox, submitButton, titleLabel
end

-- モダンなメッセージUIの作成
function CreateModernMessageUI()
    local messageGui = Instance.new("ScreenGui")
    messageGui.Name = "ModernMessageGui"
    messageGui.ResetOnSpawn = false
    messageGui.Parent = playerGui
    
    -- メッセージコンテナ
    local messageContainer = Instance.new("Frame")
    messageContainer.Name = "MessageContainer"
    messageContainer.Size = UDim2.new(1, 0, 0.3, 0)
    messageContainer.Position = UDim2.new(0, 0, 0.7, 0)
    messageContainer.BackgroundTransparency = 1
    messageContainer.Parent = messageGui
    
    UIUtil.AddListLayout(messageContainer, UDim.new(0, 5), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom)
    
    return messageGui, messageContainer
end

-- メッセージの表示
function ShowModernMessage(messageContainer, text, messageType)
    messageType = messageType or "info" -- info, success, warning, error
    
    local colors = {
        info = UITheme.Primary,
        success = Color3.fromRGB(46, 204, 113),
        warning = Color3.fromRGB(241, 196, 15),
        error = UITheme.Secondary
    }
    
    local messageFrame = UIUtil.CreateFrame("MessageFrame", UDim2.new(0.8, 0, 0, 0), UDim2.new(0.1, 0, 0, 0), messageContainer, colors[messageType])
    messageFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local messageText = UIUtil.CreateTextLabel(text, UDim2.new(0.95, 0, 0, 0), UDim2.new(0.025, 0, 0, 5), messageFrame, UITheme.TextPrimary, colors[messageType], UITheme.FontBody, 16)
    messageText.BackgroundTransparency = 1
    messageText.TextWrapped = true
    messageText.AutomaticSize = Enum.AutomaticSize.Y
    
    -- アニメーション
    messageFrame.Size = UDim2.new(0.8, 0, 0, 0)
    local sizeTween = UIUtil.CreateTween(messageFrame, {Size = UDim2.new(0.8, 0, 0, messageText.TextBounds.Y + 20)})
    sizeTween:Play()
    
    -- 3秒後に消える
    delay(3, function()
        local fadeTween = UIUtil.CreateTween(messageFrame, {BackgroundTransparency = 1})
        local textFadeTween = UIUtil.CreateTween(messageText, {TextTransparency = 1})
        
        fadeTween:Play()
        textFadeTween:Play()
        
        fadeTween.Completed:Connect(function()
            messageFrame:Destroy()
        end)
    end)
end

-- インベントリの更新
function UpdateModernInventory(inventoryGui)
    local itemsContainer = inventoryGui.MainFrame.ItemsContainer
    
    -- 既存のアイテムを削除
    for _, child in ipairs(itemsContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- プレイヤーのインベントリを取得
    local inventory = player:FindFirstChild("PuzzleInventory")
    if not inventory then return end
    
    -- アイテムを表示
    local itemHeight = 60
    local yPosition = 0
    
    for i, item in ipairs(inventory:GetChildren()) do
        if item:IsA("StringValue") then
            local itemFrame = UIUtil.CreateFrame(item.Name .. "Frame", UDim2.new(0.95, 0, 0, itemHeight), UDim2.new(0.025, 0, 0, yPosition), itemsContainer, UITheme.Primary)
            itemFrame.LayoutOrder = i
            
            -- アイテムアイコン
            local itemIcon = UIUtil.CreateIcon("rbxassetid://6031251532", UDim2.new(0, 40, 0, 40), UDim2.new(0, 10, 0, 10), itemFrame)
            
            -- アイテム名
            local itemName = UIUtil.CreateTextLabel(item.Value, UDim2.new(0.7, 0, 0.8, 0), UDim2.new(0.15, 0, 0.1, 0), itemFrame, UITheme.TextPrimary, UITheme.Primary, UITheme.FontBody, 16)
            itemName.BackgroundTransparency = 1
            itemName.TextXAlignment = Enum.TextXAlignment.Left
            
            yPosition = yPosition + itemHeight + 10
        end
    end
    
    -- スクロールフレームのキャンバスサイズを更新
    itemsContainer.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

-- 謎解きUIの設定
function SetupModernPuzzleUI(puzzleGui, descriptionText, hintText, solutionTextBox, submitButton, titleLabel, puzzleId, puzzleName, description, hint)
    -- UIの内容を設定
    titleLabel.Text = puzzleName
    descriptionText.Text = description
    hintText.Text = hint
    solutionTextBox.Text = ""
    
    -- 解答ボタンのクリックイベント
    local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
    local checkPuzzleSolutionEvent = remoteEvents:WaitForChild("CheckPuzzleSolution")
    
    -- 既存の接続を切断
    if submitButton.ClickConnection then
        submitButton.ClickConnection:Disconnect()
    end
    
    -- 新しい接続を作成
    submitButton.ClickConnection = submitButton.MouseButton1Click:Connect(function()
        local solution = solutionTextBox.Text
        if solution and solution ~= "" then
            checkPuzzleSolutionEvent:FireServer(puzzleId, solution)
        else
            ShowModernMessage(playerGui.ModernMessageGui.MessageContainer, "解答を入力してください", "warning")
        end
    end)
    
    -- UIを表示
    puzzleGui.Enabled = true
    
    -- アニメーション
    local mainFrame = puzzleGui.MainFrame
    mainFrame.Position = UDim2.new(0.1, 0, 1.2, 0)
    
    local tween = UIUtil.CreateTween(mainFrame, {Position = UDim2.new(0.1, 0, 0.1, 0)})
    tween:Play()
end

-- UIの初期化
local modernInventoryGui = CreateModernInventoryUI()
local modernPuzzleGui, descriptionText, hintText, solutionTextBox, submitButton, titleLabel = CreateModernPuzzleUI()
local modernMessageGui, messageContainer = CreateModernMessageUI()

-- イベントハンドラの設定
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

remoteEvents:WaitForChild("ShowMessage").OnClientEvent:Connect(function(message)
    ShowModernMessage(messageContainer, message, "info")
end)

remoteEvents:WaitForChild("ItemCollected").OnClientEvent:Connect(function(itemId, itemName)
    ShowModernMessage(messageContainer, "アイテムを取得しました: " .. itemName, "success")
    UpdateModernInventory(modernInventoryGui)
end)

remoteEvents:WaitForChild("PuzzleAvailable").OnClientEvent:Connect(function(puzzleId, puzzleName, description, hint)
    ShowModernMessage(messageContainer, "新しい謎が解けるようになりました: " .. puzzleName, "info")
    SetupModernPuzzleUI(modernPuzzleGui, descriptionText, hintText, solutionTextBox, submitButton, titleLabel, puzzleId, puzzleName, description, hint)
end)

remoteEvents:WaitForChild("PuzzleSolved").OnClientEvent:Connect(function(puzzleId, puzzleName, reward)
    ShowModernMessage(messageContainer, "謎を解きました: " .. puzzleName .. "\n報酬: " .. reward, "success")
    UpdateModernInventory(modernInventoryGui)
    
    local tween = UIUtil.CreateTween(modernPuzzleGui.MainFrame, {Position = UDim2.new(0.1, 0, 1.2, 0)})
    tween:Play()
    
    tween.Completed:Connect(function()
        modernPuzzleGui.Enabled = false
        modernPuzzleGui.MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    end)
end)

remoteEvents:WaitForChild("AllPuzzlesSolved").OnClientEvent:Connect(function()
    ShowModernMessage(messageContainer, "すべての謎を解きました！出口が開きました。", "success")
end)

-- キー入力の処理
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Tab then
        -- Tabキーでインベントリを開閉
        if modernInventoryGui.Enabled then
            local tween = UIUtil.CreateTween(modernInventoryGui.MainFrame, {Position = UDim2.new(0.15, 0, 1.2, 0)})
            tween:Play()
            
            tween.Completed:Connect(function()
                modernInventoryGui.Enabled = false
                modernInventoryGui.MainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
            end)
        else
            modernInventoryGui.Enabled = true
            UpdateModernInventory(modernInventoryGui)
            
            local mainFrame = modernInventoryGui.MainFrame
            mainFrame.Position = UDim2.new(0.15, 0, 1.2, 0)
            
            local tween = UIUtil.CreateTween(mainFrame, {Position = UDim2.new(0.15, 0, 0.1, 0)})
            tween:Play()
        end
    end
end)

-- 初期化完了メッセージ
print("モダンUIの初期化が完了しました")