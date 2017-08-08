# Randomize

Module containing functionality for randomizing certain aspect of the game

```Lua
bnse.randomize.vehicle(vehicle, [types])
```

- `vehicle` name or id of the vehicle to randomize
- `types` (optional) the types of vehicles that the function is allowed to select. Default value is `{ "Car", "Truck" }`

Replaces the given vehicle with a randomly selected new vehicle, and returns the selected configuration.
