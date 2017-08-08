----------------------------------------------------------------------------------------------------
-- bnse_events_tick.lua
-- Exposes a generic (instead of race-bound) onTick event.
----------------------------------------------------------------------------------------------------


-- Configuration
----------------------------------------------------------------------------------------------------

-- Length of a tick
local tickLimit = 0.1


-- Code
----------------------------------------------------------------------------------------------------

local currentTick = 0

local function onPreRender(dt)
	currentTick = currentTick + dt
	
	if currentTick > tickLimit then
		currentTick = currentTick - tickLimit
		extensions.hook('onTick', tickLimit)
	end
end


-- Interface
----------------------------------------------------------------------------------------------------

return {
	onPreRender = onPreRender
}
