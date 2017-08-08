# Resettable Scenarios

bnse adds functionality for scenarios that allow resetting. To use this, include the following setting in the scenario json:

```json
"managedRestart": true
```

This removes the default reset behavior of scenarios, allowing other Lua scripts to handle the events that happen when the player resets or reloads the vehicle. This effectively "enables" all resettable scenarios extensions, and its inclusion is required to ensure that other scenarios (that do not include it) remain unaffected by the resettable changes.

In addition, the following scenario extensions are available (include in the `extensions` setting):

* `resettable_race` Replacement for the default-added `race` extension: doesn't change any functionality, but ensures that waypoint trigger state is maintained when the vehicle is reset.
* `resettable_checkpoints` Extension that allows the player to respawn at the last checkpoint they triggered.

`resettable_checkpoints` uses the "reload vehicle" command to restart the scenario. This command is normally disabled in scenario, so if you're using `resettable_checkpoints`, enable it by adding this to your scenario json:

```json
"whiteListActions": [ "reload_vehicle" ]
```

In short, to create a simple functional checkpoint scenario, include the following in the scenario json:

```json
"managedRestart": true,
"extensions": ["resettable_checkpoints", "resettable_race"],
"whiteListActions": [ "reload_vehicle" ]
```
