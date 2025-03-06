local fn = {}
local QB = exports["qb-core"]

function fn:GetPlayer(id)
    return QB:GetPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player.PlayerData.citizenid
end


function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local job = player.PlayerData.job
    return {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        gradeLabel = job.grade.name
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    player.Functions.SetJob(name, grade)
end


function fn:GetData(id)
    local player = self:GetPlayer(id)
    local permissions = QB:GetPermission(id)
    local group
    for key, value in pairs(permissions) do
        if value == true then
            group = key
        end
    end
    return {
        name = player.PlayerData.firstname,
        lastname = player.PlayerData.lastname,
        group = group
    }
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(pObj)
    TriggerEvent("multijob:server:playerLoaded", pObj.PlayerData.source)
end)

AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
    TriggerEvent("multijob:server:onJobChange", source, {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade.name
    })
end)

return fn