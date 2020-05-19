# SpecialZone
COLLECT 30 RINGS! A simple state management library for Lua.

## Specification

States must be objects with callbacks as listed under ``love`` on the wiki. For instance, if you want your function to update, the object it returns must have an update functions ie ``state.update()``, state being what you return.

States can then be compiled into ``stack``s, which are arrays in the format of:

```lua
local stack = {
    stack = {
        {
            state = state, -- this is your required file with updates and etc
            settings = {
                -- this is some basic settings you can enable, such as disabling certain callbacks.
                -- these are usually set to defaults.
                update = true, -- To pause, set this to false.
                draw = true, -- To hide, set this to false.
                keypressed = true -- To prevent interaction, set this to false.

                -- you can make as many of these as you want!
            }
        }
    }
    call = function(self, callback, ...)
}
```

You then hook these into the various rendering functions and it should work as intended.

```lua
-- Load our state library
local state = require("specialZone")

-- Make stack with 2 modules, the second of which won't ever receive keypresses.
local stack = state.new({require("screen")}, {require("menu"), {keypressed = false}})

-- Example hook
function love.keypressed(key)
    stack:call("keypressed", key) 
    -- Arguments can (and should) be passed as normal, 
    -- but there's nothing stopping you adding a bit more to your callbacks
end

-- Drawing
function love.draw()
    stack:call("draw")
end
```

## Conventions

- Module settings and tweaks should be stored under the object returned (ie ``state.opacity``)

## Example state

```lua
local state = {
    settings = {
        text = "Hello World!"
    }
}

function state.draw()
    love.graphics.print(settings.text, 0, 0)
end

function state.keypressed(key)
    state.settings.text = state.settings.text .. key
end

return state
```

This state prints ``Hello World`` at the corner of the screen, which can be extended by keypresses. It also exposes the text to the main file.

## Documentation

#### Functions
- ``new(states)``
    Creates a new stack.
    #### Arguments
    - ``states``
        Array of tables in the format ``{state, settings}``. Settings is a table of key value booleans like ``callbackName (String): isOn (Boolean)`` ie ``{keypressed = false, draw = false}``. Anything not listed here is treated as ``true``.

    #### Returns
    ``stack`` - Callable stack of your states.

#### Types
- ``stack``
    Table formatted like:
  
    ```lua
    local stack = {
        stack = {
            {
                state = state, -- this is your required file with updates and etc
                settings = {
                    -- this is some basic settings you can enable, such as disabling certain callbacks.
                    -- these are usually set to defaults.
                    update = true, -- To pause, set this to false.
                    draw = true, -- To hide, set this to false.
                    keypressed = true -- To prevent interaction, set this to false.

                    -- you can make as many of these as you want!
                }
            }
        }
        call = function(self, callback, ...)
    }
    ```

    #### Functions

    - ``call``
        Iterates over the stack calling a specific function with the arguments provided, given that the function both exists in the stack member and that it isn't disabled via the settings arguments.
