-- GameStartup.client.lua
-- クライアント側の初期化スクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("日本の古民家 - 謎解きと妖怪ゲーム クライアント初期化中...")

-- ゲーム開始時のインストラクション表示（ModernUIに置き換えるため無効化）
local function showGameInstructions()
    -- 新しいUIを使用するため、この関数は何もしない
    return nil
end

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local gameStateChangedEvent = remoteEvents:WaitForChild("GameStateChanged")

-- ゲーム状態変更イベントのハンドラ
gameStateChangedEvent.OnClientEvent:Connect(function(state, timeRemaining)
    print("ゲーム状態が変更されました: " .. state)
    
    if state == "Preparation" then
        -- ゲーム準備フェーズ
        -- 新しいUIを使用するため、古いUIは表示しない
    elseif state == "InProgress" then
        -- ゲーム進行中
    elseif state == "Ended" then
        -- ゲーム終了
    end
end)

-- コアGUIの設定
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

print("クライアント初期化が完了しました")