local ClickFrame = CreateFrame("Frame")
ClickFrame:RegisterEvent("GLOBAL_MOUSE_DOWN")

function formatCooldown(spellID)
    local status = ""
    local remainingCooldown = C_Spell.GetSpellCooldownDuration(spellID):GetRemainingDuration(0)
    if (remainingCooldown == 0) then
        status = "Ready"
    elseif (remainingCooldown >= 60) then
        local remainingMinutes = math.floor(remainingCooldown / 60)
        local remainingSeconds = remainingCooldown % 60
        status = string.format("%dm %ds", remainingMinutes, remainingSeconds)
    else
        status = string.format("%ds", remainingCooldown)
    end
    return status
end

function formatCharges(spellID)
    local status = ""
    local currentCharges = C_Spell.GetSpellCharges(spellID).currentCharges
    local maxCharges = C_Spell.GetSpellCharges(spellID).maxCharges
    local remainingCharge = C_Spell.GetSpellChargeDuration(spellID):GetRemainingDuration(0)
    if (remainingCharge == 0) then
        status = string.format("Ready (%d/%d)", currentCharges, maxCharges)
    elseif (remainingCharge >= 60) then
        local remainingMinutes = math.floor(remainingCharge / 60)
        local remainingSeconds = remainingCharge % 60
        status = string.format("%dm %ds", remainingMinutes, remainingSeconds)
    else
        status = string.format("%ds (%d/%d)", remainingCharge, currentCharges, maxCharges)
    end
    return status
end

function pingCooldown()
    if IsAltKeyDown() then
        local spellName, spellID = GameTooltip:GetSpell()
        if (spellName ~= nil and spellID ~= nil) then
            local charges = C_Spell.GetSpellCharges(spellID)
            if (charges ~= nil) then
                -- print(spellName, "has charges")
                local msg = string.format("%s - %s", spellName, formatCharges(spellID))
                SendChatMessage(msg, "SAY")
                -- print(msg)
            else
                local msg = string.format("%s - %s", spellName, formatCooldown(spellID))
                SendChatMessage(msg, "SAY")
                -- print(msg)
            end 
        end
    end
end

ClickFrame:SetScript("OnEvent", pingCooldown)