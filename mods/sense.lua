SHELL:LOCKED()

IS:NewModule('Sense', function ()
    local CORE = {
        suggestion = nil,
        measureText = nil,
        framesCreated = false,
        suggestionColor = {0, 1, 1},
        matchBuffer = {}
    }

    local H = {
        searchWordList = function(wordList, lastWordLower, lastWordLen, listType)
            local matches = CORE.matchBuffer
            while table.getn(matches) > 0 do
                table.remove(matches)
            end
            debugprint('searchWordList - Searching ' .. listType .. ' for: ' .. lastWordLower)

            local firstLetter = string.sub(lastWordLower, 1, 1)
            local letterWords = wordList[firstLetter]
            if not letterWords then
                debugprint('searchWordList - No words for letter: ' .. firstLetter)
                return nil
            end

            for i = 1, table.getn(letterWords) do
                local word = letterWords[i]
                local wordLower = string.lower(word)
                if lastWordLen < string.len(word) and string.sub(wordLower, 1, lastWordLen) == lastWordLower then
                    local usage = IS.stats.wordUsage[word] or 0
                    debugprint('searchWordList - Found match: ' .. word .. ' (usage: ' .. usage .. ')')
                    table.insert(matches, {word = word, usage = usage})
                end
            end

            if table.getn(matches) == 0 then
                debugprint('searchWordList - No matches in ' .. listType)
                return nil
            end

            table.sort(matches, function(a, b) return a.usage > b.usage end)
            debugprint('searchWordList - Best match from ' .. listType .. ': ' .. matches[1].word .. ' (usage: ' .. matches[1].usage .. ')')
            return matches[1].word
        end,

        wordExists = function(wordList, targetWord, listType, useGetData)
            local targetLower = string.lower(targetWord)
            local firstLetter = string.sub(targetLower, 1, 1)
            local letterWords = wordList[firstLetter]
            if not letterWords then
                return false
            end

            for i = 1, table.getn(letterWords) do
                local word = letterWords[i]
                if string.lower(word) == targetLower then
                    debugprint('LearnWord - Word exists in ' .. listType)
                    return true
                end
            end
            return false
        end
    }

    function CORE:Initialize()
        IS.stats.completions = IS.stats.completions or (IS.TEMPCONFIG.completions or 0)
        IS.stats.suggestionsShown = IS.stats.suggestionsShown or (IS.TEMPCONFIG.suggestionsShown or 0)
        IS.stats.charactersSaved = IS.stats.charactersSaved or (IS.TEMPCONFIG.charactersSaved or 0)
        IS.stats.wordUsage = IS.stats.wordUsage or (IS.TEMPCONFIG.wordUsage or {})

        self.suggestionColor = IS.TEMPCONFIG.suggestionColor or self.suggestionColor
        IS.TEMPCONFIG.suggestionColor = self.suggestionColor
        if IS.TEMPCONFIG.autoCapitalize == nil and not IS.TEMPCONFIG.autoCapitalizeSet then
            IS.TEMPCONFIG.autoCapitalize = 1
            IS.TEMPCONFIG.autoCapitalizeSet = 1
        end
    end

    function CORE:FindMatch(text)
        local lastWord = string.gsub(text, '.*[%s]+([^%s]*)$', '%1')
        if lastWord == text then
            lastWord = text
        end

        local lastWordLower = string.lower(lastWord)
        local lastWordLen = string.len(lastWord)
        debugprint('FindMatch - Cached lastWord length: ' .. lastWordLen .. ' for word: ' .. lastWord)

        if lastWordLen == 0 then
            debugprint('FindMatch - Early exit: empty lastWord')
            return nil
        end

        local match = H.searchWordList(IS.words, lastWordLower, lastWordLen, 'base words')
        if match then
            return match, lastWord
        end

        if IS.TEMPWORDS then
            local learnedMatch = H.searchWordList(IS.TEMPWORDS, lastWordLower, lastWordLen, 'learned words')
            if learnedMatch then
                return learnedMatch, lastWord
            end
        end
        debugprint('FindMatch - No match found')
        return nil
    end

    function CORE:CreateTxtFrame()
        if self.framesCreated then return end
        assert(ChatFrameEditBox, 'ChatFrameEditBox not available')

        local suggestionFrame = CreateFrame('Frame', nil, UIParent)
        suggestionFrame:SetFrameStrata('TOOLTIP')
        suggestionFrame:SetFrameLevel(ChatFrameEditBox:GetFrameLevel() + 1)

        self.suggestion = suggestionFrame:CreateFontString(nil, 'OVERLAY')
        self.suggestion:SetFontObject(ChatFontNormal)
        self.suggestion:SetTextColor(self.suggestionColor[1], self.suggestionColor[2], self.suggestionColor[3])

        self.measureText = UIParent:CreateFontString(nil, 'OVERLAY')
        self.measureText:SetFontObject(ChatFontNormal)
        self.measureText:Hide()

        self.framesCreated = true
        debugprint 'CreateTxtFrame - UI components created'
    end

    function CORE:ClearSuggestion()
        self.suggestion:ClearAllPoints()
        self.suggestion:SetText('')
    end

    function CORE:ShowSuggestion(text, word, lastWord)
        assert(self.suggestion, 'suggestion UI not created')

        self.measureText:SetText(text)
        local textWidth = self.measureText:GetStringWidth()

        self.suggestion:ClearAllPoints()
        self.suggestion:SetPoint('LEFT', ChatFrameEditBox, 'LEFT', 15 + ChatFrameEditBoxHeader:GetWidth() + textWidth, 0)
        self.suggestion:SetText(string.sub(word, string.len(lastWord) + 1))
    end

    function CORE:LearnWord(text)
        assert(text, 'LearnWord - text parameter is nil')
        debugprint('LearnWord - Processing text: ' .. text)

        local _, _, foundWord = string.find(text, '%*([^%*]+)%*')
        if not foundWord then
            debugprint('LearnWord - No learning pattern found')
            return text
        end

        assert(foundWord and string.len(foundWord) > 0, 'LearnWord - extracted word is empty')
        debugprint('LearnWord - Found word to learn: ' .. foundWord)

        assert(IS.words, 'LearnWord - IS.words is nil')

        local exists = H.wordExists(IS.words, foundWord, 'base dictionary', false)

        if not exists and IS.TEMPWORDS then
            exists = H.wordExists(IS.TEMPWORDS, foundWord, 'learned words', true)
        end

        if not exists then
            if not IS.TEMPWORDS then
                IS.TEMPWORDS = {}
                debugprint('LearnWord - Created IS.TEMPWORDS table')
            end
            local firstLetter = string.lower(string.sub(foundWord, 1, 1))
            if not IS.TEMPWORDS[firstLetter] then
                IS.TEMPWORDS[firstLetter] = {}
            end
            table.insert(IS.TEMPWORDS[firstLetter], foundWord)
            debugprint('LearnWord - Added word to dictionary: ' .. foundWord .. ' (letter: ' .. firstLetter .. ')')
            if IS.OnWordsChanged then IS:OnWordsChanged() end
            if IS.OnStatsChanged then IS:OnStatsChanged() end
        else
            debugprint('LearnWord - Word already exists, skipping: ' .. foundWord)
        end

        local cleanText = string.gsub(text, '%*+([^%*]+)%*+', '%1')
        debugprint('LearnWord - Cleaned text: ' .. cleanText)
        return cleanText
    end

    function CORE:TrackNaturalUsage(text)
        local words = {}
        for word in string.gfind(text, '[^%s]+') do
            table.insert(words, word)
        end

        for i = 1, table.getn(words) do
            local word = words[i]
            if H.wordExists(IS.words, word, 'base words', false) or (IS.TEMPWORDS and H.wordExists(IS.TEMPWORDS, word, 'learned words', false)) then
                IS.stats.wordUsage[word] = (IS.stats.wordUsage[word] or 0) + 1
                IS.TEMPCONFIG.wordUsage = IS.stats.wordUsage
                debugprint('TrackNaturalUsage - Incremented: ' .. word .. ' (usage: ' .. IS.stats.wordUsage[word] .. ')')
            end
        end

        if IS.OnStatsChanged then IS:OnStatsChanged() end
    end

    function CORE:RemoveWord(targetWord)
        assert(targetWord, 'RemoveWord - targetWord is nil')
        assert(IS.TEMPWORDS, 'RemoveWord - IS.TEMPWORDS is nil')

        local targetLower = string.lower(targetWord)
        local firstLetter = string.sub(targetLower, 1, 1)
        local letterWords = IS.TEMPWORDS[firstLetter]
        if not letterWords then
            debugprint('RemoveWord - No words for letter: ' .. firstLetter)
            return
        end

        for i = 1, table.getn(letterWords) do
            local word = letterWords[i]
            if string.lower(word) == targetLower then
                for j = i, table.getn(letterWords) - 1 do
                    letterWords[j] = letterWords[j + 1]
                end
                letterWords[table.getn(letterWords)] = nil
                debugprint('RemoveWord - Removed: ' .. targetWord)
                if IS.OnWordsChanged then IS:OnWordsChanged() end
                if IS.OnStatsChanged then IS:OnStatsChanged() end
                return
            end
        end
        debugprint('RemoveWord - Word not found: ' .. targetWord)
    end

    function CORE:ShouldCapitalize(text, wordPosition)
        debugprint('ShouldCapitalize - wordPosition: ' .. wordPosition .. ', text: "' .. text .. '"')
        if wordPosition == 1 then
            debugprint('ShouldCapitalize - Start of text, should capitalize')
            return true
        end
        local beforeWord = string.sub(text, 1, wordPosition - 1)
        local foundPunctuation = string.find(beforeWord, '[%.%?%!]%s*$')
        debugprint('ShouldCapitalize - beforeWord: "' .. beforeWord .. '", foundPunctuation: ' .. (foundPunctuation and 'true' or 'false'))
        return foundPunctuation
    end

    function CORE:ProcessWordCase(matchedWord, lastWord, text, wordPosition)
        debugprint('ProcessWordCase - matchedWord: "' .. matchedWord .. '", lastWord: "' .. lastWord .. '", autoCapitalize: ' .. (IS.TEMPCONFIG.autoCapitalize and 'true' or 'false'))
        if not IS.TEMPCONFIG.autoCapitalize then
            local result = lastWord .. string.sub(matchedWord, string.len(lastWord) + 1)
            debugprint('ProcessWordCase - Auto-capitalize OFF, result: "' .. result .. '"')
            return result
        end

        if self:ShouldCapitalize(text, wordPosition) then
            local firstChar = string.upper(string.sub(matchedWord, 1, 1))
            local restOfWord = string.sub(matchedWord, 2)
            local result = firstChar .. restOfWord
            debugprint('ProcessWordCase - Should capitalize, result: "' .. result .. '"')
            return result
        else
            debugprint('ProcessWordCase - No capitalization needed, result: "' .. matchedWord .. '"')
            return matchedWord
        end
    end

    function CORE:Hook()
        if not ChatFrameEditBox then
            debugprint 'Hook - ChatFrameEditBox not ready'
            return
        end
        debugprint 'Hook - ChatFrameEditBox ready'

        local originalOnTextChanged = _G.ChatEdit_OnTextChanged
        local originalOnTabPressed = _G.ChatEdit_OnTabPressed
        local originalOnEscapePressed = _G.ChatEdit_OnEscapePressed
        local originalOnEnterPressed = _G.ChatEdit_OnEnterPressed

        _G.ChatEdit_OnTextChanged = function()
            if originalOnTextChanged then originalOnTextChanged() end

            local text = ChatFrameEditBox:GetText()
            local word, lastWord = self:FindMatch(text)
            if word and lastWord then
                IS.stats.suggestionsShown = IS.stats.suggestionsShown + 1
                IS.TEMPCONFIG.suggestionsShown = IS.stats.suggestionsShown
                if IS.OnStatsChanged then IS:OnStatsChanged() end
                self:ShowSuggestion(text, word, lastWord)
            else
                self:ClearSuggestion()
            end
        end

        _G.ChatEdit_OnTabPressed = function()
            local text = ChatFrameEditBox:GetText()
            local word, lastWord = self:FindMatch(text)
            if word then
                IS.stats.completions = IS.stats.completions + 1
                IS.TEMPCONFIG.completions = IS.stats.completions

                local savedChars = string.len(word) - string.len(lastWord)
                IS.stats.charactersSaved = IS.stats.charactersSaved + savedChars
                IS.TEMPCONFIG.charactersSaved = IS.stats.charactersSaved

                IS.stats.wordUsage[word] = (IS.stats.wordUsage[word] or 0) + 1
                IS.TEMPCONFIG.wordUsage = IS.stats.wordUsage
                if IS.OnStatsChanged then IS:OnStatsChanged() end

                local wordPosition = string.len(text) - string.len(lastWord) + 1
                local finalWord = self:ProcessWordCase(word, lastWord, text, wordPosition)
                local newText = string.sub(text, 1, string.len(text) - string.len(lastWord)) .. finalWord .. ' '
                ChatFrameEditBox:SetText(newText)
                return
            end
            if originalOnTabPressed then originalOnTabPressed() end
        end

        _G.ChatEdit_OnEscapePressed = function()
            if originalOnEscapePressed then originalOnEscapePressed(ChatFrameEditBox) end
            self:ClearSuggestion()
        end

        _G.ChatEdit_OnEnterPressed = function()
            debugprint 'ChatEdit_OnEnterPressed'
            local text = ChatFrameEditBox:GetText()

            -- track natural word usage
            self:TrackNaturalUsage(text)

            local cleanText = self:LearnWord(text)
            if cleanText ~= text then
                ChatFrameEditBox:SetText(cleanText)
            end

            if originalOnEnterPressed then originalOnEnterPressed(ChatFrameEditBox) end
            self:ClearSuggestion()
        end
    end

    CORE:Initialize()
    CORE:CreateTxtFrame()
    CORE:Hook()

    -- expose
    function IS:RemoveLearnedWord(targetWord)
        return CORE:RemoveWord(targetWord)
    end

    function IS:UpdateSuggestionColor(color)
        if CORE.suggestion then
            CORE.suggestion:SetTextColor(color[1], color[2], color[3])
        end
    end
end)
