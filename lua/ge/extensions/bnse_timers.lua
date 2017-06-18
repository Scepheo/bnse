----------------------------------------------------------------------------------------------------
-- bnse_timers.lua
-- Component that allows easy creation and usage of timers.
----------------------------------------------------------------------------------------------------

-- List of all currently active timers
local timers = {}


-- Local code
----------------------------------------------------------------------------------------------------

local bnse_timer = {}
bnse_timer.__index = bnse_timer

function bnse_timer:stop()
	if (timers[self.id]) then
		timers[self.id] = nil
		self.onStop()
	end
end

function bnse_timer:start()
	timers[self.id] = self
	self.onStart()
end

function bnse_timer:restart()
	self.currentTime = self.time
	self:start()
end


-- Global code
----------------------------------------------------------------------------------------------------

local currentId = 0

local function noop()
end

local function create(time, events)
	local newTimer = {
		time = time,
		currentTime = time,
		onStart = events.onStart or noop,
		onEnd = events.onEnd or noop,
		onUpdate = events.onUpdate or noop,
		onStop = events.onCancel or noop,
		id = currentId
	}
	
	currentId = currentId + 1
	
	setmetatable(newTimer, bnse_timer)
	
	return newTimer
end

local function update(dt)
	for id, timer in pairs(timers) do
		timer.currentTime = timer.currentTime - dt
		
		if timer.currentTime <= 0 then
			timer.onEnd()
			timers[id] = nil
		else
			timer.onUpdate(dt)
		end
	end
end


-- Interface
----------------------------------------------------------------------------------------------------

return {
	timers = {
		create = create,
		update = update
	}
}
