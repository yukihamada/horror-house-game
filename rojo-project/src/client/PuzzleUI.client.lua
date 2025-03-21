-- PuzzleUI.client.lua
-- 謎解きのUIを管理するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local showMessageEvent = remoteEvents:WaitForChild("ShowMessage")
local itemCollectedEvent = remoteEvents:WaitForChild("ItemCollected")
local puzzleAvailableEvent = remoteEvents:WaitForChild("PuzzleAvailable")
local puzzleSolvedEvent = remoteEvents:WaitForChild("PuzzleSolved")
local allPuzzlesSolvedEvent = remoteEvents:WaitForChild("AllPuzzlesSolved")
local checkPuzzleSolutionEvent = remoteEvents:WaitForChild("CheckPuzzleSolution")

-- インベントリUI
local function createInventoryUI()
    local inventoryGui = Instance.new("ScreenGui")
    inventoryGui.Name = "InventoryGui"
    inventoryGui.ResetOnSpawn = false
    inventoryGui.Enabled = false
    inventoryGui.Parent = playerGui
    
    -- 背景フレーム
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(0.6, 0, 0.7, 0)
    background.Position = UDim2.new(0.2, 0, 0.15, 0)
    background.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    background.BackgroundTransparency = 0.2
    background.BorderSizePixel = 2
    background.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    background.Parent = inventoryGui
    
    -- タイトル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    titleLabel.BackgroundTransparency = 0.5
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = "インベントリ"
    titleLabel.Parent = background
    
    -- アイテムリスト
    local itemsScrollingFrame = Instance.new("ScrollingFrame")
    itemsScrollingFrame.Name = "ItemsScrollingFrame"
    itemsScrollingFrame.Size = UDim2.new(0.95, 0, 0.8, 0)
    itemsScrollingFrame.Position = UDim2.new(0.025, 0, 0.15, 0)
    itemsScrollingFrame.BackgroundTransparency = 0.9
    itemsScrollingFrame.BorderSizePixel = 0
    itemsScrollingFrame.ScrollBarThickness = 8
    itemsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- 動的に調整
    itemsScrollingFrame.Parent = background
    
    -- 閉じるボタン
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0.025, 0)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Text = "X"
    closeButton.Parent = background
    
    -- 閉じるボタンのクリックイベント
    closeButton.MouseButton1Click:Connect(function()
        inventoryGui.Enabled = false
    end)
    
    return inventoryGui
end

