local fn = {}
local nd = require "@ND_Core/init"
local config = lib.load("shared/config")

function fn:GetPlayer(id)
    return nd.getPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player.identifier
end


function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local name, job = player.getJob()
    return {
        name = job.name,
        label = job.label,
        grade = job.rank,
        gradeLabel = job.rankName
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    player.setJob(name, grade)
    local name, job = player.getJob()
    TriggerEvent("multijob:server:onJobChange", id, {
        name = job.name,
        label = job.label,
        grade = job.rank,
        gradeLabel = job.rankName
    })
end


function fn:GetData(id)
    local player = self:GetPlayer(id)
    local perms = config.allowedGroups
    local group
    for key, value in pairs(perms) do
        if player.getGroup(key) then
            group = key
        end
    end
    return {
        name = player.firstname,
        lastname = player.lastname,
        group = group or "user"
    }
end



return fn