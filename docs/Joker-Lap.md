# Joker Lap

Scenario extension that adds a joker lap to a race. To use it, add the `joker_lap` extension to your scenario and manually add the `race` extension (as setting the scenario extensions means its default status is overridden):

```json
"extensions": [ "race", "joker_lap" ],
```

To configure the extension, set the following properties too:

* `jokerLapConfig` This is an array of the joker lap waypoints, these will be marked green.
* `jokerWaypointBefore` The last red (regular) waypoint *before* the joker lap, i.e. where the paths split. This should also appear in `lapConfig`.
* `jokerWaypointAfter` The first red (regular) waypoint *after* the joker lap, i.e. where the paths join again. This should also appear in `lapConfig`.

## Example

After configuring your scenario json, it can contain something like this (including `lapConfig` and `lapCount` for clarity):

```json
"lapConfig":
[
    "wp_race_1",
    "wp_race_2",
    "wp_race_3",
    "wp_race_4",
    "wp_race_5",
    "wp_race_6",
    "wp_race_7",
    "wp_race_8",
    "wp_race_9",
    "wp_race_10",
],
"lapCount": 2,
"jokerLapConfig":
[
    "wp_joker_1",
    "wp_joker_2",
    "wp_joker_3",
    "wp_joker_4",
    "wp_joker_5",
    "wp_joker_6",
    "wp_joker_7",
],
"jokerWaypointBefore": "wp_race_2",
"jokerWaypointAfter": "wp_race_7",
"extensions": [ "race", "joker_lap" ],
```