-- 謎解きUI
local function createPuzzleUI()
    local puzzleGui = Instance.new("ScreenGui")
    puzzleGui.Name = "PuzzleGui"
    puzzleGui.ResetOnSpawn = false
    puzzleGui.Enabled = false
    puzzleGui.Parent = playerGui
    
    -- 背景フレーム
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(0.7, 0, 0.8, 0)
    background.Position = UDim2.new(0.15, 0, 0.1, 0)
    background.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    background.BackgroundTransparency = 0.1
    background.BorderSizePixel = 2
    background.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
    background.Parent = puzzleGui
    
    -- タイトル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    titleLabel.BackgroundTransparency = 0.5
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Text = "謎解き"
    titleLabel.Parent = background
    
    -- 説明
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "DescriptionLabel"
    descriptionLabel.Size = UDim2.new(0.95, 0, 0.2, 0)
    descriptionLabel.Position = UDim2.new(0.025, 0, 0.12, 0)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.TextColor3 = Color3.new(1, 1, 1)
    descriptionLabel.TextScaled = true
    descriptionLabel.TextWrapped = true
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.Font = Enum.Font.SourceSans
    descriptionLabel.Text = "謎の説明"
    descriptionLabel.Parent = background
    
    -- ヒント
    local hintLabel = Instance.new("TextLabel")
    hintLabel.Name = "HintLabel"
    hintLabel.Size = UDim2.new(0.95, 0, 0.1, 0)
    hintLabel.Position = UDim2.new(0.025, 0, 0.33, 0)
    hintLabel.BackgroundTransparency = 1
    hintLabel.TextColor3 = Color3.new(1, 0.8, 0.2)
    hintLabel.TextScaled = true
    hintLabel.TextWrapped = true
    hintLabel.TextXAlignment = Enum.TextXAlignment.Left
    hintLabel.Font = Enum.Font.SourceSansItalic
    hintLabel.Text = "ヒント: "
    hintLabel.Parent = background
    
    -- 解答入力
    local solutionFrame = Instance.new("Frame")
    solutionFrame.Name = "SolutionFrame"
    solutionFrame.Size = UDim2.new(0.95, 0, 0.4, 0)
    solutionFrame.Position = UDim2.new(0.025, 0, 0.45, 0)
    solutionFrame.BackgroundTransparency = 0.9
    solutionFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    solutionFrame.BorderSizePixel = 1
    solutionFrame.Parent = background
    
    -- 解答テキストボックス
    local solutionTextBox = Instance.new("TextBox")
    solutionTextBox.Name = "SolutionTextBox"
    solutionTextBox.Size = UDim2.new(0.9, 0, 0.2, 0)
    solutionTextBox.Position = UDim2.new(0.05, 0, 0.1, 0)
    solutionTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    solutionTextBox.TextColor3 = Color3.new(0, 0, 0)
    solutionTextBox.TextScaled = true
    solutionTextBox.Font = Enum.Font.SourceSans
    solutionTextBox.Text = ""
    solutionTextBox.PlaceholderText = "解答を入力してください"
    solutionTextBox.ClearTextOnFocus = false
    solutionTextBox.Parent = solutionFrame
    
    -- 解答ボタン
    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0.3, 0, 0.15, 0)
    submitButton.Position = UDim2.new(0.35, 0, 0.4, 0)
    submitButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.TextScaled = true
    submitButton.Font = Enum.Font.SourceSansBold
    submitButton.Text = "解答する"
    submitButton.Parent = solutionFrame
    
    -- 閉じるボタン
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0.025, 0)
    closeButton.BackgroundColor3 = Color3.new(0.8, 0, 0)
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Text = "X"
    closeButton.Parent = background
    
    -- 閉じるボタンのクリックイベント
    closeButton.MouseButton1Click:Connect(function()
        puzzleGui.Enabled = false
    end)
    
    return puzzleGui
end

-- メッセージUI
local function createMessageUI()
    local messageGui = Instance.new("ScreenGui")
    messageGui.Name = "MessageGui"
    messageGui.ResetOnSpawn = false
    messageGui.Parent = playerGui
    
    -- メッセージフレーム
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(0.5, 0, 0.1, 0)
    messageFrame.Position = UDim2.new(0.25, 0, 0.8, 0)
    messageFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    messageFrame.BackgroundTransparency = 0.5
    messageFrame.BorderSizePixel = 2
    messageFrame.BorderColor3 = Color3.new(1, 1, 1)
    messageFrame.Visible = false
    messageFrame.Parent = messageGui
    
    -- メッセージテキスト
    local messageText = Instance.new("TextLabel")
    messageText.Name = "MessageText"
    messageText.Size = UDim2.new(0.95, 0, 0.8, 0)
    messageText.Position = UDim2.new(0.025, 0, 0.1, 0)
    messageText.BackgroundTransparency = 1
    messageText.TextColor3 = Color3.new(1, 1, 1)
    messageText.TextScaled = true
    messageText.Font = Enum.Font.SourceSansBold
    messageText.Text = ""
    messageText.Parent = messageFrame
    
    return messageGui
end

