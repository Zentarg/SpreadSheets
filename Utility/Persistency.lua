local AddonName, S = ...
_G.SpreadSheetsDB = _G.SpreadSheetsDB or {}

local SpreadSheetLDB = {}

SpreadSheetLDB["AddonVersion"] = "0.1"

function SpreadSheetLDB:LoadVarChk(name, default)

    if (SpreadSheetsDB[name] and type(SpreadSheetsDB[name]) == "string" and SpreadSheetsDB[name] == "On" or SpreadSheetsDB[name] == "Off") then
        SpreadSheetLDB[name] = SpreadSheetsDB[name]
    else
        SpreadSheetLDB[name] = default
        SpreadSheetsDB[name] = default
    end
end

function SpreadSheetLDB:LoadVarNum(name, default, valMin, valMax)
    if (SpreadSheetsDB[name] and type(SpreadSheetsDB[name]) == "number" and SpreadSheetsDB[name] >= valMin and SpreadSheetsDB[name] <= valMax) then
        SpreadSheetLDB[name] = SpreadSheetsDB[name]
    else
        SpreadSheetLDB[name] = default
        SpreadSheetsDB[name] = default
    end
end

function SpreadSheetLDB:LoadVarString(name, default)
    if (SpreadSheetsDB[name] and type(SpreadSheetsDB[name]) == "string") then
        SpreadSheetLDB[name] = SpreadSheetsDB[name]
    else
        SpreadSheetLDB[name] = default
        SpreadSheetsDB[name] = default
    end
end

function SpreadSheetLDB:LoadVarTable(name, default)
    if (SpreadSheetsDB[name] and type(SpreadSheetsDB[name]) == "table") then
        SpreadSheetLDB[name] = SpreadSheetsDB[name]
    else
        SpreadSheetLDB[name] = default
        SpreadSheetsDB[name] = default
    end
end

function SpreadSheetLDB:SaveVar(name)
    if (SpreadSheetLDB[name]) then
        SpreadSheetsDB[name] = SpreadSheetLDB[name]
    end
end

function SpreadSheetLDB:LoadSavedData()

    self:LoadVarTable("Sheets", {})
    self:LoadVarTable("Categories", {})

    LoadSettings()
end

function SpreadSheetLDB:SaveData()
    self:SaveVar("Sheets")
    self:SaveVar("Categories")
    SaveSettings()
end

function LoadSettings()
    -- Todo
    -- Load all settings into memory
end

function SaveSettings()
    -- Todo
    -- Save all settings to saved variables
end

function SpreadSheetLDB:GetSheet(name)
    if (SpreadSheetLDB["Sheets"]) then
        return SpreadSheetLDB["Sheets"][name]
    end
end

function SpreadSheetLDB:CreateSheet(name, rows, columns)
    while (SpreadSheetLDB["Sheets"][name] ~= nil) do
        local n = tonumber(strsub(name, string.len(name) + 1))
        if (n == nil) then
            n = 1
        else
            n = n + 1
        end
        name = name .. tostring(n)
    end
    local s = {}
    s["name"] = name
    s["cells"] = {}
    s["rows"] = rows
    s["columns"] = columns
    -- for i = 1, rows do
    --     for j = 1, columns do
    --        local c = {}
    --        c["row"] = i
    --        c["column"] = j
    --        c["text"] = ""
    --     end
    -- end

    if (SpreadSheetLDB["Sheets"]) then
        SpreadSheetLDB["Sheets"][name] = s
    end
    return SpreadSheetLDB["Sheets"][name]
end

function SpreadSheetLDB:GetCategories()
    return SpreadSheetLDB["Categories"]
end

S.DB = SpreadSheetLDB