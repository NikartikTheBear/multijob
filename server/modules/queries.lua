local Query = {}

function Query:init()
    local response = MySQL.query.await('SHOW TABLES LIKE "multijob"')
    if response and #response == 0 then
        MySQL.query.await('CREATE TABLE multijob (id VARCHAR(255) PRIMARY KEY, jobs VARCHAR(800)) ' , {})
    end
end

function Query:loadJobs(s)
    local id = FW:GetIdentifier(s)
    if not Jobs[s] then Jobs[s] = {} end
    local response = MySQL.query.await('SELECT `jobs` FROM `multijob` WHERE `id` = ?', {
        id
    })
    if response and #response == 0 then self:createPlayer(id) end
    if response  and #response == 1 then
        for i = 1, #response do
            local row = response[i]
            local jobs = json.decode(row.jobs) or {}   
            Jobs[s] = jobs
        end
    end
end


function Query:createPlayer(id)
    MySQL.insert.await('INSERT INTO `multijob` (id, jobs) VALUES (?, ?)', {
        id, json.encode({})
    })
end

function Query:saveJobs(s)
    print(s, type(s), json.encode(Jobs[s]),FW:GetIdentifier(s) )
    MySQL.update.await('UPDATE multijob SET jobs = ? WHERE id = ?', {
        json.encode(Jobs[s]), FW:GetIdentifier(s)
    })
end


return Query