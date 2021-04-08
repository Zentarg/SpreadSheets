local AddonName, S = ...

local EventHandler = {}

EventHandler.LOGIN_METHODS = {}

function EventHandler:PLAYER_LOGIN(frame, ...)
    S.DB:LoadSavedData()
    for i = 1, #EventHandler.LOGIN_METHODS do
        if (type(EventHandler.LOGIN_METHODS[i]) == "function") then
            EventHandler.LOGIN_METHODS[i]()
        end
    end
end

function EventHandler:PLAYER_LOGOUT(frame, ...)
    S.DB:SaveData()
end

function EventHandler:AddLoginMethod(method)
    assert(type(method) == "function")
    table.insert(EventHandler.LOGIN_METHODS, method)
end


S.EventHandler = EventHandler