-- TraditionalJapaneseHouse.lua
-- 伝統的な日本家屋のマップを作成するモジュール

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
    
    -- 畳の部屋を作成
    local tatamiBorders = {
        {min = Vector3.new(-mapSize/2 + 5, 0, -mapSize/2 + 5), max = Vector3.new(-mapSize/2 + roomSize, 0, -mapSize/2 + roomSize)},
        {min = Vector3.new(mapSize/2 - roomSize, 0, -mapSize/2 + 5), max = Vector3.new(mapSize/2 - 5, 0, -mapSize/2 + roomSize)},
        {min = Vector3.new(-mapSize/2 + 5, 0, mapSize/2 - roomSize), max = Vector3.new(-mapSize/2 + roomSize, 0, mapSize/2 - 5)},
        {min = Vector3.new(mapSize/2 - roomSize, 0, mapSize/2 - roomSize), max = Vector3.new(mapSize/2 - 5, 0, mapSize/2 - 5)}
    }
    
    for roomIndex, border in ipairs(tatamiBorders) do
        local roomFloor = Instance.new("Part")
        roomFloor.Name = "TatamiRoom_" .. roomIndex
        roomFloor.Size = Vector3.new(border.max.X - border.min.X, 0.2, border.max.Z - border.min.Z)
        roomFloor.Position = Vector3.new((border.min.X + border.max.X) / 2, 0.6, (border.min.Z + border.max.Z) / 2)
        roomFloor.Anchored = true
        roomFloor.BrickColor = BrickColor.new("Olive")
        roomFloor.Material = Enum.Material.Fabric
        roomFloor.Parent = map
        
        -- 畳の模様
        local tatamiTexture = Instance.new("Texture")
        tatamiTexture.Texture = "rbxassetid://7546645512" -- 畳テクスチャ
        tatamiTexture.StudsPerTileU = roomSize / 2
        tatamiTexture.StudsPerTileV = roomSize / 2
        tatamiTexture.Face = Enum.NormalId.Top
        tatamiTexture.Parent = roomFloor
        
        -- 畳の縁
        local border = Instance.new("Part")
        border.Name = "TatamiBorder_" .. roomIndex
        border.Size = Vector3.new(roomFloor.Size.X + 1, 0.05, roomFloor.Size.Z + 1)
        border.Position = Vector3.new(roomFloor.Position.X, 0.55, roomFloor.Position.Z)
        border.Anchored = true
        border.BrickColor = BrickColor.new("Black")
        border.Material = Enum.Material.Fabric
        border.Parent = map
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
    
    -- 2階の畳部屋
    local secondFloorTatamiBorders = {
        {min = Vector3.new(-mapSize/2 + 20, wallHeight + 1, -mapSize/2 + 20), max = Vector3.new(-mapSize/2 + roomSize, wallHeight + 1, -mapSize/2 + roomSize)},
        {min = Vector3.new(mapSize/2 - roomSize, wallHeight + 1, -mapSize/2 + 20), max = Vector3.new(mapSize/2 - 20, wallHeight + 1, -mapSize/2 + roomSize)},
        {min = Vector3.new(-mapSize/2 + 20, wallHeight + 1, mapSize/2 - roomSize), max = Vector3.new(-mapSize/2 + roomSize, wallHeight + 1, mapSize/2 - 20)},
        {min = Vector3.new(mapSize/2 - roomSize, wallHeight + 1, mapSize/2 - roomSize), max = Vector3.new(mapSize/2 - 20, wallHeight + 1, mapSize/2 - 20)}
    }
    
    for roomIndex, border in ipairs(secondFloorTatamiBorders) do
        local roomFloor = Instance.new("Part")
        roomFloor.Name = "SecondFloorTatamiRoom_" .. roomIndex
        roomFloor.Size = Vector3.new(border.max.X - border.min.X, 0.2, border.max.Z - border.min.Z)
        roomFloor.Position = Vector3.new((border.min.X + border.max.X) / 2, wallHeight + 1.6, (border.min.Z + border.max.Z) / 2)
        roomFloor.Anchored = true
        roomFloor.BrickColor = BrickColor.new("Olive")
        roomFloor.Material = Enum.Material.Fabric
        roomFloor.Parent = map
        
        -- 畳の模様
        local tatamiTexture = Instance.new("Texture")
        tatamiTexture.Texture = "rbxassetid://7546645512" -- 畳テクスチャ
        tatamiTexture.StudsPerTileU = roomSize / 2
        tatamiTexture.StudsPerTileV = roomSize / 2
        tatamiTexture.Face = Enum.NormalId.Top
        tatamiTexture.Parent = roomFloor
    end
    
    -- 2階の壁
    local secondFloorWalls = {"North", "South", "East", "West"}
    for _, direction in ipairs(secondFloorWalls) do
        local wall = Instance.new("Part")
        wall.Name = "SecondFloor" .. direction .. "Wall"
        
        if direction == "North" or direction == "South" then
            wall.Size = Vector3.new(mapSize, wallHeight, wallThickness)
            if direction == "North" then
                wall.Position = Vector3.new(0, wallHeight * 1.5 + 1, -mapSize/2)
            else
                wall.Position = Vector3.new(0, wallHeight * 1.5 + 1, mapSize/2)
            end
        else
            wall.Size = Vector3.new(wallThickness, wallHeight, mapSize)
            if direction == "East" then
                wall.Position = Vector3.new(mapSize/2, wallHeight * 1.5 + 1, 0)
            else
                wall.Position = Vector3.new(-mapSize/2, wallHeight * 1.5 + 1, 0)
            end
        end
        
        wall.Anchored = true
        wall.BrickColor = BrickColor.new("Reddish brown")
        wall.Material = Enum.Material.Wood
        wall.Parent = map
    end
    
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
            roofSlope.Size = Vector3.new(mapSize + 10, 5, 10)
            if direction == "North" then
                roofSlope.CFrame = CFrame.new(0, wallHeight, -mapSize/2 - 5) * CFrame.Angles(math.rad(-90), 0, 0)
            else
                roofSlope.CFrame = CFrame.new(0, wallHeight, mapSize/2 + 5) * CFrame.Angles(math.rad(90), 0, 0)
            end
        else
            roofSlope.Size = Vector3.new(10, 5, mapSize + 10)
            if direction == "East" then
                roofSlope.CFrame = CFrame.new(mapSize/2 + 5, wallHeight, 0) * CFrame.Angles(0, 0, math.rad(90))
            else
                roofSlope.CFrame = CFrame.new(-mapSize/2 - 5, wallHeight, 0) * CFrame.Angles(0, 0, math.rad(-90))
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
    
    -- 内部の部屋を作成（障子と襖）
    local roomLayouts = {
        -- 中央の廊下（縦）
        {start = Vector3.new(-corridorWidth/2, 0, -mapSize/2 + 5), finish = Vector3.new(corridorWidth/2, wallHeight, mapSize/2 - 5), isVertical = true},
        -- 中央の廊下（横）
        {start = Vector3.new(-mapSize/2 + 5, 0, -corridorWidth/2), finish = Vector3.new(mapSize/2 - 5, wallHeight, corridorWidth/2), isVertical = false}
    }
    
    -- 部屋の仕切りを作成
    for _, layout in ipairs(roomLayouts) do
        -- 廊下の両側に障子/襖を設置
        local side1 = Instance.new("Part")
        local side2 = Instance.new("Part")
        
        if layout.isVertical then
            -- 縦の廊下の場合、左右に仕切り
            side1.Size = Vector3.new(wallThickness, wallHeight, layout.finish.Z - layout.start.Z)
            side2.Size = Vector3.new(wallThickness, wallHeight, layout.finish.Z - layout.start.Z)
            
            side1.Position = Vector3.new(layout.start.X - corridorWidth/2, wallHeight/2, (layout.start.Z + layout.finish.Z) / 2)
            side2.Position = Vector3.new(layout.finish.X + corridorWidth/2, wallHeight/2, (layout.start.Z + layout.finish.Z) / 2)
        else
            -- 横の廊下の場合、上下に仕切り
            side1.Size = Vector3.new(layout.finish.X - layout.start.X, wallHeight, wallThickness)
            side2.Size = Vector3.new(layout.finish.X - layout.start.X, wallHeight, wallThickness)
            
            side1.Position = Vector3.new((layout.start.X + layout.finish.X) / 2, wallHeight/2, layout.start.Z - corridorWidth/2)
            side2.Position = Vector3.new((layout.start.X + layout.finish.X) / 2, wallHeight/2, layout.finish.Z + corridorWidth/2)
        end
        
        side1.Anchored = true
        side2.Anchored = true
        
        side1.BrickColor = BrickColor.new("Reddish brown")
        side2.BrickColor = BrickColor.new("Reddish brown")
        
        side1.Material = Enum.Material.Wood
        side2.Material = Enum.Material.Wood
        
        side1.Parent = map
        side2.Parent = map
        
        -- 廊下に沿って障子と襖を配置
        local partitionCount = layout.isVertical and 10 or 8
        local partitionWidth = layout.isVertical and (layout.finish.Z - layout.start.Z) / partitionCount or (layout.finish.X - layout.start.X) / partitionCount
        
        for i = 1, partitionCount do
            -- 左右/上下それぞれに障子/襖を配置
            for side = 1, 2 do
                local isShoji = math.random(1, 2) == 1
                local partition = Instance.new("Part")
                partition.Name = (isShoji and "Shoji_" or "Fusuma_") .. (layout.isVertical and "V" or "H") .. "_" .. i .. "_" .. side
                
                if layout.isVertical then
                    partition.Size = Vector3.new(wallThickness, wallHeight * 0.8, partitionWidth - 1)
                    local sideOffset = side == 1 and -corridorWidth/2 - wallThickness/2 or corridorWidth/2 + wallThickness/2
                    partition.Position = Vector3.new(layout.start.X + sideOffset, wallHeight * 0.4, layout.start.Z + partitionWidth * (i - 0.5))
                else
                    partition.Size = Vector3.new(partitionWidth - 1, wallHeight * 0.8, wallThickness)
                    local sideOffset = side == 1 and -corridorWidth/2 - wallThickness/2 or corridorWidth/2 + wallThickness/2
                    partition.Position = Vector3.new(layout.start.X + partitionWidth * (i - 0.5), wallHeight * 0.4, layout.start.Z + sideOffset)
                end
                
                partition.Anchored = true
                
                if isShoji then
                    -- 障子（白い紙の仕切り）
                    partition.BrickColor = BrickColor.new("White")
                    partition.Material = Enum.Material.SmoothPlastic
                    partition.Transparency = 0.3
                    
                    -- 障子の格子模様
                    local shojiTexture = Instance.new("Texture")
                    shojiTexture.Texture = "rbxassetid://7057529868" -- 障子テクスチャ
                    shojiTexture.StudsPerTileU = partition.Size.X > partition.Size.Z and partition.Size.X or partition.Size.Z
                    shojiTexture.StudsPerTileV = wallHeight * 0.8
                    shojiTexture.Face = layout.isVertical and (side == 1 and Enum.NormalId.Right or Enum.NormalId.Left) or (side == 1 and Enum.NormalId.Back or Enum.NormalId.Front)
                    shojiTexture.Parent = partition
                else
                    -- 襖（絵付きの引き戸）
                    partition.BrickColor = BrickColor.new("Beige")
                    partition.Material = Enum.Material.Fabric
                    
                    -- 襖の模様
                    local fusumaTexture = Instance.new("Texture")
                    fusumaTexture.Texture = "rbxassetid://7546636894" -- 襖テクスチャ
                    fusumaTexture.StudsPerTileU = partition.Size.X > partition.Size.Z and partition.Size.X or partition.Size.Z
                    fusumaTexture.StudsPerTileV = wallHeight * 0.8
                    fusumaTexture.Face = layout.isVertical and (side == 1 and Enum.NormalId.Right or Enum.NormalId.Left) or (side == 1 and Enum.NormalId.Back or Enum.NormalId.Front)
                    fusumaTexture.Parent = partition
                end
                
                partition.Parent = map
            end
        end
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
        {x = -mapSize/2 + roomSize, z = -mapSize/2 + roomSize},
        {x = mapSize/2 - roomSize, z = -mapSize/2 + roomSize},
        {x = -mapSize/2 + roomSize, z = mapSize/2 - roomSize},
        {x = mapSize/2 - roomSize, z = mapSize/2 - roomSize}
    }
    
    for i, pos in ipairs(pillarPositions) do
        local pillar = Instance.new("Part")
        pillar.Name = "Pillar_" .. i
        pillar.Size = Vector3.new(2, wallHeight, 2)
        pillar.Position = Vector3.new(pos.x, wallHeight/2, pos.z)
        pillar.Anchored = true
        pillar.BrickColor = BrickColor.new("Reddish brown")
        pillar.Material = Enum.Material.Wood
        
        -- 柱のテクスチャ
        local pillarTexture = Instance.new("Texture")
        pillarTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        pillarTexture.StudsPerTileU = 2
        pillarTexture.StudsPerTileV = wallHeight
        pillarTexture.Parent = pillar
        
        pillar.Parent = map
    end
    
    -- 縁側の作成
    local verandaPositions = {
        {start = Vector3.new(-mapSize/2 + roomSize, 0, -mapSize/2), finish = Vector3.new(mapSize/2 - roomSize, 0, -mapSize/2 + 5)},
        {start = Vector3.new(-mapSize/2 + roomSize, 0, mapSize/2 - 5), finish = Vector3.new(mapSize/2 - roomSize, 0, mapSize/2)},
        {start = Vector3.new(-mapSize/2, 0, -mapSize/2 + roomSize), finish = Vector3.new(-mapSize/2 + 5, 0, mapSize/2 - roomSize)},
        {start = Vector3.new(mapSize/2 - 5, 0, -mapSize/2 + roomSize), finish = Vector3.new(mapSize/2, 0, mapSize/2 - roomSize)}
    }
    
    for i, pos in ipairs(verandaPositions) do
        local veranda = Instance.new("Part")
        veranda.Name = "Veranda_" .. i
        veranda.Size = Vector3.new(pos.finish.X - pos.start.X, 0.3, pos.finish.Z - pos.start.Z)
        veranda.Position = Vector3.new((pos.start.X + pos.finish.X) / 2, 0.15, (pos.start.Z + pos.finish.Z) / 2)
        veranda.Anchored = true
        veranda.BrickColor = BrickColor.new("Brown")
        veranda.Material = Enum.Material.WoodPlanks
        
        -- 縁側のテクスチャ
        local verandaTexture = Instance.new("Texture")
        verandaTexture.Texture = "rbxassetid://9873284556" -- 木目テクスチャ
        verandaTexture.StudsPerTileU = 5
        verandaTexture.StudsPerTileV = 5
        verandaTexture.Face = Enum.NormalId.Top
        verandaTexture.Parent = veranda
        
        veranda.Parent = map
    end
    
    -- 家具の配置（伝統的な和風家具）
    -- 座卓（ちゃぶ台）
    local tablePositions = {
        Vector3.new(-mapSize/2 + roomSize/2, 0, -mapSize/2 + roomSize/2),
        Vector3.new(mapSize/2 - roomSize/2, 0, -mapSize/2 + roomSize/2),
        Vector3.new(-mapSize/2 + roomSize/2, 0, mapSize/2 - roomSize/2),
        Vector3.new(mapSize/2 - roomSize/2, 0, mapSize/2 - roomSize/2)
    }
    
    for i, pos in ipairs(tablePositions) do
        local table = Instance.new("Part")
        table.Name = "Chabudai_" .. i
        table.Size = Vector3.new(10, 0.5, 10)
        table.Position = pos + Vector3.new(0, 1.5, 0)
        table.Anchored = true
        table.BrickColor = BrickColor.new("Reddish brown")
        table.Material = Enum.Material.Wood
        
        -- テーブルのテクスチャ
        local tableTexture = Instance.new("Texture")
        tableTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
        tableTexture.StudsPerTileU = 10
        tableTexture.StudsPerTileV = 10
        tableTexture.Face = Enum.NormalId.Top
        tableTexture.Parent = table
        
        -- テーブルの脚
        for xOffset = -3, 3, 6 do
            for zOffset = -3, 3, 6 do
                local leg = Instance.new("Part")
                leg.Name = "TableLeg"
                leg.Size = Vector3.new(1, 1.5, 1)
                leg.Position = pos + Vector3.new(xOffset, 0.75, zOffset)
                leg.Anchored = true
                leg.BrickColor = BrickColor.new("Reddish brown")
                leg.Material = Enum.Material.Wood
                leg.Parent = map
            end
        end
        
        table.Parent = map
        
        -- 座布団を配置
        for j = 1, 4 do
            local cushionPos
            if j == 1 then
                cushionPos = pos + Vector3.new(0, 0.25, -6)
            elseif j == 2 then
                cushionPos = pos + Vector3.new(6, 0.25, 0)
            elseif j == 3 then
                cushionPos = pos + Vector3.new(0, 0.25, 6)
            else
                cushionPos = pos + Vector3.new(-6, 0.25, 0)
            end
            
            local cushion = Instance.new("Part")
            cushion.Name = "Zabuton_" .. i .. "_" .. j
            cushion.Size = Vector3.new(5, 0.5, 5)
            cushion.Position = cushionPos
            cushion.Anchored = true
            cushion.BrickColor = BrickColor.new("Bright red")
            cushion.Material = Enum.Material.Fabric
            
            -- 座布団のテクスチャ
            local cushionTexture = Instance.new("Texture")
            cushionTexture.Texture = "rbxassetid://7546636894" -- 和風模様
            cushionTexture.StudsPerTileU = 5
            cushionTexture.StudsPerTileV = 5
            cushionTexture.Face = Enum.NormalId.Top
            cushionTexture.Parent = cushion
            
            cushion.Parent = map
        end
    end
    
    -- 床の間（一部屋に一つ）
    local tokonoma = Instance.new("Part")
    tokonoma.Name = "Tokonoma"
    tokonoma.Size = Vector3.new(15, 5, 2)
    tokonoma.Position = Vector3.new(-mapSize/2 + roomSize/2, 2.5, -mapSize/2 + 3)
    tokonoma.Anchored = true
    tokonoma.BrickColor = BrickColor.new("Reddish brown")
    tokonoma.Material = Enum.Material.Wood
    
    -- 床の間のテクスチャ
    local tokonomaTexture = Instance.new("Texture")
    tokonomaTexture.Texture = "rbxassetid://9438453972" -- 木目テクスチャ
    tokonomaTexture.StudsPerTileU = 15
    tokonomaTexture.StudsPerTileV = 5
    tokonomaTexture.Face = Enum.NormalId.Front
    tokonomaTexture.Parent = tokonoma
    
    tokonoma.Parent = map
    
    -- 掛け軸
    local scroll = Instance.new("Part")
    scroll.Name = "HangingScroll"
    scroll.Size = Vector3.new(0.1, 4, 2)
    scroll.Position = Vector3.new(-mapSize/2 + roomSize/2, 3, -mapSize/2 + 2)
    scroll.Anchored = true
    scroll.BrickColor = BrickColor.new("White")
    scroll.Material = Enum.Material.Fabric
    
    -- 掛け軸のテクスチャ
    local scrollTexture = Instance.new("Texture")
    scrollTexture.Texture = "rbxassetid://7546636894" -- 和風模様
    scrollTexture.StudsPerTileU = 2
    scrollTexture.StudsPerTileV = 4
    scrollTexture.Face = Enum.NormalId.Front
    scrollTexture.Parent = scroll
    
    scroll.Parent = map
    
    -- 照明の配置（提灯）
    local lightPositions = {
        -- 各部屋の中央
        Vector3.new(-mapSize/2 + roomSize/2, wallHeight - 1, -mapSize/2 + roomSize/2),
        Vector3.new(mapSize/2 - roomSize/2, wallHeight - 1, -mapSize/2 + roomSize/2),
        Vector3.new(-mapSize/2 + roomSize/2, wallHeight - 1, mapSize/2 - roomSize/2),
        Vector3.new(mapSize/2 - roomSize/2, wallHeight - 1, mapSize/2 - roomSize/2),
        
        -- 廊下の交差点
        Vector3.new(0, wallHeight - 1, 0),
        
        -- 廊下の中間点
        Vector3.new(0, wallHeight - 1, -mapSize/4),
        Vector3.new(0, wallHeight - 1, mapSize/4),
        Vector3.new(-mapSize/4, wallHeight - 1, 0),
        Vector3.new(mapSize/4, wallHeight - 1, 0)
    }
    
    for i, pos in ipairs(lightPositions) do
        -- 提灯
        local lantern = Instance.new("Part")
        lantern.Name = "Lantern_" .. i
        lantern.Shape = Enum.PartType.Ball
        lantern.Size = Vector3.new(3, 3, 3)
        lantern.Position = pos
        lantern.Anchored = true
        lantern.BrickColor = BrickColor.new("Bright yellow")
        lantern.Material = Enum.Material.Neon
        lantern.Transparency = 0.3
        
        -- 光源
        local light = Instance.new("PointLight")
        light.Brightness = 1
        light.Color = Color3.fromRGB(255, 223, 186) -- 暖かい光
        light.Range = 20
        light.Shadows = true
        light.Parent = lantern
        
        lantern.Parent = map
    end
    
    -- 鳥居（脱出ポイント）
    local torii = Instance.new("Model")
    torii.Name = "Torii"
    
    -- 鳥居の柱（左）
    local leftPillar = Instance.new("Part")
    leftPillar.Name = "LeftPillar"
    leftPillar.Size = Vector3.new(2, 15, 2)
    leftPillar.Position = Vector3.new(-5, 7.5, -mapSize/2 - 10)
    leftPillar.Anchored = true
    leftPillar.BrickColor = BrickColor.new("Bright red")
    leftPillar.Material = Enum.Material.SmoothPlastic
    leftPillar.Parent = torii
    
    -- 鳥居の柱（右）
    local rightPillar = Instance.new("Part")
    rightPillar.Name = "RightPillar"
    rightPillar.Size = Vector3.new(2, 15, 2)
    rightPillar.Position = Vector3.new(5, 7.5, -mapSize/2 - 10)
    rightPillar.Anchored = true
    rightPillar.BrickColor = BrickColor.new("Bright red")
    rightPillar.Material = Enum.Material.SmoothPlastic
    rightPillar.Parent = torii
    
    -- 鳥居の横木（上）
    local topBeam = Instance.new("Part")
    topBeam.Name = "TopBeam"
    topBeam.Size = Vector3.new(14, 2, 2)
    topBeam.Position = Vector3.new(0, 14, -mapSize/2 - 10)
    topBeam.Anchored = true
    topBeam.BrickColor = BrickColor.new("Bright red")
    topBeam.Material = Enum.Material.SmoothPlastic
    topBeam.Parent = torii
    
    -- 鳥居の横木（中）
    local middleBeam = Instance.new("Part")
    middleBeam.Name = "MiddleBeam"
    middleBeam.Size = Vector3.new(16, 1, 1)
    middleBeam.Position = Vector3.new(0, 12, -mapSize/2 - 10)
    middleBeam.Anchored = true
    middleBeam.BrickColor = BrickColor.new("Bright red")
    middleBeam.Material = Enum.Material.SmoothPlastic
    middleBeam.Parent = torii
    
    torii.Parent = map
    
    return map
end

return TraditionalJapaneseHouse