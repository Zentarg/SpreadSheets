local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --

local function Close_OnClick(frame)
    frame:GetParent():Hide()
end

local function Title_OnMouseDown(frame)
    frame:GetParent():StartMoving()
end

local function MoverSizer_OnMouseUp(mover)
    local frame = mover:GetParent()
    frame:StopMovingOrSizing()
    local titleBar = frame.titleBar
    titleBar:SetWidth(frame:GetWidth())
end

local function SizerSE_OnMouseDown(frame)
    frame:GetParent():StartSizing("BOTTOMRIGHT")
end

-- [[        Methods       ]] --


local methods = {
    ["RegisterEvent"] = function(self, event)
        self.frame:RegisterEvent(self, event)
    end,
    ["SetScript"] = function(self, event, script)
        assert(type(script) == "function")
        self.frame:SetScript(event, script)
    end,
    ["SetTitle"] = function(self, title)
        self.title:SetText(title)
    end,
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end
}


-- [[      Constructor     ]] --

local function Constructor()
    local f = CreateFrame("Frame", nil, UIParent)
    f:Hide()

    f:EnableMouse(true)
    f:SetMovable(true)
    f:SetResizable(true)
    f:SetFrameStrata("DIALOG")
    f:SetWidth(600)
    f:SetHeight(400)
    f.background = f:CreateTexture(nil, 'BACKGROUND')
    f.background:SetAllPoints(f)
    f.background:SetColorTexture(0.1, 0.1, 0.1, 1)
    f:SetMinResize(600, 400)
    f:SetToplevel(true)
    f:SetPoint("CENTER", UIParent, "CENTER")

    local closeButton = CreateFrame("Button", nil, f)
    closeButton:SetScript("OnClick", Close_OnClick)
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    closeButton:SetHeight(30)
    closeButton:SetWidth(30)
    closeButton:SetNormalTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Close')
    closeButton:SetScript('OnEnter', function(self)
        self:GetNormalTexture():SetVertexColor(1, 1, 1, 0.8)
    end)
    closeButton:SetScript('OnLeave', function(self)
        self:GetNormalTexture():SetVertexColor(1, 1, 1, 1)
    end)
    f.closeButton = closeButton


    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetPoint("TOP", 0, 0)
    titleBar:SetWidth(f:GetWidth())
    titleBar:SetHeight(40)
    titleBar:EnableMouse(true)
    titleBar:SetScript("OnMouseDown", Title_OnMouseDown)
    titleBar:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
    -- titleBar.background = titleBar:CreateTexture(nil, 'BACKGROUND')
    -- titleBar.background:SetAllPoints(titleBar)
    -- titleBar.background:SetColorTexture(0.05, 0.05, 0.05, 1)
    f.titleBar = titleBar

    local title = titleBar:CreateFontString(nil, "OVERLAY", "Arialnb")
    title:SetPoint("TOP", titleBar, "TOP", 0, -10)

    local sizer_se = CreateFrame("Frame", nil, f)
    sizer_se:SetPoint("BOTTOMRIGHT")
    sizer_se:SetWidth(25)
    sizer_se:SetHeight(25)
    sizer_se:EnableMouse()
    sizer_se:SetScript("OnMouseDown", SizerSE_OnMouseDown)
    sizer_se:SetScript("OnMouseUp", MoverSizer_OnMouseUp)


    local widget = {
        frame = f,
        titleBar = titleBar,
        title = title,
        sizer_se = sizer_se,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("Frame", Constructor)

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