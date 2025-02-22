local fn = {}
local LGF = exports["LEGACYCORE"]:GetCoreData()
local Jobs = require '@LGF_Society.modules.server.jobs'

function fn:GetPlayer(id)
    return LGF.DATA:GetPlayerDataBySlot(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    local charId = LGF.DATA:GetPlayerCharSlot(id)
    return ("%s:%s"):format(charId, player.identifier)
end


function fn:GetJob(id)
    local job = LGF.DATA:GetPlayerJobData(id)
    return {
        name = job.JobName,
        label = job.JobLabel,
        grade = job.JobGrade,
        gradeLabel = job.JobLabel
    }
end

function fn:SetJob(id, name, grade)
    Jobs:SetPlayerJob(id, name, grade)
    local job = self:GetJob(id)
    TriggerEvent("multijob:server:onJobChange", id, {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.gradeLabel
    })
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    
    return {
        name = player.playerName,
        lastname = "",
        group = LGF.DATA:GetPlayerGroup(id)
    }
end


return fn