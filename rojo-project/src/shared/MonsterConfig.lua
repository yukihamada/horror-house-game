-- MonsterConfig.lua
-- モンスターの設定を管理するモジュールスクリプト

local MonsterConfig = {}

-- 日本の妖怪タイプの定義
MonsterConfig.Types = {
    YUREI = "Yurei",       -- 幽霊
    KAPPA = "Kappa",       -- 河童
    ONI = "Oni",           -- 鬼
    KITSUNE = "Kitsune"    -- 狐
}

-- 妖怪の設定
MonsterConfig.Settings = {
    [MonsterConfig.Types.YUREI] = {
        speed = 16,
        health = 100,
        damage = 10,
        detectionRange = 30,
        attackRange = 5,
        attackCooldown = 2,
        spawnChance = 0.4,
        model = "Yurei", -- モデル名
        description = "浮遊する幽霊。壁をすり抜けることができる。"
    },
    
    [MonsterConfig.Types.KAPPA] = {
        speed = 12,
        health = 150,
        damage = 20,
        detectionRange = 20,
        attackRange = 3,
        attackCooldown = 3,
        spawnChance = 0.3,
        model = "Kappa", -- モデル名
        description = "河童。水場に潜み、通りかかる人を引きずり込む。"
    },
    
    [MonsterConfig.Types.ONI] = {
        speed = 20,
        health = 200,
        damage = 30,
        detectionRange = 40,
        attackRange = 7,
        attackCooldown = 4,
        spawnChance = 0.2,
        model = "Oni", -- モデル名
        description = "巨大な鬼。金棒を持ち、強力な攻撃を繰り出す。"
    },
    
    [MonsterConfig.Types.KITSUNE] = {
        speed = 25,
        health = 80,
        damage = 15,
        detectionRange = 50,
        attackRange = 4,
        attackCooldown = 1.5,
        spawnChance = 0.1,
        model = "Kitsune", -- モデル名
        description = "狐の妖怪。幻術を使い、姿を変えることができる。"
    }
}

-- スポーン位置の設定
MonsterConfig.SpawnLocations = {
    -- 例: {x, y, z}
    {50, 0, 50},
    {-50, 0, 50},
    {50, 0, -50},
    {-50, 0, -50},
    {0, 0, 100},
    {0, 0, -100},
    {100, 0, 0},
    {-100, 0, 0}
}

-- ランダムなモンスタータイプを取得する関数
function MonsterConfig.GetRandomType()
    local random = math.random()
    local cumulativeChance = 0
    
    for type, settings in pairs(MonsterConfig.Settings) do
        cumulativeChance = cumulativeChance + settings.spawnChance
        if random <= cumulativeChance then
            return type
        end
    end
    
    -- デフォルトはゴースト
    return MonsterConfig.Types.GHOST
end

-- ランダムなスポーン位置を取得する関数
function MonsterConfig.GetRandomSpawnLocation()
    local index = math.random(1, #MonsterConfig.SpawnLocations)
    local location = MonsterConfig.SpawnLocations[index]
    return Vector3.new(location[1], location[2], location[3])
end

return MonsterConfig