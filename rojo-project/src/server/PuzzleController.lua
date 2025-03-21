-- PuzzleController.lua
-- 謎解き要素を管理するモジュールスクリプト

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local PuzzleController = {}
PuzzleController.SolvedPuzzles = {}
PuzzleController.PuzzleItems = {}

-- 謎解きの定義
PuzzleController.Puzzles = {
    -- 謎1: 四季の和歌
    {
        id = "seasons_poem",
        name = "四季の和歌",
        description = "四季を表す和歌の断片を正しい順序で並べる",
        hint = "春夏秋冬の順に並べると…",
        requiredItems = {"spring_poem", "summer_poem", "autumn_poem", "winter_poem"},
        solution = function(items)
            -- 正しい順序で並んでいるか確認
            local correctOrder = {"spring_poem", "summer_poem", "autumn_poem", "winter_poem"}
            for i, itemId in ipairs(items) do
                if itemId ~= correctOrder[i] then
                    return false
                end
            end
            return true
        end,
        reward = "seasonal_key"
    },
    
    -- 謎2: 家紋の謎
    {
        id = "family_crest",
        name = "家紋の謎",
        description = "5つの家紋を正しい場所に配置する",
        hint = "家紋の形と方角には関連がある",
        requiredItems = {"north_crest", "east_crest", "south_crest", "west_crest", "center_crest"},
        solution = function(positions)
            -- 各家紋が正しい方角に配置されているか確認
            local correctPositions = {
                north_crest = Vector3.new(0, 0, -40),
                east_crest = Vector3.new(40, 0, 0),
                south_crest = Vector3.new(0, 0, 40),
                west_crest = Vector3.new(-40, 0, 0),
                center_crest = Vector3.new(0, 0, 0)
            }
            
            for itemId, position in pairs(positions) do
                local correctPos = correctPositions[itemId]
                if not correctPos or (position - correctPos).Magnitude > 5 then
                    return false
                end
            end
            return true
        end,
        reward = "family_scroll"
    },
    
    -- 謎3: 暗号文書
    {
        id = "cipher_document",
        name = "暗号文書",
        description = "古文書に隠された暗号を解読する",
        hint = "文字を逆から読むと意味が通る",
        requiredItems = {"cipher_page1", "cipher_page2", "cipher_page3"},
        solution = function(input)
            -- プレイヤーが入力した解答が正しいか確認
            return input:lower() == "月影草花風"
        end,
        reward = "hidden_key"
    },
    
    -- 謎4: 茶室の謎
    {
        id = "tea_ceremony",
        name = "茶室の謎",
        description = "茶道具を正しい配置で並べる",
        hint = "茶碗、茶筅、茶入れ、菓子器の配置には決まりがある",
        requiredItems = {"tea_bowl", "tea_whisk", "tea_caddy", "sweet_container"},
        solution = function(arrangement)
            -- 茶道具の配置が正しいか確認
            local correctArrangement = {
                tea_bowl = {position = Vector3.new(0, 0, 5), rotation = Vector3.new(0, 0, 0)},
                tea_whisk = {position = Vector3.new(2, 0, 5), rotation = Vector3.new(0, 90, 0)},
                tea_caddy = {position = Vector3.new(-2, 0, 5), rotation = Vector3.new(0, 0, 0)},
                sweet_container = {position = Vector3.new(0, 0, 7), rotation = Vector3.new(0, 0, 0)}
            }
            
            for itemId, data in pairs(arrangement) do
                local correct = correctArrangement[itemId]
                if not correct or 
                   (data.position - correct.position).Magnitude > 1 or
                   (data.rotation - correct.rotation).Magnitude > 10 then
                    return false
                end
            end
            return true
        end,
        reward = "tea_master_scroll"
    },
    
    -- 謎5: 最終謎
    {
        id = "final_puzzle",
        name = "家の秘密",
        description = "4つの鍵を使って隠し部屋を開く",
        hint = "すべての謎を解くと最後の扉が開く",
        requiredItems = {"seasonal_key", "family_scroll", "hidden_key", "tea_master_scroll"},
        solution = function(items)
            -- すべての必要アイテムを持っているか確認
            local requiredItems = {"seasonal_key", "family_scroll", "hidden_key", "tea_master_scroll"}
            for _, requiredItem in ipairs(requiredItems) do
                local hasItem = false
                for _, item in ipairs(items) do
                    if item == requiredItem then
                        hasItem = true
                        break
                    end
                end
                if not hasItem then
                    return false
                end
            end
            return true
        end,
        reward = "exit_key"
    }
}

