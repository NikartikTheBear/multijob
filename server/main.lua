
local Query = require "server/modules/queries"
local config = lib.load("shared/config")
local fn = lib.load("server/functions")
Jobs = {}


lib.callback.register("multijob:server:getJobs", function(source)
    local source = tostring(source)
    return (Jobs[source] or {}), FW:GetJob(source).name
end)




RegisterNetEvent("multijob:server:setJob", function(name)
    local source = tostring(source)
    local jobs = Jobs?[source]
    if jobs?[name] then
        FW:SetJob(source, name, jobs[name].grade)
    end
end)


AddEventHandler("multijob:server:onJobChange", function(source, job, lastJob)
    local source = tostring(source)
    local jobs = Jobs[source] or {}
    if jobs[job.name] and jobs?[job.name].grade == job.grade then return end
    jobs[job.name] = {
        label = job.label,
        grade = job.grade,
        gradeLabel = job.gradeLabel
    }
    Jobs[source] = jobs
end)

lib.callback.register("multijob:server:getPlayersJobs", function(source)
    local data = {}
    for _, id in pairs(GetPlayers()) do
        local info = FW:GetData(id)
        id = tostring(id)
        data[#data+1] = {
            id = id,
            name = info.name.." "..info.lastname,
            playerName = GetPlayerName(id)
        }
    end
    return data
end)

RegisterCommand("playerjobs", function(s)
    local can = FW:GetData(s).group 
    if config.allowedGroups[can] then
        TriggerClientEvent("multijob:client:buildPlayersMenu", s)
    end
end, false)

AddEventHandler("multijob:server:playerLoaded", function(id)
    local source = tostring(id)
    Query:loadJobs(source)
end)

AddEventHandler("playerDropped", function()
    local source = tostring(source)
    Query:saveJobs(source)
end)

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        for _, id in pairs(GetPlayers()) do
            id = tostring(id)
            Query:saveJobs(id)
        end
    end
end)

--fallback
CreateThread(function()
    if GetResourceState(GetCurrentResourceName()) == "started" then
        Wait(100)
        Query:init()
        for _, id in pairs(GetPlayers()) do
            id = tostring(id)
            Query:loadJobs(id)
        end
    end
end)