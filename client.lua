local lastActionTime = GetGameTimer()
local lastPos = nil
local warned = false

-- Liste de contrôles à surveiller
local controlsToCheck = {
    22, -- sprint
    32, 33, 34, 35, -- Z Q S D
    24, 25, -- tir, vise
    22, -- jump / sprint selon contexte
    51, -- interaction (E)
    47, 38, -- enter vehicle / action
    75, -- exit vehicle
}

local function playerUsedControl()
    for _, control in ipairs(controlsToCheck) do
        if IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control) or IsControlPressed(0, control) then
            return true
        end
    end
    if IsPlayerFreeAiming(PlayerId()) or IsControlPressed(0, 24) or IsControlPressed(0, 25) then
        return true
    end
    return false
end

local function playerMoved()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return false end
    local pos = GetEntityCoords(ped)
    if not lastPos then
        lastPos = pos
        return true
    end
    local dx = pos.x - lastPos.x
    local dy = pos.y - lastPos.y
    local dz = pos.z - lastPos.z
    local dist2 = dx*dx + dy*dy + dz*dz
    if dist2 >= (AFK.minMoveDistance * AFK.minMoveDistance) then
        lastPos = pos
        return true
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Wait(100)
        local used = playerUsedControl()
        local moved = playerMoved()

        if used or moved then
            lastActionTime = GetGameTimer()
            if warned then
                -- Annule le warning si le joueur bouge après avertissement
                warned = false
                -- On peut aussi notifier le serveur si on veut
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(AFK and AFK.checkInterval or 5000)
        local now = GetGameTimer()
        local inactiveSeconds = (now - lastActionTime) / 1000
        local skip = false
        local playerName = GetPlayerName(PlayerId())
        local warnTime = AFK.warnTime or 300
        local kickTime = AFK.kickTime or 360

        if inactiveSeconds >= warnTime and inactiveSeconds < kickTime then
            if not warned then
                warned = true
                local remaining = math.floor(kickTime - inactiveSeconds)
                TriggerEvent('chat:addMessage', { args = { '^1[Anti-AFK]^0', string.format(AFK and AFK.warningMessage or 'Vous allez être kick pour AFK dans %s secondes.', remaining) } })
            end
        elseif inactiveSeconds >= kickTime then
            TriggerServerEvent('pso_antiafk::serverRequestKick')
            warned = true
        end
    end
end)
