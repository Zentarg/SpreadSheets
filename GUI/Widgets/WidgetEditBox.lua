local AddonName, S = ...
local Type = "EditBox"

-- [[       Scripts        ]] --

-- [[        Methods       ]] --

local methods = {
    ["Hide"] = function (self)
        self.editBox:Hide()
    end,
    ["Show"] = function (self)
        self.editBox:Show()
    end,
    ["SetHeight"] = function(self, h)
        self.editBox:SetHeight(h)
    end,
    ["SetWidth"] = function(self, w)
        self.editBox:SetWidth(w)
    end,
    ["SetParent"] = function(self, parent)
        self.editBox:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.editBox:SetPoint(pos1, frame, pos2, x, y)
    end,
    ["SetOnValueChanged"] = function(self, OnValueChanged)
        assert(type(OnValueChanged) == "function")
        self.editBox:SetScript("OnValueChanged", OnValueChanged)
    end,
    ["SetValue"] = function(self, value)
        self.editBox:SetValue(value)
    end,
    ["SetOnCheckmarkClicked"] = function(self, OnCheckmarkClicked)
        assert(type(OnCheckmarkClicked) == "function")
        -- self.scrollBar:SetScript("OnValueChanged", OnCheckmarkClicked)
    end,
    ["SetFocus"] = function(self)
        self.editBox:SetFocus()
    end,
    ["ClearFocus"] = function(self)
        self.editBox:ClearFocus()
    end,
    ["SetOnEscapePressed"] = function(self, OnEscapePressed)
        assert(type(OnEscapePressed) == "function")
        self.editBox:SetScript("OnEscapePressed", OnEscapePressed)
    end,
    ["SetOnEnterPressed"] = function(self, OnEnterPressed)
        assert(type(OnEnterPressed) == "function")
        self.editBox:SetScript("OnEnterPressed", OnEnterPressed)
    end,
    ["SetFontObject"] = function (self, font)
        self.editBox:SetFontObject(font)
    end,
    ["SetPadding"] = function(self, l, r, t, b)
        self.editBox:SetTextInsets(l, r, t, b)
    end
}

-- [[      Constructor     ]] --

local function Constructor()
    local e = CreateFrame("EditBox", nil, UIParent, "InputBoxTemplate")
    e:SetAutoFocus(false)
    e:SetHeight(30)
    e:SetWidth(200)
    e:SetJustifyH("LEFT")
    e:SetJustifyV("CENTER")
    e:EnableMouse(true)
    e:SetFontObject("Arialn_EditText")
    e:SetTextInsets(5, 5, 0, 0)
    e.Middle:Hide()
    e.Left:Hide()
    e.Right:Hide()
    local eBackground = e:CreateTexture(nil, "BACKGROUND")
    eBackground:SetAllPoints()
    eBackground:SetColorTexture(0.15, 0.15, 0.15, 1)


    local widget = {
        editBox = e,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("EditBox", Constructor)