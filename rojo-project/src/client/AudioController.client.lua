-- AudioController.client.lua
-- ゲーム内のオーディオを管理するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- RemoteEventsの取得
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local gameStateChangedEvent = remoteEvents:WaitForChild("GameStateChanged")
local monsterSpawnedEvent = remoteEvents:WaitForChild("MonsterSpawned")
local itemCollectedEvent = remoteEvents:WaitForChild("ItemCollected")
local gameEndedEvent = remoteEvents:WaitForChild("GameEnded")

-- サウンドグループの作成
local function setupSoundGroups()
    -- メインサウンドグループ
    local mainGroup = Instance.new("SoundGroup")
    mainGroup.Name = "MainSoundGroup"
    mainGroup.Volume = 1
    mainGroup.Parent = SoundService
    
    -- 環境音グループ
    local ambientGroup = Instance.new("SoundGroup")
    ambientGroup.Name = "AmbientSoundGroup"
    ambientGroup.Volume = 0.7
    ambientGroup.Parent = mainGroup
    
    -- 効果音グループ
    local sfxGroup = Instance.new("SoundGroup")
    sfxGroup.Name = "SFXSoundGroup"
    sfxGroup.Volume = 1
    sfxGroup.Parent = mainGroup
    
    -- 妖怪音グループ
    local yokaiGroup = Instance.new("SoundGroup")
    yokaiGroup.Name = "YokaiSoundGroup"
    yokaiGroup.Volume = 1
    yokaiGroup.Parent = mainGroup
    
    -- UI音グループ
    local uiGroup = Instance.new("SoundGroup")
    uiGroup.Name = "UISoundGroup"
    uiGroup.Volume = 0.8
    uiGroup.Parent = mainGroup
    
    -- BGMグループ
    local bgmGroup = Instance.new("SoundGroup")
    bgmGroup.Name = "BGMSoundGroup"
    bgmGroup.Volume = 0.5
    bgmGroup.Parent = mainGroup
    
    return {
        main = mainGroup,
        ambient = ambientGroup,
        sfx = sfxGroup,
        yokai = yokaiGroup,
        ui = uiGroup,
        bgm = bgmGroup
    }
end

-- サウンド定義
local soundDefinitions = {
    -- 環境音
    ambient = {
        wind = {
            id = "rbxassetid://5977154884",
            looped = true,
            volume = 0.3,
            group = "ambient"
        },
        rain = {
            id = "rbxassetid://130976109",
            looped = true,
            volume = 0.4,
            group = "ambient"
        },
        crickets = {
            id = "rbxassetid://142376088",
            looped = true,
            volume = 0.2,
            group = "ambient"
        },
        creaking = {
            id = "rbxassetid://9125573621",
            looped = true,
            volume = 0.2,
            group = "ambient"
        }
    },
    
    -- 効果音
    sfx = {
        footstep_wood = {
            id = "rbxassetid://142070127",
            looped = false,
            volume = 0.5,
            group = "sfx"
        },
        footstep_tatami = {
            id = "rbxassetid://7149255551",
            looped = false,
            volume = 0.4,
            group = "sfx"
        },
        door_open = {
            id = "rbxassetid://142082167",
            looped = false,
            volume = 0.6,
            group = "sfx"
        },
        door_close = {
            id = "rbxassetid://142082167",
            looped = false,
            volume = 0.6,
            group = "sfx"
        },
        item_pickup = {
            id = "rbxassetid://6333823613",
            looped = false,
            volume = 0.7,
            group = "sfx"
        },
        seal_collect = {
            id = "rbxassetid://5982028147",
            looped = false,
            volume = 0.8,
            group = "sfx"
        }
    },
    
    -- 妖怪の音
    yokai = {
        yurei_ambient = {
            id = "rbxassetid://1565473107",
            looped = true,
            volume = 0.4,
            group = "yokai"
        },
        yurei_attack = {
            id = "rbxassetid://5567523997",
            looped = false,
            volume = 0.7,
            group = "yokai"
        },
        kappa_ambient = {
            id = "rbxassetid://169736440",
            looped = true,
            volume = 0.4,
            group = "yokai"
        },
        kappa_attack = {
            id = "rbxassetid://5567523997",
            looped = false,
            volume = 0.7,
            group = "yokai"
        },
        oni_ambient = {
            id = "rbxassetid://9125626120",
            looped = true,
            volume = 0.5,
            group = "yokai"
        },
        oni_attack = {
            id = "rbxassetid://5567523997",
            looped = false,
            volume = 0.8,
            group = "yokai"
        },
        kitsune_ambient = {
            id = "rbxassetid://169736440",
            looped = true,
            volume = 0.4,
            group = "yokai"
        },
        kitsune_attack = {
            id = "rbxassetid://5567523997",
            looped = false,
            volume = 0.7,
            group = "yokai"
        }
    },
    
    -- UI音
    ui = {
        button_click = {
            id = "rbxassetid://6333823613",
            looped = false,
            volume = 0.5,
            group = "ui"
        },
        game_start = {
            id = "rbxassetid://6518811702",
            looped = false,
            volume = 0.7,
            group = "ui"
        },
        game_over = {
            id = "rbxassetid://5567523997",
            looped = false,
            volume = 0.7,
            group = "ui"
        },
        game_win = {
            id = "rbxassetid://6518811702",
            looped = false,
            volume = 0.8,
            group = "ui"
        }
    },
    
    -- BGM
    bgm = {
        main_theme = {
            id = "rbxassetid://1846999567",
            looped = true,
            volume = 0.4,
            group = "bgm"
        },
        tension = {
            id = "rbxassetid://1837879082",
            looped = true,
            volume = 0.5,
            group = "bgm"
        },
        chase = {
            id = "rbxassetid://1842006694",
            looped = true,
            volume = 0.6,
            group = "bgm"
        }
    }
}

