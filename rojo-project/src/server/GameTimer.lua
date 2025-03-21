-- GameTimer.lua
-- ゲームの時間を管理するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameTimer = {}
GameTimer.RemainingTime = 5 * 60 -- 5分（秒単位）
GameTimer.IsRunning = false
GameTimer.TimeUpdateInterval = 1 -- 1秒ごとに更新

-- タイマーの開始
function GameTimer.Start()
    if GameTimer.IsRunning then return end
    
    GameTimer.IsRunning = true
    GameTimer.RemainingTime = 5 * 60 -- 5分にリセット
    
    -- RemoteEventsの取得
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if not remoteEvents then
        remoteEvents = Instance.new("Folder")
        remoteEvents.Name = "RemoteEvents"
        remoteEvents.Parent = ReplicatedStorage
    end
    
    -- TimeUpdatedイベントの取得または作成
    local timeUpdatedEvent = remoteEvents:FindFirstChild("TimeUpdated")
    if not timeUpdatedEvent then
        timeUpdatedEvent = Instance.new("RemoteEvent")
        timeUpdatedEvent.Name = "TimeUpdated"
        timeUpdatedEvent.Parent = remoteEvents
    end
    
    -- 初期時間を全プレイヤーに通知
    timeUpdatedEvent:FireAllClients(GameTimer.RemainingTime)
    
    -- タイマーの実行
    spawn(function()
        while GameTimer.IsRunning and GameTimer.RemainingTime > 0 do
            wait(GameTimer.TimeUpdateInterval)
            GameTimer.RemainingTime = GameTimer.RemainingTime - GameTimer.TimeUpdateInterval
            
            -- 時間を全プレイヤーに通知
            timeUpdatedEvent:FireAllClients(GameTimer.RemainingTime)
            
            -- 時間切れの処理
            if GameTimer.RemainingTime <= 0 then
                GameTimer.TimeUp()
                break
            end
        end
    end)
    
    print("ゲームタイマーを開始しました: " .. GameTimer.RemainingTime .. "秒")
end

-- タイマーの停止
function GameTimer.Stop()
    GameTimer.IsRunning = false
    print("ゲームタイマーを停止しました")
end

-- タイマーのリセット
function GameTimer.Reset()
    GameTimer.RemainingTime = 5 * 60
    
    -- RemoteEventsの取得
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("TimeUpdated") then
        remoteEvents.TimeUpdated:FireAllClients(GameTimer.RemainingTime)
    end
    
    print("ゲームタイマーをリセットしました: " .. GameTimer.RemainingTime .. "秒")
end

-- 時間切れの処理
function GameTimer.TimeUp()
    GameTimer.IsRunning = false
    
    -- RemoteEventsの取得
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("GameEnded") then
        remoteEvents.GameEnded:FireAllClients("TimeUp")
    end
    
    print("時間切れ: ゲーム終了")
end

-- プレイヤーが参加したときの処理
Players.PlayerAdded:Connect(function(player)
    -- 既にタイマーが実行中の場合、現在の時間を通知
    if GameTimer.IsRunning then
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("TimeUpdated") then
            remoteEvents.TimeUpdated:FireClient(player, GameTimer.RemainingTime)
        end
    end
end)

return GameTimer