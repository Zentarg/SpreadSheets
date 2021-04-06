local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --

local function Close_OnClick(frame)
    frame:GetParent():Hide()
end

local function Title_OnMouseDown(frame)
    frame:GetParent():StartMoving()
end

local function MoverSizer_OnMouseUp(self)
    local frame = self:GetParent()
    frame:StopMovingOrSizing()
    local titleBar = frame.titleBar
    titleBar:SetWidth(frame:GetWidth())
end

local function SizerSE_OnMouseDown(frame)
    frame:GetParent():StartSizing("BOTTOMRIGHT")
end

-- [[        Methods       ]] --


local methods = {
    ["SetTitle"] = function(self, title)
        self.title:SetText(title)
    end,
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end,
    ["AddIcon"] = function(self, onclick, texture, bottom)
        assert(type(onclick) == "function")
        local i = CreateFrame("Button", nil, self.frame)
        i:SetHeight(32)
        i:SetWidth(32)
        i:SetScript("OnClick", onclick)
        i:SetNormalTexture(texture)
        i:SetScript('OnEnter', function(self)
            self:GetNormalTexture():SetVertexColor(1, 1, 1, 0.8)
        end)
        i:SetScript('OnLeave', function(self)
            self:GetNormalTexture():SetVertexColor(1, 1, 1, 1)
        end)
        if (bottom) then
            i:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 8, 10 + 40 * #self.frame.IconsBottom)
            table.insert(self.frame.IconsBottom, i)
        else
            i:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 8, -62 - 40 * #self.frame.IconsTop)
            table.insert(self.frame.IconsTop, i)
        end
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


    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetPoint("TOP", 0, 0)
    titleBar:SetWidth(f:GetWidth())
    titleBar:SetHeight(40)
    titleBar:EnableMouse(true)
    titleBar:SetScript("OnMouseDown", Title_OnMouseDown)
    titleBar:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
    f.titleBar = titleBar

    local title = titleBar:CreateFontString(nil, "OVERLAY", "Arialnb")
    title:SetPoint("TOP", titleBar, "TOP", 0, -10)

    f.IconsTop = {}
    f.IconsBottom = {}

    local Logo = f:CreateTexture(nil, "ARTWORK")
    Logo:SetSize(32, 32)
    Logo:SetPoint("TOPLEFT", f, "TOPLEFT", 8, -10)
    Logo:SetTexture('Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Logo')



    local sizer_se = CreateFrame("Frame", nil, f)
    sizer_se:SetPoint("BOTTOMRIGHT", 1, 0)
    sizer_se:SetWidth(25)
    sizer_se:SetHeight(25)
    sizer_se:EnableMouse()
    sizer_se:SetScript("OnMouseDown", SizerSE_OnMouseDown)
    sizer_se:SetScript("OnMouseUp", MoverSizer_OnMouseUp)
    sizer_se.background = sizer_se:CreateTexture(nil, 'BACKGROUND')
    sizer_se.background:SetAllPoints(sizer_se)
    sizer_se.background:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")


    local widget = {
        frame = f,
        closeButton = closeButton,
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

S.GUI:RegisterWidgetType("FrameWithSidebar", Constructor)

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