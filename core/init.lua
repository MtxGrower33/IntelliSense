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
_G.IS_CONTEXT = {}

IS.TEMPWORDS = {}
IS.TEMPCONFIG = {}
IS.TEMPCONTEXT = {}

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
        _G.IS_CONTEXT = {}
        IS.TEMPWORDS = {}
        IS.TEMPCONFIG = {dbVersion = currentVersion}
        IS.TEMPCONTEXT = {}
    else
        debugprint('LoadDBs - Version match: ' .. currentVersion)
        IS.TEMPWORDS = copy(_G.IS_WORDS)
        IS.TEMPCONFIG = copy(_G.IS_CONFIG)
        IS.TEMPCONTEXT = copy(_G.IS_CONTEXT)
    end
    debugprint('LoadDBs - copied WORDS: ' .. table.getn(IS.TEMPWORDS))
    debugprint('LoadDBs - copied SETUP: ' .. table.getn(IS.TEMPCONFIG))
    debugprint('LoadDBs - copied CONTEXT: ' .. table.getn(IS.TEMPCONTEXT))
end

function IS:SaveDBs()
    _G.IS_WORDS = IS.TEMPWORDS
    _G.IS_CONFIG = IS.TEMPCONFIG
    _G.IS_CONTEXT = IS.TEMPCONTEXT
    debugprint('SaveDBs - saved WORDS: ' .. table.getn(_G.IS_WORDS))
    debugprint('SaveDBs - saved SETUP: ' .. table.getn(_G.IS_CONFIG))
    local contextCount = 0
    if _G.IS_CONTEXT then
        for word1, pairs in _G.IS_CONTEXT do
            for word2, usage in pairs do
                contextCount = contextCount + 1
            end
        end
    end
    debugprint('SaveDBs - saved CONTEXT pairs: ' .. contextCount)
end
