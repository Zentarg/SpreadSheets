local AddonName, S = ...
local MainFrameWidth, MainFrameHeight = 1000, 800


-- [[       Main        ]] --

local mainFrame = S.GUI:Create("FrameWithSidebar")
mainFrame:RegisterEvent("PLAYER_LOGIN")
mainFrame:RegisterEvent("PLAYER_LOGOUT")
mainFrame:SetScript("OnEvent", function(self, event, ...)
    S.EventHandler[event](self, ...)
end)
mainFrame:Show()

function CreateCategory(name)
    S.DB:CreateCategory(name)
end

function CreateSheet(cat, name)
    S.DB:CreateSheet(cat, name, 20, 20)
end

function DelSheet(name)
    S.DB:RemoveSheet(name)
end

function DelCategory(name)
    S.DB:RemoveCategory(name)
end

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


    local spreadSheetFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    spreadSheetFrame:Hide()
    local sheet = S.GUI:Create("Sheet")
    sheet:SetParent(spreadSheetFrame)
    sheet:SetPoint("TOPLEFT", spreadSheetFrame, "TOPLEFT")
    sheet:SetPoint("BOTTOMRIGHT", spreadSheetFrame, "BOTTOMRIGHT")
    sheet:SetOnCellChanged(function()
        sheet:SaveCurrentSheet()
    end)
    mainFrame:AddTab('SpreadSheet', spreadSheetFrame)
    sheet:InitSheet(30, 30)
    -- S.DB:CreateSheet("test2", 30, 30)
    -- sheet:LoadSheet(S.DB:GetSheet("test2"))

    local settingsFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    settingsFrame:Hide()
    mainFrame:AddTab('Settings', settingsFrame)




    local infoFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    infoFrame:Hide()
    local infoHeader = infoFrame:CreateFontString(nil, 'OVERLAY', 'Arialnb_H1')
    infoHeader:SetText('Info')
    infoHeader:SetPoint('TOPRIGHT', infoFrame, 'TOPRIGHT')
    mainFrame:AddTab('Info', infoFrame)

    local listFrame = CreateFrame("Frame", nil, mainFrame.tabFrame)
    listFrame:Hide()
    mainFrame:AddTab('List', listFrame)
    local treeList = S.GUI:Create("TreeList")
    treeList:SetParent(listFrame)
    treeList:SetPoint("TOPLEFT", listFrame, "TOPLEFT")
    treeList:SetPoint("BOTTOMRIGHT", listFrame, "BOTTOMRIGHT")
    for k, v in pairs(S.DB:GetCategories()) do
        treeList:AddListItem(nil, v["name"], "category", v["name"], function()
            print("Clicked " .. v["name"])
        end)
        for k2, v2 in pairs(v) do
            if (type(k2) == "number") then
                local s = S.DB:GetSheet(v2)
                treeList:AddListItem(v["name"], s["name"], "sheet", s["name"], function()
                    sheet:LoadSheet(s)
                    mainFrame:OpenTab("SpreadSheet")
                end)
            end
        end
    end
    mainFrame:OpenTab("List")


    -- self, parent, name, itemType, text, onclick
    -- treeList:AddListItem(nil, "TestSheet", "category", "Test Sheet", function()
    --     print("Clicked test sheet")
    -- end)
    -- treeList:AddListItem("TestSheet", "TestSheetChild1", "sheet", "Test Sheet Child 1", function()
    --     print("Clicked test sheet child 1")
    -- end)
    -- treeList:AddListItem("TestSheet", "TestSheetChild2", "sheet", "Test Sheet Child 2", function()
    --     print("Clicked test sheet child 2")
    -- end)
    -- treeList:AddListItem("TestSheet", "TestSheetChild3", "sheet", "Test Sheet Child 3", function()
    --     print("Clicked test sheet child 3")
    -- end)
    -- treeList:AddListItem(nil, "TestSheet2", "category", "Test Sheet2", function()
    --     print("Clicked test sheet")
    -- end)
    -- treeList:AddListItem("TestSheet2", "TestSheet2Child1", "sheet", "Test Sheet2 Child 1", function()
    --     print("Clicked test sheet2 child 1")
    -- end)
    -- treeList:AddListItem("TestSheet2", "TestSheet2Child2", "sheet", "Test Sheet2 Child 2", function()
    --     print("Clicked test sheet2 child 2")
    -- end)
    -- treeList:AddListItem("TestSheet2", "TestSheet2Child3", "sheet", "Test Sheet2 Child 3", function()
    --     print("Clicked test sheet2 child 3")
    -- end)
    treeList:UpdateListFrame()
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


-- [[       Minimap Icon        ]] --

local ldb = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("SpreadSheets", {
	type = "launcher",
	icon = "Interface\\AddOns\\SpreadSheets\\Media\\Icons\\Logo",
	OnClick = function(clickedframe, button)
        if (mainFrame:IsShown()) then
            mainFrame:Hide()
        else
            mainFrame:Show()
        end
	end,
    minimap = {
        hide = false
    }
})

local icon = LibStub("LibDBIcon-1.0")

icon:Register("SpreadSheets", ldb, ldb.minimap)

S.EventHandler:AddLoginMethod(InitGUI)