FW = {}

local frameworks <const> = {"LEGACYCORE", "es_extended", "qb-core", "qbox", "nd_core", "ox_core"}

local path <const> = "bridge/framework/"

--credits to Andy for the original bridge loading
local function getFw()
    for i =1, #frameworks do
        local f = frameworks[i]
        if GetResourceState(f):find("start") or GetResourceState(f):find("started") then
            print("Framework Found: "..f)
            return (path.."%s/%s"):format(lib.context, f)
        end
    end
    return (path.."%s/%s"):format(lib.context, "custom")
end

local dir = getFw()
FW = lib.load(dir)
