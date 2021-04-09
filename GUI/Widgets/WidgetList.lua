local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --


-- [[        Methods       ]] --


local methods = {
    ["RegisterEvent"] = function(self, event)
        self.frame:RegisterEvent(self, event)
    end,
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end,
    ["AddSection"] = function(self, name, columns)
        local topMargin = 10
        for k,v in pairs(self.frame.sections) do
            topMargin = topMargin + v.currentHeight + 10
        end

        local f = CreateFrame("Frame")
        f:SetToplevel(true)
        f:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -topMargin)
        f:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, -topMargin)
        f.currentHeight = 0

        local titleBar = CreateFrame("Frame", nil, f)
        titleBar:SetPoint("TOPLEFT", f, "TOPLEFT")
        titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT")
        titleBar:SetHeight(30)
        titleBar.background = titleBar:CreateTexture(nil, 'BACKGROUND')
        titleBar.background:SetAllPoints(titleBar)
        titleBar.background:SetColorTexture(0.15, 0.15, 0.15, 1)
        f.titleBar = titleBar

        local title = titleBar:CreateFontString(nil, "OVERLAY", "Arialnb_H2")
        title:SetPoint("TOP", titleBar, "TOP", 0, -10)
        table.insert(self.frame.sections, f)
    end,
    ["AddSetting"] = function(self, parent, name, text, tooltip, type)
        local s = CreateFrame("Frame")
    end,
    ["SetParent"] = function(self, parent)
        self.frame:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.frame:SetPoint(pos1, frame, pos2, x, y)
    end
}


-- [[      Constructor     ]] --

local function Constructor()
    local f = CreateFrame("Frame", nil, UIParent)
    f.sections = {}
    f.settings = {}

    local widget = {
        frame = f,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("List", Constructor)