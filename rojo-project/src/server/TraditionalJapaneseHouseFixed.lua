-- TraditionalJapaneseHouseFixed.lua
-- 伝統的な日本家屋のマップを作成するモジュールスクリプト（修正版）

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TraditionalJapaneseHouse = {}

-- 伝統的な日本家屋のマップを作成する関数
function TraditionalJapaneseHouse.Create(parent)
    -- マップのモデル作成
    local map = Instance.new("Model")
    map.Name = "TraditionalJapaneseHouse"
    map.Parent = parent
    
    -- 基本設定
    local wallHeight = 8
    local wallThickness = 0.3
    local mapSize = 400
    local roomSize = 80
    local corridorWidth = 20
    
    -- 床の作成（高品質な木製フローリング）
    local floor = Instance.new("Part")
    floor.Name = "WoodenFloor"
    floor.Size = Vector3.new(mapSize, 1, mapSize)
    floor.Position = Vector3.new(0, 0, 0)
    floor.Anchored = true
    floor.BrickColor = BrickColor.new("Brown")
    floor.Material = Enum.Material.WoodPlanks
    floor.Parent = map
    
    -- 床のテクスチャ
    local floorTexture = Instance.new("Texture")
    floorTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
    floorTexture.StudsPerTileU = 10
    floorTexture.StudsPerTileV = 10
    floorTexture.Face = Enum.NormalId.Top
    floorTexture.Parent = floor
    
    -- 部屋のレイアウト定義
    local rooms = {
        -- 1階の部屋
        {name = "玄関", type = "entrance", floor = 1, x = -mapSize/4, z = -mapSize/2 + roomSize/2, size = {x = roomSize/2, z = roomSize}},
        {name = "和室1", type = "tatami", floor = 1, x = -mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "茶室", type = "tatami", floor = 1, x = mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "居間", type = "tatami", floor = 1, x = -mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "台所", type = "wooden", floor = 1, x = mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}},
        
        -- 2階の部屋
        {name = "和室2", type = "tatami", floor = 2, x = -mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "和室3", type = "tatami", floor = 2, x = mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "書斎", type = "wooden", floor = 2, x = -mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "寝室", type = "tatami", floor = 2, x = mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}}
    }
    
    -- 廊下のレイアウト定義
    local corridors = {
        -- 1階の廊下
        {floor = 1, startX = -mapSize/2 + corridorWidth, endX = mapSize/2 - corridorWidth, y = 0, z = 0, direction = "horizontal"},
        {floor = 1, startZ = -mapSize/2 + corridorWidth, endZ = mapSize/2 - corridorWidth, y = 0, x = 0, direction = "vertical"},
        
        -- 2階の廊下
        {floor = 2, startX = -mapSize/2 + corridorWidth, endX = mapSize/2 - corridorWidth, y = wallHeight + 1, z = 0, direction = "horizontal"},
        {floor = 2, startZ = -mapSize/2 + corridorWidth, endZ = mapSize/2 - corridorWidth, y = wallHeight + 1, x = 0, direction = "vertical"}
    }
    
    -- 縁側のレイアウト定義
    local verandas = {
        {startX = -mapSize/2 + roomSize, endX = mapSize/2 - roomSize, y = 0, z = -mapSize/2 + corridorWidth/2, direction = "horizontal"},
        {startX = -mapSize/2 + roomSize, endX = mapSize/2 - roomSize, y = 0, z = mapSize/2 - corridorWidth/2, direction = "horizontal"},
        {startZ = -mapSize/2 + roomSize, endZ = mapSize/2 - roomSize, y = 0, x = -mapSize/2 + corridorWidth/2, direction = "vertical"},
        {startZ = -mapSize/2 + roomSize, endZ = mapSize/2 - roomSize, y = 0, x = mapSize/2 - corridorWidth/2, direction = "vertical"}
    }
    
    -- 部屋を作成
    for _, room in ipairs(rooms) do
        local y = room.floor == 1 and 0 or wallHeight + 1
        
        -- 部屋の床
        local roomFloor = Instance.new("Part")
        roomFloor.Name = room.name .. "Floor"
        roomFloor.Size = Vector3.new(room.size.x, 0.2, room.size.z)
        roomFloor.Position = Vector3.new(room.x, y + 0.6, room.z)
        roomFloor.Anchored = true
        
        if room.type == "tatami" then
            -- 畳
            roomFloor.BrickColor = BrickColor.new("Olive")
            roomFloor.Material = Enum.Material.Fabric
            
            -- 畳のテクスチャ
            local tatamiTexture = Instance.new("Texture")
            tatamiTexture.Texture = "rbxassetid://7546645512" -- 畳テクスチャ
            tatamiTexture.StudsPerTileU = room.size.x / 2
            tatamiTexture.StudsPerTileV = room.size.z / 2
            tatamiTexture.Face = Enum.NormalId.Top
            tatamiTexture.Parent = roomFloor
            
            -- 畳の縁
            local border = Instance.new("Part")
            border.Name = room.name .. "TatamiBorder"
            border.Size = Vector3.new(roomFloor.Size.X + 1, 0.05, roomFloor.Size.Z + 1)
            border.Position = Vector3.new(roomFloor.Position.X, y + 0.55, roomFloor.Position.Z)
            border.Anchored = true
            border.BrickColor = BrickColor.new("Black")
            border.Material = Enum.Material.Fabric
            border.Parent = map
        else
            -- 木製の床
            roomFloor.BrickColor = BrickColor.new("Brown")
            roomFloor.Material = Enum.Material.WoodPlanks
            
            -- 木製床のテクスチャ
            local woodTexture = Instance.new("Texture")
            woodTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
            woodTexture.StudsPerTileU = 5
            woodTexture.StudsPerTileV = 5
            woodTexture.Face = Enum.NormalId.Top
            woodTexture.Parent = roomFloor
        end
        
        roomFloor.Parent = map
        
        -- 特殊な部屋の装飾
        if room.name == "和室1" then
            -- 床の間
            local tokonoma = Instance.new("Part")
            tokonoma.Name = "Tokonoma"
            tokonoma.Size = Vector3.new(room.size.x / 3, wallHeight * 0.8, 2)
            tokonoma.Position = Vector3.new(room.x - room.size.x / 3, y + wallHeight * 0.4, room.z - room.size.z / 2 + 1)
            tokonoma.Anchored = true
            tokonoma.BrickColor = BrickColor.new("Reddish brown")
            tokonoma.Material = Enum.Material.Wood
            
            -- 床の間のテクスチャ
            local tokonomaTexture = Instance.new("Texture")
            tokonomaTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
            tokonomaTexture.StudsPerTileU = room.size.x / 3
            tokonomaTexture.StudsPerTileV = wallHeight * 0.8
            tokonomaTexture.Face = Enum.NormalId.Front
            tokonomaTexture.Parent = tokonoma
            
            tokonoma.Parent = map
            
            -- 掛け軸
            local scroll = Instance.new("Part")
            scroll.Name = "HangingScroll"
            scroll.Size = Vector3.new(0.1, wallHeight * 0.6, room.size.x / 6)
            scroll.Position = Vector3.new(room.x - room.size.x / 3, y + wallHeight * 0.6, room.z - room.size.z / 2 + 0.5)
            scroll.Anchored = true
            scroll.BrickColor = BrickColor.new("White")
            scroll.Material = Enum.Material.Fabric
            
            -- 掛け軸のテクスチャ
            local scrollTexture = Instance.new("Texture")
            scrollTexture.Texture = "rbxassetid://7546636894" -- 和風模様
            scrollTexture.StudsPerTileU = room.size.x / 6
            scrollTexture.StudsPerTileV = wallHeight * 0.6
            scrollTexture.Face = Enum.NormalId.Front
            scrollTexture.Parent = scroll
            
            scroll.Parent = map
            
            -- 座卓
            local table = Instance.new("Part")
            table.Name = "Chabudai"
            table.Size = Vector3.new(room.size.x / 3, 1, room.size.z / 3)
            table.Position = Vector3.new(room.x, y + 1.5, room.z)
            table.Anchored = true
            table.BrickColor = BrickColor.new("Reddish brown")
            table.Material = Enum.Material.Wood
            
            -- テーブルのテクスチャ
            local tableTexture = Instance.new("Texture")
            tableTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
            tableTexture.StudsPerTileU = room.size.x / 3
            tableTexture.StudsPerTileV = room.size.z / 3
            tableTexture.Face = Enum.NormalId.Top
            tableTexture.Parent = table
            
            table.Parent = map
            
            -- 座布団（4つ）
            local cushionPositions = {
                Vector3.new(room.x, y + 0.7, room.z - room.size.z / 6),
                Vector3.new(room.x + room.size.x / 6, y + 0.7, room.z),
                Vector3.new(room.x, y + 0.7, room.z + room.size.z / 6),
                Vector3.new(room.x - room.size.x / 6, y + 0.7, room.z)
            }
            
            for i, pos in ipairs(cushionPositions) do
                local cushion = Instance.new("Part")
                cushion.Name = "Zabuton_" .. i
                cushion.Size = Vector3.new(room.size.x / 8, 0.3, room.size.z / 8)
                cushion.Position = pos
                cushion.Anchored = true
                cushion.BrickColor = BrickColor.new("Bright red")
                cushion.Material = Enum.Material.Fabric
                
                -- 座布団のテクスチャ
                local cushionTexture = Instance.new("Texture")
                cushionTexture.Texture = "rbxassetid://7546636894" -- 和風模様
                cushionTexture.StudsPerTileU = room.size.x / 8
                cushionTexture.StudsPerTileV = room.size.z / 8
                cushionTexture.Face = Enum.NormalId.Top
                cushionTexture.Parent = cushion
                
                cushion.Parent = map
            end
        elseif room.name == "茶室" then
            -- 茶道具
            local teaSet = Instance.new("Model")
            teaSet.Name = "TeaSet"
            
            -- 茶碗
            local teaBowl = Instance.new("Part")
            teaBowl.Name = "TeaBowl"
            teaBowl.Shape = Enum.PartType.Cylinder
            teaBowl.Size = Vector3.new(5, 3, 5)
            teaBowl.CFrame = CFrame.new(room.x, y + 2, room.z) * CFrame.Angles(0, 0, math.rad(90))
            teaBowl.Anchored = true
            teaBowl.BrickColor = BrickColor.new("Black")
            teaBowl.Material = Enum.Material.Ceramic
            teaBowl.Parent = teaSet
            
            -- 茶筅（茶せん）
            local teaWhisk = Instance.new("Part")
            teaWhisk.Name = "TeaWhisk"
            teaWhisk.Size = Vector3.new(0.5, 4, 0.5)
            teaWhisk.Position = Vector3.new(room.x + 6, y + 2, room.z)
            teaWhisk.Anchored = true
            teaWhisk.BrickColor = BrickColor.new("Brown")
            teaWhisk.Material = Enum.Material.Wood
            teaWhisk.Parent = teaSet
            
            -- 茶入れ
            local teaContainer = Instance.new("Part")
            teaContainer.Name = "TeaContainer"
            teaContainer.Shape = Enum.PartType.Cylinder
            teaContainer.Size = Vector3.new(3, 4, 3)
            teaContainer.CFrame = CFrame.new(room.x - 6, y + 2, room.z) * CFrame.Angles(0, 0, math.rad(90))
            teaContainer.Anchored = true
            teaContainer.BrickColor = BrickColor.new("Reddish brown")
            teaContainer.Material = Enum.Material.Wood
            teaContainer.Parent = teaSet
            
            teaSet.Parent = map
            
            -- 畳の敷物（特別な茶室用）
            local specialTatami = Instance.new("Part")
            specialTatami.Name = "SpecialTatami"
            specialTatami.Size = Vector3.new(room.size.x * 0.7, 0.1, room.size.z * 0.7)
            specialTatami.Position = Vector3.new(room.x, y + 0.7, room.z)
            specialTatami.Anchored = true
            specialTatami.BrickColor = BrickColor.new("Bright green")
            specialTatami.Material = Enum.Material.Fabric
            
            -- 特別な畳のテクスチャ
            local specialTatamiTexture = Instance.new("Texture")
            specialTatamiTexture.Texture = "rbxassetid://7546645512" -- 畳テクスチャ
            specialTatamiTexture.StudsPerTileU = room.size.x * 0.7
            specialTatamiTexture.StudsPerTileV = room.size.z * 0.7
            specialTatamiTexture.Face = Enum.NormalId.Top
            specialTatamiTexture.Parent = specialTatami
            
            specialTatami.Parent = map
        elseif room.name == "台所" then
            -- 台所の設備
            
            -- 流し台
            local sink = Instance.new("Part")
            sink.Name = "Sink"
            sink.Size = Vector3.new(room.size.x / 3, wallHeight / 2, room.size.z / 4)
            sink.Position = Vector3.new(room.x, y + wallHeight / 4, room.z - room.size.z / 3)
            sink.Anchored = true
            sink.BrickColor = BrickColor.new("Medium stone grey")
            sink.Material = Enum.Material.Slate
            sink.Parent = map
            
            -- 調理台
            local counter = Instance.new("Part")
            counter.Name = "Counter"
            counter.Size = Vector3.new(room.size.x / 2, wallHeight / 2, room.size.z / 4)
            counter.Position = Vector3.new(room.x, y + wallHeight / 4, room.z + room.size.z / 3)
            counter.Anchored = true
            counter.BrickColor = BrickColor.new("Brown")
            counter.Material = Enum.Material.Wood
            counter.Parent = map
            
            -- 囲炉裏
            local irori = Instance.new("Part")
            irori.Name = "Irori"
            irori.Size = Vector3.new(room.size.x / 5, 0.5, room.size.z / 5)
            irori.Position = Vector3.new(room.x, y + 0.7, room.z)
            irori.Anchored = true
            irori.BrickColor = BrickColor.new("Black")
            irori.Material = Enum.Material.Slate
            irori.Parent = map
            
            -- 囲炉裏の火
            local fire = Instance.new("Part")
            fire.Name = "Fire"
            fire.Size = Vector3.new(room.size.x / 10, 0.1, room.size.z / 10)
            fire.Position = Vector3.new(room.x, y + 0.8, room.z)
            fire.Anchored = true
            fire.BrickColor = BrickColor.new("Bright orange")
            fire.Material = Enum.Material.Neon
            fire.Parent = map
            
            -- 火の光源
            local fireLight = Instance.new("PointLight")
            fireLight.Color = Color3.fromRGB(255, 150, 50)
            fireLight.Range = 20
            fireLight.Brightness = 2
            fireLight.Parent = fire
            
            -- 火の煙
            local smoke = Instance.new("ParticleEmitter")
            smoke.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200))
            smoke.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 3)
            })
            smoke.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 1)
            })
            smoke.Rate = 5
            smoke.Speed = NumberRange.new(1, 3)
            smoke.Lifetime = NumberRange.new(1, 2)
            smoke.Parent = fire
        elseif room.name == "玄関" then
            -- 玄関の設備
            
            -- 靴箱
            local shoeRack = Instance.new("Part")
            shoeRack.Name = "ShoeRack"
            shoeRack.Size = Vector3.new(room.size.x / 2, wallHeight * 0.8, room.size.z / 6)
            shoeRack.Position = Vector3.new(room.x, y + wallHeight * 0.4, room.z - room.size.z / 3)
            shoeRack.Anchored = true
            shoeRack.BrickColor = BrickColor.new("Reddish brown")
            shoeRack.Material = Enum.Material.Wood
            shoeRack.Parent = map
            
            -- 靴
            local shoePositions = {
                Vector3.new(room.x - room.size.x / 6, y + 0.3, room.z - room.size.z / 4),
                Vector3.new(room.x, y + 0.3, room.z - room.size.z / 4),
                Vector3.new(room.x + room.size.x / 6, y + 0.3, room.z - room.size.z / 4)
            }
            
            for i, pos in ipairs(shoePositions) do
                local shoe = Instance.new("Part")
                shoe.Name = "Shoe_" .. i
                shoe.Size = Vector3.new(3, 1, 6)
                shoe.Position = pos
                shoe.Anchored = true
                shoe.BrickColor = BrickColor.new("Black")
                shoe.Material = Enum.Material.Leather
                shoe.Parent = map
            end
            
            -- 玄関マット
            local entranceMat = Instance.new("Part")
            entranceMat.Name = "EntranceMat"
            entranceMat.Size = Vector3.new(room.size.x * 0.8, 0.1, room.size.z / 3)
            entranceMat.Position = Vector3.new(room.x, y + 0.05, room.z)
            entranceMat.Anchored = true
            entranceMat.BrickColor = BrickColor.new("Brown")
            entranceMat.Material = Enum.Material.Fabric
            entranceMat.Parent = map
        elseif room.name == "書斎" then
            -- 書斎の設備
            
            -- 机
            local desk = Instance.new("Part")
            desk.Name = "Desk"
            desk.Size = Vector3.new(room.size.x / 3, wallHeight / 3, room.size.z / 3)
            desk.Position = Vector3.new(room.x, y + wallHeight / 6, room.z)
            desk.Anchored = true
            desk.BrickColor = BrickColor.new("Reddish brown")
            desk.Material = Enum.Material.Wood
            desk.Parent = map
            
            -- 本棚
            local bookshelf = Instance.new("Part")
            bookshelf.Name = "Bookshelf"
            bookshelf.Size = Vector3.new(room.size.x / 2, wallHeight * 0.8, room.size.z / 10)
            bookshelf.Position = Vector3.new(room.x, y + wallHeight * 0.4, room.z - room.size.z / 2 + room.size.z / 20)
            bookshelf.Anchored = true
            bookshelf.BrickColor = BrickColor.new("Reddish brown")
            bookshelf.Material = Enum.Material.Wood
            bookshelf.Parent = map
            
            -- 本
            for i = 1, 5 do
                local book = Instance.new("Part")
                book.Name = "Book_" .. i
                book.Size = Vector3.new(2, wallHeight * 0.2, room.size.z / 20)
                book.Position = Vector3.new(room.x - room.size.x / 5 + (i-1) * room.size.x / 10, y + wallHeight * 0.4, room.z - room.size.z / 2 + room.size.z / 10)
                book.Anchored = true
                book.BrickColor = BrickColor.new(math.random(1, 1032)) -- ランダムな色
                book.Material = Enum.Material.SmoothPlastic
                book.Parent = map
            end
        elseif room.name == "寝室" then
            -- 寝室の設備
            
            -- 布団
            local futon = Instance.new("Part")
            futon.Name = "Futon"
            futon.Size = Vector3.new(room.size.x / 2, 0.5, room.size.z / 2)
            futon.Position = Vector3.new(room.x, y + 0.8, room.z)
            futon.Anchored = true
            futon.BrickColor = BrickColor.new("White")
            futon.Material = Enum.Material.Fabric
            futon.Parent = map
            
            -- 枕
            local pillow = Instance.new("Part")
            pillow.Name = "Pillow"
            pillow.Size = Vector3.new(room.size.x / 10, 1, room.size.z / 5)
            pillow.Position = Vector3.new(room.x, y + 1.1, room.z - room.size.z / 6)
            pillow.Anchored = true
            pillow.BrickColor = BrickColor.new("White")
            pillow.Material = Enum.Material.Fabric
            pillow.Parent = map
            
            -- 衣装箪笥
            local wardrobe = Instance.new("Part")
            wardrobe.Name = "Wardrobe"
            wardrobe.Size = Vector3.new(room.size.x / 4, wallHeight * 0.8, room.size.z / 6)
            wardrobe.Position = Vector3.new(room.x - room.size.x / 3, y + wallHeight * 0.4, room.z - room.size.z / 3)
            wardrobe.Anchored = true
            wardrobe.BrickColor = BrickColor.new("Reddish brown")
            wardrobe.Material = Enum.Material.Wood
            wardrobe.Parent = map
        end
    end
    
    -- 廊下を作成
    for _, corridor in ipairs(corridors) do
        local corridorFloor = Instance.new("Part")
        corridorFloor.Name = "Corridor_Floor_" .. (corridor.floor == 1 and "1F" or "2F") .. "_" .. corridor.direction
        
        if corridor.direction == "horizontal" then
            corridorFloor.Size = Vector3.new(corridor.endX - corridor.startX, 0.2, corridorWidth)
            corridorFloor.Position = Vector3.new((corridor.startX + corridor.endX) / 2, corridor.y + 0.6, corridor.z)
        else
            corridorFloor.Size = Vector3.new(corridorWidth, 0.2, corridor.endZ - corridor.startZ)
            corridorFloor.Position = Vector3.new(corridor.x, corridor.y + 0.6, (corridor.startZ + corridor.endZ) / 2)
        end
        
        corridorFloor.Anchored = true
        corridorFloor.BrickColor = BrickColor.new("Reddish brown")
        corridorFloor.Material = Enum.Material.WoodPlanks
        
        -- 廊下のテクスチャ
        local corridorTexture = Instance.new("Texture")
        corridorTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
        corridorTexture.StudsPerTileU = 5
        corridorTexture.StudsPerTileV = 5
        corridorTexture.Face = Enum.NormalId.Top
        corridorTexture.Parent = corridorFloor
        
        corridorFloor.Parent = map
    end
    
    -- 縁側を作成
    for _, veranda in ipairs(verandas) do
        local verandaFloor = Instance.new("Part")
        verandaFloor.Name = "Veranda_" .. veranda.direction
        
        if veranda.direction == "horizontal" then
            verandaFloor.Size = Vector3.new(veranda.endX - veranda.startX, 0.3, corridorWidth)
            verandaFloor.Position = Vector3.new((veranda.startX + veranda.endX) / 2, veranda.y + 0.15, veranda.z)
        else
            verandaFloor.Size = Vector3.new(corridorWidth, 0.3, veranda.endZ - veranda.startZ)
            verandaFloor.Position = Vector3.new(veranda.x, veranda.y + 0.15, (veranda.startZ + veranda.endZ) / 2)
        end
        
        verandaFloor.Anchored = true
        verandaFloor.BrickColor = BrickColor.new("Brown")
        verandaFloor.Material = Enum.Material.WoodPlanks
        
        -- 縁側のテクスチャ
        local verandaTexture = Instance.new("Texture")
        verandaTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
        verandaTexture.StudsPerTileU = 5
        verandaTexture.StudsPerTileV = 5
        verandaTexture.Face = Enum.NormalId.Top
        verandaTexture.Parent = verandaFloor
        
        verandaFloor.Parent = map
    end
    
    -- 外壁の作成（木造）
    local exteriorWalls = {"North", "South", "East", "West"}
    for _, direction in ipairs(exteriorWalls) do
        local wall = Instance.new("Part")
        wall.Name = direction .. "Wall"
        
        if direction == "North" or direction == "South" then
            wall.Size = Vector3.new(mapSize, wallHeight, wallThickness)
            if direction == "North" then
                wall.Position = Vector3.new(0, wallHeight/2, -mapSize/2)
            else
                wall.Position = Vector3.new(0, wallHeight/2, mapSize/2)
            end
        else
            wall.Size = Vector3.new(wallThickness, wallHeight, mapSize)
            if direction == "East" then
                wall.Position = Vector3.new(mapSize/2, wallHeight/2, 0)
            else
                wall.Position = Vector3.new(-mapSize/2, wallHeight/2, 0)
            end
        end
        
        wall.Anchored = true
        wall.BrickColor = BrickColor.new("Reddish brown")
        wall.Material = Enum.Material.Wood
        wall.Parent = map
        
        -- 壁のテクスチャ
        local wallTexture = Instance.new("Texture")
        wallTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        wallTexture.StudsPerTileU = 10
        wallTexture.StudsPerTileV = 5
        
        if direction == "North" or direction == "South" then
            wallTexture.Face = direction == "North" and Enum.NormalId.Back or Enum.NormalId.Front
        else
            wallTexture.Face = direction == "East" and Enum.NormalId.Right or Enum.NormalId.Left
        end
        
        wallTexture.Parent = wall
        
        -- 2階の外壁
        local upperWall = Instance.new("Part")
        upperWall.Name = direction .. "UpperWall"
        
        if direction == "North" or direction == "South" then
            upperWall.Size = Vector3.new(mapSize, wallHeight, wallThickness)
            if direction == "North" then
                upperWall.Position = Vector3.new(0, wallHeight * 1.5 + 1, -mapSize/2)
            else
                upperWall.Position = Vector3.new(0, wallHeight * 1.5 + 1, mapSize/2)
            end
        else
            upperWall.Size = Vector3.new(wallThickness, wallHeight, mapSize)
            if direction == "East" then
                upperWall.Position = Vector3.new(mapSize/2, wallHeight * 1.5 + 1, 0)
            else
                upperWall.Position = Vector3.new(-mapSize/2, wallHeight * 1.5 + 1, 0)
            end
        end
        
        upperWall.Anchored = true
        upperWall.BrickColor = BrickColor.new("Reddish brown")
        upperWall.Material = Enum.Material.Wood
        upperWall.Parent = map
        
        -- 壁のテクスチャ
        local upperWallTexture = Instance.new("Texture")
        upperWallTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        upperWallTexture.StudsPerTileU = 10
        upperWallTexture.StudsPerTileV = 5
        
        if direction == "North" or direction == "South" then
            upperWallTexture.Face = direction == "North" and Enum.NormalId.Back or Enum.NormalId.Front
        else
            upperWallTexture.Face = direction == "East" and Enum.NormalId.Right or Enum.NormalId.Left
        end
        
        upperWallTexture.Parent = upperWall
    end
    
    -- 2階の床
    local secondFloor = Instance.new("Part")
    secondFloor.Name = "SecondFloor"
    secondFloor.Size = Vector3.new(mapSize, 1, mapSize)
    secondFloor.Position = Vector3.new(0, wallHeight + 1, 0)
    secondFloor.Anchored = true
    secondFloor.BrickColor = BrickColor.new("Brown")
    secondFloor.Material = Enum.Material.WoodPlanks
    secondFloor.Parent = map
    
    -- 2階の床のテクスチャ
    local secondFloorTexture = Instance.new("Texture")
    secondFloorTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
    secondFloorTexture.StudsPerTileU = 20
    secondFloorTexture.StudsPerTileV = 20
    secondFloorTexture.Face = Enum.NormalId.Top
    secondFloorTexture.Parent = secondFloor
    
    -- 階段の作成
    local staircase = Instance.new("Model")
    staircase.Name = "Staircase"
    
    local stairCount = 16
    local stairWidth = 20
    local stairDepth = 2
    local stairHeight = wallHeight / stairCount
    
    for i = 1, stairCount do
        local stair = Instance.new("Part")
        stair.Name = "Stair_" .. i
        stair.Size = Vector3.new(stairWidth, stairHeight, stairDepth)
        stair.Position = Vector3.new(0, stairHeight * (i - 0.5), -mapSize/4 + stairDepth * (i - 1))
        stair.Anchored = true
        stair.BrickColor = BrickColor.new("Reddish brown")
        stair.Material = Enum.Material.Wood
        stair.Parent = staircase
    end
    
    staircase.Parent = map
    
    -- 屋根の作成（伝統的な瓦屋根）
    local roof = Instance.new("Part")
    roof.Name = "Roof"
    roof.Size = Vector3.new(mapSize + 40, 1, mapSize + 40)
    roof.Position = Vector3.new(0, wallHeight * 2 + 2, 0)
    roof.Anchored = true
    roof.BrickColor = BrickColor.new("Dark stone grey")
    roof.Material = Enum.Material.Slate
    roof.Parent = map
    
    -- 屋根のテクスチャ
    local roofTexture = Instance.new("Texture")
    roofTexture.Texture = "rbxassetid://7546636894" -- 瓦テクスチャ
    roofTexture.StudsPerTileU = 5
    roofTexture.StudsPerTileV = 5
    roofTexture.Face = Enum.NormalId.Top
    roofTexture.Parent = roof
    
    -- 屋根の傾斜部分
    local roofAngles = {"North", "South", "East", "West"}
    for _, direction in ipairs(roofAngles) do
        local roofSlope = Instance.new("WedgePart")
        roofSlope.Name = direction .. "RoofSlope"
        
        if direction == "North" or direction == "South" then
            roofSlope.Size = Vector3.new(mapSize + 40, 20, 40)
            if direction == "North" then
                roofSlope.CFrame = CFrame.new(0, wallHeight * 2 - 8, -mapSize/2 - 20) * CFrame.Angles(math.rad(-90), 0, 0)
            else
                roofSlope.CFrame = CFrame.new(0, wallHeight * 2 - 8, mapSize/2 + 20) * CFrame.Angles(math.rad(90), 0, 0)
            end
        else
            roofSlope.Size = Vector3.new(40, 20, mapSize + 40)
            if direction == "East" then
                roofSlope.CFrame = CFrame.new(mapSize/2 + 20, wallHeight * 2 - 8, 0) * CFrame.Angles(0, 0, math.rad(90))
            else
                roofSlope.CFrame = CFrame.new(-mapSize/2 - 20, wallHeight * 2 - 8, 0) * CFrame.Angles(0, 0, math.rad(-90))
            end
        end
        
        roofSlope.Anchored = true
        roofSlope.BrickColor = BrickColor.new("Dark stone grey")
        roofSlope.Material = Enum.Material.Slate
        
        -- 屋根のテクスチャ
        local slopeTexture = Instance.new("Texture")
        slopeTexture.Texture = "rbxassetid://7546636894" -- 瓦テクスチャ
        slopeTexture.StudsPerTileU = 5
        slopeTexture.StudsPerTileV = 5
        slopeTexture.Face = Enum.NormalId.Top
        slopeTexture.Parent = roofSlope
        
        roofSlope.Parent = map
    end
    
    -- 障子と襖の配置
    local doorPositions = {
        -- 1階の障子/襖
        {type = "shoji", floor = 1, x = -mapSize/4 - roomSize/2, z = 0, rotation = 0, isVertical = false},
        {type = "shoji", floor = 1, x = mapSize/4 - roomSize/2, z = 0, rotation = 0, isVertical = false},
        {type = "fusuma", floor = 1, x = 0, z = -mapSize/4 - roomSize/2, rotation = 90, isVertical = true},
        {type = "fusuma", floor = 1, x = 0, z = mapSize/4 - roomSize/2, rotation = 90, isVertical = true},
        
        -- 2階の障子/襖
        {type = "shoji", floor = 2, x = -mapSize/4 - roomSize/2, z = 0, rotation = 0, isVertical = false},
        {type = "shoji", floor = 2, x = mapSize/4 - roomSize/2, z = 0, rotation = 0, isVertical = false},
        {type = "fusuma", floor = 2, x = 0, z = -mapSize/4 - roomSize/2, rotation = 90, isVertical = true},
        {type = "fusuma", floor = 2, x = 0, z = mapSize/4 - roomSize/2, rotation = 90, isVertical = true}
    }
    
    for i, door in ipairs(doorPositions) do
        local y = door.floor == 1 and wallHeight/2 or wallHeight * 1.5 + 1
        
        local doorFrame = Instance.new("Part")
        doorFrame.Name = door.type .. "_Frame_" .. i
        
        if door.isVertical then
            doorFrame.Size = Vector3.new(corridorWidth + 2, wallHeight, wallThickness)
        else
            doorFrame.Size = Vector3.new(wallThickness, wallHeight, corridorWidth + 2)
        end
        
        doorFrame.Position = Vector3.new(door.x, y, door.z)
        doorFrame.Rotation = Vector3.new(0, door.rotation, 0)
        doorFrame.Anchored = true
        doorFrame.BrickColor = BrickColor.new("Reddish brown")
        doorFrame.Material = Enum.Material.Wood
        doorFrame.Parent = map
        
        -- ドア本体
        local doorPart = Instance.new("Part")
        doorPart.Name = door.type .. "_Door_" .. i
        
        if door.isVertical then
            doorPart.Size = Vector3.new(corridorWidth, wallHeight * 0.9, wallThickness / 2)
        else
            doorPart.Size = Vector3.new(wallThickness / 2, wallHeight * 0.9, corridorWidth)
        end
        
        doorPart.Position = Vector3.new(door.x, y, door.z)
        doorPart.Rotation = Vector3.new(0, door.rotation, 0)
        doorPart.Anchored = true
        
        if door.type == "shoji" then
            -- 障子（白い紙の仕切り）
            doorPart.BrickColor = BrickColor.new("White")
            doorPart.Material = Enum.Material.SmoothPlastic
            doorPart.Transparency = 0.3
            
            -- 障子の格子模様
            local shojiTexture = Instance.new("Texture")
            shojiTexture.Texture = "rbxassetid://7057529868" -- 障子テクスチャ
            
            if door.isVertical then
                shojiTexture.Face = Enum.NormalId.Front
            else
                shojiTexture.Face = Enum.NormalId.Right
            end
            
            shojiTexture.Parent = doorPart
        else
            -- 襖（絵付きの引き戸）
            doorPart.BrickColor = BrickColor.new("Beige")
            doorPart.Material = Enum.Material.Fabric
            
            -- 襖の模様
            local fusumaTexture = Instance.new("Texture")
            fusumaTexture.Texture = "rbxassetid://7546636894" -- 襖テクスチャ
            
            if door.isVertical then
                fusumaTexture.Face = Enum.NormalId.Front
            else
                fusumaTexture.Face = Enum.NormalId.Right
            end
            
            fusumaTexture.Parent = doorPart
        end
        
        -- ドアの開閉機能を追加するための属性
        doorPart:SetAttribute("IsDoor", true)
        doorPart:SetAttribute("IsOpen", false)
        doorPart:SetAttribute("DoorType", door.type)
        doorPart:SetAttribute("IsVertical", door.isVertical)
        doorPart:SetAttribute("OriginalPosition", tostring(doorPart.Position))
        
        doorPart.Parent = map
    end
    
    -- 柱の作成（伝統的な木製柱）
    local pillarPositions = {
        -- 四隅
        {x = -mapSize/2 + 2, z = -mapSize/2 + 2},
        {x = mapSize/2 - 2, z = -mapSize/2 + 2},
        {x = -mapSize/2 + 2, z = mapSize/2 - 2},
        {x = mapSize/2 - 2, z = mapSize/2 - 2},
        
        -- 中央の交差点
        {x = 0, z = 0},
        
        -- 廊下の端
        {x = 0, z = -mapSize/2 + 2},
        {x = 0, z = mapSize/2 - 2},
        {x = -mapSize/2 + 2, z = 0},
        {x = mapSize/2 - 2, z = 0},
        
        -- 部屋の角
        {x = -mapSize/4 - roomSize/2, z = -mapSize/4 - roomSize/2},
        {x = mapSize/4 - roomSize/2, z = -mapSize/4 - roomSize/2},
        {x = -mapSize/4 - roomSize/2, z = mapSize/4 - roomSize/2},
        {x = mapSize/4 - roomSize/2, z = mapSize/4 - roomSize/2},
        {x = -mapSize/4 + roomSize/2, z = -mapSize/4 - roomSize/2},
        {x = mapSize/4 + roomSize/2, z = -mapSize/4 - roomSize/2},
        {x = -mapSize/4 + roomSize/2, z = mapSize/4 - roomSize/2},
        {x = mapSize/4 + roomSize/2, z = mapSize/4 - roomSize/2},
        {x = -mapSize/4 - roomSize/2, z = -mapSize/4 + roomSize/2},
        {x = mapSize/4 - roomSize/2, z = -mapSize/4 + roomSize/2},
        {x = -mapSize/4 - roomSize/2, z = mapSize/4 + roomSize/2},
        {x = mapSize/4 - roomSize/2, z = mapSize/4 + roomSize/2}
    }
    
    for i, pos in ipairs(pillarPositions) do
        -- 1階の柱
        local pillar = Instance.new("Part")
        pillar.Name = "Pillar_1F_" .. i
        pillar.Size = Vector3.new(4, wallHeight, 4)
        pillar.Position = Vector3.new(pos.x, wallHeight/2, pos.z)
        pillar.Anchored = true
        pillar.BrickColor = BrickColor.new("Reddish brown")
        pillar.Material = Enum.Material.Wood
        
        -- 柱のテクスチャ
        local pillarTexture = Instance.new("Texture")
        pillarTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        pillarTexture.StudsPerTileU = 4
        pillarTexture.StudsPerTileV = wallHeight
        pillarTexture.Parent = pillar
        
        pillar.Parent = map
        
        -- 2階の柱
        local upperPillar = Instance.new("Part")
        upperPillar.Name = "Pillar_2F_" .. i
        upperPillar.Size = Vector3.new(4, wallHeight, 4)
        upperPillar.Position = Vector3.new(pos.x, wallHeight * 1.5 + 1, pos.z)
        upperPillar.Anchored = true
        upperPillar.BrickColor = BrickColor.new("Reddish brown")
        upperPillar.Material = Enum.Material.Wood
        
        -- 柱のテクスチャ
        local upperPillarTexture = Instance.new("Texture")
        upperPillarTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        upperPillarTexture.StudsPerTileU = 4
        upperPillarTexture.StudsPerTileV = wallHeight
        upperPillarTexture.Parent = upperPillar
        
        upperPillar.Parent = map
    end
    
    -- 照明の配置（提灯）
    local lightPositions = {
        -- 1階の照明
        {x = -mapSize/4, y = wallHeight - 1, z = -mapSize/4},
        {x = mapSize/4, y = wallHeight - 1, z = -mapSize/4},
        {x = -mapSize/4, y = wallHeight - 1, z = mapSize/4},
        {x = mapSize/4, y = wallHeight - 1, z = mapSize/4},
        {x = 0, y = wallHeight - 1, z = 0},
        
        -- 2階の照明
        {x = -mapSize/4, y = wallHeight * 2 - 1, z = -mapSize/4},
        {x = mapSize/4, y = wallHeight * 2 - 1, z = -mapSize/4},
        {x = -mapSize/4, y = wallHeight * 2 - 1, z = mapSize/4},
        {x = mapSize/4, y = wallHeight * 2 - 1, z = mapSize/4},
        {x = 0, y = wallHeight * 2 - 1, z = 0}
    }
    
    for i, pos in ipairs(lightPositions) do
        -- 提灯
        local lantern = Instance.new("Part")
        lantern.Name = "Lantern_" .. i
        lantern.Shape = Enum.PartType.Ball
        lantern.Size = Vector3.new(8, 8, 8)
        lantern.Position = Vector3.new(pos.x, pos.y, pos.z)
        lantern.Anchored = true
        lantern.BrickColor = BrickColor.new("Bright yellow")
        lantern.Material = Enum.Material.Neon
        lantern.Transparency = 0.3
        
        -- 光源
        local light = Instance.new("PointLight")
        light.Brightness = 1
        light.Color = Color3.fromRGB(255, 223, 186) -- 暖かい光
        light.Range = 30
        light.Shadows = true
        light.Parent = lantern
        
        lantern.Parent = map
    end
    
    -- 窓の作成
    local windowPositions = {
        -- 1階の窓
        {floor = 1, x = -mapSize/2, z = -mapSize/4, direction = "west"},
        {floor = 1, x = -mapSize/2, z = mapSize/4, direction = "west"},
        {floor = 1, x = mapSize/2, z = -mapSize/4, direction = "east"},
        {floor = 1, x = mapSize/2, z = mapSize/4, direction = "east"},
        {floor = 1, x = -mapSize/4, z = -mapSize/2, direction = "north"},
        {floor = 1, x = mapSize/4, z = -mapSize/2, direction = "north"},
        {floor = 1, x = -mapSize/4, z = mapSize/2, direction = "south"},
        {floor = 1, x = mapSize/4, z = mapSize/2, direction = "south"},
        
        -- 2階の窓
        {floor = 2, x = -mapSize/2, z = -mapSize/4, direction = "west"},
        {floor = 2, x = -mapSize/2, z = mapSize/4, direction = "west"},
        {floor = 2, x = mapSize/2, z = -mapSize/4, direction = "east"},
        {floor = 2, x = mapSize/2, z = mapSize/4, direction = "east"},
        {floor = 2, x = -mapSize/4, z = -mapSize/2, direction = "north"},
        {floor = 2, x = mapSize/4, z = -mapSize/2, direction = "north"},
        {floor = 2, x = -mapSize/4, z = mapSize/2, direction = "south"},
        {floor = 2, x = mapSize/4, z = mapSize/2, direction = "south"}
    }
    
    for i, window in ipairs(windowPositions) do
        local y = window.floor == 1 and wallHeight/2 or wallHeight * 1.5 + 1
        
        -- 窓枠
        local windowFrame = Instance.new("Part")
        windowFrame.Name = "WindowFrame_" .. window.floor .. "F_" .. i
        
        if window.direction == "north" or window.direction == "south" then
            windowFrame.Size = Vector3.new(roomSize/2, wallHeight/2, wallThickness)
        else
            windowFrame.Size = Vector3.new(wallThickness, wallHeight/2, roomSize/2)
        end
        
        if window.direction == "north" then
            windowFrame.Position = Vector3.new(window.x, y, window.z)
        elseif window.direction == "south" then
            windowFrame.Position = Vector3.new(window.x, y, window.z)
        elseif window.direction == "east" then
            windowFrame.Position = Vector3.new(window.x, y, window.z)
        elseif window.direction == "west" then
            windowFrame.Position = Vector3.new(window.x, y, window.z)
        end
        
        windowFrame.Anchored = true
        windowFrame.BrickColor = BrickColor.new("Reddish brown")
        windowFrame.Material = Enum.Material.Wood
        windowFrame.Parent = map
        
        -- 障子窓
        local windowPane = Instance.new("Part")
        windowPane.Name = "WindowPane_" .. window.floor .. "F_" .. i
        
        if window.direction == "north" or window.direction == "south" then
            windowPane.Size = Vector3.new(roomSize/2 - 2, wallHeight/2 - 2, wallThickness/2)
        else
            windowPane.Size = Vector3.new(wallThickness/2, wallHeight/2 - 2, roomSize/2 - 2)
        end
        
        windowPane.Position = windowFrame.Position
        windowPane.Anchored = true
        windowPane.BrickColor = BrickColor.new("White")
        windowPane.Material = Enum.Material.SmoothPlastic
        windowPane.Transparency = 0.5
        
        -- 障子窓のテクスチャ
        local windowTexture = Instance.new("Texture")
        windowTexture.Texture = "rbxassetid://7057529868" -- 障子テクスチャ
        
        if window.direction == "north" then
            windowTexture.Face = Enum.NormalId.Back
        elseif window.direction == "south" then
            windowTexture.Face = Enum.NormalId.Front
        elseif window.direction == "east" then
            windowTexture.Face = Enum.NormalId.Right
        elseif window.direction == "west" then
            windowTexture.Face = Enum.NormalId.Left
        end
        
        windowTexture.Parent = windowPane
        
        windowPane.Parent = map
    end
    
    -- 鳥居（脱出ポイント）
    local torii = Instance.new("Model")
    torii.Name = "Torii"
    
    -- 鳥居の柱（左）
    local leftPillar = Instance.new("Part")
    leftPillar.Name = "LeftPillar"
    leftPillar.Size = Vector3.new(5, 30, 5)
    leftPillar.Position = Vector3.new(-15, 15, -mapSize/2 - 20)
    leftPillar.Anchored = true
    leftPillar.BrickColor = BrickColor.new("Bright red")
    leftPillar.Material = Enum.Material.SmoothPlastic
    leftPillar.Parent = torii
    
    -- 鳥居の柱（右）
    local rightPillar = Instance.new("Part")
    rightPillar.Name = "RightPillar"
    rightPillar.Size = Vector3.new(5, 30, 5)
    rightPillar.Position = Vector3.new(15, 15, -mapSize/2 - 20)
    rightPillar.Anchored = true
    rightPillar.BrickColor = BrickColor.new("Bright red")
    rightPillar.Material = Enum.Material.SmoothPlastic
    rightPillar.Parent = torii
    
    -- 鳥居の横木（上）
    local topBeam = Instance.new("Part")
    topBeam.Name = "TopBeam"
    topBeam.Size = Vector3.new(40, 5, 5)
    topBeam.Position = Vector3.new(0, 27.5, -mapSize/2 - 20)
    topBeam.Anchored = true
    topBeam.BrickColor = BrickColor.new("Bright red")
    topBeam.Material = Enum.Material.SmoothPlastic
    topBeam.Parent = torii
    
    -- 鳥居の横木（中）
    local middleBeam = Instance.new("Part")
    middleBeam.Name = "MiddleBeam"
    middleBeam.Size = Vector3.new(45, 3, 3)
    middleBeam.Position = Vector3.new(0, 23, -mapSize/2 - 20)
    middleBeam.Anchored = true
    middleBeam.BrickColor = BrickColor.new("Bright red")
    middleBeam.Material = Enum.Material.SmoothPlastic
    middleBeam.Parent = torii
    
    torii.Parent = map
    
    -- 庭園の要素（鳥居の周り）
    local garden = Instance.new("Model")
    garden.Name = "Garden"
    
    -- 石畳の道
    local stonePath = Instance.new("Part")
    stonePath.Name = "StonePath"
    stonePath.Size = Vector3.new(30, 0.5, 40)
    stonePath.Position = Vector3.new(0, 0.25, -mapSize/2 - 40)
    stonePath.Anchored = true
    stonePath.BrickColor = BrickColor.new("Medium stone grey")
    stonePath.Material = Enum.Material.Slate
    
    -- 石畳のテクスチャ
    local stoneTexture = Instance.new("Texture")
    stoneTexture.Texture = "rbxassetid://7546636894" -- 石畳テクスチャ
    stoneTexture.StudsPerTileU = 5
    stoneTexture.StudsPerTileV = 5
    stoneTexture.Face = Enum.NormalId.Top
    stoneTexture.Parent = stonePath
    
    stonePath.Parent = garden
    
    -- 灯籠
    local lanternPositions = {
        {x = -20, z = -mapSize/2 - 30},
        {x = 20, z = -mapSize/2 - 30},
        {x = -20, z = -mapSize/2 - 50},
        {x = 20, z = -mapSize/2 - 50}
    }
    
    for i, pos in ipairs(lanternPositions) do
        local stoneLantern = Instance.new("Part")
        stoneLantern.Name = "StoneLantern_" .. i
        stoneLantern.Size = Vector3.new(5, 15, 5)
        stoneLantern.Position = Vector3.new(pos.x, 7.5, pos.z)
        stoneLantern.Anchored = true
        stoneLantern.BrickColor = BrickColor.new("Medium stone grey")
        stoneLantern.Material = Enum.Material.Slate
        
        -- 灯籠の光
        local lanternLight = Instance.new("Part")
        lanternLight.Name = "LanternLight"
        lanternLight.Size = Vector3.new(3, 3, 3)
        lanternLight.Position = Vector3.new(pos.x, 10, pos.z)
        lanternLight.Anchored = true
        lanternLight.BrickColor = BrickColor.new("Bright yellow")
        lanternLight.Material = Enum.Material.Neon
        lanternLight.Transparency = 0.3
        
        -- 光源
        local light = Instance.new("PointLight")
        light.Brightness = 1
        light.Color = Color3.fromRGB(255, 223, 186)
        light.Range = 20
        light.Shadows = true
        light.Parent = lanternLight
        
        lanternLight.Parent = garden
        stoneLantern.Parent = garden
    }
    
    garden.Parent = map
    
    -- ドアの開閉スクリプト
    local doorScript = Instance.new("Script")
    doorScript.Name = "DoorController"
    doorScript.Source = [[
        -- ドアの開閉を制御するスクリプト
        local doors = {}
        
        -- ドアを見つける
        for _, part in pairs(script.Parent:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("IsDoor") then
                table.insert(doors, part)
            end
        end
        
        -- ドアの開閉関数
        local function toggleDoor(door)
            local isOpen = door:GetAttribute("IsOpen")
            local isVertical = door:GetAttribute("IsVertical")
            local doorType = door:GetAttribute("DoorType")
            local originalPosition = door.Position
            
            -- ドアの状態を切り替え
            door:SetAttribute("IsOpen", not isOpen)
            
            -- ドアを開く/閉じる
            if not isOpen then
                -- ドアを開く
                if isVertical then
                    door.Position = door.Position + Vector3.new(10, 0, 0)
                else
                    door.Position = door.Position + Vector3.new(0, 0, 10)
                end
                
                -- 効果音
                local openSound = Instance.new("Sound")
                openSound.Name = "DoorOpenSound"
                openSound.SoundId = doorType == "shoji" 
                    and "rbxassetid://142082167"  -- 障子を開く音
                    or "rbxassetid://142082167"   -- 襖を開く音
                openSound.Volume = 0.5
                openSound.Parent = door
                openSound:Play()
                game.Debris:AddItem(openSound, 2)
            else
                -- ドアを閉じる
                if isVertical then
                    door.Position = door.Position - Vector3.new(10, 0, 0)
                else
                    door.Position = door.Position - Vector3.new(0, 0, 10)
                end
                
                -- 効果音
                local closeSound = Instance.new("Sound")
                closeSound.Name = "DoorCloseSound"
                closeSound.SoundId = doorType == "shoji" 
                    and "rbxassetid://142082167"  -- 障子を閉じる音
                    or "rbxassetid://142082167"   -- 襖を閉じる音
                closeSound.Volume = 0.5
                closeSound.Parent = door
                closeSound:Play()
                game.Debris:AddItem(closeSound, 2)
            end
        end
        
        -- プレイヤーがドアに近づいたときに開閉できるようにする
        for _, door in ipairs(doors) do
            door.Touched:Connect(function(hit)
                local humanoid = hit.Parent:FindFirstChild("Humanoid")
                if humanoid then
                    toggleDoor(door)
                end
            end)
        end
    ]]
    doorScript.Parent = map
    
    return map
end

return TraditionalJapaneseHouse