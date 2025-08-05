SHELL:LOCKED()

local words = {
    -- basic existing
    'hello', 'wow', 'there', 'world',

    -- common verbs
    'go', 'come', 'take', 'give', 'make', 'get', 'see', 'know', 'think', 'look',
    'use', 'find', 'work', 'call', 'try', 'ask', 'need', 'feel', 'become', 'leave',
    'put', 'mean', 'keep', 'let', 'begin', 'seem', 'turn', 'start',
    'show', 'hear', 'play', 'live', 'believe', 'bring', 'happen', 'write',
    'want', 'like', 'love', 'hate', 'prefer', 'wish', 'hope', 'expect', 'plan', 'remember',
    'eat', 'drink', 'sleep', 'wake', 'pay', 'cost', 'spend', 'save',
    'open', 'close', 'stop', 'wait', 'sit', 'stand', 'lie', 'rest', 'carry', 'hold',
    'push', 'pull', 'throw', 'catch', 'drop', 'pick', 'lift', 'break', 'fix', 'build',
    'learn', 'teach', 'understand', 'forget', 'decide', 'choose', 'agree', 'disagree',
    'meet', 'visit', 'stay', 'return', 'send', 'receive', 'win', 'lose', 'fight', 'hurt', 'help',
    'wash', 'cook', 'prepare', 'wear', 'dress', 'cut', 'grow', 'plant',
    'click', 'type', 'download', 'upload', 'connect', 'disconnect', 'charge', 'install',

    -- communication verbs
    'say', 'tell', 'speak', 'talk', 'whisper', 'shout', 'yell', 'announce', 'explain', 'describe',
    'discuss', 'mention', 'reply', 'answer', 'respond', 'communicate', 'express', 'share', 'inform', 'notify',

    -- movement verbs
    'walk', 'jump', 'travel', 'ride', 'fly', 'swim', 'climb', 'crawl',
    'dance', 'step', 'march', 'rush', 'hurry', 'wander', 'explore', 'follow', 'chase', 'escape',

    -- essential nouns
    'hand', 'head', 'eye', 'arm', 'leg', 'foot', 'body', 'face', 'hair', 'mouth',
    'mother', 'father', 'brother', 'sister', 'family', 'friend', 'child', 'parent', 'wife', 'husband',
    'day', 'night', 'hour', 'minute', 'time', 'week', 'month', 'year', 'morning', 'evening',
    'home', 'work', 'school', 'house', 'room', 'door', 'window', 'table', 'chair', 'bed',
    'water', 'food', 'money', 'book', 'car', 'phone', 'game', 'music', 'movie',

    -- common adjectives
    'red', 'blue', 'green', 'black', 'white', 'yellow', 'brown', 'orange', 'purple', 'pink',
    'big', 'small', 'large', 'tiny', 'huge', 'little', 'long', 'short', 'tall', 'wide',
    'happy', 'sad', 'angry', 'excited', 'tired', 'scared', 'surprised', 'worried', 'calm', 'nervous',
    'good', 'bad', 'nice', 'great', 'awesome', 'terrible', 'wonderful', 'amazing', 'perfect', 'horrible',
    'hot', 'cold', 'warm', 'cool', 'dry', 'wet', 'dirty', 'full', 'empty',

    -- comparative and superlative forms
    'bigger', 'biggest', 'smaller', 'smallest', 'larger', 'largest', 'longer', 'longest', 'shorter', 'shortest',
    'taller', 'tallest', 'wider', 'widest', 'happier', 'happiest', 'sadder', 'saddest', 'angrier', 'angriest',
    'better', 'best', 'worse', 'worst', 'nicer', 'nicest', 'greater', 'greatest', 'hotter', 'hottest',
    'colder', 'coldest', 'warmer', 'warmest', 'cooler', 'coolest', 'drier', 'driest', 'wetter', 'wettest',
    'dirtier', 'dirtiest', 'fuller', 'fullest', 'emptier', 'emptiest', 'faster', 'fastest', 'slower', 'slowest',

    -- pronouns
    'you', 'he', 'she', 'it', 'we', 'they', 'me', 'him', 'her',
    'us', 'them', 'my', 'your', 'his', 'its', 'our', 'their', 'mine',

    -- articles and auxiliary verbs
    'the', 'an', 'is', 'am', 'are', 'was', 'were', 'be', 'been', 'being',

    -- prepositions
    'in', 'on', 'at', 'under', 'over', 'above', 'below', 'beside', 'behind', 'front',
    'between', 'among', 'through', 'across', 'around', 'near', 'far', 'inside', 'outside', 'within',

    -- conjunctions
    'and', 'but', 'or', 'because', 'so', 'if', 'when', 'while', 'although', 'unless',
    'since', 'until', 'before', 'after', 'though', 'however', 'therefore', 'moreover', 'furthermore', 'nevertheless',

    -- numbers
    'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten',
    'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',

    -- quantities
    'some', 'many', 'few', 'all', 'most', 'several', 'enough', 'more', 'less', 'much',

    -- question words
    'what', 'where', 'when', 'why', 'how', 'who', 'which', 'whose', 'whom', 'whatever', 'question',

    -- common adverbs
    'now', 'then', 'always', 'never', 'often', 'sometimes', 'usually', 'rarely', 'today', 'tomorrow',
    'yesterday', 'here', 'there', 'everywhere', 'nowhere', 'quickly', 'slowly', 'well', 'badly', 'carefully',
    'soon', 'late', 'early', 'fast', 'slow', 'quick', 'yes', 'no', 'maybe', 'please',
    'thanks', 'sorry', 'excuse', 'welcome',

    -- top 100 basic english words
    'be', 'have', 'do', 'will', 'would', 'could', 'should', 'can', 'may', 'might',
    'this', 'that', 'these', 'those', 'with', 'from', 'for', 'to', 'of', 'as',
    'by', 'up', 'out', 'about', 'into', 'just', 'only', 'first', 'last', 'new',
    'old', 'right', 'left', 'way', 'back', 'down', 'off', 'other', 'same', 'different',
    'each', 'every', 'any', 'no', 'not', 'very', 'too', 'also', 'even', 'still',
    'again', 'once', 'twice', 'next', 'part', 'place', 'thing', 'person', 'people', 'man',
    'woman', 'boy', 'girl', 'life', 'country', 'state', 'city', 'town', 'area',
    'side', 'end', 'point', 'line', 'number', 'fact', 'case', 'problem',
    'answer', 'reason', 'idea', 'kind', 'type', 'sort', 'example', 'group', 'company', 'system',
    'program', 'service', 'information', 'name', 'word', 'story', 'news', 'report', 'study',

    -- luxury words
    'analyze', 'synthesize', 'evaluate', 'implement', 'negotiate', 'strategy', 'magnificent', 'extraordinary', 'sophisticated', 'elaborate',
    'computer', 'internet', 'software', 'technology', 'digital', 'virtual', 'online', 'website', 'database', 'network',
    'business', 'professional', 'corporate', 'management', 'leadership', 'innovation', 'development', 'research', 'analysis', 'solution',
    'education', 'knowledge', 'wisdom', 'intelligence', 'creativity', 'imagination', 'inspiration', 'motivation', 'achievement', 'success',
    'beautiful', 'gorgeous', 'stunning', 'elegant', 'graceful', 'charming', 'delightful', 'pleasant', 'comfortable', 'luxurious',
    'adventure', 'journey', 'experience', 'discovery', 'exploration', 'challenge', 'opportunity', 'possibility', 'potential', 'future',
    'relationship', 'friendship', 'partnership', 'collaboration', 'cooperation', 'communication', 'understanding', 'respect', 'trust', 'loyalty',
    'environment', 'nature', 'universe', 'planet', 'earth', 'ocean', 'mountain', 'forest', 'desert', 'sky',
    'culture', 'tradition', 'history', 'heritage', 'civilization', 'society', 'community', 'population', 'generation', 'democracy',

    -- wow classes
    'warrior', 'paladin', 'hunter', 'rogue', 'priest', 'shaman', 'mage', 'warlock', 'druid',

    -- wow races
    'human', 'dwarf', 'gnome', 'elf', 'orc', 'troll', 'tauren', 'undead', 'nightelf', 'forsaken',

    -- wow cities
    'stormwind', 'ironforge', 'darnassus', 'orgrimmar', 'thunderbluff', 'undercity', 'goldshire', 'crossroads', 'gadgetzan', 'booty',

    -- wow zones
    'elwynn', 'westfall', 'redridge', 'duskwood', 'stranglethorn', 'barrens', 'mulgore', 'durotar', 'tirisfal', 'silverpine',
    'hillsbrad', 'arathi', 'wetlands', 'badlands', 'searing', 'tanaris', 'azshara', 'felwood', 'winterspring', 'moonglade',
    'darkshore', 'ashenvale', 'desolace', 'feralas', 'thousand', 'needles', 'stonetalon', 'dustwallow', 'swamp', 'sorrows',

    -- wow dungeons
    'deadmines', 'wailing', 'caverns', 'shadowfang', 'keep', 'stockade', 'gnomeregan', 'razorfen', 'kraul', 'downs',
    'scarlet', 'monastery', 'uldaman', 'zulfarrak', 'maraudon', 'temple', 'sunken', 'blackrock', 'depths', 'spire',
    'dire', 'maul', 'scholomance', 'stratholme', 'molten', 'core', 'onyxia', 'lair', 'blackwing',

    -- wow items
    'sword', 'axe', 'mace', 'dagger', 'bow', 'gun', 'crossbow', 'staff', 'wand', 'shield',
    'helmet', 'chestplate', 'leggings', 'boots', 'gloves', 'bracers', 'belt', 'cloak', 'ring', 'necklace',
    'common', 'uncommon', 'rare', 'epic', 'legendary', 'artifact', 'poor', 'white', 'green', 'blue',
    'purple', 'orange', 'potion', 'elixir', 'flask', 'scroll', 'reagent', 'herb', 'ore', 'gem', 'gear',

    -- wow spells
    'heal', 'fireball', 'frostbolt', 'lightning', 'bolt', 'charge', 'backstab', 'stealth', 'vanish', 'sap',
    'polymorph', 'counterspell', 'dispel', 'purify', 'cleanse', 'blessing', 'curse', 'fear', 'charm', 'sleep',
    'resurrection', 'revive', 'teleport', 'portal', 'summon', 'banish', 'shield', 'armor', 'weapon', 'enchant',
    'buff', 'debuff', 'dot', 'hot', 'aura', 'totem',

    -- wow npcs
    'thrall', 'jaina', 'bolvar', 'magni', 'tyrande', 'malfurion', 'cairne', 'sylvanas', 'voljin', 'rexxar',
    'ragnaros', 'onyxia', 'nefarian', 'chromaggus', 'baron', 'geddon', 'garr', 'sulfuron', 'golemagg', 'domo',

    -- wow mechanics
    'aggro', 'tank', 'dps', 'healer', 'damage', 'threat', 'taunt', 'pull', 'wipe',
    'party', 'raid', 'guild', 'group', 'member', 'leader', 'officer', 'invite', 'kick', 'promote',
    'battleground', 'honor', 'pvp', 'pve', 'alliance', 'horde', 'faction', 'reputation', 'standing', 'exalted',
    'auction', 'house', 'trade', 'vendor', 'gold', 'silver', 'copper', 'mail',
    'level', 'experience', 'talent', 'skill', 'profession', 'training', 'quest', 'objective', 'reward', 'complete'
}

-- expose
IS.words = words