-- 謎解きアイテムの作成
function PuzzleController.CreatePuzzleItems()
    local itemsFolder = Instance.new("Folder")
    itemsFolder.Name = "PuzzleItems"
    itemsFolder.Parent = workspace
    
    -- 四季の和歌アイテム
    local poemItems = {
        {id = "spring_poem", name = "春の和歌", color = "Pastel green", position = Vector3.new(30, 1, 20)},
        {id = "summer_poem", name = "夏の和歌", color = "Bright blue", position = Vector3.new(-25, 1, 35)},
        {id = "autumn_poem", name = "秋の和歌", color = "Bright orange", position = Vector3.new(-40, 1, -15)},
        {id = "winter_poem", name = "冬の和歌", color = "White", position = Vector3.new(15, 1, -30)}
    }
    
    for _, itemInfo in ipairs(poemItems) do
        local item = Instance.new("Part")
        item.Name = itemInfo.id
        item.Size = Vector3.new(2, 0.2, 3)
        item.Position = itemInfo.position
        item.Anchored = true
        item.CanCollide = false
        item.BrickColor = BrickColor.new(itemInfo.color)
        item.Material = Enum.Material.Neon
        
        -- アイテム情報の設定
        item:SetAttribute("ItemType", "puzzle_item")
        item:SetAttribute("ItemId", itemInfo.id)
        item:SetAttribute("ItemName", itemInfo.name)
        
        -- 説明ラベル
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ItemLabel"
        billboardGui.Size = UDim2.new(0, 100, 0, 40)
        billboardGui.StudsOffset = Vector3.new(0, 1, 0)
        billboardGui.Adornee = item
        billboardGui.Parent = item
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NameLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = itemInfo.name
        textLabel.Parent = billboardGui
        
        -- クリックイベント
        local clickDetector = Instance.new("ClickDetector")
        clickDetector.Parent = item
        clickDetector.MouseClick:Connect(function(player)
            PuzzleController.CollectItem(player, itemInfo.id)
        end)
        
        item.Parent = itemsFolder
        PuzzleController.PuzzleItems[itemInfo.id] = item
    end
    
    -- 家紋アイテム
    local crestItems = {
        {id = "north_crest", name = "北の家紋", color = "Navy blue", position = Vector3.new(10, 1, 10)},
        {id = "east_crest", name = "東の家紋", color = "Bright green", position = Vector3.new(25, 1, -20)},
        {id = "south_crest", name = "南の家紋", color = "Bright red", position = Vector3.new(-10, 1, 25)},
        {id = "west_crest", name = "西の家紋", color = "White", position = Vector3.new(-30, 1, -25)},
        {id = "center_crest", name = "中央の家紋", color = "Gold", position = Vector3.new(0, 1, 0)}
    }
    
    for _, itemInfo in ipairs(crestItems) do
        local item = Instance.new("Part")
        item.Name = itemInfo.id
        item.Shape = Enum.PartType.Cylinder
        item.Size = Vector3.new(0.2, 3, 3)
        item.Position = itemInfo.position
        item.Anchored = true
        item.CanCollide = false
        item.BrickColor = BrickColor.new(itemInfo.color)
        item.Material = Enum.Material.SmoothPlastic
        
        -- アイテム情報の設定
        item:SetAttribute("ItemType", "puzzle_item")
        item:SetAttribute("ItemId", itemInfo.id)
        item:SetAttribute("ItemName", itemInfo.name)
        
        -- 説明ラベル
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ItemLabel"
        billboardGui.Size = UDim2.new(0, 100, 0, 40)
        billboardGui.StudsOffset = Vector3.new(0, 1, 0)
        billboardGui.Adornee = item
        billboardGui.Parent = item
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NameLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = itemInfo.name
        textLabel.Parent = billboardGui
        
        -- クリックイベント
        local clickDetector = Instance.new("ClickDetector")
        clickDetector.Parent = item
        clickDetector.MouseClick:Connect(function(player)
            PuzzleController.CollectItem(player, itemInfo.id)
        end)
        
        item.Parent = itemsFolder
        PuzzleController.PuzzleItems[itemInfo.id] = item
    end
    
    -- 暗号文書アイテム
    local cipherItems = {
        {id = "cipher_page1", name = "暗号ページ1", color = "Brick yellow", position = Vector3.new(35, 1, -35)},
        {id = "cipher_page2", name = "暗号ページ2", color = "Brick yellow", position = Vector3.new(-35, 1, 30)},
        {id = "cipher_page3", name = "暗号ページ3", color = "Brick yellow", position = Vector3.new(5, 1, -15)}
    }
    
    for _, itemInfo in ipairs(cipherItems) do
        local item = Instance.new("Part")
        item.Name = itemInfo.id
        item.Size = Vector3.new(2, 0.1, 3)
        item.Position = itemInfo.position
        item.Anchored = true
        item.CanCollide = false
        item.BrickColor = BrickColor.new(itemInfo.color)
        item.Material = Enum.Material.SmoothPlastic
        
        -- アイテム情報の設定
        item:SetAttribute("ItemType", "puzzle_item")
        item:SetAttribute("ItemId", itemInfo.id)
        item:SetAttribute("ItemName", itemInfo.name)
        
        -- 説明ラベル
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ItemLabel"
        billboardGui.Size = UDim2.new(0, 100, 0, 40)
        billboardGui.StudsOffset = Vector3.new(0, 1, 0)
        billboardGui.Adornee = item
        billboardGui.Parent = item
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NameLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(0, 0, 0)
        textLabel.TextStrokeTransparency = 1
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = itemInfo.name
        textLabel.Parent = billboardGui
        
        -- クリックイベント
        local clickDetector = Instance.new("ClickDetector")
        clickDetector.Parent = item
        clickDetector.MouseClick:Connect(function(player)
            PuzzleController.CollectItem(player, itemInfo.id)
        end)
        
        item.Parent = itemsFolder
        PuzzleController.PuzzleItems[itemInfo.id] = item
    end
    
    -- 茶道具アイテム
    local teaItems = {
        {id = "tea_bowl", name = "茶碗", color = "Reddish brown", position = Vector3.new(15, 1, 15)},
        {id = "tea_whisk", name = "茶筅", color = "Bright yellow", position = Vector3.new(-15, 1, -10)},
        {id = "tea_caddy", name = "茶入れ", color = "Dark green", position = Vector3.new(20, 1, -10)},
        {id = "sweet_container", name = "菓子器", color = "Bright red", position = Vector3.new(-20, 1, 15)}
    }
    
    for _, itemInfo in ipairs(teaItems) do
        local item = Instance.new("Part")
        item.Name = itemInfo.id
        
        if itemInfo.id == "tea_bowl" then
            item.Shape = Enum.PartType.Cylinder
            item.Size = Vector3.new(1, 2, 2)
        elseif itemInfo.id == "tea_whisk" then
            item.Size = Vector3.new(0.5, 2, 0.5)
        elseif itemInfo.id == "tea_caddy" then
            item.Size = Vector3.new(1, 2, 1)
        else
            item.Size = Vector3.new(2, 1, 2)
        end
        
        item.Position = itemInfo.position
        item.Anchored = true
        item.CanCollide = false
        item.BrickColor = BrickColor.new(itemInfo.color)
        item.Material = Enum.Material.SmoothPlastic
        
        -- アイテム情報の設定
        item:SetAttribute("ItemType", "puzzle_item")
        item:SetAttribute("ItemId", itemInfo.id)
        item:SetAttribute("ItemName", itemInfo.name)
        
        -- 説明ラベル
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ItemLabel"
        billboardGui.Size = UDim2.new(0, 100, 0, 40)
        billboardGui.StudsOffset = Vector3.new(0, 1, 0)
        billboardGui.Adornee = item
        billboardGui.Parent = item
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NameLabel"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = itemInfo.name
        textLabel.Parent = billboardGui
        
        -- クリックイベント
        local clickDetector = Instance.new("ClickDetector")
        clickDetector.Parent = item
        clickDetector.MouseClick:Connect(function(player)
            PuzzleController.CollectItem(player, itemInfo.id)
        end)
        
        item.Parent = itemsFolder
        PuzzleController.PuzzleItems[itemInfo.id] = item
    end
