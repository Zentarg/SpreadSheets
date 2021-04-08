local AddonName, S = ...
local Type = "Frame"
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

-- [[       Scripts        ]] --

local function OnCellChanged()end

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

local function editBox_OnEnterPressed(self)
    if (self:GetParent().focusedCell ~= nil) then
        self:GetParent().focusedCell:SetText(self:GetText())
    end
    self:ClearFocus()
    OnCellChanged()
end

local function ScrollFrame_OnMouseWheel(self, value)
    if (self:IsShown()) then
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

local function ScrollFrame_SizeChanged(self)
    local contentHeight, contentWidth = 0, 10
    local dummy = S.GUI:Create("Cell")

    local cscale = self.content:GetScale()

    local rows, columns = self:GetParent().rows, self:GetParent().columns
    local height, width = self:GetTop() - self:GetBottom(), self:GetRight() - self:GetLeft()
    for i = 1, rows do
        contentHeight = contentHeight + dummy:GetHeight() + 10
    end
    for i = 1, columns do
        contentWidth = contentWidth + dummy:GetWidth() + 10
    end
    contentHeight, contentWidth = contentHeight * cscale, contentWidth * cscale
    self.content:SetHeight(contentHeight)
    self.content:SetWidth(contentWidth)
    if (height >= contentHeight) then
        self.scrollBar:SetMinMaxValues(0, 0)
        self.scrollBar:Hide()
    else
        -- self.scrollBar.Thumb:SetSize(10, (height / contentHeight) * height)
        -- self.scrollBar:SetThumbTexture(self.scrollBar.Thumb)
        -- self.scrollBar:SetValueStep((height * contentHeight) / height)

        self.scrollBar:SetMinMaxValues(0, contentHeight - height)
        self.scrollBar:Show()
    end
    if (width >= contentWidth) then
        self.scrollBarH:SetMinMaxValues(0, 0)
        self.scrollBarH:Hide()
    else
        self.scrollBarH:SetMinMaxValues(0, contentWidth - width)
        self.scrollBarH:Show()
    end
end

-- [[        Methods       ]] --

local methods = {
    ["SetOnCellChanged"] = function(self, onCellChanged)
        assert(type(onCellChanged) == "function")
        OnCellChanged = onCellChanged
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
    ["SetWidth"] = function(self, w)
        self.frame:SetWidth(w)
    end,
    ["SetParent"] = function(self, parent)
        self.frame:SetParent(parent)
    end,
    ["SetPoint"] = function(self, pos1, frame, pos2, x, y)
        self.frame:SetPoint(pos1, frame, pos2, x, y)
    end,
    ["AddRow"] = function(self)

        self.frame.rows = self.frame.rows + 1
    end,
    ["AddColumnn"] = function(self)

        self.frame.columns = self.frame.columns + 1
    end,
    ["ClearSheet"] = function(self)
        for k, v in pairs(self.frame.cells) do
            v:SetText("")
        end
    end,
    ["SaveCurrentSheet"] = function(self)
        if (self.frame.currentSheet == nil) then
            self.frame.currentSheet = {}
        else
            wipe(self.frame.currentSheet["cells"])
        end
        for k, v in pairs(self.frame.cells) do
            if (v:GetText() ~= "") then
                local c = {}
                c["text"] = v:GetText()
                c["row"] = v:GetRow()
                c["column"] = v:GetColumn()
                table.insert(self.frame.currentSheet["cells"], c)
            end
        end
        -- S.DB["Sheets"][self.frame.currentSheet["name"]] = self.frame.currentSheet
    end,
    ["LoadSheet"] = function(self, sheet)
        self:ClearSheet()
        local rows, columns = sheet["rows"], sheet["columns"]
        if (rows > self.frame.rows) then
            -- AddRow
        elseif(columns > self.frame.columns) then
            -- AddColumn
        end
        for k, v in pairs(sheet["cells"]) do
            self.frame.cells[v["row"] .. "-" .. v["column"]]:SetText(v["text"])
        end
        self.frame.currentSheet = sheet
    end,
    ["InitSheet"] = function(self, rows, columns)
        local contentHeight, contentWidth = 0, 10
        local dummy = S.GUI:Create("Cell")

        local cscale = self.content:GetScale()

        for i = 1, rows do
            for j = 1, columns do
                local c = S.GUI:Create("Cell")
                c:SetRow(i)
                c:SetColumn(j)
                c:SetParent(self.content)
                c:SetPoint("TOPLEFT", self.content, "TOPLEFT", (c:GetWidth() + 10) * (j-1) + 10, -((c:GetHeight() + 10) * (i-1)))
                c:SetOnMouseDown(function(e, button)
                    if (button == 'LeftButton') then
                        if (self.frame.focusedCell ~= nil) then
                            self.frame.focusedCell:SetIsFocused(false)
                        end
                        c:SetIsFocused(true)
                        self.frame.focusedCell = c
                        self.editBox:SetText(c:GetText())
                    end
                end)
                self.frame.cells[i.."-"..j] = c
            end
        end
        self.frame.rows = rows
        self.frame.columns = columns

        local height, width = self.scrollFrame:GetTop() - self.scrollFrame:GetBottom(), self.scrollFrame:GetRight() - self.scrollFrame:GetLeft()
        for i = 1, rows do
            contentHeight = contentHeight + dummy:GetHeight() + 10
        end
        for i = 1, columns do
            contentWidth = contentWidth + dummy:GetWidth() + 10
        end
        self.content:SetHeight(contentHeight)
        self.content:SetWidth(contentWidth)
        contentHeight, contentWidth = contentHeight * cscale, contentWidth * cscale
        if (height >= contentHeight) then
            self.scrollBar:SetMinMaxValues(0, 0)
            self.scrollBar:Hide()
        else
            self.scrollBar:SetMinMaxValues(0, contentHeight - height)
            self.scrollBar:Show()
        end
        if (width >= contentWidth) then
            self.scrollBarH.SetMinMaxValues(0, 0)
            self.scrollBarH:Hide()
        else
            self.scrollBarH:SetMinMaxValues(0, contentWidth - width)
            self.scrollBarH:Show()
        end
    end
}

-- [[      Constructor     ]] --

local function Constructor()
    local f = CreateFrame("Frame", nil, UIParent)
    f:Show()
    f:EnableMouse(true)

    local editBox = S.GUI:Create("EditBox")
    editBox:SetParent(f)
    editBox:SetPoint("TOPLEFT", f, 10, 0)
    editBox:SetPoint("TOPRIGHT", f, -10, 0)
    editBox:SetHeight(30)
    editBox:SetOnEnterPressed(editBox_OnEnterPressed)

    local scrollFrame = CreateFrame("ScrollFrame", nil, f)
    scrollFrame:SetPoint("TOPLEFT", f, 0, -40)
    scrollFrame:SetPoint("BOTTOMRIGHT", f, -10, 10)
    scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)
    scrollFrame:SetScript("OnSizeChanged", ScrollFrame_SizeChanged)

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

    f.rows = 0
    f.columns = 0
    f.currentSheet = nil
    f.focusedCell = nil
    f.cells = {}

    local widget = {
        frame = f,
        scrollFrame = scrollFrame,
        content = content,
        scrollBar = scrollBar,
        scrollBarH = scrollBarH,
        editBox = editBox,
        type = Type
    }

    for method, func in pairs(methods) do
        widget[method] = func
    end

    return widget

end

S.GUI:RegisterWidgetType("Sheet", Constructor)