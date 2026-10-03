local sfilter = {
  [" "] = true,
  ["\227\128\130"] = true,
  ["\239\188\140"] = true,
  ["\227\128\129"] = true,
  ["\239\188\155"] = true,
  ["\239\188\154"] = true,
  ["\226\128\153"] = true,
  ["\226\128\152"] = true,
  ["."] = true,
  [","] = true,
  ["/"] = true,
  [";"] = true,
  [":"] = true,
  ["'"] = true
}
local FilterWordsManager = BaseClass("FilterWordsManager")

function FilterWordsManager:__init()
  self.badWordMap = {}
  self.loadFileNames = {}
  self.cursor = 1
end

function FilterWordsManager:getBadWordFileName()
  local lang = ChatInterface.getLanguageName()
  local filename = ""
  if lang ~= "ko" and ChatInterface.isChina() and ChatInterface.checkIsOpenByKey("front_end_badwords") then
    filename = "bad_words_cn.txt"
  elseif lang == "ko" and ChatInterface.checkIsOpenByKey("korean_shielding") then
    filename = "bad_words_kr.txt"
  else
    local thisLang = lang
    local arr = {
      "en",
      "fr",
      "de",
      "ru",
      "th",
      "ja",
      "pt",
      "es",
      "tr",
      "id",
      "it",
      "pl",
      "nl",
      "ar",
      "pr"
    }
    for j = 1, #arr do
      local str = arr[j]
      if string.len(str) <= string.len(lang) then
        local str1 = string.sub(lang, 1, string.len(str))
        if str1 == str then
          thisLang = str
          break
        end
      end
    end
    filename = "bad_words_" .. thisLang .. ".txt"
    local localFile = "local/" .. filename
    if not ChatInterface.isFileExist(localFile) then
      filename = "bad_words_en.txt"
    end
  end
  ChatPrint("\230\149\143\230\132\159\229\173\151\230\150\135\228\187\182:%s", filename)
  return filename
end

function FilterWordsManager:initBadWords()
  local filename = self:getBadWordFileName()
  if filename == "" then
    return
  end
  if self.loadFileNames[filename] then
    return
  end
  self.loadFileNames[filename] = true
  local path = ChatInterface.getFullPath("local/" .. filename)
  local content = io.readfile(path)
  if not content then
    return
  end
  local strList = string.split(content, ",")
  for i = 1, #strList do
    self:addFilterWorld(strList[i])
  end
end

function FilterWordsManager:splitStringToWords(str)
  local words = {}
  for uchar in string.gmatch(str, "[%z\001-\127\194-\244][\128-\191]*") do
    words[#words + 1] = uchar
  end
  return words
end

function FilterWordsManager:addFilterWorld(vals)
  local words = self:splitStringToWords(vals)
  local t = self.badWordMap
  local wordNum = #words
  local pos = 1
  while wordNum >= pos do
    if not t[words[pos]] then
      t[words[pos]] = {}
    end
    if pos == wordNum then
      t[words[pos]].flag = true
    end
    t = t[words[pos]]
    pos = pos + 1
  end
end

function FilterWordsManager:replaceSensitiveWord(words, bIndex, eIndex)
  for i = bIndex, eIndex do
    if sfilter[words[i]] ~= true then
      words[i] = "*"
    end
  end
end

function FilterWordsManager:moveCursor(words)
  self.cursor = self.cursor + 1
  if sfilter[words[self.cursor]] then
    self.cursor = self.cursor + 1
  end
end

function FilterWordsManager:filterSensitiveWord(str)
  local words = self:splitStringToWords(str)
  local existSensitiveWord = false
  local pos = 1
  while pos <= #words do
    self.cursor = pos
    local head = self.badWordMap[words[pos]]
    
    local function getNextWord()
      self:moveCursor(words)
      return head[words[self.cursor]]
    end
    
    while head ~= nil do
      if not head.flag then
        head = getNextWord()
      else
        existSensitiveWord = true
        self:replaceSensitiveWord(words, pos, self.cursor)
        if 1 < table.count(head) then
          head = getNextWord()
        else
          pos = self.cursor
          break
        end
      end
    end
    pos = pos + 1
  end
  local newStr = ""
  if existSensitiveWord then
    for i = 1, #words do
      newStr = newStr .. words[i]
    end
  else
    newStr = str
  end
  return newStr
end

function FilterWordsManager:IsHaveSensitiveWord(str)
  local words = self:splitStringToWords(str)
  local pos = 1
  while pos <= #words do
    self.cursor = pos
    local head = self.badWordMap[words[pos]]
    
    local function getNextWord()
      self:moveCursor(words)
      return head[words[self.cursor]]
    end
    
    while head ~= nil do
      if not head.flag then
        head = getNextWord()
      else
        return true
      end
    end
    pos = pos + 1
  end
  return false
end

return FilterWordsManager
