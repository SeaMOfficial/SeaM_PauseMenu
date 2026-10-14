local isOpen = false
local population = 0
local slots = 0
local joinedAt = GetGameTimer()
local nativeMenuPendingUntil = 0

local function reportAvailable()
    if type(Config.ReportCommand) ~= 'string' or not Config.ReportCommand:match('^[%w_%-]+$') then
        return false
    end
    local resource = Config.ReportResource
    return type(resource) ~= 'string' or resource == '' or GetResourceState(resource) == 'started'
end

local function safeLinks()
    local links = {}
    for _, entry in ipairs(Config.Links or {}) do
        if type(entry) == 'table' and type(entry.url) == 'string'
            and entry.url:match('^https://[%w%p]+$')
            and not entry.url:find('[%s<>"\']') then
            links[#links + 1] = {
                label = tostring(entry.label or 'Visit link'),
                description = tostring(entry.description or 'Open in browser'),
                icon = tostring(entry.icon or 'link'),
                url = entry.url
            }
        end
    end
    return links
end

local function snapshot()
    local player = PlayerId()
    return {
        playerName = GetPlayerName(player) or 'Sailor',
        serverId = GetPlayerServerId(player),
        population = population,
        slots = slots,
        ping = GetPlayerPing(player),
        hours = GetClockHours(),
        minutes = GetClockMinutes(),
        sessionMinutes = math.floor((GetGameTimer() - joinedAt) / 60000)
    }
end

local function closeMenu()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    if Config.BlurBackground then TriggerScreenblurFadeOut(180) end
    SendNUIMessage({ type = 'close' })
end

local function openMenu()
    if isOpen or IsPauseMenuActive() or IsNuiFocused() or GetGameTimer() < nativeMenuPendingUntil then return end
    isOpen = true
    TriggerServerEvent('SeaM_PauseMenu:requestPopulation')
    if Config.BlurBackground then TriggerScreenblurFadeIn(180) end
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({
        type = 'open',
        data = snapshot(),
        config = {
            brand = Config.Brand,
            serverName = Config.ServerName,
            tagline = Config.Tagline,
            links = safeLinks(),
            hasReport = reportAvailable()
        }
    })
end

-- GTA uses 199 (P / controller Start) and 200 (ESC) for the pause frontend.
-- Leave other NUI resources and the native frontend in control of their own keys.
CreateThread(function()
    while true do
        if isOpen or IsNuiFocused() or IsPauseMenuActive() or GetGameTimer() < nativeMenuPendingUntil then
            Wait(100)
        else
            Wait(0)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            if IsDisabledControlJustPressed(0, 199) or IsDisabledControlJustPressed(0, 200) then
                openMenu()
            end
        end
    end
end)

RegisterNetEvent('SeaM_PauseMenu:population', function(count, maximum)
    population = tonumber(count) or 0
    slots = tonumber(maximum) or 0
    if isOpen then SendNUIMessage({ type = 'stats', data = snapshot() }) end
end)

CreateThread(function()
    local refresh = 0
    while true do
        Wait(1000)
        if isOpen then
            refresh = refresh + 1
            SendNUIMessage({ type = 'stats', data = snapshot() })
            if refresh >= 15 then
                refresh = 0
                TriggerServerEvent('SeaM_PauseMenu:requestPopulation')
            end
        else
            refresh = 0
        end
    end
end)

RegisterNUICallback('action', function(data, cb)
    local action = type(data) == 'table' and data.action or nil
    if not isOpen then cb({ ok = false }); return end

    if action == 'close' then
        closeMenu()
        cb({ ok = true })
    elseif action == 'map' or action == 'settings' then
        closeMenu()
        nativeMenuPendingUntil = GetGameTimer() + 1200
        cb({ ok = true })
        CreateThread(function()
            Wait(100)
            ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), false, -1)
            local deadline = GetGameTimer() + 1200
            while not IsPauseMenuActive() and GetGameTimer() < deadline do Wait(0) end
            if IsPauseMenuActive() then PauseMenuceptionGoDeeper(action == 'map' and 0 or 6) end
        end)
    elseif action == 'report' and reportAvailable() then
        closeMenu()
        cb({ ok = true })
        CreateThread(function()
            Wait(100)
            ExecuteCommand(Config.ReportCommand)
        end)
    elseif action == 'disconnect' then
        closeMenu()
        cb({ ok = true })
        CreateThread(function()
            Wait(100)
            ExecuteCommand('disconnect')
        end)
    else
        cb({ ok = false })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if isOpen then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        if Config.BlurBackground then TriggerScreenblurFadeOut(0) end
    end
end)
