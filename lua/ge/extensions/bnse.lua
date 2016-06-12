----------------------------------------------------------------------------------------------------
-- bnse.lua
-- This is the main ge module. It both loads all other modules and exposes bnse's features.
----------------------------------------------------------------------------------------------------


-- Load event modules
----------------------------------------------------------------------------------------------------
extensions.loadModule('bnse_events_collision')
extensions.loadModule('bnse_events_physics')
extensions.loadModule('bnse_events_tick')

-- Logging of events for debugging purposes
-- extensions.loadModule('bnse_events_test')


-- Main module
----------------------------------------------------------------------------------------------------
local main = {}

local function loadComponent(name)
	local newModule = require(name)
	
	for k, v in pairs(newModule) do
		main[k] = v
	end
end

loadComponent('bnse_randomize')
loadComponent('bnse_timers')
loadComponent('bnse_triggers')

main.onPreRender = function(dt)
	main.timers.update(dt)
	main.triggers.update(dt)
end

return main