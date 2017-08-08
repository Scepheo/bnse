# Game Engine Events

```Lua
onVehicleSpawn(id)
```

- `id` Physics id of the spawned vehicle

```Lua
onVehicleDespawn(id)
```

- `id` Physics id of the despawned vehicle

Triggered when a vehicle is despawned.

```Lua
onVehicleReset(id)
```

- `id` Physics id of the reset vehicle

Triggered when a vehicle is reset.

```Lua
onVehicleDamage(id, damage)
```

- `id` Physics id of the damaged vehicle
- `damage` Total amount of damage the vehicle has after the event

Triggered when a vehicle takes damage.

```Lua
onVehicleCollision(left, right)
```

- `left` Physics id of one of the vehicles in the collision
- `right` Physics id of the other vehicle in the collision

Triggered when two vehicles collide. Which vehicle will be passed as left or right is random, but this event will only be triggered once. So when vehicle *1* and *2* collide, you will get *either* `onVehicleCollision(1, 2)` *or* `onVehicleCollision(2, 1)`, but not both.

```Lua
onTick(dt)
```

- `dt` Time since last tick (tick length)

A generic (not bound to being in a scenario and the race.lua extension being loaded) version of `onRaceTick`. Has a somewhat higher resolution, but can be used to minimise the performance impact of continuously updating modules.
