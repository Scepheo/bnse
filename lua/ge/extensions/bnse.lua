-- Load events
extensions.loadModule('bnse_events_collision')
extensions.loadModule('bnse_events_physics')
extensions.loadModule('bnse_events_tick')
extensions.loadModule('bnse_events_test')

-- Main module
local main = {}

local function addModule(name)
	local newModule = require(name)
	
	for k, v in pairs(newModule) do
		main[k] = v
	end
end

addModule('bnse_randomize')
addModule('bnse_timers')
addModule('bnse_triggers')

main.onPreRender = function(dt)
	main.timers.update(dt)
	main.triggers.update(dt)
end

return main