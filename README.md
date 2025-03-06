# multijob
Simple and lightweight multijob script for fivem built with ox-lib

### Update
- fixed jobs not saving
- added max number of jobs

## Exports

```lua
-- if you are using the export for a script check just put the source the same as the player id

-- source: id of the player calling the export
-- id: id of the playerthat you want the job removed from
-- job: job name to remove
exports.multijob:removeJob(source, id, job)

-- source: id of the player calling the export
-- id: id of the player that you want to check
-- returns: table with player jobs
exports.multijob:getJobs(source, id)

-- source: id of the player calling the export
-- id: id of the player that you want to check
-- name: name of the job
-- grade?: grade to check
-- returns: bool name bool grade
exports.multijob:hasJob(source, id, name, grade)
```
