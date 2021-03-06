--[[
ConfigurationChangedData
Table with the following fields:
old_version :: string (optional): Old version of the map. Present only when loading map version other than the current version.
new_version :: string (optional): New version of the map. Present only when loading map version other than the current version.
mod_changes :: dictionary string → ModConfigurationChangedData: Dictionary of mod changes. It is indexed by mod name.
ModConfigurationChangedData
Table with the following fields:
old_version :: string: Old version of the mod. May be nil if the mod wasn't previously present (i.e. it was just added).
new_version :: string: New version of the mod. May be nil if the mod is no longer present (i.e. it was just removed).
--]]
local mod_name = MOD.name or "not-set"
local migrations = {"1.2.0", "1.2.3"}
local changes = {}

--Mark all migrations as complete during Init.
function changes.on_init(version)
    for _, migration in ipairs(migrations) do
        global._changes[migration] = version
    end
end

function changes.on_configuration_changed(event)
    changes["map-change-always-first"]()
    if event.data.mod_changes then
        changes["any-change-always-first"]()
        if event.data.mod_changes[mod_name] then
            local this_mod_changes = event.data.mod_changes[mod_name]
            changes.on_mod_changed(this_mod_changes)
            game.print(mod_name..": changed from ".. tostring(this_mod_changes.old_version) .. " to " .. tostring(this_mod_changes.new_version))
        end
        changes["any-change-always-last"]()
    end
    changes["map-change-always-last"]()
end

function changes.on_mod_changed(this_mod_changes)
    global._changes = global._changes or {}
    local old = this_mod_changes.old_version
    local migration_index = 1
    if old then -- Find the last installed version
        for i, ver in ipairs(migrations) do
            if old == ver and global._changes[ver] then
                --previous version found
                migration_index = i + 1
            end
        end
    end
    changes["mod-change-always-first"]()
    for i = migration_index, #migrations do
        if changes[migrations[i]] then
            changes[migrations[i]](this_mod_changes)
            global._changes[migrations[i]] = this_mod_changes.old_version or 0
            game.print(mod_name..": Migration complete for ".. migrations[i])
        end
    end
    changes["mod-change-always-last"]()
end

-------------------------------------------------------------------------------
--[[Always run these before any migrations]]
changes["map-change-always-first"] = function()
end

changes["any-change-always-first"] = function()
end

changes["mod-change-always-first"] = function()
end

-------------------------------------------------------------------------------
--[[Version change code make sure to include the version in
--migrations table above.]]--

--Major changes made
changes["1.2.0"] = function ()
    global.current_index = 1
    global.config = global.config or table.deepcopy(MOD.config.control)
    remote.call("nanobots", "reset_config")
end

--Minor changes to reformat the changes made table
changes["1.2.3"] = function ()
    for _, history in pairs({"1.2.2", "1.2.1", "1.2.0"}) do
        if global._changes[history] and type(global._changes[history]) == "table" and global._changes[history].from then
            global._changes[history] = global._changes[history].from
        end
    end
end

-------------------------------------------------------------------------------
--[[Always run these at the end ]]--

changes["mod-change-always-last"] = function()
end

changes["any-change-always-last"] = function()
end

changes["map-change-always-last"] = function()
end

-------------------------------------------------------------------------------
return changes
