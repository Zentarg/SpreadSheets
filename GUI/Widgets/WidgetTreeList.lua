local AddonName, S = ...
local Type = "Frame"

-- [[       Scripts        ]] --

local function ScrollFrame_OnSizeChanged(self)
    local height, width = self:GetTop() - self:GetBottom(), self:GetRight() - self:GetLeft()

    if (height >= self.content.currentHeight) then
        self.scrollBar:SetMinMaxValues(0, 0)
        self.scrollBar:Hide()
    else
        self.scrollBar:SetMinMaxValues(0, self.content.currentHeight - height)
        self.scrollBar:Show()
    end

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
    ["Hide"] = function (self)
        self.frame:Hide()
    end,
    ["Show"] = function (self)
        self.frame:Show()
    end,
    ["UpdateListFrame"] = function(self)
        self.frame.currentHeight = 0
        print(self.frame.currentHeight)
        for k, v in pairs(self.frame.listItems) do
            v.currentHeight = v:GetHeight()
        end
        for k, v in pairs(self.frame.listItems) do
            if (not v.currentlyPooled) then
                if (v.parent == nil or self.frame.listItems[v.parent] == nil) then
                    v:SetParent(self.frame)
                    v:ClearAllPoints()
                    print(self.frame.currentHeight)
                    v:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 15, -self.frame.currentHeight - 5)
                    v:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, -self.frame.currentHeight - v:GetHeight())
                    -- v.background = v:CreateTexture(nil, 'BACKGROUND')
                    -- v.background:SetAllPoints(v)
                    -- v.background:SetColorTexture(v.itemLevel * 0.1, v.itemLevel * 0.1, v.itemLevel * 0.1, 1)
                    for k2,v2 in pairs(self.frame.listItems) do
                        if (k == v2.parent) then
                            self.frame.currentHeight = self.frame.currentHeight + v2:GetHeight() + 5
                        end
                    end
                    self.frame.currentHeight = self.frame.currentHeight + v:GetHeight() + 5
                    -- AddTopLevelItem
                else
                    local topMargin = self.frame.listItems[v.parent].currentHeight + 5
                    v.itemLevel = self.frame.listItems[v.parent].itemLevel + 1
                    self.frame.listItems[v.parent].currentHeight = self.frame.listItems[v.parent]:GetHeight() + topMargin
                    v:SetParent(self.frame.listItems[v.parent])
                    v:ClearAllPoints()
                    v:SetPoint("TOPLEFT", self.frame.listItems[v.parent], "TOPLEFT", 15, -topMargin)
                    v:SetPoint("TOPRIGHT", self.frame.listItems[v.parent], "TOPRIGHT", 0, -topMargin - v:GetHeight())
                    -- v.background = v:CreateTexture(nil, 'BACKGROUND')
                    -- v.background:SetAllPoints(v)
                    -- v.background:SetColorTexture(v.itemLevel * 0.1, v.itemLevel * 0.1, v.itemLevel * 0.1, 1)
                    -- AddItemToParent
                end
            else
                v:Hide()
            end
        end
    end,
    ["AddListItem"] = function(self, parent, name, itemType, text, onclick)
        assert(type(itemType) == "string")
        assert(type(text) == "string")
        assert(type(onclick) == "function")
        assert(not self.frame.listItems[name], "A list item with that name already exists.")

        for k, v in pairs(self.frame.listItems) do
            if (v.currentlyPooled) then
                v.itemType = itemType
                v.parent = parent
                v.itemLevel = 1
                v.currentHeight = 0
                v.isHidden = false
                v.currentlyPooled = false
                v.text:SetText(text)
                v:SetScript("OnMouseDown", onclick)
                return
            end
        end

        local f = CreateFrame("Frame", nil, UIParent)
        f:SetHeight(20)
        f:SetScript("OnMouseDown", onclick)
        f.itemType = itemType
        f.parent = parent
        f.itemLevel = 1
        f.currentHeight = 0
        f.isHidden = false
        f.currentlyPooled = false

        local t = f:CreateFontString(nil, "OVERLAY", "Arialn_Cell")
        t:SetText(text)
        t:SetPoint("TOPLEFT", f, "TOPLEFT")
        t:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT")
        t:SetJustifyH("LEFT")
        t:SetJustifyV("CENTER")
        f.text = t

        self.frame.listItems[name] = f
    end,
    ["RemoveListItem"] = function(self, name)
        if (self.frame.listItem[name]) then
            self.frame.listItem[name].currentlyPooled = true
        end
    end,
    ["SetParent"] = function(self, parent)
        self.frame:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.frame:SetPoint(pos1, frame, pos2, x, y)
    end,
}


-- [[      Constructor     ]] --

local function Constructor()
    local f = CreateFrame("Frame", nil, UIParent)
    f:SetFrameStrata("DIALOG")

    f.listItems = {}
    f.currentHeight = 0

    local widget = {
        frame = f,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("TreeList", Constructor)