end

-- プレイヤーがアイテムを拾う
function PuzzleController.CollectItem(player, itemId)
    -- プレイヤーのインベントリにアイテムを追加
    local inventory = player:FindFirstChild("PuzzleInventory")
    if not inventory then
        inventory = Instance.new("Folder")
        inventory.Name = "PuzzleInventory"
        inventory.Parent = player
    end
    
    -- 既に持っているか確認
    if inventory:FindFirstChild(itemId) then
        -- 既に持っている場合はメッセージを表示
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("ShowMessage") then
            remoteEvents.ShowMessage:FireClient(player, "既に持っています: " .. PuzzleController.PuzzleItems[itemId]:GetAttribute("ItemName"))
        end
        return
    end
    
    -- インベントリにアイテムを追加
    local item = Instance.new("StringValue")
    item.Name = itemId
    item.Value = PuzzleController.PuzzleItems[itemId]:GetAttribute("ItemName")
    item.Parent = inventory
    
    -- アイテム取得メッセージを表示
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents and remoteEvents:FindFirstChild("ShowMessage") then
        remoteEvents.ShowMessage:FireClient(player, "アイテムを取得しました: " .. item.Value)
    end
    
    -- アイテム取得イベントを発火
    if remoteEvents and remoteEvents:FindFirstChild("ItemCollected") then
        remoteEvents.ItemCollected:FireClient(player, itemId, item.Value)
    end
    
    -- 謎解きの進行状況をチェック
    PuzzleController.CheckPuzzleProgress(player)