-- サウンドの作成
local function createSound(definition, parent, soundGroups)
    local sound = Instance.new("Sound")
    sound.Name = definition.name or "Sound"
    sound.SoundId = definition.id
    sound.Volume = definition.volume or 1
    sound.Looped = definition.looped or false
    
    if definition.group and soundGroups[definition.group] then
        sound.SoundGroup = soundGroups[definition.group]
    end
    
    sound.Parent = parent
    return sound
end

-- 足音システム
local function setupFootstepSystem(character, soundGroups)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- 足音サウンド
    local footstepWood = createSound({
        name = "FootstepWood",
        id = soundDefinitions.sfx.footstep_wood.id,
        volume = soundDefinitions.sfx.footstep_wood.volume,
        looped = false,
        group = "sfx"
    }, rootPart, soundGroups)
    
    local footstepTatami = createSound({
        name = "FootstepTatami",
        id = soundDefinitions.sfx.footstep_tatami.id,
        volume = soundDefinitions.sfx.footstep_tatami.volume,
        looped = false,
        group = "sfx"
    }, rootPart, soundGroups)
    
    -- 足音タイマー
    local lastFootstep = 0
    local footstepInterval = 0.3
    
    -- 移動中の足音
    game:GetService("RunService").Heartbeat:Connect(function()
        if humanoid.MoveDirection.Magnitude > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            local now = tick()
            if now - lastFootstep >= footstepInterval then
                lastFootstep = now
                
                -- 床の材質を検出
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {character}
                
                local rayResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0), rayParams)
                if rayResult and rayResult.Instance then
                    local material = rayResult.Instance.Material
                    local name = rayResult.Instance.Name:lower()
                    
                    -- 畳の上かどうかを判定
                    if name:find("tatami") or name:find("tatami") then
                        footstepTatami:Play()
                    else
                        footstepWood:Play()
                    end
                else
                    footstepWood:Play()
                end
            end
        end
    end)
end

-- 環境音の設定
local function setupAmbientSounds(soundGroups)
    -- 風の音
    local windSound = createSound({
        name = "WindSound",
        id = soundDefinitions.ambient.wind.id,
        volume = soundDefinitions.ambient.wind.volume,
        looped = true,
        group = "ambient"
    }, workspace, soundGroups)
    
    -- きしみ音
    local creakingSound = createSound({
        name = "CreakingSound",
        id = soundDefinitions.ambient.creaking.id,
        volume = soundDefinitions.ambient.creaking.volume,
        looped = true,
        group = "ambient"
    }, workspace, soundGroups)
    
    -- 環境音を再生
    windSound:Play()
    creakingSound:Play()
    
    return {
        wind = windSound,
        creaking = creakingSound
    }
end

-- BGMの設定
local function setupBGM(soundGroups)
    -- メインテーマ
    local mainTheme = createSound({
        name = "MainTheme",
        id = soundDefinitions.bgm.main_theme.id,
        volume = soundDefinitions.bgm.main_theme.volume,
        looped = true,
        group = "bgm"
    }, workspace, soundGroups)
    
    -- テンション音楽
    local tensionTheme = createSound({
        name = "TensionTheme",
        id = soundDefinitions.bgm.tension.id,
        volume = soundDefinitions.bgm.tension.volume,
        looped = true,
        group = "bgm"
    }, workspace, soundGroups)
    
    -- 追跡音楽
    local chaseTheme = createSound({
        name = "ChaseTheme",
        id = soundDefinitions.bgm.chase.id,
        volume = soundDefinitions.bgm.chase.volume,
        looped = true,
        group = "bgm"
    }, workspace, soundGroups)
    
    return {
        main = mainTheme,
        tension = tensionTheme,
        chase = chaseTheme
    }
end

