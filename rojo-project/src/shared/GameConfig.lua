-- GameConfig.lua
-- ゲーム全体の設定を管理するモジュールスクリプト

local GameConfig = {}

-- ゲームの基本設定
GameConfig.Settings = {
    -- ゲームの時間設定
    GameDuration = 300, -- 5分間
    PreparationTime = 30, -- 準備時間30秒
    
    -- プレイヤー設定
    MaxPlayers = 8,
    InitialHealth = 100,
    RespawnTime = 5,
    
    -- 環境設定
    Darkness = 0.8, -- 0.0 (明るい) から 1.0 (暗い)
    FogDensity = 0.5, -- 0.0 (なし) から 1.0 (濃い)
    AmbientSoundVolume = 0.7, -- 0.0 (無音) から 1.0 (最大)
    
    -- ゲームプレイ設定
    MonsterSpawnInterval = 30, -- 30秒ごとにモンスター出現
    ItemSpawnInterval = 60, -- 60秒ごとにアイテム出現
    MaxMonstersActive = 10, -- 同時に存在できるモンスターの最大数
    
    -- 難易度設定
    Difficulty = "Normal", -- "Easy", "Normal", "Hard", "Nightmare"
    DifficultyModifiers = {
        Easy = {
            MonsterDamageMultiplier = 0.5,
            MonsterSpeedMultiplier = 0.8,
            ItemSpawnRateMultiplier = 1.5
        },
        Normal = {
            MonsterDamageMultiplier = 1.0,
            MonsterSpeedMultiplier = 1.0,
            ItemSpawnRateMultiplier = 1.0
        },
        Hard = {
            MonsterDamageMultiplier = 1.5,
            MonsterSpeedMultiplier = 1.2,
            ItemSpawnRateMultiplier = 0.7
        },
        Nightmare = {
            MonsterDamageMultiplier = 2.0,
            MonsterSpeedMultiplier = 1.5,
            ItemSpawnRateMultiplier = 0.5
        }
    }
}

-- アイテムの設定
GameConfig.Items = {
    HealthPack = {
        HealAmount = 50,
        SpawnChance = 0.4,
        Model = "HealthPack" -- モデル名
    },
    Battery = {
        FlashlightRecharge = 100,
        SpawnChance = 0.3,
        Model = "Battery" -- モデル名
    },
    SpeedBoost = {
        SpeedMultiplier = 1.5,
        Duration = 10, -- 10秒間
        SpawnChance = 0.2,
        Model = "SpeedBoost" -- モデル名
    },
    Shield = {
        DamageReduction = 0.5, -- 50%ダメージ軽減
        Duration = 15, -- 15秒間
        SpawnChance = 0.1,
        Model = "Shield" -- モデル名
    }
}

-- マップの設定
GameConfig.Map = {
    Size = {X = 500, Y = 100, Z = 500}, -- マップサイズ
    SpawnPoints = {
        -- プレイヤーのスポーン位置
        {X = 0, Y = 5, Z = 0},
        {X = 10, Y = 5, Z = 10},
        {X = -10, Y = 5, Z = -10},
        {X = 10, Y = 5, Z = -10},
        {X = -10, Y = 5, Z = 10}
    },
    ExitPoints = {
        -- 脱出ポイント
        {X = 200, Y = 5, Z = 200},
        {X = -200, Y = 5, Z = -200}
    }
}

-- 難易度に基づいた設定を取得する関数
function GameConfig.GetDifficultySettings()
    local difficulty = GameConfig.Settings.Difficulty
    return GameConfig.Settings.DifficultyModifiers[difficulty] or GameConfig.Settings.DifficultyModifiers.Normal
end

-- ランダムなプレイヤースポーン位置を取得する関数
function GameConfig.GetRandomSpawnPoint()
    local index = math.random(1, #GameConfig.Map.SpawnPoints)
    local point = GameConfig.Map.SpawnPoints[index]
    return Vector3.new(point.X, point.Y, point.Z)
end

-- ランダムな脱出ポイントを取得する関数
function GameConfig.GetRandomExitPoint()
    local index = math.random(1, #GameConfig.Map.ExitPoints)
    local point = GameConfig.Map.ExitPoints[index]
    return Vector3.new(point.X, point.Y, point.Z)
end

return GameConfig