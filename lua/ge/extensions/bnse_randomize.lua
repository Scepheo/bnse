local randomize = {}

local function addModule(name)
	local newModule = require(name)
	
	for k, v in pairs(newModule) do
		randomize[k] = v
	end
end

addModule('bnse_randomize_vehicle')

return {
	randomize = randomize
}