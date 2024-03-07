
local function loadLocaleFile(locale)
    local resourceName = GetCurrentResourceName()
    local file = LoadResourceFile(resourceName, ("locales/%s.lua"):format(locale))
    if not file then
        file = LoadResourceFile(resourceName, "locales/en.lua")
        CreateThread(function()
            print(("Locale file \"%s\" not found, falling back to default \"en\"."):format(locale))
        end)
    end
    return file
end


local function loadLocale(locale)
    local file = loadLocaleFile(locale)
    local data, err = load(file)
    if err then
        print(err)
        error(err)
    end
    return data()
end


locales = loadLocale(Config.Locale or "en")


function _t(key, ...)
    local keys = {}
    for k in string.gmatch(key, "[^.]+") do
        table.insert(keys, k)
    end
    local currentTable = locales
    for _, k in ipairs(keys) do
        currentTable = currentTable[k]
        if not currentTable then
            return key
        end
    end
    if type(currentTable) == "string" then
        return currentTable:format(...)
    else
        return key
    end
end
