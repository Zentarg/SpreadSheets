local AddonName, S = ...
local Type = "Slider"

-- [[       Scripts        ]] --


-- [[        Methods       ]] --

local methods = {
    ["Hide"] = function (self)
        self.scrollBar:Hide()
    end,
    ["Show"] = function (self)
        self.scrollBar:Show()
    end,
    ["SetHeight"] = function(self, h)
        self.scrollBar:SetHeight(h)
    end,
    ["SetWidth"] = function(self, w)
        self.scrollBar:SetWidth(w)
    end,
    ["SetParent"] = function(self, parent)
        self.scrollBar:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.scrollBar:SetPoint(pos1, frame, pos2, x, y)
    end,
    ["SetOnValueChanged"] = function(self, OnValueChanged)
        assert(type(OnValueChanged) == "function")
        self.scrollBar:SetScript("OnValueChanged", OnValueChanged)
    end,
    ["SetMinMaxValues"] = function(self, min, max)
        self.scrollBar:SetMinMaxValues(min, max)
    end,
    ["GetMinMaxValues"] = function(self)
        return self.scrollBar:GetMinMaxValues()
    end,
    ["SetValue"] = function(self, value)
        self.scrollBar:SetValue(value)
    end,
    ["SetHorizontal"] = function(self)
        self.scrollBar:SetHeight(10)
        self.scrollBar:SetOrientation("HORIZONTAL")
        self.scrollBar.Thumb:SetSize(70,10)
        self.scrollBar:SetThumbTexture(self.scrollBar.Thumb)
    end,
    ["SetVertical"] = function(self)
        self.scrollBar:SetWidth(10)
        self.scrollBar:SetOrientation("VERTICAL")
        self.scrollBar.Thumb:SetSize(10,70)
        self.scrollBar:SetThumbTexture(self.scrollBar.Thumb)
    end
}

-- [[      Constructor     ]] --

local function Constructor()
    local scrollBar = CreateFrame("Slider", nil, UIParent, "UIPanelScrollBarTemplate")
    scrollBar:SetValue(0)
    scrollBar:SetMinMaxValues(0, 0)
    scrollBar:SetValueStep(1)
    scrollBar:Hide()
    scrollBar.Thumb = scrollBar:CreateTexture()
    scrollBar.Thumb:SetColorTexture(0.1,0.1,0.1,1)
    scrollBar.Thumb:SetSize(10,70)
    scrollBar:SetThumbTexture(scrollBar.Thumb)

    local scrollBackground = scrollBar:CreateTexture(nil, "BACKGROUND")
    scrollBackground:SetAllPoints()
    scrollBackground:SetColorTexture(0.2, 0.2, 0.2, 1)
    scrollBar.ScrollUpButton:Hide()
    scrollBar.ScrollDownButton:Hide()
    -- scrollBar.ScrollUpButton:SetNormalTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Up')
    -- scrollBar.ScrollUpButton:SetPushedTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Up')
    -- scrollBar.ScrollUpButton:GetPushedTexture():SetVertexColor(1, 1, 1, 0.9)
    -- scrollBar.ScrollUpButton:SetDisabledTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Up')
    -- scrollBar.ScrollUpButton:GetDisabledTexture():SetVertexColor(1, 1, 1, 0.6)
    -- scrollBar.ScrollUpButton:SetWidth(10)
    -- scrollBar.ScrollUpButton:SetHeight(10)

    -- scrollBar.ScrollDownButton:SetNormalTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Down')
    -- scrollBar.ScrollDownButton:SetPushedTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Down')
    -- scrollBar.ScrollDownButton:SetDisabledTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Down')
    -- scrollBar.ScrollDownButton:GetPushedTexture():SetVertexColor(1, 1, 1, 0.9)
    -- scrollBar.ScrollDownButton:GetDisabledTexture():SetVertexColor(1, 1, 1, 0.6)
    -- scrollBar.ScrollDownButton:SetWidth(10)
    -- scrollBar.ScrollDownButton:SetHeight(10)


    local widget = {
        scrollBar = scrollBar,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("Slider", Constructor)