-- UIManager.lua
-- UIの管理を行うLocalScript

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

-- メッセージ表示イベント
Events:WaitForChild("ShowMessage").OnClientEvent:Connect(function(message)
	local messageGui = script.Parent:WaitForChild("MessageGui")
	local messageLabel = messageGui:WaitForChild("MessageLabel")
	
	messageLabel.Text = message
	messageGui.Visible = true
	
	-- 3秒後にメッセージを非表示
	delay(3, function()
		messageGui.Visible = false
	end)
end)

-- アイテム追加イベント
Events:WaitForChild("AddItem").OnClientEvent:Connect(function(itemData)
	-- インベントリUIの更新処理
	local inventoryGui = script.Parent:WaitForChild("InventoryGui")
	local itemsFrame = inventoryGui:WaitForChild("ItemsFrame")
	
	-- アイテムスロットの作成
	local itemSlot = Instance.new("ImageButton")
	itemSlot.Name = itemData.id
	itemSlot.Size = UDim2.new(0, 50, 0, 50)
	itemSlot.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	itemSlot.BorderSizePixel = 2
	
	-- アイテム名ラベル
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, 0, 0, 20)
	nameLabel.Position = UDim2.new(0, 0, 1, 0)
	nameLabel.BackgroundTransparency = 0.5
	nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 12
	nameLabel.Text = itemData.name
	nameLabel.Parent = itemSlot
	
	-- アイテムスロットをクリックしたときの処理
	itemSlot.MouseButton1Click:Connect(function()
		-- アイテム詳細の表示
		local detailsFrame = inventoryGui:WaitForChild("DetailsFrame")
		local detailsName = detailsFrame:WaitForChild("NameLabel")
		local detailsDesc = detailsFrame:WaitForChild("DescriptionLabel")
		
		detailsName.Text = itemData.name
		detailsDesc.Text = itemData.description
		detailsFrame.Visible = true
	end)
	
	-- アイテムスロットをインベントリに追加
	itemSlot.Parent = itemsFrame
	
	-- インベントリUIを表示
	inventoryGui.Visible = true
end)

-- SAN値更新イベント
Events:WaitForChild("UpdateSanity").OnClientEvent:Connect(function(sanityValue)
	local sanityGui = script.Parent:WaitForChild("SanityGui")
	local sanityBar = sanityGui:WaitForChild("SanityBar")
	
	-- SAN値バーの更新
	sanityBar.Size = UDim2.new(sanityValue / 100, 0, 1, 0)
	
	-- SAN値に応じた視覚効果
	local sanityEffect = script.Parent:WaitForChild("SanityEffect")
	sanityEffect.BackgroundTransparency = math.min(1, sanityValue / 50)
end)