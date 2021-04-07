local AddonName, S = ...
local MainFrameWidth, MainFrameHeight = 1000, 800


function InitGUI()
    S:LoadSavedData()
    -- function(self, onclick, texture, bottom)
    local mainFrame = S.GUI:Create("FrameWithSidebar")
    mainFrame:Show()
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
    mainFrame:AddTab('Settings', settingsFrame)
    sheet:InitCells(27, 10)

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

function OnLogout()
    S:SaveData()
end

InitGUI()