-- PlayerController.client.lua
-- プレイヤーの動きと操作を制御するクライアントスクリプト

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ローカルプレイヤーの取得
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 定数
local WALK_SPEED = 16
local SPRINT_SPEED = 24
local CROUCH_SPEED = 8
local FLASHLIGHT_RANGE = 20
local FLASHLIGHT_BRIGHTNESS = 2

-- 変数
local isSprinting = false
local isCrouching = false
local isFlashlightOn = false
local flashlight = nil

-- フラッシュライトの作成
local function createFlashlight()
    if flashlight then return end
    
    flashlight = Instance.new("SpotLight")
    flashlight.Range = FLASHLIGHT_RANGE * 2 -- 範囲を2倍に
    flashlight.Brightness = FLASHLIGHT_BRIGHTNESS * 2 -- 明るさを2倍に
    flashlight.Angle = 60 -- 角度を広げる
    flashlight.Enabled = true -- 最初からオン
    isFlashlightOn = true -- 状態を更新
    
    -- フラッシュライトをプレイヤーの右手に取り付け
    local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
    if rightHand then
        flashlight.Parent = rightHand
    else
        flashlight.Parent = character:FindFirstChild("Head")
    end
    
    -- フラッシュライトの光源を示す部品を作成
    local flashlightPart = Instance.new("Part")
    flashlightPart.Name = "FlashlightPart"
    flashlightPart.Size = Vector3.new(0.5, 0.5, 1.5)
    flashlightPart.Material = Enum.Material.Neon
    flashlightPart.BrickColor = BrickColor.new("Institutional white")
    flashlightPart.CanCollide = false
    flashlightPart.Anchored = false
    
    -- フラッシュライトの位置を調整
    local attachment = Instance.new("Attachment")
    attachment.Parent = rightHand or character:FindFirstChild("Head")
    
    local weld = Instance.new("Weld")
    weld.Part0 = rightHand or character:FindFirstChild("Head")
    weld.Part1 = flashlightPart
    weld.C0 = CFrame.new(0, 0, 0)
    weld.C1 = CFrame.new(0, 0, -0.75)
    weld.Parent = flashlightPart
    
    flashlightPart.Parent = character
    
    print("フラッシュライトを作成しました（自動的にオン）")
end

-- フラッシュライトの切り替え
local function toggleFlashlight()
    if not flashlight then
        createFlashlight()
    end
    
    isFlashlightOn = not isFlashlightOn
    flashlight.Enabled = isFlashlightOn
    
    print("フラッシュライト: " .. (isFlashlightOn and "オン" or "オフ"))
end

-- スプリント状態の切り替え
local function toggleSprint(sprinting)
    isSprinting = sprinting
    
    if isCrouching then
        -- しゃがみ中はスプリントできない
        humanoid.WalkSpeed = CROUCH_SPEED
    else
        humanoid.WalkSpeed = isSprinting and SPRINT_SPEED or WALK_SPEED
    end
end

-- しゃがみ状態の切り替え
local function toggleCrouch()
    isCrouching = not isCrouching
    
    if isCrouching then
        humanoid.WalkSpeed = CROUCH_SPEED
        -- キャラクターの高さを低くする
        humanoid.CameraOffset = Vector3.new(0, -1, 0)
    else
        humanoid.WalkSpeed = isSprinting and SPRINT_SPEED or WALK_SPEED
        -- キャラクターの高さを元に戻す
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
    
    print("しゃがみ: " .. (isCrouching and "オン" or "オフ"))
end

-- キー入力の処理
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        -- Fキーでフラッシュライト切り替え
        toggleFlashlight()
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        -- 左Shiftキーでスプリント開始
        toggleSprint(true)
    elseif input.KeyCode == Enum.KeyCode.C then
        -- Cキーでしゃがみ切り替え
        toggleCrouch()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift then
        -- 左Shiftキーを離すとスプリント終了
        toggleSprint(false)
    end
end)

-- キャラクターが変わったときの処理
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- 初期設定
    humanoid.WalkSpeed = WALK_SPEED
    isSprinting = false
    isCrouching = false
    isFlashlightOn = false
    flashlight = nil
    
    -- フラッシュライトの再作成（自動的にオンになる）
    wait(1)
    createFlashlight()
    
    -- プレイヤーの位置を少し上げて、床に埋まらないようにする
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local currentPos = rootPart.Position
        rootPart.Position = Vector3.new(currentPos.X, currentPos.Y + 5, currentPos.Z)
    end
    
    -- プレイヤーの体力を最大に
    humanoid.Health = humanoid.MaxHealth
end)

-- 初期フラッシュライトの作成（ゲーム開始時）
wait(2) -- プレイヤーのロードを待機
createFlashlight()

print("PlayerController initialized")