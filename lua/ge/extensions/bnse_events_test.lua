local function onVehicleSpawn(id)
	log('I', 'bnse_events_test', 'onVehicleSpawn, id=' .. id)
end

local function onVehicleDespawn(id)
	log('I', 'bnse_events_test', 'onVehicleDespawn, id=' .. id)
end

local function onVehicleReset(id)
	log('I', 'bnse_events_test', 'onVehicleReset, id=' .. id)
end

local function onVehicleDamage(id, damage)
	log('I', 'bnse_events_test', 'onVehicleDamage, id=' .. id .. ', damage=' .. damage)
end

local function onVehicleCollision(left, right)
	log('I', 'bnse_events_test', 'onVehicleCollision, left=' .. left .. ', right=' .. right)
end

return {
	onVehicleSpawn = onVehicleSpawn,
	onVehicleDespawn = onVehicleDespawn,
	onVehicleReset = onVehicleReset,
	onVehicleDamage = onVehicleDamage,
	onVehicleCollision = onVehicleCollision
}