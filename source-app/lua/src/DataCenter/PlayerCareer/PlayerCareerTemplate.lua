local PlayerCareerTemplate = BaseClass("PlayerCareerTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.level = 0
  self.name = 0
  self.description = 0
  self.story = 0
  self.requireItemDict = {}
  self.requireResDict = {}
  self.requirePlayerLv = 0
  self.icon = ""
  self.image = ""
  self.initEffectList = {}
  self.levelEffect = 0
  self.tagInfoList = {}
  self.order = 0
  self.showType = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.level = nil
  self.name = nil
  self.description = nil
  self.story = nil
  self.requireItemDict = nil
  self.requireResDict = nil
  self.requirePlayerLv = nil
  self.icon = nil
  self.image = nil
  self.initEffectList = nil
  self.levelEffect = nil
  self.tagInfoList = nil
  self.order = nil
  self.showType = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.level = self.id % 1000 + 1
  self.name = tonumber(row:getValue("name")) or 0
  self.description = tonumber(row:getValue("description")) or 0
  self.story = tonumber(row:getValue("story")) or 0
  self.requireItemDict = {}
  local requireItemStr = row:getValue("require_item") or ""
  for _, str in ipairs(string.split(requireItemStr, "|")) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local itemId = tonumber(spls[1])
      local count = tonumber(spls[2])
      self.requireItemDict[itemId] = count
    end
  end
  self.requireResDict = {}
  local requireResStr = row:getValue("require_resource") or ""
  for _, str in ipairs(string.split(requireResStr, "|")) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local resType = tonumber(spls[1])
      local count = tonumber(spls[2])
      self.requireResDict[resType] = count
    end
  end
  self.requirePlayerLv = tonumber(row:getValue("require_lv")) or 0
  self.icon = row:getValue("icon")
  self.image = row:getValue("image")
  self.initEffectList = {}
  local effectStr = row:getValue("effect") or ""
  for _, str in ipairs(string.split(effectStr, ";")) do
    table.insert(self.initEffectList, tonumber(str))
  end
  self.levelEffect = tonumber(row:getValue("effect_add")) or 0
  self.tagInfoList = {}
  local tagStr = row:getValue("career_tag") or ""
  for _, str in ipairs(string.split(tagStr, "|")) do
    local spls = string.split(str, ";")
    if #spls == 3 then
      local tagInfo = {
        title = tonumber(spls[1]),
        detail = tonumber(spls[2]),
        color = tonumber(spls[3])
      }
      table.insert(self.tagInfoList, tagInfo)
    end
  end
  self.order = tonumber(row:getValue("order")) or 0
  self.showType = tonumber(row:getValue("show_type")) or 0
end

PlayerCareerTemplate.__init = __init
PlayerCareerTemplate.__delete = __delete
PlayerCareerTemplate.InitData = InitData
PlayerCareerTemplate.GetInitCareerEffectIdList = GetInitCareerEffectIdList
PlayerCareerTemplate.GetCareerEffectIdByLevel = GetCareerEffectIdByLevel
PlayerCareerTemplate.GetCareerEffectCount = GetCareerEffectCount
return PlayerCareerTemplate
