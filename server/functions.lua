local fn = {}

function fn:keytoindex (table)
    local nt = {}
    for k, v in pairs(table) do
        nt[#nt+1] = k
    end
    return nt
end

function fn:countJobs(jobs)
    return #self:keytoindex(jobs)
end

return fn