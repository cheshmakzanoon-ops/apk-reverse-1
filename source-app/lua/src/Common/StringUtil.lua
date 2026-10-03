local unpack = unpack or table.unpack

local function split(split_string, pattern, search_pos_begin, plain)
  search_pos_begin = search_pos_begin or 1
  if type(plain) ~= "boolean" then
    plain = true
  end
  local split_result = {}
  assert(type(split_string) == "string")
  assert(type(pattern) == "string" and 0 < #pattern)
  pattern = pattern or ","
  if type(split_string) ~= "string" then
    return split_result
  end
  while true do
    local find_pos_begin, find_pos_end = string.find(split_string, pattern, search_pos_begin, plain)
    if not find_pos_begin then
      break
    end
    local cur_str = ""
    if search_pos_begin < find_pos_begin then
      cur_str = string.sub(split_string, search_pos_begin, find_pos_begin - 1)
    end
    split_result[#split_result + 1] = cur_str
    search_pos_begin = find_pos_end + 1
  end
  if search_pos_begin <= string.len(split_string) then
    split_result[#split_result + 1] = string.sub(split_string, search_pos_begin)
  else
    split_result[#split_result + 1] = ""
  end
  return split_result
end

function join(join_table, joiner)
  return table.concat(join_table, joiner)
end

function contains(target_string, pattern, plain)
  if type(plain) ~= "boolean" then
    plain = true
  end
  local find_pos_begin, find_pos_end = string.find(target_string, pattern, 1, plain)
  return find_pos_begin ~= nil
end

function startswith(target_string, str)
  local find_pos_begin, find_pos_end = string.find(target_string, str, 1, true)
  return find_pos_begin == 1
end

function endswith(target_string, str)
  local find_pos_begin, find_pos_end = string.find(target_string, str, -#str, true)
  return find_pos_end == #target_string
end

local function GetIndonesianNum(value)
  local Localization = CS.GameEntry.Localization
  local LanguageType = CS.GameFramework.Localization.Language
  if Localization.Language == LanguageType.Indonesian or Localization.Language == LanguageType.German then
    value = string.gsub(value, ",", "TEMP_COMMA")
    value = string.gsub(value, "%.", ",")
    value = string.gsub(value, "TEMP_COMMA", ".")
  end
  return value
end

local function GetFormattedStr0(value)
  local unit = ""
  if value < 0 then
    value = -value
    unit = "-"
  end
  local kVal = value / 100
  local mVal = value / 100000
  local gVal = value / 100000000
  if 10 <= gVal then
    local num = math.floor(gVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.0fG", unit, num))
  end
  if 10 <= mVal then
    local num = math.floor(mVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.0fM", unit, num))
  end
  if 10 <= kVal then
    local num = math.floor(kVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.0fK", unit, num))
  end
  return GetIndonesianNum(string.format("%s%d", unit, math.floor(value)))
end

local function GetFormattedStr(value)
  local unit = ""
  if value == nil then
    return ""
  end
  if value < 0 then
    value = -value
    unit = "-"
  end
  local kVal = value / 100
  local mVal = value / 100000
  local gVal = value / 100000000
  if 10 <= gVal then
    local num = math.floor(gVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.1fG", unit, num))
  end
  if 10 <= mVal then
    local num = math.floor(mVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.1fM", unit, num))
  end
  if 10 <= kVal then
    local num = math.floor(kVal)
    num = num / 10
    return GetIndonesianNum(string.format("%s%.1fK", unit, num))
  end
  return GetIndonesianNum(string.format("%s%d", unit, math.floor(value)))
end

local function GetFormattedStr2(value)
  local unit = ""
  if value < 0 then
    value = -value
    unit = "-"
  end
  local kVal = value / 10
  local mVal = value / 10000
  local gVal = value / 10000000
  if 100 <= gVal then
    local num = math.floor(gVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.2fG", unit, num))
  end
  if 100 <= mVal then
    local num = math.floor(mVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.2fM", unit, num))
  end
  if 100 <= kVal then
    local num = math.floor(kVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.2fK", unit, num))
  end
  return GetIndonesianNum(string.format("%s%d", unit, math.floor(value)))
end

local function GetFormattedSeparatorNum(n)
  if n == nil or n == "" or n == 0 then
    return "0"
  end
  local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")
  if left == nil or num == nil or right == nil then
    return "0"
  end
  return GetIndonesianNum(left .. num:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. right)
end

local function GetFormattedGiga2(value)
  local unit = ""
  if value < 0 then
    value = -value
    unit = "-"
  end
  local kVal = value / 10
  local mVal = value / 10000
  local gVal = value / 10000000
  if 100 <= gVal then
    local num = math.floor(gVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.2fG", unit, num))
  end
  if 100 <= mVal then
    local num = math.floor(mVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.0fM", unit, num))
  end
  if 100 <= kVal then
    local num = math.floor(kVal)
    num = num / 100
    return GetIndonesianNum(string.format("%s%.0fK", unit, num))
  end
  return GetIndonesianNum(string.format("%s%d", unit, math.floor(value)))
end

local function GetFormattedSpecial(value)
  if 1000000 <= value then
    return string.GetFormattedStr(value)
  else
    return string.GetFormattedSeperatorNum(math.floor(value))
  end
end

local function GetFormattedGoldNum(value)
  if 100000 <= value then
    return string.GetFormattedStr(value)
  else
    return string.GetFormattedSeperatorNum(math.floor(value))
  end
end

local function GetFloatStr(value)
  if value == 0 then
    return "0"
  end
  return GetIndonesianNum(string.format("%.1f", value))
end

local function GetFormattedPercentStr(value)
  value = value * 100
  return GetIndonesianNum(string.format("%.1f", value) .. "%")
end

local function GetFormattedPercentTwoDecimalStr(value)
  value = value * 100
  return GetIndonesianNum(string.format("%.2f", value) .. "%")
end

local function GetFormattedThousandthStr(value)
  value = value * 1000
  return GetIndonesianNum(string.format("%.1f", value) .. "\226\128\176")
end

local function IsNullOrEmpty(str)
  if str == nil or str == "" then
    return true
  end
  return false
end

function string.findlast(s, pattern, plain)
  local curr = 0
  repeat
    local next = s:find(pattern, curr + 1, plain)
    if next then
      curr = next
    end
  until not next
  if 0 < curr then
    return curr
  end
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function string.TryGetValue(value1, value2, value3)
  if value1 ~= nil and value1 ~= "" then
    return value1
  end
  if value2 ~= nil and value2 ~= "" then
    return value2
  end
  return value3
end

function string.IsNullOrEmpty(value)
  if value == nil or value == "" then
    return true
  end
  return false
end

local function at(str, pos)
  return string.sub(str, pos, pos)
end

local function word_count(input)
  local len = string.len(input)
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 do
    local tmp = string.byte(input, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        break
      end
      i = i - 1
    end
    cnt = cnt + 1
  end
  return cnt
end

local function string2table_ii(str, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = math.tointeger(ts2[1])
      local v = math.tointeger(ts2[2])
      if k and v then
        t[k] = v
      end
    end
  end
  return t
end

local function string2table_ii_toList(str, sep1, sep2, list)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = list or {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = math.tointeger(ts2[1])
      local v = math.tointeger(ts2[2])
      if k and v then
        table.insert(t, {k, v})
      end
    end
  end
  return t
end

local function string2table_ss(str, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = tostring(ts2[1])
      local v = tostring(ts2[2])
      if k and v then
        t[k] = v
      end
    end
  end
  return t
end

local function string2table_si(str, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = tostring(ts2[1])
      local v = math.tointeger(ts2[2])
      if k and v then
        t[k] = v
      end
    end
  end
  return t
end

local function string2table_is(str, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = math.tointeger(ts2[1])
      local v = tostring(ts2[2])
      if k and v then
        t[k] = v
      end
    end
  end
  return t
end

local function string2table_sf(str, sep1, sep2)
  sep1 = sep1 or ";"
  sep2 = sep2 or "="
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    if ts2 and #ts2 == 2 then
      local k = tostring(ts2[1])
      local v = tonumber(ts2[2])
      if k and v then
        t[k] = v
      end
    end
  end
  return t
end

local function string2array_i(str, sep1, sep2)
  sep1 = sep1 or ","
  sep2 = sep2 or "|"
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local t2 = {}
    local ts2 = string.split(v, sep1)
    if ts2 then
      for _, v in ipairs(ts2) do
        table.insert(t2, toInt(v))
      end
    end
    table.insert(t, t2)
  end
  return t
end

local function string2array_num(str, sep1, sep2)
  sep1 = sep1 or ","
  sep2 = sep2 or "|"
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local t2 = {}
    local ts2 = string.split(v, sep1)
    if ts2 then
      for _, v in ipairs(ts2) do
        table.insert(t2, tonumber(v))
      end
    end
    table.insert(t, t2)
  end
  return t
end

local function string2array_i_oneSep(str, sep)
  sep = sep or "|"
  local t = {}
  local ts = string.split(str, sep)
  for _, v in ipairs(ts) do
    table.insert(t, toInt(v))
  end
  return t
end

local function string2array_num_oneSep(str, sep)
  sep = sep or "|"
  local t = {}
  local ts = string.split(str, sep)
  for _, v in ipairs(ts) do
    table.insert(t, tonumber(v))
  end
  return t
end

local function string2array_s(str, sep1, sep2)
  sep1 = sep1 or ","
  sep2 = sep2 or "|"
  local t = {}
  local ts = string.split(str, sep2)
  for _, v in ipairs(ts) do
    local ts2 = string.split(v, sep1)
    table.insert(t, ts2 or {})
  end
  return t
end

local function SliceToInt(str, beg_pos, end_pos)
  local sign = 1
  local Base = 0
  local i = beg_pos
  end_pos = end_pos or string.len(str)
  local t = str:at(i)
  while t == " " do
    i = i + 1
    t = str:at(i)
  end
  if t == "-" or t == "+" then
    sign = 1 - 2 * (t == "-" and 1 or 0)
    i = i + 1
  end
  t = str:at(i)
  while end_pos >= i and t ~= nil and "0" <= t and t <= "9" do
    if Base > math.maxinteger / 10 or Base == math.maxinteger / 10 and t - "0" > 7 then
      if sign == 1 then
        return math.maxinteger
      else
        return math.mininteger
      end
    end
    Base = 10 * Base + math.floor(t - "0")
    i = i + 1
    t = str:at(i)
  end
  return Base * sign
end

local function string2_ii(str, sep)
  local pos = string.find(str, sep)
  if pos == nil then
    return toInt(str), 0
  end
  local a = SliceToInt(str, 1, pos - 1)
  local b = SliceToInt(str, pos + 1)
  return a, b
end

local function _split_ss(str, sep)
  return string.split_ss(str, sep)
end

local function _split_ss_array(str, sep)
  return string.split_ss_array(str, sep)
end

local function GetBytes(char)
  if not char then
    return 0
  end
  local code = string.byte(char)
  if code < 127 then
    return 1
  elseif code <= 223 then
    return 2
  elseif code <= 239 then
    return 3
  elseif code <= 247 then
    return 4
  else
    return 0
  end
end

local function SubStr(str, startIndex, endIndex)
  local tempStr = str
  local byteStart = 1
  local byteEnd = -1
  local index = 0
  local bytes = 0
  startIndex = math.max(startIndex, 1)
  endIndex = endIndex or -1
  while 0 < string.len(tempStr) do
    if index == startIndex - 1 then
      byteStart = bytes + 1
    elseif index == endIndex then
      byteEnd = bytes
      break
    end
    bytes = bytes + GetBytes(tempStr)
    tempStr = string.sub(str, bytes + 1)
    index = index + 1
  end
  return string.sub(str, byteStart, byteEnd)
end

local function cleanNestingTag(txt, tagName)
  local tagStart = "<" .. tagName
  local tagEnd = "</" .. tagName .. ">"
  local lineTbl1 = split(txt, tagStart, 1, true)
  local lineTbl2 = {}
  for _, v in ipairs(lineTbl1) do
    local _, count = string.gsub(v, tagEnd, "")
    if 1 < count then
      local lineTbl3 = split(v, tagEnd, 1, true)
      local item = table.remove(lineTbl3)
      v = join(lineTbl3, "") .. tagEnd .. item
      local cut = string.find(v, ">", 1, true)
      v = string.sub(v, cut + 1)
      while 1 < count do
        item = table.remove(lineTbl2)
        if 2 < count then
          v = string.sub(item, string.find(item, ">", 1, true) + 1) .. v
        else
          v = item .. v
        end
        count = count - 1
      end
      table.insert(lineTbl2, v)
    else
      table.insert(lineTbl2, v)
    end
  end
  return join(lineTbl2, tagStart)
end

local function insert(str, index, insertStr, flag)
  if flag and string.find(str, flag) ~= nil then
    index = index + #flag
  end
  local pre = string.sub(str, 1, index - 1)
  local tail = string.sub(str, index, -1)
  local createStr = string.format("%s%s%s", pre, insertStr, tail)
  return createStr
end

local function removeByIndex(str, index, indexEnd)
  local pre = string.sub(str, 1, index - 1)
  local tail = string.sub(str, indexEnd + 1, -1)
  local createStr = string.format("%s%s", pre, tail)
  return createStr
end

local function wordIndexToLenIndex(input, wordIndex)
  local lenIndex = 0
  local len = string.len(input)
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 and wordIndex > cnt do
    local tmp = string.byte(input, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        lenIndex = lenIndex + i
        break
      end
      i = i - 1
    end
    cnt = cnt + 1
  end
  return lenIndex
end

local function charIndexToWordIndex(input, targetCharIndex)
  local charIndex = 0
  local wordIndex = 0
  local len = string.len(input)
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 and targetCharIndex > charIndex do
    local tmp = string.byte(input, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        wordIndex = wordIndex + 1
        if 4 <= i then
          charIndex = charIndex + 2
          break
        end
        charIndex = charIndex + 1
        break
      end
      i = i - 1
    end
  end
  return wordIndex
end

local function wordIndexToCharIndex(input, targetWordIndex)
  local charIndex = 0
  local wordIndex = 0
  local len = string.len(input)
  local left = len
  local cnt = 0
  local arr = {
    0,
    192,
    224,
    240,
    248,
    252
  }
  while left ~= 0 and targetWordIndex > wordIndex do
    local tmp = string.byte(input, -left)
    local i = #arr
    while arr[i] do
      if tmp >= arr[i] then
        left = left - i
        wordIndex = wordIndex + 1
        if i == #arr then
          charIndex = charIndex + 2
          break
        end
        charIndex = charIndex + 1
        break
      end
      i = i - 1
    end
  end
  return charIndex
end

local NUMBERIC_UNIT = {
  [1] = "",
  [2] = "K",
  [3] = "M",
  [4] = "B"
}
local floor = math.floor

local function numbericFormationWithPrefix(value, digits, sep)
  digits = digits or 5
  digits = math.max(digits, 1)
  local sign = ""
  if value < 0 then
    value = -value
    sign = "-"
  end
  value = floor(value)
  local judge = 1
  for i = 1, digits do
    judge = judge * 10
  end
  local unitIdx = 1
  local remainder = 0
  while value >= judge and 1000 <= value and unitIdx < #NUMBERIC_UNIT do
    remainder = value % 1000
    value = floor(value / 1000)
    unitIdx = unitIdx + 1
  end
  local str = tostring(value)
  local fillDigits = digits - string.len(str)
  if sep then
    local count = floor((string.len(str) - 1) / 3)
    for i = 1, count do
      local index = string.len(str) - i * 3 + 1 - (i - 1)
      str = string.insert(str, index, sep)
    end
  end
  if 0 < fillDigits and 1 < unitIdx then
    str = str .. "."
    str = str .. string.sub(string.format("%03d", remainder), 1, fillDigits)
  end
  return sign .. str .. NUMBERIC_UNIT[unitIdx]
end

local abs = math.abs

local function formatDecimal(val, n)
  local sign = 1
  if val < 0 then
    sign = -1
  end
  local n = 10 ^ (n or 1)
  val = abs(tonumber(val))
  return tostring(sign * floor(val * n) / n)
end

function string.formatDecimalDown(val, n)
  local sign = 1
  if val < 0 then
    sign = -1
  end
  local integerPart, decimalPart = math.modf(val)
  if 0 < n then
    decimalPart = math.floor(decimalPart * 10 ^ n) / 10 ^ n
  else
    decimalPart = 0
  end
  local result = integerPart + decimalPart
  if decimalPart == 0 then
    return integerPart
  end
  return result
end

local toolTable = {}

local function fast_concat(...)
  for i = 1, select("#", ...) do
    toolTable[i] = select(i, ...)
  end
  local res = table.concat(toolTable)
  for i = 1, select("#", ...) do
    toolTable[i] = nil
  end
  return res
end

local function percentage(numerator, denominator, accuracy)
  local a = tonumber(numerator) or 0
  local b = tonumber(denominator) or 0
  if a <= 0 or b <= 0 then
    return "0%"
  end
  if a >= b then
    return "100%"
  end
  local c = toInt(accuracy)
  if c == 0 then
    return math.floor(a * 100 / b) .. "%"
  end
  local base = tonumber("1e-" .. c + 2)
  return math.floor(math.max(a / b, base) * 10 ^ (c + 2)) / 10 ^ c .. "%"
end

function string.removeExtraDecimals(theNum)
  local ret = theNum
  pcall(function()
    local left, num, right = string.match(theNum, "([^%d]*%d)(%d*)([.]?%d*%%?)$")
    if right == ".0" or right == ".00" or right == ".000" then
      ret = left .. num
    elseif right == ".0%" or right == ".00%" or right == ".000%" then
      ret = left .. num .. "%"
    end
  end)
  return ret
end

function string.filterRichTextSize(text)
  local replaceText, number = string.gsub(text, "<size=[0-9]+>(.-)</size>", "%1")
  if 0 < number then
    return replaceText
  else
    return text
  end
end

function string.filterRichTextBold(text)
  local replaceText, number = string.gsub(text, "<b>(.-)</b>", "%1")
  if 0 < number then
    return replaceText
  else
    return text
  end
end

function string.filterRichTextColor(text)
  local replaceText, number = string.gsub(text, "<color=#[a-zA-Z0-9]+>(.-)</color>", "%1")
  if 0 < number then
    return replaceText
  else
    return text
  end
end

function string.filterRichTextItalic(text)
  local replaceText, number = string.gsub(text, "<i>(.-)</i>", "%1")
  if 0 < number then
    return replaceText
  else
    return text
  end
end

function string.filterRichText(text)
  text = string.filterRichTextSize(text)
  text = string.filterRichTextBold(text)
  text = string.filterRichTextColor(text)
  text = string.filterRichTextItalic(text)
  return text
end

function string.bold(text)
  return "<b>" .. text .. "</b>"
end

function string.plain_gsub(s, pattern, repl, n)
  if string.IsNullOrEmpty(pattern) then
    return s, 0
  end
  n = n or math.huge
  local result = {}
  local startPos = 1
  local count = 0
  local i, j = string.find(s, pattern, startPos, true)
  while i and n > count do
    table.insert(result, string.sub(s, startPos, i - 1))
    table.insert(result, repl)
    startPos = j + 1
    count = count + 1
    i, j = string.find(s, pattern, startPos, true)
  end
  table.insert(result, string.sub(s, startPos))
  return table.concat(result), count
end

string._split_ss_array = _split_ss_array
string._split_ss = _split_ss
string.split = split
string.join = join
string.contains = contains
string.startswith = startswith
string.endswith = endswith
string.GetFormattedStr0 = GetFormattedStr0
string.GetFormattedStr = GetFormattedStr
string.GetFormattedStr2 = GetFormattedStr2
string.GetFormattedSeperatorNum = GetFormattedSeparatorNum
string.GetFormattedSeparatorNum = GetFormattedSeparatorNum
string.GetFormattedGiga2 = GetFormattedGiga2
string.GetFloatStr = GetFloatStr
string.GetFormattedGoldNum = GetFormattedGoldNum
string.GetFormattedPercentStr = GetFormattedPercentStr
string.GetFormattedPercentTwoDecimalStr = GetFormattedPercentTwoDecimalStr
string.IsNullOrEmpty = IsNullOrEmpty
string.at = at
string.trim = trim
string.word_count = word_count
string.GetFormattedThousandthStr = GetFormattedThousandthStr
string.string2table_ii = string2table_ii
string.string2table_ii_toList = string2table_ii_toList
string.string2table_ss = string2table_ss
string.string2table_si = string2table_si
string.string2table_is = string2table_is
string.string2table_sf = string2table_sf
string.string2array_i = string2array_i
string.string2array_i_oneSep = string2array_i_oneSep
string.string2array_num = string2array_num
string.string2array_num_oneSep = string2array_num_oneSep
string.string2array_s = string2array_s
string.SliceToInt = SliceToInt
string.string2_ii = string2_ii
string.GetFormattedSpecial = GetFormattedSpecial
string.GetBytes = GetBytes
string.SubStr = SubStr
string.cleanNestingTag = cleanNestingTag
string.numbericFormationWithPrefix = numbericFormationWithPrefix
string.insert = insert
string.removeByIndex = removeByIndex
string.wordIndexToLenIndex = wordIndexToLenIndex
string.charIndexToWordIndex = charIndexToWordIndex
string.wordIndexToCharIndex = wordIndexToCharIndex
string.formatDecimal = formatDecimal
string.fast_concat = fast_concat
string.percentage = percentage
