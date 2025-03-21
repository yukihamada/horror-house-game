-- GameIntroUI.client.lua
-- ゲーム開始時の説明UIを表示するクライアントスクリプト

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ゲーム説明UI
local function createGameIntroUI()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "GameIntroGui"
    introGui.ResetOnSpawn = false
    introGui.Parent = playerGui
    
    -- 背景オーバーレイ
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = introGui
    
    -- メインパネル
    local mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0.7, 0, 0.8, 0)
    mainPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    mainPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainPanel.BackgroundTransparency = 0.1
    mainPanel.BorderSizePixel = 0
    mainPanel.Parent = introGui
    
    -- 角丸
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainPanel
    
    -- 影
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.Position = UDim2.new(0.5, 5, 0.5, 5)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.ZIndex = mainPanel.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = mainPanel
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 16)
    shadowCorner.Parent = shadow
    
    -- ヘッダー
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0.15, 0)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    header.BackgroundTransparency = 0.1
    header.BorderSizePixel = 0
    header.Parent = mainPanel
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    -- ヘッダーの下部を四角にする
    local headerBottom = Instance.new("Frame")
    headerBottom.Name = "HeaderBottom"
    headerBottom.Size = UDim2.new(1, 0, 0.5, 0)
    headerBottom.Position = UDim2.new(0, 0, 0.5, 0)
    headerBottom.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    headerBottom.BackgroundTransparency = 0.1
    headerBottom.BorderSizePixel = 0
    headerBottom.Parent = header
    
    -- タイトル
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
    titleLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 36
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "おばけ屋敷の謎解き"
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = header
    
    -- コンテンツ領域
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(0.95, 0, 0.75, 0)
    contentFrame.Position = UDim2.new(0.025, 0, 0.175, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 100)
    contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- スクロール可能な領域
    contentFrame.Parent = mainPanel
    
    -- 説明テキスト
    local descriptionText = Instance.new("TextLabel")
    descriptionText.Name = "DescriptionText"
    descriptionText.Size = UDim2.new(0.95, 0, 0.95, 0)
    descriptionText.Position = UDim2.new(0.025, 0, 0.025, 0)
    descriptionText.BackgroundTransparency = 1
    descriptionText.TextColor3 = Color3.new(1, 1, 1)
    descriptionText.TextSize = 36
    descriptionText.Font = Enum.Font.GothamBold
    descriptionText.TextWrapped = true
    descriptionText.TextXAlignment = Enum.TextXAlignment.Left
    descriptionText.TextYAlignment = Enum.TextYAlignment.Top
    descriptionText.Text = [[
おばけ屋敷からの脱出！

• 3つの封印の札を集めよう
• 鳥居の封印を解こう
• おばけから逃げよう
• WASD：歩く
• E：物を拾う

がんばって！
]]
    descriptionText.Parent = contentFrame
    
    -- 開始ボタン
    local startButton = Instance.new("TextButton")
    startButton.Name = "StartButton"
    startButton.Size = UDim2.new(0.3, 0, 0.08, 0)
    startButton.Position = UDim2.new(0.35, 0, 0.9, 0)
    startButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    startButton.TextColor3 = Color3.new(1, 1, 1)
    startButton.TextSize = 24
    startButton.Font = Enum.Font.GothamBold
    startButton.Text = "ゲーム開始"
    startButton.BorderSizePixel = 0
    startButton.Parent = mainPanel
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = startButton
    
    -- ボタンの影
    local buttonShadow = Instance.new("Frame")
    buttonShadow.Name = "ButtonShadow"
    buttonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    buttonShadow.BackgroundColor3 = Color3.new(0, 0, 0)
    buttonShadow.BackgroundTransparency = 0.6
    buttonShadow.Position = UDim2.new(0.5, 2, 0.5, 2)
    buttonShadow.Size = UDim2.new(1, 4, 1, 4)
    buttonShadow.ZIndex = startButton.ZIndex - 1
    buttonShadow.BorderSizePixel = 0
    buttonShadow.Parent = startButton
    
    local buttonShadowCorner = Instance.new("UICorner")
    buttonShadowCorner.CornerRadius = UDim.new(0, 8)
    buttonShadowCorner.Parent = buttonShadow
    
    -- ボタンのホバーエフェクト
    startButton.MouseEnter:Connect(function()
        local tween = TweenService:Create(
            startButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 100, 100), Size = UDim2.new(0.32, 0, 0.085, 0)}
        )
        tween:Play()
    end)
    
    startButton.MouseLeave:Connect(function()
        local tween = TweenService:Create(
            startButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(255, 70, 70), Size = UDim2.new(0.3, 0, 0.08, 0)}
        )
        tween:Play()
    end)
    
    -- ボタンクリック時の処理
    startButton.MouseButton1Click:Connect(function()
        -- クリックエフェクト
        local clickTween = TweenService:Create(
            startButton,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(200, 50, 50), Size = UDim2.new(0.28, 0, 0.075, 0)}
        )
        clickTween:Play()
        
        -- UIを閉じる
        wait(0.2)
        local closeTween = TweenService:Create(
            mainPanel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 1.5, 0)}
        )
        closeTween:Play()
        
        local overlayTween = TweenService:Create(
            overlay,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        )
        overlayTween:Play()
        
        wait(0.5)
        introGui:Destroy()
    end)
    
    -- 初期アニメーション
    mainPanel.Position = UDim2.new(0.5, 0, -1, 0)
    overlay.BackgroundTransparency = 1
    
    local panelTween = TweenService:Create(
        mainPanel,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0.5, 0)}
    )
    
    local overlayTween = TweenService:Create(
        overlay,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.5}
    )
    
    overlayTween:Play()
    wait(0.2)
    panelTween:Play()
    
    return introGui
end

-- ゲーム説明UIの表示
wait(1) -- ゲーム開始後1秒待機
local introUI = createGameIntroUI()

print("ゲーム説明UIの初期化が完了しました")