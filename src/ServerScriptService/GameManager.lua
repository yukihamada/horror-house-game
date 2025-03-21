-- GameManager.lua
-- ゲームの基本的な管理を行うスクリプト

local GameManager = {}
GameManager.GameState = "Waiting" -- Waiting, Playing, GameOver, Completed

-- プレイヤーが参加したときの処理
game.Players.PlayerAdded:Connect(function(player)
	print(player.Name .. " has joined the game!")
	
	-- プレイヤーのキャラクターが読み込まれたときの処理
	player.CharacterAdded:Connect(function(character)
		-- 初期位置の設定（家の入り口など）
		local spawnLocation = workspace:FindFirstChild("SpawnLocation")
		if spawnLocation then
			character:SetPrimaryPartCFrame(spawnLocation.CFrame + Vector3.new(0, 5, 0))
		end
		
		-- 懐中電灯の追加
		local tool = Instance.new("Tool")
		tool.Name = "Flashlight"
		tool.RequiresHandle = true
		
		local handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(0.5, 1.2, 0.5)
		handle.Parent = tool
		
		local light = Instance.new("SpotLight")
		light.Brightness = 1
		light.Range = 30
		light.Angle = 45
		light.Parent = handle
		
		tool.Parent = player.Backpack
	end)
end)

-- プレイヤーが退出したときの処理
game.Players.PlayerRemoving:Connect(function(player)
	print(player.Name .. " has left the game!")
end)

return GameManager