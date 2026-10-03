local HeroLevelTemplateManager = BaseClass("HeroLevelTemplateManager")
local HeroLevelTemplate = require("DataCenter.HeroData.HeroLevel.HeroLevelTemplate")

local function __init(self)
  self.templateDict = {}
  self.unconditionalMaxLv = 0
  self.maxReachableLevel = 0
  self.hasInitAllTemplate = false
end

local function __delete(self)
  self.templateDict = nil
  self.unconditionalMaxLv = 0
  self.maxReachableLevel = 0
  self.hasInitAllTemplate = false
end

local function InitAllTemplate(self)
  if self.hasInitAllTemplate then
    return
  end
  LocalController:instance():visitTable(TableName.LW_Hero_Level, function(id, lineData)
    local template = HeroLevelTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    local lv = template.level
    if lv > self.unconditionalMaxLv then
      self.unconditionalMaxLv = lv
    end
  end)
  self.hasInitAllTemplate = true
end

function HeroLevelTemplateManager:GetTemplate(level)
  if not self.templateDict[level] then
    local lineData = LocalController:instance():getLine(TableName.LW_Hero_Level, level)
    if not lineData then
      return nil
    end
    local template = HeroLevelTemplate.New()
    template:InitData(lineData)
    self.templateDict[level] = template
  end
  return self.templateDict[level]
end

function HeroLevelTemplateManager:GetUnconditionalMaxLv()
  self:InitAllTemplate()
  if self.unconditionalMaxLv == 0 then
    return 100
  end
  return self.unconditionalMaxLv + 1
end

local LUA_TONUMBER = tonumber

function HeroLevelTemplateManager:GetMaxReachableLevel()
  local unconditionalMaxLv = self:GetUnconditionalMaxLv()
  if self.maxReachableLevel == unconditionalMaxLv - 1 then
    return unconditionalMaxLv
  end
  for i = self.maxReachableLevel + 1, unconditionalMaxLv - 1 do
    local template = self:GetTemplate(i)
    if template then
      local techCondition = template.tech_condition
      if not string.IsNullOrEmpty(techCondition) then
        local scienceData = DataCenter.ScienceTemplateManager:GetScienceTemplate(techCondition)
        if scienceData then
          local science
          if DataCenter.ScienceDataManager ~= nil then
            science = DataCenter.ScienceDataManager:GetScienceById(LUA_TONUMBER(scienceData.science_id))
          end
          if science then
            self.maxReachableLevel = i
          else
            break
          end
        end
      else
        self.maxReachableLevel = i
      end
    end
  end
  return self.maxReachableLevel + 1
end

HeroLevelTemplateManager.__init = __init
HeroLevelTemplateManager.__delete = __delete
HeroLevelTemplateManager.InitAllTemplate = InitAllTemplate
return HeroLevelTemplateManager
