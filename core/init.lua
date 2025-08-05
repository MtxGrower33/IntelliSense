SHELL:LOCKED()

-- mainframe
IS = CreateFrame'Frame'
IS:RegisterEvent'PLAYER_ENTERING_WORLD'
IS:RegisterEvent'PLAYER_LOGOUT'
IS:SetScript('OnEvent', function()
    if event == 'PLAYER_ENTERING_WORLD' then
        IS:LoadDBs()
        IS:RunModules()
        print('IntelliSense loaded - V: ' .. info.TOCversion .. ' - open via /int')
    elseif event == 'PLAYER_LOGOUT' then
        IS:SaveDBs()
    end
end)

-- tables
_G.IS_WORDS = {}
_G.IS_CONFIG = {}

IS.TEMPWORDS = {}
IS.TEMPCONFIG = {}

IS.modules = {}
IS.words = {}
IS.stats = {}
IS.gui = {}

-- modules
function IS:NewModule(module, func)
    self.modules[module] = func
    debugprint('NewModule: ' .. module)
end

function IS:RunModules()
    for name, func in pairs(self.modules) do
        debugprint('RunModules - Exec: ' .. name)
        func()
    end
end

-- database
function IS:LoadDBs()
    local currentVersion = info.DBversion
    local savedVersion = _G.IS_CONFIG.dbVersion

    if savedVersion ~= currentVersion or not currentVersion then
        debugprint('LoadDBs - Version mismatch: ' .. tostring(savedVersion) .. ' -> ' .. currentVersion .. ' - Wiping data')
        _G.IS_WORDS = {}
        _G.IS_CONFIG = {dbVersion = currentVersion}
        IS.TEMPWORDS = {}
        IS.TEMPCONFIG = {dbVersion = currentVersion}
    else
        debugprint('LoadDBs - Version match: ' .. currentVersion)
        IS.TEMPWORDS = copy(_G.IS_WORDS)
        IS.TEMPCONFIG = copy(_G.IS_CONFIG)
    end
    debugprint('LoadDBs - copied WORDS: ' .. table.getn(IS.TEMPWORDS))
    debugprint('LoadDBs - copied SETUP: ' .. table.getn(IS.TEMPCONFIG))
end

function IS:SaveDBs()
    _G.IS_WORDS = IS.TEMPWORDS
    _G.IS_CONFIG = IS.TEMPCONFIG
    debugprint('SaveDBs - saved WORDS: ' .. table.getn(_G.IS_WORDS))
    debugprint('SaveDBs - saved SETUP: ' .. table.getn(_G.IS_CONFIG))
end