end

-- 謎解きの進行状況をチェック
function PuzzleController.CheckPuzzleProgress(player)
    local inventory = player:FindFirstChild("PuzzleInventory")
    if not inventory then return end
    
    -- プレイヤーのインベントリ内のアイテムを取得
    local playerItems = {}
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("StringValue") then
            table.insert(playerItems, item.Name)
        end
    end
    
    -- 各謎解きの条件をチェック
    for _, puzzle in ipairs(PuzzleController.Puzzles) do
        -- 既に解いた謎はスキップ
        if PuzzleController.SolvedPuzzles[player.UserId .. "_" .. puzzle.id] then
            continue
        end
        
        -- 必要なアイテムをすべて持っているか確認
        local hasAllItems = true
        for _, requiredItem in ipairs(puzzle.requiredItems) do
            local hasItem = false
            for _, playerItem in ipairs(playerItems) do
                if playerItem == requiredItem then
                    hasItem = true
                    break
                end
            end
            if not hasItem then
                hasAllItems = false
                break
            end
        end
        
        -- 必要なアイテムをすべて持っている場合、謎解き可能を通知
        if hasAllItems then
            local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remoteEvents and remoteEvents:FindFirstChild("PuzzleAvailable") then
                remoteEvents.PuzzleAvailable:FireClient(player, puzzle.id, puzzle.name, puzzle.description, puzzle.hint)
            end
        end
    end
end

