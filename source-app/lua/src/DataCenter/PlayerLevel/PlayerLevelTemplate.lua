local PlayerLevelTemplate = BaseClass("PlayerLevelTemplate")

local function __init(self)
  self.id = 0
  self.level = 0
  self.curExp = 0
  self.totalExp = 0
  self.boxIcon = ""
  self.reward = ""
  self.buildIdList = {}
  self.farmIdList = {}
  self.factoryIdList = {}
  self.effect = ""
  self.effectList = {}
  self.unlockCareerLv = 0
  self.careerFree = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.level = nil
  self.name = nil
  self.description = nil
  self.story = nil
  self.requireItemDict = nil
  self.requirePlayerLv = nil
  self.icon = nil
  self.image = nil
  self.initEffectList = nil
  self.levelEffect = nil
  self.unlockCareerLv = nil
  self.careerFree = nil
end

local function InitData(self, lineData)
  if lineData == nil then
    return
  end
  local buildIdList = {}
  local buildStr = tostring(lineData:getValue("unlock_build"))
  if not string.IsNullOrEmpty(buildStr) then
    for _, str in pairs(string.split(buildStr, ";")) do
      table.insert(buildIdList, tonumber(str))
    end
  end
  local farmIdList = {}
  local farmStr = tostring(lineData:getValue("unlock_farms"))
  if not string.IsNullOrEmpty(farmStr) then
    for _, str in pairs(string.split(farmStr, ";")) do
      table.insert(farmIdList, tonumber(str))
    end
  end
  local factoryIdList = {}
  local factoryStr = tostring(lineData:getValue("unlock_factory"))
  if not string.IsNullOrEmpty(factoryStr) then
    for _, str in pairs(string.split(factoryStr, ";")) do
      table.insert(factoryIdList, tonumber(str))
    end
  end
  self.id = tonumber(lineData:getValue("id"))
  self.level = tonumber(lineData:getValue("level"))
  self.curExp = tonumber(lineData:getValue("exp"))
  self.totalExp = 0
  self.boxIcon = lineData:getValue("box_icon")
  self.reward = lineData:getValue("unlock_reward")
  self.buildIdList = buildIdList
  self.farmIdList = farmIdList
  self.factoryIdList = factoryIdList
  self.effect = lineData:getValue("effect")
  self.effectList = {}
  self.unlockCareerLv = tonumber(lineData:getValue("unlock_career")) or 0
  self.careerFree = tonumber(lineData:getValue("career_free")) or 0
end

PlayerLevelTemplate.__init = __init
PlayerLevelTemplate.__delete = __delete
PlayerLevelTemplate.InitData = InitData
PlayerLevelTemplate.GetInitCareerEffectIdList = GetInitCareerEffectIdList
PlayerLevelTemplate.GetCareerEffectIdByLevel = GetCareerEffectIdByLevel
PlayerLevelTemplate.GetCareerEffectCount = GetCareerEffectCount
return PlayerLevelTemplate
