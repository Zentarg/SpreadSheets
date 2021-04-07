local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --

local function Cell_OnEnter(self)
    if (not self.isFocused) then
        self.background:SetColorTexture(0.2, 0.2, 0.2, 1)
    end
end

local function Cell_OnLeave(self)
    if (not self.isFocused) then
        self.background:SetColorTexture(0.15, 0.15, 0.15, 1)
    end
end

-- [[        Methods       ]] --

local methods = {
    ["SetName"] = function(self, name)
        self.frame.name = name
    end,
    ["SetText"] = function(self, text)
        assert(type(text) == "string")
        self.frame.text = text
        self.content:SetText(text)
    end,
    ["GetText"] = function(self)
        return self.frame.text
    end,
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end,
    ["SetHeight"] = function(self, h)
        self.frame:SetHeight(h)
    end,
    ["GetHeight"] = function(self)
        return self.frame:GetHeight()
    end,
    ["SetWidth"] = function(self, w)
        self.frame:SetWidth(w)
    end,
    ["GetWidth"] = function(self)
        return self.frame:GetWidth()
    end,
    ["SetOnClick"] = function(self, onclick)
        assert(type(onclick) == "function")
        self.frame:SetScript("OnClick", onclick)
    end,
    ["SetParent"] = function(self, parent)
        self.frame:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.frame:SetPoint(pos1, frame, pos2, x, y)
    end,
    ["ParseText"] = function(self)
        local text = self.frame.text
        if (string.sub(text, 1, 1) == "=") then
            -- Parse text
            print("Should Parse")
        end
        self.content:SetText(text)
    end,
    ["SetIsFocused"] = function(self, isFocused)
        self.frame.isFocused = isFocused
    end
}

-- [[      Constructor     ]] --

local function Constructor()
    local f = CreateFrame("Frame", nil, UIParent)
    f:Show()

    f:EnableMouse(true)
    f:SetFrameStrata("DIALOG")
    f:SetWidth(100)
    f:SetHeight(40)
    f.background = f:CreateTexture(nil, 'BACKGROUND')
    f.background:SetAllPoints(f)
    f.background:SetColorTexture(0.15, 0.15, 0.15, 1)
    f:SetScript("OnEnter", Cell_OnEnter)
    f:SetScript("OnLeave", Cell_OnLeave)

    f.text = ""
    f.name = ""
    f.isFocused = false

    local content = f:CreateFontString(nil, "OVERLAY", "Arialn_Cell")
    content:SetPoint("LEFT", f, "LEFT", 5, 0)
    content:SetHeight(f:GetHeight())
    content:SetWidth(f:GetWidth() - 10)

    local widget = {
        frame = f,
        content = content,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("Cell", Constructor)