--[[

    GET 30 RINGS!

    State management system for Love2D.

]]

local state = {}

-- Callbacks

function call(self, functionName, ...)

    local stack = self.stack

    for i=1, #stack, 1 do
        -- if the function is enabled (by either a setting not being present or being set to true) and it exists then do

        local toExec = true

        if stack[i].settings[functionName] ~= nil then
            toExec = stack[i].settings[functionName]
        end

        if toExec and stack[i].state[functionName] then
            stack[i].state[functionName](...)
        end
    end
end

-- Stack creation

function state.new(...)
    local stack = {...}

    for i=1, #stack, 1 do
        stack[i] = {
            state = stack[i][1],
            settings = stack[i][2] or {}
        }
    end

    local finalStack = {
        stack = stack,
        call = call
    }

    return finalStack
end

return state