local AddonName, S = ...
local MainFrameWidth, MainFrameHeight = 1000, 800

local mainFrame = S.GUI:Create("FrameWithSidebar")
mainFrame:RegisterEvent("PLAYER_LOGIN")
mainFrame:RegisterEvent("PLAYER_LOGOUT")
mainFrame:SetScript("OnEvent", function(self, event, ...)
    S.EventHandler[event](self, ...)
end)
mainFrame:Show()

function InitGUI()
    mainFrame:SetTitle(AddonName)
    mainFrame:AddIcon(function()
            mainFrame:OpenTab('Settings')
        end, 'Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Settings', true)
    mainFrame:AddIcon(function()
            mainFrame:OpenTab('Info')
        end, 'Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Info', true)
    mainFrame:AddIcon(function()
            mainFrame:OpenTab('List')
        end, 'Interface\\AddOns\\SpreadSheets\\Media\\Icons\\List', false)
    mainFrame:AddIcon(function()
            print("ImportExport")
        end, 'Interface\\AddOns\\SpreadSheets\\Media\\Icons\\ImportExport', false)
    mainFrame:AddIcon(function()
            print("Help")
        end, 'Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Help', false)


    local settingsFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    settingsFrame:Hide()

    local sheet = S.GUI:Create("Sheet")
    sheet:SetParent(settingsFrame)
    sheet:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT")
    sheet:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT")
    sheet:SetOnCellChanged(function()
        sheet:SaveCurrentSheet()
    end)
    mainFrame:AddTab('Settings', settingsFrame)
    sheet:InitSheet(30, 30)
    -- S.DB:CreateSheet("test2", 30, 30)
    sheet:LoadSheet(S.DB:GetSheet("test2"))


    local infoFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    infoFrame:Hide()
    local infoHeader = infoFrame:CreateFontString(nil, 'OVERLAY', 'Arialnb')
    infoHeader:SetText('Info')
    infoHeader:SetPoint('TOPRIGHT', infoFrame, 'TOPRIGHT')
    mainFrame:AddTab('Info', infoFrame)

    local listFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    listFrame:Hide()
    local listHeader = listFrame:CreateFontString(nil, 'OVERLAY', 'Arialnb')
    listHeader:SetText('List')
    listHeader:SetPoint('CENTER', listFrame, 'CENTER')
    mainFrame:AddTab('List', listFrame)

end



-- local AstralKeyFrame = CreateFrame('FRAME', 'AstralKeyFrame', UIParent)
-- AstralKeyFrame:SetFrameStrata('DIALOG')
-- AstralKeyFrame:SetWidth(715)
-- AstralKeyFrame:SetHeight(490)
-- AstralKeyFrame:SetPoint('CENTER', UIParent, 'CENTER')
-- AstralKeyFrame:EnableMouse(true)
-- AstralKeyFrame:SetMovable(true)
-- AstralKeyFrame:RegisterForDrag('LeftButton')
-- AstralKeyFrame:EnableKeyboard(true)
-- AstralKeyFrame:SetPropagateKeyboardInput(true)
-- AstralKeyFrame:SetClampedToScreen(true)
-- AstralKeyFrame:Hide()
-- AstralKeyFrame.updateDelay = 0
-- AstralKeyFrame.background = AstralKeyFrame:CreateTexture(nil, 'BACKGROUND')
-- AstralKeyFrame.background:SetAllPoints(AstralKeyFrame)
-- AstralKeyFrame.background:SetColorTexture(0, 0, 0, 0.8)

S.EventHandler:AddLoginMethod(InitGUI)