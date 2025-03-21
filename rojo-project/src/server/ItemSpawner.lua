-- ItemSpawner.lua
-- アイテムを生成して配置するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- アイテムデータモジュールの読み込み
local ItemsData = require(script.Parent.Parent.shared.ItemsData)

local ItemSpawner = {}

-- アイテムを生成する関数
function ItemSpawner.CreateItem(itemData)
    -- アイテムのモデルを作成
    local itemModel = Instance.new("Model")
    itemModel.Name = itemData.id
    
    -- アイテムの本体を作成
    local itemPart
    if itemData.model.shape == "Cylinder" then
        itemPart = Instance.new("CylinderHandleAdornment")
        itemPart.Height = itemData.model.size.Y
        itemPart.Radius = itemData.model.size.X / 2
        itemPart.CFrame = CFrame.new(itemData.position)
    else
        itemPart = Instance.new("Part")
        itemPart.Size = itemData.model.size
        itemPart.Position = itemData.position
        itemPart.Shape = itemData.model.shape == "Ball" and Enum.PartType.Ball or Enum.PartType.Block
    end
    
    itemPart.Name = "ItemPart"
    itemPart.Anchored = true
    itemPart.CanCollide = false
    itemPart.BrickColor = BrickColor.new(itemData.model.color)
    itemPart.Material = itemData.model.material
    
    -- テクスチャがある場合は適用
    if itemData.model.texture then
        local texture = Instance.new("Texture")
        texture.Texture = itemData.model.texture
        texture.StudsPerTileU = itemData.model.size.X
        texture.StudsPerTileV = itemData.model.size.Y
        texture.Face = Enum.NormalId.Front
        texture.Parent = itemPart
        
        -- 裏面にもテクスチャを適用
        local backTexture = Instance.new("Texture")
        backTexture.Texture = itemData.model.texture
        backTexture.StudsPerTileU = itemData.model.size.X
        backTexture.StudsPerTileV = itemData.model.size.Y
        backTexture.Face = Enum.NormalId.Back
        backTexture.Parent = itemPart
    end
    
    -- 光るエフェクトがある場合は追加
    if itemData.glow then
        local light = Instance.new("PointLight")
        light.Brightness = 1
        light.Range = 5
        light.Color = itemData.model.color
        light.Parent = itemPart
        
        -- 浮遊アニメーション用のスクリプト
        local floatScript = Instance.new("Script")
        floatScript.Name = "FloatScript"
        floatScript.Source = [[
            local part = script.Parent
            local originalY = part.Position.Y
            local time = 0
            
            game:GetService("RunService").Heartbeat:Connect(function(dt)
                time = time + dt
                local offset = math.sin(time * 2) * 0.3
                part.Position = Vector3.new(part.Position.X, originalY + offset, part.Position.Z)
            end)
        ]]
        floatScript.Parent = itemPart
    end
    
    -- アイテムの情報を属性として保存
    itemPart:SetAttribute("ItemId", itemData.id)
    itemPart:SetAttribute("ItemName", itemData.name)
    itemPart:SetAttribute("ItemType", itemData.type)
    itemPart:SetAttribute("ItemDescription", itemData.description)
    
    if itemData.readableText then
        itemPart:SetAttribute("ReadableText", itemData.readableText)
    end
    
    if itemData.useEffect then
        itemPart:SetAttribute("UseEffect", itemData.useEffect)
    end
    
    if itemData.collectSound then
        itemPart:SetAttribute("CollectSound", itemData.collectSound)
    end
    
    -- クリック検出用のClickDetectorを追加
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 10
    clickDetector.Parent = itemPart
    
    -- アイテム収集時の処理
    clickDetector.MouseClick:Connect(function(player)
        -- アイテム収集イベントを発火
        local itemCollectedEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and 
                                  ReplicatedStorage.RemoteEvents:FindFirstChild("ItemCollected")
        
        if itemCollectedEvent then
            itemCollectedEvent:FireClient(player, itemData.id)
        end
        
        -- 収集音を再生
        if itemData.collectSound then
            local sound = Instance.new("Sound")
            sound.SoundId = itemData.collectSound
            sound.Volume = 1
            sound.Parent = workspace
            sound:Play()
            
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end
        
        -- アイテム情報を表示
        local showItemInfoEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and 
                                 ReplicatedStorage.RemoteEvents:FindFirstChild("ShowItemInfo")
        
        if showItemInfoEvent then
            showItemInfoEvent:FireClient(player, itemData)
        end
        
        -- アイテムをプレイヤーのインベントリに追加（実際のインベントリシステムに合わせて実装）
        
        -- アイテムを消す
        itemModel:Destroy()
    end)
    
    -- ホバー時の処理
    clickDetector.MouseHoverEnter:Connect(function(player)
        -- アイテム名を表示
        local showItemNameEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and 
                                 ReplicatedStorage.RemoteEvents:FindFirstChild("ShowItemName")
        
        if showItemNameEvent then
            showItemNameEvent:FireClient(player, itemData.name)
        end
    end)
    
    clickDetector.MouseHoverLeave:Connect(function(player)
        -- アイテム名表示を消す
        local hideItemNameEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and 
                                 ReplicatedStorage.RemoteEvents:FindFirstChild("HideItemName")
        
        if hideItemNameEvent then
            hideItemNameEvent:FireClient(player)
        end
    end)
    
    itemPart.Parent = itemModel
    itemModel.Parent = workspace
    
    return itemModel
end

-- すべてのアイテムを生成する関数
function ItemSpawner.SpawnAllItems()
    print("アイテムの生成を開始します...")
    
    -- RemoteEventsフォルダがなければ作成
    if not ReplicatedStorage:FindFirstChild("RemoteEvents") then
        local remoteEvents = Instance.new("Folder")
        remoteEvents.Name = "RemoteEvents"
        remoteEvents.Parent = ReplicatedStorage
        
        -- 必要なRemoteEventを作成
        local events = {
            "ItemCollected",
            "ShowItemInfo",
            "ShowItemName",
            "HideItemName"
        }
        
        for _, eventName in ipairs(events) do
            local event = Instance.new("RemoteEvent")
            event.Name = eventName
            event.Parent = remoteEvents
        end
    end
    
    -- すべてのアイテムを生成
    for _, itemData in ipairs(ItemsData.Items) do
        ItemSpawner.CreateItem(itemData)
    end
    
    print("アイテムの生成が完了しました")
end

return ItemSpawner