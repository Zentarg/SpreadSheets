local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --

local function slider_OnValueChanged(self, value)
    value = value / self:GetParent().content:GetScale()
    self:GetParent().content.y = value
    self:GetParent().content:SetPoint("TOPLEFT", -self:GetParent().content.x, value)
end

local function sliderH_OnValueChanged(self, value)
    value = value / self:GetParent().content:GetScale()
    self:GetParent().content.x = value
    self:GetParent().content:SetPoint("TOPLEFT", -value, self:GetParent().content.y)
end

local function ScrollFrame_OnMouseWheel(self, value)
    if (self:IsShown() and self.mouseWheelEnabled) then
        local delta = 15
        if (value > 0) then
            delta = -15
        end
        if (IsShiftKeyDown()) then
            delta = delta * 7
        end
        if (IsAltKeyDown()) then
            local sliderMin, sliderMax = self.scrollBarH:GetMinMaxValues()
            if (self.content.x + delta < sliderMin) then
                self.content.x = sliderMin
            elseif (self.content.x + delta > sliderMax) then
                self.content.x = sliderMax
            else
                self.content.x = self.content.x + delta
            end
            self.scrollBarH:SetValue(self.content.x)
        else
            local sliderMin, sliderMax = self.scrollBar:GetMinMaxValues()
            if (self.content.y + delta < sliderMin) then
                self.content.y = sliderMin
            elseif (self.content.y + delta > sliderMax) then
                self.content.y = sliderMax
            else
                self.content.y = self.content.y + delta
            end
            self.scrollBar:SetValue(self.content.y)
        end
    end
end

-- local function ScrollFrame_SizeChanged(self)
--     -- local contentHeight, contentWidth = 0, 10
--     -- local dummy = S.GUI:Create("Cell")

--     -- local cscale = self.content:GetScale()

--     -- local rows, columns = self:GetParent().rows, self:GetParent().columns
--     -- for i = 1, rows do
--     --     contentHeight = contentHeight + dummy:GetHeight() + 10
--     -- end
--     -- for i = 1, columns do
--     --     contentWidth = contentWidth + dummy:GetWidth() + 10
--     -- end
--     local height, width = self:GetTop() - self:GetBottom(), self:GetRight() - self:GetLeft()
--     local contentHeight, contentWidth = self.content:GetHeight(), self.content:GetWidth()
--     -- self.content:SetHeight(contentHeight)
--     -- self.content:SetWidth(contentWidth)
--     if (height >= contentHeight) then
--         self.scrollBar:SetMinMaxValues(0, 0)
--         self.scrollBar:Hide()
--     else
--         -- self.scrollBar.Thumb:SetSize(10, (height / contentHeight) * height)
--         -- self.scrollBar:SetThumbTexture(self.scrollBar.Thumb)
--         -- self.scrollBar:SetValueStep((height * contentHeight) / height)

--         self.scrollBar:SetMinMaxValues(0, contentHeight - height)
--         self.scrollBar:Show()
--     end
--     if (width >= contentWidth) then
--         self.scrollBarH:SetMinMaxValues(0, 0)
--         self.scrollBarH:Hide()
--     else
--         self.scrollBarH:SetMinMaxValues(0, contentWidth - width)
--         self.scrollBarH:Show()
--     end
-- end

-- [[        Methods       ]] --


local methods = {
    ["RegisterEvent"] = function(self, event)
        self.frame:RegisterEvent(self, event)
    end,
    ["SetScript"] = function(self, event, script)
        assert(type(script) == "function")
        self.frame:SetScript(event, script)
    end,
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end,
    ["SetMouseWheelEnabled"] = function(self, bool)
        assert(type(bool) == "boolean")
        self.frame.mouseWheelEnabled = bool
    end,
    ["SetOnSizeChanged"] = function(self, OnSizeChanged)
        assert(type(OnSizeChanged) == "function")
        self.frame:SetScript("OnSizeChanged", OnSizeChanged)
    end,
    ["SetParent"] = function(self, parent)
        self.frame:SetParent(parent)
    end,
    ["GetParent"] = function(self)
        return self.frame:GetParent()
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.frame:SetPoint(pos1, frame, pos2, x, y)
    end,
    ["GetTop"] = function(self)
        return self.frame:GetTop()
    end,
    ["GetBottom"] = function(self)
        return self.frame:GetBottom()
    end,
    ["GetLeft"] = function(self)
        return self.frame:GetLeft()
    end,
    ["GetRight"] = function(self)
        return self.frame:GetRight()
    end,
}


-- [[      Constructor     ]] --

local function Constructor()
    local scrollFrame = CreateFrame("ScrollFrame", nil, UIParent)
    -- scrollFrame:SetPoint("TOPLEFT", f, 0, -40)
    -- scrollFrame:SetPoint("BOTTOMRIGHT", f, -10, 10)
    scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
    scrollFrame:SetScript("OnSizeChanged", ScrollFrame_SizeChanged)
    scrollFrame.mouseWheelEnabled = true

    local scrollBar = S.GUI:Create("Slider")
    scrollBar:SetParent(scrollFrame)
    scrollBar:SetPoint("TOPRIGHT", scrollFrame, 10, 0)
    scrollBar:SetPoint("BOTTOMRIGHT", scrollFrame, 10, 32)
    scrollBar:SetVertical()
    scrollBar:SetOnValueChanged(slider_OnValueChanged)
    scrollFrame.scrollBar = scrollBar

    local scrollBarH = S.GUI:Create("Slider")
    scrollBarH:SetParent(scrollFrame)
    scrollBarH:SetPoint("BOTTOMLEFT", scrollFrame, 0, -10)
    scrollBarH:SetPoint("BOTTOMRIGHT", scrollFrame, -32, -10)
    scrollBarH:SetHorizontal()
    scrollBarH:SetOnValueChanged(sliderH_OnValueChanged)
    scrollFrame.scrollBarH = scrollBarH

    local content = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(content)
    content:SetPoint("TOPLEFT")
    content:SetPoint("TOPRIGHT")
    content.y = 0
    content.x = 0

    scrollFrame.content = content

    local widget = {
        frame = scrollFrame,
        content = content,
        scrollBar = scrollBar,
        scrollBarH = scrollBarH,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("ScrollFrame", Constructor)

-- S.MainFrame = CreateFrame('Frame', AddonName.."MainFrame", UIParent, 'SpreadSheetsMainFrame')
--     S.MainFrame:SetFrameStrata('DIALOG')
--     S.MainFrame:SetWidth(MainFrameWidth)
--     S.MainFrame:SetHeight(MainFrameHeight)
--     S.MainFrame:SetPoint('CENTER', UIParent, 'CENTER')
--     S.MainFrame:EnableMouse(true)
--     S.MainFrame:RegisterForDrag('LeftButton')
--     S.MainFrame:SetClampedToScreen(true)
--     S.MainFrame:Hide()
--     S.MainFrame.background = S.MainFrame:CreateTexture(nil, 'BACKGROUND')
--     S.MainFrame.background:SetAllPoints(S.MainFrame)
--     S.MainFrame.background:SetColorTexture(0.1, 0.1, 0.1, 1)