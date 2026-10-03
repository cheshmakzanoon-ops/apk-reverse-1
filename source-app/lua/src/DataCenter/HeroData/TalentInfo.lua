local TalentInfo = BaseClass("TalentInfo")

local function __init(self)
  self.pageIndex = 0
  self.pageName = ""
  self.own = {}
end

local function __delete(self)
  self.pageIndex = nil
  self.pageName = nil
  self.own = nil
end

local function UpdateInfo(self, message)
  if message.index ~= nil then
    self.pageIndex = message.index
  end
  if message.pageName ~= nil then
    self.pageName = message.pageName
  end
  if message.talentInfoArray ~= nil then
    local temp = message.talentInfoArray
    self.own = {}
    for k, v in pairs(message.talentInfoArray) do
      local talentId = tonumber(v.talentId)
      local baseId = math.modf(talentId / LevelMod)
      baseId = baseId * LevelMod
      local level = talentId % LevelMod
      self.own[baseId] = level
    end
  end
end

local function GetTalentLevel(self, talentId)
  if self.own[talentId] == nil then
    return 0
  end
  return self.own[talentId]
end

local function ResetTalent(self)
  self.own = {}
end

local function ChangeName(self, name)
  self.pageName = name
end

local function GetUsePoint(self)
  local result = 0
  for k, v in pairs(self.own) do
    result = result + v
  end
  return result
end

local function GetUsePointEveryType(self)
  local result = {}
  for k, v in pairs(self.own) do
    local template
    if template ~= nil then
      local type = template.type
      if result[type] == nil then
        result[type] = v
      else
        result[type] = result[type] + v
      end
    end
  end
  return result
end

TalentInfo.__init = __init
TalentInfo.__delete = __delete
TalentInfo.UpdateInfo = UpdateInfo
TalentInfo.GetTalentLevel = GetTalentLevel
TalentInfo.ResetTalent = ResetTalent
TalentInfo.ChangeName = ChangeName
TalentInfo.GetUsePoint = GetUsePoint
TalentInfo.GetUsePointEveryType = GetUsePointEveryType
return TalentInfo
