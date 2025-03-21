-- SanitySystem.lua
local SanitySystem = {}
SanitySystem.CurrentValue = 100
SanitySystem.EffectsEnabled = true

-- SAN値減少関数
function SanitySystem:DecreaseSanity(amount, player)
    self.CurrentValue = math.max(0, self.CurrentValue - amount)
    
    -- SAN値に応じた効果適用
    if self.CurrentValue < 75 and self.CurrentValue >= 50 then
        self:ApplyLowSanityEffects(player, 1) -- 軽度の効果
    elseif self.CurrentValue < 50 and self.CurrentValue >= 25 then
        self:ApplyLowSanityEffects(player, 2) -- 中度の効果
    elseif self.CurrentValue < 25 then
        self:ApplyLowSanityEffects(player, 3) -- 重度の効果
    end
end

-- 効果適用関数
function SanitySystem:ApplyLowSanityEffects(player, level)
    -- レベルに応じた視覚・聴覚効果の適用
    local gui = player.PlayerGui:FindFirstChild("SanityEffectGui")
    if gui then
        -- 視界の狭窄、色調変化などの効果
        gui.Frame.Transparency = 1 - (level * 0.2)
        -- 幻覚の表示頻度調整
        gui.HallucinationChance = level * 0.1
    end
    
    -- 幻聴の再生
    if math.random() < (level * 0.15) then
        -- ランダムな恐怖音声の再生
        self:PlayRandomScarySound(player)
    end
end

-- 幻聴再生関数（実装例）
function SanitySystem:PlayRandomScarySound(player)
    -- 恐怖音声のIDリスト
    local scarySounds = {
        "rbxassetid://1234567", -- 実際のサウンドIDに置き換えてください
        "rbxassetid://2345678",
        "rbxassetid://3456789"
    }
    
    -- ランダムな音声を選択
    local randomSound = scarySounds[math.random(1, #scarySounds)]
    
    -- 音声を再生
    local sound = Instance.new("Sound")
    sound.SoundId = randomSound
    sound.Volume = 0.5
    sound.Parent = player.Character.Head
    sound:Play()
    
    -- 再生後に削除
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

return SanitySystem