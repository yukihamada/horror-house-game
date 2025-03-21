-- InteractiveObject.lua
-- プレイヤーが調査できるオブジェクト

local object = script.Parent
local ProximityPrompt = Instance.new("ProximityPrompt")
ProximityPrompt.ObjectText = "引き出し" -- オブジェクトの名前
ProximityPrompt.ActionText = "調べる" -- アクション名
ProximityPrompt.HoldDuration = 0.5 -- 長押し時間
ProximityPrompt.Parent = object

-- アイテムデータ（このオブジェクトから見つかるアイテム）
local itemData = {
	id = "key_bedroom", -- アイテムID
	name = "寝室の鍵", -- アイテム名
	description = "2階の寝室のドアを開けるための鍵", -- 説明
	found = false -- 既に見つかったかどうか
}

-- プレイヤーがオブジェクトを調査したときの処理
ProximityPrompt.Triggered:Connect(function(player)
	if not itemData.found then
		-- アイテム発見のメッセージ
		local message = itemData.name .. "を見つけた！"
		game.ReplicatedStorage.Events.ShowMessage:FireClient(player, message)
		
		-- インベントリにアイテムを追加
		game.ReplicatedStorage.Events.AddItem:FireClient(player, itemData)
		
		itemData.found = true
	else
		-- 既に調査済みのメッセージ
		game.ReplicatedStorage.Events.ShowMessage:FireClient(player, "何もない...")
	end
end)