-- 妖怪の音を設定
local function setupYokaiSounds(soundGroups)
    local yokaiSounds = {}
    
    for yokaiType, sounds in pairs(soundDefinitions.yokai) do
        if yokaiType:find("_ambient") then
            local yokaiName = yokaiType:gsub("_ambient", "")
            if not yokaiSounds[yokaiName] then
                yokaiSounds[yokaiName] = {}
            end
            
            yokaiSounds[yokaiName].ambient = createSound({
                name = yokaiName .. "AmbientSound",
                id = sounds.id,
                volume = sounds.volume,
                looped = true,
                group = "yokai"
            }, workspace, soundGroups)
        elseif yokaiType:find("_attack") then
            local yokaiName = yokaiType:gsub("_attack", "")
            if not yokaiSounds[yokaiName] then
                yokaiSounds[yokaiName] = {}
            end
            
            yokaiSounds[yokaiName].attack = createSound({
                name = yokaiName .. "AttackSound",
                id = sounds.id,
                volume = sounds.volume,
                looped = false,
                group = "yokai"
            }, workspace, soundGroups)
        end
    end
    
    return yokaiSounds
end

-- UI音の設定
local function setupUISounds(soundGroups)
    local uiSounds = {}
    
    for soundName, soundDef in pairs(soundDefinitions.ui) do
        uiSounds[soundName] = createSound({
            name = soundName,
            id = soundDef.id,
            volume = soundDef.volume,
            looped = soundDef.looped,
            group = "ui"
        }, player.PlayerGui, soundGroups)
    end
    
    return uiSounds
end

-- 効果音の再生
local function playSFX(sfxName, soundGroups)
    if soundDefinitions.sfx[sfxName] then
        local sfxDef = soundDefinitions.sfx[sfxName]
        local sfx = createSound({
            name = sfxName,
            id = sfxDef.id,
            volume = sfxDef.volume,
            looped = sfxDef.looped,
            group = "sfx"
        }, workspace, soundGroups)
        
        sfx:Play()
        
        -- ループしない効果音は再生後に削除
        if not sfxDef.looped then
            sfx.Ended:Connect(function()
                sfx:Destroy()
            end)
        end
        
        return sfx
    end
    return nil
end

-- 初期化
local soundGroups = setupSoundGroups()
local ambientSounds = setupAmbientSounds(soundGroups)
local bgmSounds = setupBGM(soundGroups)
local yokaiSounds = setupYokaiSounds(soundGroups)
local uiSounds = setupUISounds(soundGroups)

-- キャラクターが読み込まれたときの処理
local function onCharacterAdded(newCharacter)
    character = newCharacter
    setupFootstepSystem(character, soundGroups)
end

player.CharacterAdded:Connect(onCharacterAdded)
if character then
    setupFootstepSystem(character, soundGroups)
end

-- ゲーム状態変更イベント
gameStateChangedEvent.OnClientEvent:Connect(function(state, data)
    if state == "Preparation" then
        -- 準備フェーズ
        bgmSounds.main:Play()
        uiSounds.game_start:Play()
    elseif state == "Playing" then
        -- プレイ中
        if not bgmSounds.main.IsPlaying then
            bgmSounds.main:Play()
        end
    elseif state == "Message" then
        -- メッセージ表示時
        playSFX("item_pickup", soundGroups)
    end
end)

-- 妖怪出現イベント
monsterSpawnedEvent.OnClientEvent:Connect(function(monsterType, position)
    -- 妖怪タイプに応じた音を再生
    local yokaiType = string.lower(monsterType)
    
    if yokaiType:find("yurei") and yokaiSounds.yurei then
        yokaiSounds.yurei.ambient:Play()
    elseif yokaiType:find("kappa") and yokaiSounds.kappa then
        yokaiSounds.kappa.ambient:Play()
    elseif yokaiType:find("oni") and yokaiSounds.oni then
        yokaiSounds.oni.ambient:Play()
    elseif yokaiType:find("kitsune") and yokaiSounds.kitsune then
        yokaiSounds.kitsune.ambient:Play()
    end
    
    -- テンションBGMに切り替え
    bgmSounds.main:Stop()
    bgmSounds.tension:Play()
end)

-- アイテム収集イベント
itemCollectedEvent.OnClientEvent:Connect(function(playerName, itemType)
    if itemType:find("SealTalisman_") then
        -- 封印の札収集音
        playSFX("seal_collect", soundGroups)
    else
        -- 通常アイテム収集音
        playSFX("item_pickup", soundGroups)
    end
end)

-- ゲーム終了イベント
gameEndedEvent.OnClientEvent:Connect(function(isVictory, winnerName)
    -- BGMを停止
    for _, sound in pairs(bgmSounds) do
        sound:Stop()
    end
    
    -- 妖怪の音を停止
    for _, yokai in pairs(yokaiSounds) do
        for _, sound in pairs(yokai) do
            sound:Stop()
        end
    end
    
    if isVictory then
        -- 勝利音
        uiSounds.game_win:Play()
    else
        -- ゲームオーバー音
        uiSounds.game_over:Play()
    end
end)

-- ドア開閉音のフック
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Sound") and (child.Name == "DoorOpenSound" or child.Name == "DoorCloseSound") then
        -- サウンドグループを設定
        child.SoundGroup = soundGroups.sfx
    end
end)

print("AudioController initialized")