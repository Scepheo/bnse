----------------------------------------------------------------------------------------------------
-- resettable_load.lua
-- Replaces the default scenarios Lua with the bnse resettable_scenarios Lua.
----------------------------------------------------------------------------------------------------


-- Unload the original scenarios module.
extensions.unloadModule('scenarios')

-- Load the custom scenarios module
extensions.loadModule('scenario/resettable_scenarios')

-- Make the global 'scenarios' variable point to our custom module, to prevent other scripts from
-- breaking.
_G.scenarios = _G.resettable_scenarios
