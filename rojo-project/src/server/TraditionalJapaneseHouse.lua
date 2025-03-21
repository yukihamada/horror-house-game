-- TraditionalJapaneseHouse.lua
-- 伝統的な日本家屋のマップを作成するモジュールスクリプト

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
        {name = "納戸", type = "wooden", floor = 1, x = mapSize/3, z = 0, size = {x = roomSize/2, z = roomSize/2}},
        {name = "風呂場", type = "bath", floor = 1, x = -mapSize/3, z = 0, size = {x = roomSize/2, z = roomSize/2}},
        
        -- 2階の部屋
        {name = "和室2", type = "tatami", floor = 2, x = -mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "和室3", type = "tatami", floor = 2, x = mapSize/4, z = -mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "書斎", type = "wooden", floor = 2, x = -mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "寝室", type = "tatami", floor = 2, x = mapSize/4, z = mapSize/4, size = {x = roomSize, z = roomSize}},
        {name = "物置", type = "wooden", floor = 2, x = 0, z = mapSize/3, size = {x = roomSize/2, z = roomSize/2}},
        {name = "隠し部屋", type = "hidden", floor = 2, x = 0, z = -mapSize/3, size = {x = roomSize/2, z = roomSize/2}}
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
        elseif room.type == "bath" then
            -- 風呂場の床
            roomFloor.BrickColor = BrickColor.new("Medium stone grey")
            roomFloor.Material = Enum.Material.Slate
            
            -- 風呂場のテクスチャ
            local bathTexture = Instance.new("Texture")
            bathTexture.Texture = "rbxassetid://9438453972" -- 石のテクスチャ
            bathTexture.StudsPerTileU = 5
            bathTexture.StudsPerTileV = 5
            bathTexture.Face = Enum.NormalId.Top
            bathTexture.Parent = roomFloor
            
            -- 浴槽
            local bathtub = Instance.new("Part")
            bathtub.Name = "Bathtub"
            bathtub.Size = Vector3.new(room.size.x * 0.7, 2, room.size.z * 0.7)
            bathtub.Position = Vector3.new(room.x, y + 1, room.z)
            bathtub.Anchored = true
            bathtub.BrickColor = BrickColor.new("Medium stone grey")
            bathtub.Material = Enum.Material.Slate
            
            -- 浴槽の内側
            local bathtubInside = Instance.new("Part")
            bathtubInside.Name = "BathtubInside"
            bathtubInside.Size = Vector3.new(room.size.x * 0.6, 1.5, room.size.z * 0.6)
            bathtubInside.Position = Vector3.new(room.x, y + 1, room.z)
            bathtubInside.Anchored = true
            bathtubInside.BrickColor = BrickColor.new("Pastel blue")
            bathtubInside.Material = Enum.Material.SmoothPlastic
            bathtubInside.Parent = map
            
            -- 水の効果
            local water = Instance.new("Part")
            water.Name = "Water"
            water.Size = Vector3.new(room.size.x * 0.59, 0.1, room.size.z * 0.59)
            water.Position = Vector3.new(room.x, y + 1.7, room.z)
            water.Anchored = true
            water.BrickColor = BrickColor.new("Pastel blue-green")
            water.Material = Enum.Material.Glass
            water.Transparency = 0.3
            
            -- 水面のテクスチャ
            local waterTexture = Instance.new("Texture")
            waterTexture.Texture = "rbxassetid://6372755229" -- 水面テクスチャ
            waterTexture.StudsPerTileU = 5
            waterTexture.StudsPerTileV = 5
            waterTexture.Face = Enum.NormalId.Top
            waterTexture.Parent = water
            
            water.Parent = map
            bathtub.Parent = map
        elseif room.type == "hidden" then
            -- 隠し部屋の床
            roomFloor.BrickColor = BrickColor.new("Really black")
            roomFloor.Material = Enum.Material.Slate
            
            -- 隠し部屋のテクスチャ
            local hiddenTexture = Instance.new("Texture")
            hiddenTexture.Texture = "rbxassetid://9438453972" -- 石のテクスチャ
            hiddenTexture.StudsPerTileU = 5
            hiddenTexture.StudsPerTileV = 5
            hiddenTexture.Face = Enum.NormalId.Top
            hiddenTexture.Parent = roomFloor
            
            -- 祭壇
            local altar = Instance.new("Part")
            altar.Name = "Altar"
            altar.Size = Vector3.new(room.size.x * 0.5, 1, room.size.z * 0.5)
            altar.Position = Vector3.new(room.x, y + 1, room.z)
            altar.Anchored = true
            altar.BrickColor = BrickColor.new("Really black")
            altar.Material = Enum.Material.Slate
            
            -- 祭壇のテクスチャ
            local altarTexture = Instance.new("Texture")
            altarTexture.Texture = "rbxassetid://7546636894" -- 和風模様
            altarTexture.StudsPerTileU = 5
            altarTexture.StudsPerTileV = 5
            altarTexture.Face = Enum.NormalId.Top
            altarTexture.Parent = altar
            
            -- キャンドル
            for i = 1, 4 do
                local angle = (i - 1) * math.pi / 2
                local candleX = room.x + math.cos(angle) * room.size.x * 0.3
                local candleZ = room.z + math.sin(angle) * room.size.z * 0.3
                
                local candle = Instance.new("Part")
                candle.Name = "Candle_" .. i
                candle.Size = Vector3.new(1, 3, 1)
                candle.Position = Vector3.new(candleX, y + 1.5, candleZ)
                candle.Anchored = true
                candle.BrickColor = BrickColor.new("White")
                candle.Material = Enum.Material.SmoothPlastic
                
                -- 炎
                local flame = Instance.new("Part")
                flame.Name = "Flame"
                flame.Size = Vector3.new(0.5, 1, 0.5)
                flame.Position = Vector3.new(candleX, y + 3, candleZ)
                flame.Anchored = true
                flame.BrickColor = BrickColor.new("Bright orange")
                flame.Material = Enum.Material.Neon
                flame.Shape = Enum.PartType.Ball
                
                -- 光源
                local light = Instance.new("PointLight")
                light.Color = Color3.fromRGB(255, 150, 50)
                light.Range = 10
                light.Brightness = 1
                light.Parent = flame
                
                flame.Parent = map
                candle.Parent = map
            end
            
            altar.Parent = map
            
            -- 不気味な装飾
            local symbol = Instance.new("Part")
            symbol.Name = "Symbol"
            symbol.Size = Vector3.new(room.size.x * 0.4, 0.1, room.size.z * 0.4)
            symbol.Position = Vector3.new(room.x, y + 1.1, room.z)
            symbol.Anchored = true
            symbol.BrickColor = BrickColor.new("Really red")
            symbol.Material = Enum.Material.Neon
            
            -- シンボルのテクスチャ
            local symbolTexture = Instance.new("Texture")
            symbolTexture.Texture = "rbxassetid://7546636894" -- 和風模様
            symbolTexture.StudsPerTileU = 1
            symbolTexture.StudsPerTileV = 1
            symbolTexture.Face = Enum.NormalId.Top
            symbolTexture.Parent = symbol
            
            symbol.Parent = map
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
    
    return map
end

return TraditionalJapaneseHouse