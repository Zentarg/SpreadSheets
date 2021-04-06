local AddonName, S = ...
local WidgetRegistry = {}


S.GUI = {}


function S.GUI:Create(widget)
    if WidgetRegistry[widget] then
        return WidgetRegistry[widget]()
    end
end

function S.GUI:RegisterWidgetType(name, constructor)
    assert(type(constructor) == "function")
    WidgetRegistry[name] = constructor;
end