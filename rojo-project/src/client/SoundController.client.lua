-- SoundController.client.lua
-- 環境音や効果音を管理するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

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
    
    -- BGMグループ
    local bgmGroup = Instance.new("SoundGroup")
    bgmGroup.Name = "BGMSoundGroup"
    bgmGroup.Volume = 0.5
    bgmGroup.Parent = mainGroup
    
    return {
        main = mainGroup,
        ambient = ambientGroup,
        sfx = sfxGroup,
        bgm = bgmGroup
    }
end

-- 環境音の設定
local function setupAmbientSounds(soundGroups)
    -- 雨の音
    local rainSound = Instance.new("Sound")
    rainSound.Name = "RainSound"
    rainSound.SoundId = "rbxassetid://130976109" -- 雨の音
    rainSound.Volume = 0.5
    rainSound.Looped = true
    rainSound.SoundGroup = soundGroups.ambient
    rainSound.Parent = workspace
    
    -- 風の音
    local windSound = Instance.new("Sound")
    windSound.Name = "WindSound"
    windSound.SoundId = "rbxassetid://5977154884" -- 風の音
    windSound.Volume = 0.3
    windSound.Looped = true
    windSound.SoundGroup = soundGroups.ambient
    windSound.Parent = workspace
    
    -- 家のきしみ音
    local creakSound = Instance.new("Sound")
    creakSound.Name = "CreakSound"
    creakSound.SoundId = "rbxassetid://9125573621" -- きしみ音
    creakSound.Volume = 0.2
    creakSound.Looped = true
    creakSound.SoundGroup = soundGroups.ambient
    creakSound.Parent = workspace
    
    -- 環境音を再生
    rainSound:Play()
    windSound:Play()
    creakSound:Play()
    
    -- ランダムな不気味な音
    spawn(function()
        local creepySounds = {
            "rbxassetid://9125626120", -- うめき声
            "rbxassetid://5567523997", -- 叫び声
            "rbxassetid://1565473107", -- 囁き声
            "rbxassetid://169736440"   -- 不気味な音
        }
        
        while true do
            wait(math.random(30, 120)) -- 30秒〜2分ごとにランダムに再生
            
            local randomSound = Instance.new("Sound")
            randomSound.SoundId = creepySounds[math.random(1, #creepySounds)]
            randomSound.Volume = math.random(10, 30) / 100 -- 0.1〜0.3のランダムな音量
            randomSound.PlaybackSpeed = math.random(80, 120) / 100 -- 0.8〜1.2のランダムな再生速度
            
            -- 3Dサウンド効果
            local position = character.HumanoidRootPart.Position
            local angle = math.random() * math.pi * 2
            local distance = math.random(30, 50)
            local soundPosition = position + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
            
            randomSound.Position = soundPosition
            randomSound.RollOffMaxDistance = 100
            randomSound.RollOffMinDistance = 10
            randomSound.SoundGroup = soundGroups.ambient
            randomSound.Parent = workspace
            
            randomSound:Play()
            
            -- 音が終わったら削除
            randomSound.Ended:Connect(function()
                randomSound:Destroy()
            end)
        end
    end)
    
    return {
        rain = rainSound,
        wind = windSound,
        creak = creakSound
    }
end

-- BGMの設定
local function setupBGM(soundGroups)
    -- メインBGM
    local mainBGM = Instance.new("Sound")
    mainBGM.Name = "MainBGM"
    mainBGM.SoundId = "rbxassetid://1846999567" -- 和風ホラーBGM
    mainBGM.Volume = 0.3
    mainBGM.Looped = true
    mainBGM.SoundGroup = soundGroups.bgm
    mainBGM.Parent = workspace
    
    -- BGMを再生
    mainBGM:Play()
    
    return mainBGM
end

-- 足音システム
local function setupFootstepSystem(character, soundGroups)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- 足音の種類（より静かな足音に変更）
    local footstepSounds = {
        wood = {
            "rbxassetid://6333823613", -- 木の床の足音1（静かな足音）
            "rbxassetid://6333823613", -- 木の床の足音2（静かな足音）
            "rbxassetid://6333823613"  -- 木の床の足音3（静かな足音）
        },
        tatami = {
            "rbxassetid://6333823613", -- 畳の足音1（静かな足音）
            "rbxassetid://6333823613", -- 畳の足音2（静かな足音）
            "rbxassetid://6333823613"  -- 畳の足音3（静かな足音）
        }
    }
    
    -- 足音タイマー（間隔を長くして足音を減らす）
    local lastFootstep = 0
    local footstepInterval = 0.5
    
    -- 移動中の足音
    RunService.Heartbeat:Connect(function()
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
                    
                    -- 足音の選択
                    local soundType = "wood"
                    if name:find("tatami") then
                        soundType = "tatami"
                    end
                    
                    -- 足音の再生（音量を下げて、再生速度も調整）
                    local soundId = footstepSounds[soundType][math.random(1, #footstepSounds[soundType])]
                    local footstepSound = Instance.new("Sound")
                    footstepSound.SoundId = soundId
                    footstepSound.Volume = 0.1 -- 音量を下げる
                    footstepSound.PlaybackSpeed = math.random(70, 90) / 100 -- 再生速度を遅くする
                    footstepSound.SoundGroup = soundGroups.sfx
                    footstepSound.Parent = rootPart
                    
                    footstepSound:Play()
                    
                    -- 音が終わったら削除
                    footstepSound.Ended:Connect(function()
                        footstepSound:Destroy()
                    end)
                end
            end
        end
    end)
end

-- 初期化
local soundGroups = setupSoundGroups()
local ambientSounds = setupAmbientSounds(soundGroups)
local mainBGM = setupBGM(soundGroups)

-- キャラクターが読み込まれたときの処理
local function onCharacterAdded(newCharacter)
    character = newCharacter
    setupFootstepSystem(character, soundGroups)
end

player.CharacterAdded:Connect(onCharacterAdded)
if character then
    setupFootstepSystem(character, soundGroups)
end

print("SoundController initialized")