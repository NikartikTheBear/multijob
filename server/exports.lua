local config = lib.load("shared/config")

local function removeJob(source, id, job)
    local id = tostring(id)
    if source and id ~= tostring(source) then 
        local can = FW:GetData(source).group 
        if config.allowedGroups[can] then
            
            if Jobs?[id]?[job] then
                FW:SetJob(id, "unemployed", 0)
                Jobs[id][job] = nil
                return
            end
        end
    end
    if Jobs?[id]?[job] then
        FW:SetJob(id, "unemployed", 0)
        Jobs[id][job] = nil
    end
end

local function getJob(source, id)
    local id = tostring(id) 
    if source and id ~= tostring(source) then 
        local can = FW:GetData(source).group 
        if config.allowedGroups[can] then
            return Jobs[id]
        end
    end
    return Jobs[id]
end

local function hasJob(source, id, name, grade)
    local id = tostring(id) 
    local job = Jobs?[id]
    if source and id ~= tostring(source) then 
        local can = FW:GetData(source).group 
        if config.allowedGroups[can] then       
            if job then
                for k, v in pairs(job) do
                    if k == name then
                        if grade then
                            return k == name, grade == v.grade
                        end
                        return k == name, false
                    end
                end
                return false, false
            end
            return false, false
        end
    end
    if job then
        for k, v in pairs(job) do
            if k == name then
                if grade then
                    return k == name, grade == v.grade
                end
                return k == name, false
            end
        end
        return false, false
    end
end


RegisterNetEvent("multijob:server:removeJob", function(args)
    local source = source
    removeJob(source, args.id, args.job)
    if source ~= args.id then
        TriggerClientEvent('ox_lib:notify', source, {description = "You removed the job from the player!"})
    end
end)


RegisterNetEvent("multijob:server:getPlayerInfo", function(id)
    local source = source
    local jobData = getJob(source, id)
    local options = {}
    for k, v in pairs(jobData) do
        options[#options+1] = {
            title = v.label,
            description = ("Grade: %s - %s"):format(v.grade, v.gradeLabel),
            icon = "xmark",
            serverEvent = "multijob:server:removeJob",
            args = {
                id = id,
                job = k
            }
        }
    end
    TriggerClientEvent("multijob:client:buildPlayerMenu", source, {
        id = "player_jobmenu",
        title = GetPlayerName(id),
        options = options
    })
end)


exports("removeJob", removeJob)
exports("getJobs", getJob)
exports("hasJob", hasJob)