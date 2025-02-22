local function createAdminMenu()
    if GetInvokingResource() then return end
    local data = lib.callback.await("multijob:server:getPlayersJobs", false)
    local options = {}
    for i = 1, #data do
        local player = data[i]
        options[#options+1] = {
            title = player.name,
            description = player.playerName.." ID: "..player.id,
            onSelect = function()
                TriggerServerEvent("multijob:server:getPlayerInfo", player.id)
            end,
        }
    end
    lib.registerContext({
        id = "player_joblist",
        title = "Players",
        options = options
    }) 
    lib.showContext("player_joblist")
end

RegisterNetEvent("multijob:client:buildPlayersMenu", createAdminMenu)

RegisterNetEvent("multijob:client:buildPlayerMenu", function(data)
    if GetInvokingResource() then return end
    lib.registerContext( data) 
    lib.showContext("player_jobmenu")
end)
