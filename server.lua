RegisterNetEvent('pso_antiafk::serverRequestKick')
AddEventHandler('pso_antiafk::serverRequestKick', function()
    local src = source
    -- check whitelist si configurée
    local identifiers = GetPlayerIdentifiers(src)
    local isWhitelisted = false
    for _, id in ipairs(identifiers) do
        for _, w in ipairs(AFK.whitelist) do
            if id == w then
                isWhitelisted = true
                break
            end
        end
        if isWhitelisted then break end
    end

    if isWhitelisted then
        -- Optionnel: log
        print(("antiAfk: joueur %s (%s) est whitelist, pas de kick"):format(GetPlayerName(src), identifiers[1] or "unknown"))
        return
    end

    -- Kick le joueur
    DropPlayer(src, AFK.kickReason or "AFK")
end)
