local icons = {
    ["police"] = "fa-star",
    ["ambulance"] = "fa-ambulance",
    ["mechanic"] = "fa-wrench",
    ["unemployed"] = "fa-user",
    ["cardealer"] = "fa-car"
}


local function createJobMenu()
    local jobs, currJob = lib.callback.await("multijob:server:getJobs", false)
    local options = {}

    for k, v in pairs(jobs) do
        options[#options+1] = {
            title = ("%s %s"):format(v.label, (currJob == k and "(Active)" or "") ),
            description = ("Grade: %s - %s"):format(v.grade, v.gradeLabel),
            icon = icons[k],
            disabled = currJob == k,
            event = "multijob:client:sendJobData",
            args = {name =k},
            arrow = true,
            -- menu = 'select_job'
        }
    end
    if not next(jobs) then
        options[1] = {
            title = "No Jobs",
            icon = "fa-cross",
            disabled = true,
        }
    end
    
    lib.registerContext({
        id = "job_menu",
        title = "Multijob",
        options = options,
    })
    lib.showContext("job_menu")
end


AddEventHandler("multijob:client:sendJobData", function(job)
    lib.registerContext({
        id = 'select_job',
        title = 'Job action',
        menu = 'job_menu',
        onBack = function()
        end,
        options = {
          {
            title = 'Select Job',
            icon = "check",
            onSelect = function()
                TriggerServerEvent("multijob:server:setJob", job.name)
                lib.notify({description = "You switched job!"})
            end
          },
          {
            title = 'Resign job',
            icon = "xmark",
            onSelect = function()
                if job.name == "unemployed" then lib.notify({description = "You cannot resign this job!"}) return end
                TriggerServerEvent("multijob:server:removeJob", {id = cache.serverId, job = job.name})
                lib.notify({description = "You resigned job!"})
            end
          }
        }
      })
      lib.showContext('select_job')
end)




RegisterCommand("jobm", function()
    createJobMenu()
end)