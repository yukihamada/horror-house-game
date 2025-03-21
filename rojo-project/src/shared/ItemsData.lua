-- ItemsData.lua
-- ゲーム内のアイテムデータを定義するモジュールスクリプト

local ItemsData = {}

-- アイテムの種類
ItemsData.ItemTypes = {
    SEAL = "封印の札",
    KEY = "鍵",
    DOCUMENT = "古文書",
    TOOL = "道具",
    RELIC = "遺物"
}

-- アイテムデータ
ItemsData.Items = {
    -- 封印の札
    {
        id = "seal_talisman_1",
        name = "火の封印札",
        description = "炎の力を封じ込めた札。鳥居の封印を解くのに必要。",
        type = ItemsData.ItemTypes.SEAL,
        model = {
            shape = "Part",
            size = Vector3.new(0.5, 0.8, 0.05),
            color = Color3.fromRGB(255, 100, 100),
            material = Enum.Material.Paper,
            texture = "rbxassetid://7546636894" -- 和風模様
        },
        position = Vector3.new(-50, 5, 50), -- 和室1に配置
        glow = true,
        collectSound = "rbxassetid://5982028147"
    },
    {
        id = "seal_talisman_2",
        name = "水の封印札",
        description = "水の力を封じ込めた札。鳥居の封印を解くのに必要。",
        type = ItemsData.ItemTypes.SEAL,
        model = {
            shape = "Part",
            size = Vector3.new(0.5, 0.8, 0.05),
            color = Color3.fromRGB(100, 100, 255),
            material = Enum.Material.Paper,
            texture = "rbxassetid://7546636894" -- 和風模様
        },
        position = Vector3.new(50, 5, -50), -- 茶室に配置
        glow = true,
        collectSound = "rbxassetid://5982028147"
    },
    {
        id = "seal_talisman_3",
        name = "風の封印札",
        description = "風の力を封じ込めた札。鳥居の封印を解くのに必要。",
        type = ItemsData.ItemTypes.SEAL,
        model = {
            shape = "Part",
            size = Vector3.new(0.5, 0.8, 0.05),
            color = Color3.fromRGB(100, 255, 100),
            material = Enum.Material.Paper,
            texture = "rbxassetid://7546636894" -- 和風模様
        },
        position = Vector3.new(0, 15, 0), -- 隠し部屋に配置
        glow = true,
        collectSound = "rbxassetid://5982028147"
    },
    
    -- 鍵
    {
        id = "key_storage",
        name = "納戸の鍵",
        description = "納戸のドアを開けるための古い鍵。",
        type = ItemsData.ItemTypes.KEY,
        model = {
            shape = "Part",
            size = Vector3.new(0.3, 0.1, 0.5),
            color = Color3.fromRGB(200, 170, 0),
            material = Enum.Material.Metal
        },
        position = Vector3.new(80, 5, 30), -- 台所に配置
        glow = false,
        collectSound = "rbxassetid://6333823613"
    },
    {
        id = "key_hidden_room",
        name = "隠し部屋の鍵",
        description = "2階の隠し部屋に通じる扉の鍵。不吉なオーラを放っている。",
        type = ItemsData.ItemTypes.KEY,
        model = {
            shape = "Part",
            size = Vector3.new(0.3, 0.1, 0.5),
            color = Color3.fromRGB(100, 0, 0),
            material = Enum.Material.Metal
        },
        position = Vector3.new(-80, 15, 80), -- 書斎に配置
        glow = false,
        collectSound = "rbxassetid://6333823613"
    },
    
    -- 古文書
    {
        id = "document_ritual",
        name = "儀式の書",
        description = "鳥居の封印を解く方法が記された古文書。",
        type = ItemsData.ItemTypes.DOCUMENT,
        model = {
            shape = "Part",
            size = Vector3.new(0.7, 0.05, 0.5),
            color = Color3.fromRGB(220, 200, 150),
            material = Enum.Material.Paper
        },
        position = Vector3.new(-50, 15, -50), -- 和室2に配置
        glow = false,
        collectSound = "rbxassetid://6333823613",
        readableText = "「三つの札を集め、鳥居の前に立ち、祈りを捧げよ。そうすれば封印は解かれ、あの世への扉が開かれるだろう。」"
    },
    {
        id = "document_warning",
        name = "警告の書",
        description = "この家の危険性について書かれた古文書。",
        type = ItemsData.ItemTypes.DOCUMENT,
        model = {
            shape = "Part",
            size = Vector3.new(0.7, 0.05, 0.5),
            color = Color3.fromRGB(220, 200, 150),
            material = Enum.Material.Paper
        },
        position = Vector3.new(-80, 5, -30), -- 玄関に配置
        glow = false,
        collectSound = "rbxassetid://6333823613",
        readableText = "「この家に足を踏み入れし者よ、警告する。夜になれば妖怪たちが現れ、迷い込んだ者の魂を奪うだろう。決して一人で行動せず、提灯の灯りを絶やさぬよう。」"
    },
    
    -- 道具
    {
        id = "tool_lantern_battery",
        name = "提灯の油",
        description = "提灯の燃料を補充できる油。",
        type = ItemsData.ItemTypes.TOOL,
        model = {
            shape = "Cylinder",
            size = Vector3.new(0.5, 0.8, 0.5),
            color = Color3.fromRGB(200, 150, 50),
            material = Enum.Material.Glass
        },
        position = Vector3.new(30, 5, 80), -- 居間に配置
        glow = false,
        collectSound = "rbxassetid://6333823613",
        useEffect = "提灯の燃料が補充された。"
    },
    {
        id = "tool_compass",
        name = "古い羅針盤",
        description = "常に最も近い封印の札の方向を指す不思議な羅針盤。",
        type = ItemsData.ItemTypes.TOOL,
        model = {
            shape = "Cylinder",
            size = Vector3.new(0.5, 0.1, 0.5),
            color = Color3.fromRGB(150, 120, 80),
            material = Enum.Material.Metal
        },
        position = Vector3.new(50, 15, 50), -- 寝室に配置
        glow = false,
        collectSound = "rbxassetid://6333823613",
        useEffect = "羅針盤が最も近い封印の札の方向を指している。"
    },
    
    -- 遺物
    {
        id = "relic_mirror",
        name = "曇り鏡",
        description = "妖怪の姿を映し出す古い鏡。一時的に妖怪を弱らせることができる。",
        type = ItemsData.ItemTypes.RELIC,
        model = {
            shape = "Part",
            size = Vector3.new(0.6, 0.8, 0.1),
            color = Color3.fromRGB(200, 200, 220),
            material = Enum.Material.Glass,
            transparency = 0.3
        },
        position = Vector3.new(0, 5, -80), -- 風呂場に配置
        glow = true,
        collectSound = "rbxassetid://5982028147",
        useEffect = "鏡が妖怪の姿を映し出し、一時的に弱らせた。"
    },
    {
        id = "relic_doll",
        name = "藁人形",
        description = "妖怪の注意を引きつける藁人形。危険な状況から逃げるのに使える。",
        type = ItemsData.ItemTypes.RELIC,
        model = {
            shape = "Part",
            size = Vector3.new(0.3, 0.6, 0.2),
            color = Color3.fromRGB(200, 180, 100),
            material = Enum.Material.Fabric
        },
        position = Vector3.new(0, 15, 80), -- 物置に配置
        glow = false,
        collectSound = "rbxassetid://6333823613",
        useEffect = "藁人形が妖怪の注意を引きつけた。今のうちに逃げよう。"
    }
}

-- アイテムIDからアイテムデータを取得する関数
function ItemsData.GetItemById(itemId)
    for _, item in ipairs(ItemsData.Items) do
        if item.id == itemId then
            return item
        end
    end
    return nil
end

-- アイテムタイプでフィルタリングする関数
function ItemsData.GetItemsByType(itemType)
    local filteredItems = {}
    for _, item in ipairs(ItemsData.Items) do
        if item.type == itemType then
            table.insert(filteredItems, item)
        end
    end
    return filteredItems
end

return ItemsData