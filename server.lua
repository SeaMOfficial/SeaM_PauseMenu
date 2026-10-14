RegisterNetEvent('SeaM_PauseMenu:requestPopulation', function()
    local sourceId = source
    TriggerClientEvent('SeaM_PauseMenu:population', sourceId, #GetPlayers(), GetConvarInt('sv_maxclients', 48))
end)
