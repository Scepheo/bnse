# Triggers

Exposes a trigger interface that makes it easy to call functions based on the distance between objects.

## Module interface

```lua
bnse.triggers.create(to, from, distance, events)
```

- `to` the first object that defines the trigger
- `from` the second object that defines the trigger
- `distance` the distance (in meters) at which the trigger will call callbacks
- `events` object containing the trigger events

Returns a trigger object (see below for how to use it) and enables it. It will instantly call one of the callbacks, depending on the distance between the two objects when created. The `events` object can define the following events:

- `onEnter()` called when the distance between `to` and `from` becomes *smaller* than `distance`
- `onLeave()` called when the distance between `to` and `from` becomes *greater* than `distance`

## Trigger interface

```lua
trigger:destroy()
```

Destroys the trigger, preventing it from triggering further events.