-- 謎解きの解答を確認
function PuzzleController.CheckPuzzleSolution(player, puzzleId, solution)
    -- 謎解きの情報を取得
    local puzzle = nil
    for _, p in ipairs(PuzzleController.Puzzles) do
        if p.id == puzzleId then
            puzzle = p
            break
        end
    end
    
    if not puzzle then
        return false, "謎解きが見つかりません"
    end
    
    -- 既に解いた謎かチェック
    if PuzzleController.SolvedPuzzles[player.UserId .. "_" .. puzzleId] then
        return false, "既に解いた謎です"
    end
    
    -- 解答が正しいか確認
    local isCorrect = puzzle.solution(solution)
    
    if isCorrect then
        -- 謎解き成功
        PuzzleController.SolvedPuzzles[player.UserId .. "_" .. puzzleId] = true
        
        -- 報酬を与える
        local inventory = player:FindFirstChild("PuzzleInventory")
        if not inventory then
            inventory = Instance.new("Folder")
            inventory.Name = "PuzzleInventory"
            inventory.Parent = player
        end
        
        local reward = Instance.new("StringValue")
        reward.Name = puzzle.reward
        reward.Value = "報酬: " .. puzzle.reward
        reward.Parent = inventory
        
        -- 成功メッセージを表示
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("ShowMessage") then
            remoteEvents.ShowMessage:FireClient(player, "謎解き成功！報酬を獲得しました: " .. puzzle.reward)
        end
        
        -- 謎解き成功イベントを発火
        if remoteEvents and remoteEvents:FindFirstChild("PuzzleSolved") then
            remoteEvents.PuzzleSolved:FireClient(player, puzzleId, puzzle.name, puzzle.reward)
        end
        
        -- すべての謎を解いたかチェック
        local allSolved = true
        for _, p in ipairs(PuzzleController.Puzzles) do
            if not PuzzleController.SolvedPuzzles[player.UserId .. "_" .. p.id] then
                allSolved = false
                break
            end
        end
        
        if allSolved then
            -- すべての謎を解いた場合、脱出口を開放
            if remoteEvents and remoteEvents:FindFirstChild("AllPuzzlesSolved") then
                remoteEvents.AllPuzzlesSolved:FireClient(player)
            end
        end
        
        return true, "謎解き成功！"
    else
        -- 謎解き失敗
        local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if remoteEvents and remoteEvents:FindFirstChild("ShowMessage") then
            remoteEvents.ShowMessage:FireClient(player, "謎解き失敗。もう一度考えてみてください。")
        end
        
        return false, "謎解き失敗"
    end
end

-- 初期化
function PuzzleController.Initialize()
    print("謎解きシステムを初期化中...")
    
    -- 謎解きアイテムの作成
    PuzzleController.CreatePuzzleItems()
    
    -- RemoteEventsの設定
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if not remoteEvents then
        remoteEvents = Instance.new("Folder")
        remoteEvents.Name = "RemoteEvents"
        remoteEvents.Parent = ReplicatedStorage
    end
    
    -- 謎解き関連のRemoteEventを作成
    local events = {
        "ShowMessage",
        "ItemCollected",
        "PuzzleAvailable",
        "PuzzleSolved",
        "AllPuzzlesSolved",
        "CheckPuzzleSolution"
    }
    
    for _, eventName in ipairs(events) do
        if not remoteEvents:FindFirstChild(eventName) then
            local event = Instance.new("RemoteEvent")
            event.Name = eventName
            event.Parent = remoteEvents
        end
    end
    
    -- CheckPuzzleSolutionイベントのハンドラを設定
    remoteEvents.CheckPuzzleSolution.OnServerEvent:Connect(function(player, puzzleId, solution)
        PuzzleController.CheckPuzzleSolution(player, puzzleId, solution)
    end)
    
    -- プレイヤーが参加したときの処理
    Players.PlayerAdded:Connect(function(player)
        -- プレイヤーのインベントリを作成
        local inventory = Instance.new("Folder")
        inventory.Name = "PuzzleInventory"
        inventory.Parent = player
        
        -- プレイヤーが退出したときの処理
        player.CharacterRemoving:Connect(function()
            -- 必要に応じてプレイヤーの進行状況を保存
        end)
    end)
    
    print("謎解きシステムの初期化が完了しました")
end

return PuzzleController