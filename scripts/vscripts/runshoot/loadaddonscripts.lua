local playerActivate = nil
local runShootContext = {}
local spawnScript = function()
    -- print("SPAWN SCRIPT CALLED")
    SpawnEntityFromTableAsynchronous("logic_script", {
        targetname = "@runShootScript",
        vscripts = "runshoot/runshoot_global",

    },
    function(runShootScript)
        EntFireByHandle(runShootScript,runShootScript,"CallScriptFunction","Start",2)
        
    end, nil)

end
if IsServer() then
    -- print("LOAD ADDON SCRIPTS")

    -- ListenToGameEvent("player_activate",spawnScript, runShootContext)   
    -- ListenToPlayerEvent("vr_player_ready",spawnScript, runShootContext)
    ListenToPlayerEvent("player_activate",spawnScript, runShootContext)
end
