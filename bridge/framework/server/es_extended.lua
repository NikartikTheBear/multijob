local fn = {}
local ESX = exports.es_extended:getSharedObject()
local config = lib.load("shared/config")
local fn = lib.load("server/functions")

function fn:GetPlayer(id)
    return ESX.GetPlayerFromId(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player.identifier
end


function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local job = player.job
    return {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    if ESX.DoesJobExist(name, grade) then
        player.setJob(name, grade)
    else
        return print("Job not found!")
    end
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    return {
        name = player.get("firstName"),
        lastname = player.get("lastName"),
        group = player.group
    }
end

AddEventHandler('esx:playerLoaded', function(player, xPlayer, isNew)
    TriggerEvent("multijob:server:playerLoaded", player)
end)


AddEventHandler('esx:setJob', function(player, job, lastJob)
    local player = tostring(player)
    local jobs = Jobs?[player]
    if (fn:countJobs(Jobs[player]) >= config.maxJobs) and not jobs[job.name] then fn:SetJob(player, lastJob.name, lastJob.grade) return end
    TriggerEvent("multijob:server:onJobChange", player, {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label
    }, lastJob)
end)


return fn