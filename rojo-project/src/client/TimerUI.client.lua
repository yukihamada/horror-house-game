-- TimerUI.client.lua
-- 残り時間を表示するUIを管理するクライアントスクリプト
-- 注意: このスクリプトは無効化されています。タイマーはUIController.client.luaで管理されています。

--[[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local timeUpdatedEvent = remoteEvents:WaitForChild("TimeUpdated")

-- タイマーUI
local function createTimerUI()
    local timerGui = Instance.new("ScreenGui")
    timerGui.Name = "TimerGui"
    timerGui.ResetOnSpawn = false
    timerGui.Parent = playerGui
    
    -- タイマーフレーム
    local timerFrame = Instance.new("Frame")
    timerFrame.Name = "TimerFrame"
    timerFrame.Size = UDim2.new(0.22, 0, 0.1, 0)
    timerFrame.Position = UDim2.new(0.5, 0, 0.02, 0)
    timerFrame.AnchorPoint = Vector2.new(0.5, 0)
    timerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    timerFrame.BackgroundTransparency = 0.1
    timerFrame.BorderSizePixel = 0
    timerFrame.Parent = timerGui
    
    -- 角丸
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = timerFrame
    
    -- 影
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundColor3 = Color3.new(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.Position = UDim2.new(0.5, 3, 0.5, 3)
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.ZIndex = timerFrame.ZIndex - 1
    shadow.BorderSizePixel = 0
    shadow.Parent = timerFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- 内側の装飾フレーム
    local innerFrame = Instance.new("Frame")
    innerFrame.Name = "InnerFrame"
    innerFrame.Size = UDim2.new(0.96, 0, 0.85, 0)
    innerFrame.Position = UDim2.new(0.02, 0, 0.075, 0)
    innerFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    innerFrame.BackgroundTransparency = 0.1
    innerFrame.BorderSizePixel = 0
    innerFrame.Parent = timerFrame
    
    local innerCorner = Instance.new("UICorner")
    innerCorner.CornerRadius = UDim.new(0, 8)
    innerCorner.Parent = innerFrame
    
    -- グラデーション
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = innerFrame
    
    -- タイマーアイコン
    local timerIcon = Instance.new("ImageLabel")
    timerIcon.Name = "TimerIcon"
    timerIcon.Size = UDim2.new(0.15, 0, 0.6, 0)
    timerIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
    timerIcon.BackgroundTransparency = 1
    timerIcon.Image = "rbxassetid://7734010488" -- 時計アイコン
    timerIcon.ImageColor3 = Color3.fromRGB(255, 100, 100)
    timerIcon.Parent = innerFrame
    
    -- タイマーラベル
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
    timerLabel.Position = UDim2.new(0.25, 0, 0.15, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.TextSize = 28
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.Text = "残り時間: 05:00"
    timerLabel.TextXAlignment = Enum.TextXAlignment.Left
    timerLabel.Parent = innerFrame
    
    -- 装飾的な光沢効果
    local shine = Instance.new("Frame")
    shine.Name = "Shine"
    shine.Size = UDim2.new(1, 0, 0.1, 0)
    shine.Position = UDim2.new(0, 0, 0, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.9
    shine.BorderSizePixel = 0
    shine.Parent = timerFrame
    
    local shineCorner = Instance.new("UICorner")
    shineCorner.CornerRadius = UDim.new(0, 12)
    shineCorner.Parent = shine
    
    -- パルスアニメーション
    spawn(function()
        while wait(1) do
            local tween = TweenService:Create(
                timerIcon, 
                TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), 
                {ImageColor3 = Color3.fromRGB(255, 50, 50)}
            )
            tween:Play()
            wait(1)
            
            local tween2 = TweenService:Create(
                timerIcon, 
                TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), 
                {ImageColor3 = Color3.fromRGB(255, 150, 150)}
            )
            tween2:Play()
        end
    end)
    
    return timerGui, timerLabel
end

-- 時間の表示形式を整える
local function formatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%02d:%02d", minutes, remainingSeconds)
end

-- タイマーUIの作成
local timerGui, timerLabel = createTimerUI()

-- 残り時間の初期値（5分）
local remainingTime = 5 * 60

-- タイマーの更新
local function updateTimer(newTime)
    remainingTime = newTime
    timerLabel.Text = "残り時間: " .. formatTime(remainingTime)
    
    -- 残り時間が少なくなったら色を変える
    if remainingTime <= 60 then -- 残り1分
        timerLabel.TextColor3 = Color3.new(1, 0, 0) -- 赤色
    elseif remainingTime <= 300 then -- 残り5分
        timerLabel.TextColor3 = Color3.new(1, 0.5, 0) -- オレンジ色
    else
        timerLabel.TextColor3 = Color3.new(1, 1, 1) -- 白色
    end
end

-- サーバーからの時間更新イベント
timeUpdatedEvent.OnClientEvent:Connect(updateTimer)

-- ローカルでのタイマー更新（1秒ごと）
local lastUpdate = tick()
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastUpdate >= 1 then
        lastUpdate = now
        remainingTime = math.max(0, remainingTime - 1)
        updateTimer(remainingTime)
    end
end)

-- 初期化
updateTimer(remainingTime)
print("タイマーUIの初期化が完了しました")
]]