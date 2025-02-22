local fn = {}
local ox = require "@ox_core/lib/init"
local config = lib.load("shared/config")

function fn:GetPlayer(id)
    return ox:GetPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player.charId
end

function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local jobName = player.get('activeGroup')
    local jobGrade = player.getGroup(jobName)
    return {
        name = jobName,
        label = jobName,
        grade = jobGrade,
        gradeLabel = jobGrade
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    player.setGroup(name, grade)

    local jobName = player.get('activeGroup')
    local jobGrade = player.getGroup(jobName)
    TriggerEvent("multijob:server:onJobChange", id, {
        name = jobName,
        label = jobName,
        grade = jobGrade,
        gradeLabel = jobGrade
    })

end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    local perms = config.allowedGroups
    local group
    for key, value in pairs(perms) do
        if IsPlayerAceAllowed(id, value) then
            group = key
        end
    end
    return {
        name = GetPlayerName(id),
        lastname = "",
        group = group or "user"
    }
end



return fn