local HeroUWEnhanceLvTemplate = BaseClass("HeroUWEnhanceLvTemplate")

local function __init(self)
  self.id = 0
  self.heroId = 0
  self.type = 0
  self.maxLv = 0
  self.overallAttr = 0
  self.overallValue = 0
  self.personalAttr = 0
  self.personalValue = 0
end

local function __delete(self)
  self.id = nil
  self.heroId = nil
  self.type = nil
  self.maxLv = nil
  self.overallAttr = nil
  self.overallValue = nil
  self.personalAttr = nil
  self.personalValue = nil
end

local function InitData(self, lineData)
  if not lineData then
    return
  end
  self.id = tonumber(lineData:getValue("id")) or 0
  self.heroId = tonumber(lineData:getValue("hero")) or 0
  self.type = tonumber(lineData:getValue("type")) or 0
  self.maxLv = tonumber(lineData:getValue("max_lv")) or 0
  self.overallAttr = tonumber(lineData:getValue("overall_attr")) or 0
  self.personalAttr = tonumber(lineData:getValue("personal_attr")) or 0
  local overallValue = lineData:getValue("overall_value") or {}
  self.overallValue = {}
  for i = 1, #overallValue do
    local strVal = overallValue[i]
    local splitVal = string.split(strVal, ",")
    local lv = tonumber(splitVal[1]) or 0
    local value = tonumber(splitVal[2]) or 0
    self.overallValue[#self.overallValue + 1] = {lv = lv, value = value}
  end
  local personalValue = lineData:getValue("personal_value") or {}
  self.personalValue = {}
  for i = 1, #personalValue do
    local strVal = personalValue[i]
    local splitVal = string.split(strVal, ",")
    local lv = tonumber(splitVal[1]) or 0
    local value = tonumber(splitVal[2]) or 0
    self.personalValue[#self.personalValue + 1] = {lv = lv, value = value}
  end
end

function HeroUWEnhanceLvTemplate:GetAllValueAtLv(lv)
  local value = 0
  local nextNonFulfillLv
  local prevLv = 0
  for i = 1, #self.overallValue do
    if lv >= self.overallValue[i].lv then
      local lvRange = self.overallValue[i].lv - prevLv
      value = value + self.overallValue[i].value * lvRange
      prevLv = self.overallValue[i].lv
    else
      nextNonFulfillLv = self.overallValue[i]
      break
    end
  end
  if nextNonFulfillLv then
    local calcLv = lv - prevLv
    value = value + nextNonFulfillLv.value * calcLv
  end
  return self.overallAttr, value
end

function HeroUWEnhanceLvTemplate:GetSelfValueAtLv(lv)
  local value = 0
  for i = 1, #self.personalValue do
    if lv >= self.personalValue[i].lv then
      value = self.personalValue[i].value + value
    end
  end
  return self.personalAttr, value
end

function HeroUWEnhanceLvTemplate:GetNextUnlockSelfAttr(lv)
  local nextLv = 0
  local nextValue = 0
  for i = 1, #self.personalValue do
    if lv < self.personalValue[i].lv then
      nextLv = self.personalValue[i].lv
      nextValue = self.personalValue[i].value
      break
    end
  end
  return nextLv, nextValue
end

function HeroUWEnhanceLvTemplate:GetAllAttrs(lv)
  local attrs = {}
  local effectId, value = self:GetAllValueAtLv(lv)
  attrs[effectId] = value
  effectId, value = self:GetSelfValueAtLv(lv)
  attrs[effectId] = value
  return attrs
end

HeroUWEnhanceLvTemplate.__init = __init
HeroUWEnhanceLvTemplate.__delete = __delete
HeroUWEnhanceLvTemplate.InitData = InitData
return HeroUWEnhanceLvTemplate
