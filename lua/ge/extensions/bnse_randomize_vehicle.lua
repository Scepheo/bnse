----------------------------------------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------------------------------------

-- Default car types
local defaultCarTypes = { "Car", "Truck" }


----------------------------------------------------------------------------------------------------
-- Randomize vehicle
----------------------------------------------------------------------------------------------------

local function randomizeVehicle(name, validCarTypes)
	local configList = vehicles.getConfigList().configs
	validCarTypes = validCarTypes or defaultCarTypes
	
	local config
	local valid = false
	
	while not valid do
		config = configList[tableChooseRandomKey(configList)]
		
		for _, validType in pairs(validCarTypes) do
			if config.aggregates.Type[validType] then
				valid = true
			end
		end
	end
		
	local selectedVehicle = config.Name or 'Unknown'
	log('I', 'bnse.randomize.vehicle', string.format('Selected %s', selectedVehicle))
	
	local jbeam = config.model_key
	local partConfig = string.format('vehicles/%s/%s.pc', jbeam, config.key)
	local color = config.default_color or 'TransparentWhite'
	
	TorqueScript.eval([[
		]]..name..[[.JBeam = "]] .. jbeam .. [[";
		]]..name..[[.partConfig = "]] .. partConfig .. [[";
		]]..name..[[.color = "]] .. color .. [[";
		]]..name..[[.requestReload();
	]])
end


----------------------------------------------------------------------------------------------------
-- Interface
----------------------------------------------------------------------------------------------------

return {
	vehicle = randomizeVehicle
}