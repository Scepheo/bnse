# Timers

bnse adds easy-to-use timers to BeamNG.*drive*.

## Module interface

```
bnse.timers.create(time, events)
```

- `time` time (in seconds) the timer will run
- `events` object containing the timer events

Returns a timer object (see below for how to use it). Note that the timer won't start running until you call `start`. The `events` object can define the following events:

- `onStart()` called when the timer is started or restarted
- `onUpdate(dt)` called every frame, with the amount of time that has passed since the last frame
- `onEnd()` called when the timer runs to completion or is stopped

## Timer interface

```lua
timer:start()
```

Starts the timer, calling the `onStart` function if set.

```lua
timer:restart()
```

Resets the timer, calling the `onStart` function if set.

```lua
timer:stop()
```

Stops and destroys the timer, calling the `onEnd` function if set.
