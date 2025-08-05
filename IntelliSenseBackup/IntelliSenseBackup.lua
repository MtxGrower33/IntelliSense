local _G = getfenv(0)

-- backup storage
_G.ISB_WORDS = {}

-- API interface
_G.ISB_API = {
    Save = function(words)
        if not words then return false end
        _G.ISB_WORDS = {}
        for i = 1, table.getn(words) do
            _G.ISB_WORDS[i] = words[i]
        end
        return true
    end,

    Load = function()
        return _G.ISB_WORDS or {}
    end,

    IsReady = function()
        return true
    end
}