-- インベントリの更新
local function updateInventory(inventoryGui)
    local itemsScrollingFrame = inventoryGui.Background.ItemsScrollingFrame
    
    -- 既存のアイテムを削除
    for _, child in ipairs(itemsScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- プレイヤーのインベントリを取得
    local inventory = player:FindFirstChild("PuzzleInventory")
    if not inventory then return end
    
    -- アイテムを表示
    local itemHeight = 50
    local padding = 5
    local yPosition = 0
    
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("StringValue") then
            local itemFrame = Instance.new("Frame")
            itemFrame.Name = item.Name .. "Frame"
            itemFrame.Size = UDim2.new(0.95, 0, 0, itemHeight)
            itemFrame.Position = UDim2.new(0.025, 0, 0, yPosition)
            itemFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            itemFrame.BackgroundTransparency = 0.5
            itemFrame.BorderSizePixel = 1
            itemFrame.Parent = itemsScrollingFrame
            
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = "ItemLabel"
            itemLabel.Size = UDim2.new(0.95, 0, 0.8, 0)
            itemLabel.Position = UDim2.new(0.025, 0, 0.1, 0)
            itemLabel.BackgroundTransparency = 1
            itemLabel.TextColor3 = Color3.new(1, 1, 1)
            itemLabel.TextScaled = true
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.Font = Enum.Font.SourceSans
            itemLabel.Text = item.Value
            itemLabel.Parent = itemFrame
            
            yPosition = yPosition + itemHeight + padding
        end
    end
    
    -- スクロールフレームのキャンバスサイズを更新
    itemsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition)
end

-- メッセージの表示
local function showMessage(message)
    local messageGui = playerGui:FindFirstChild("MessageGui")
    if not messageGui then return end
    
    local messageFrame = messageGui.MessageFrame
    local messageText = messageFrame.MessageText
    
    messageText.Text = message
    messageFrame.Visible = true
    
    -- 3秒後に非表示
    delay(3, function()
        messageFrame.Visible = false
    end)
end

-- 謎解きUIの設定
local function setupPuzzleUI(puzzleGui, puzzleId, puzzleName, description, hint)
    local titleLabel = puzzleGui.Background.TitleLabel
    local descriptionLabel = puzzleGui.Background.DescriptionLabel
    local hintLabel = puzzleGui.Background.HintLabel
    local solutionTextBox = puzzleGui.Background.SolutionFrame.SolutionTextBox
    local submitButton = puzzleGui.Background.SolutionFrame.SubmitButton
    
    -- UIの内容を設定
    titleLabel.Text = puzzleName
    descriptionLabel.Text = description
    hintLabel.Text = "ヒント: " .. hint
    solutionTextBox.Text = ""
    
    -- 解答ボタンのクリックイベント
    submitButton.MouseButton1Click:Connect(function()
        local solution = solutionTextBox.Text
        if solution and solution ~= "" then
            checkPuzzleSolutionEvent:FireServer(puzzleId, solution)
        else
            showMessage("解答を入力してください")
        end
    end)
    
    -- UIを表示
    puzzleGui.Enabled = true
end

-- 古いUIは無効化（ModernUIを使用するため）
-- local inventoryGui = createInventoryUI()
-- local puzzleGui = createPuzzleUI()
-- local messageGui = createMessageUI()
local inventoryGui = nil
local puzzleGui = nil
local messageGui = nil

-- イベントハンドラの設定
showMessageEvent.OnClientEvent:Connect(showMessage)

itemCollectedEvent.OnClientEvent:Connect(function(itemId, itemName)
    showMessage("アイテムを取得しました: " .. itemName)
    updateInventory(inventoryGui)
end)

puzzleAvailableEvent.OnClientEvent:Connect(function(puzzleId, puzzleName, description, hint)
    showMessage("新しい謎が解けるようになりました: " .. puzzleName)
    setupPuzzleUI(puzzleGui, puzzleId, puzzleName, description, hint)
end)

puzzleSolvedEvent.OnClientEvent:Connect(function(puzzleId, puzzleName, reward)
    showMessage("謎を解きました: " .. puzzleName .. "\n報酬: " .. reward)
    updateInventory(inventoryGui)
    puzzleGui.Enabled = false
end)

allPuzzlesSolvedEvent.OnClientEvent:Connect(function()
    showMessage("すべての謎を解きました！出口が開きました。")
end)

-- キー入力の処理
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Tab then
        -- Tabキーでインベントリを開閉
        inventoryGui.Enabled = not inventoryGui.Enabled
        if inventoryGui.Enabled then
            updateInventory(inventoryGui)
        end
    end
end)

-- 初期化完了メッセージ
print("謎解きUIの初期化が完了しました")