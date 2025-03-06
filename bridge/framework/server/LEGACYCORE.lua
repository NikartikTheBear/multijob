local fn = {}
local LGF = exports["LEGACYCORE"]:GetCoreData()
local LgfJobs = require '@LGF_Society.modules.server.jobs'
local config = lib.load("shared/config")
local fn = lib.load("server/functions")

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
    LgfJobs:SetPlayerJob(id, name, grade)
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    
    return {
        name = player.playerName,
        lastname = "",
        group = LGF.DATA:GetPlayerGroup(id)
    }
end

AddEventHandler('LegacyCore:changeJob', function(id, jobName, jobGrade, currJob)
    local player = tostring(id)
    local jobs = Jobs?[player]
    if (fn:countJobs(Jobs[player]) >= config.maxJobs) and not jobs[jobName] then fn:SetJob(player, currJob.JobName, currJob.JobGrade) return end
    TriggerEvent("multijob:server:onJobChange", player, {
        name = jobName,
        label = jobName,
        grade = jobGrade,
        gradeLabel = jobGrade
    })
end)

    AddEventHandler('LegacyCore:PlayerLoaded', function(slot, playerdata, new)
        TriggerEvent("multijob:server:playerLoaded", playerdata.id)
        end)

return fn