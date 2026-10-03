local HeroRankTemplateManager = BaseClass("HeroRankTemplateManager")
local HeorRankTemplate = require("DataCenter.HeroData.HeroRankTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.templateDict = {}
end

local function __delete(self)
  self.templateDict = nil
end

local function GetTemplate(self, id)
  if id == nil then
    return nil
  end
  local data = self.templateDict[id]
  if data == nil then
    data = HeorRankTemplate.New()
    data:InitData(LocalController:instance():getLine(TableName.LW_Hero_Rank, id))
    self.templateDict[id] = data
  end
  return data
end

local function GetRankName(self, rankId)
  local rankTemplate = self:GetTemplate(rankId)
  if rankTemplate == nil then
    return ""
  end
  return Localization:GetString(rankTemplate.name)
end

local function GetRankSmallIcon(self, rankId)
  local rankTemplate = self:GetTemplate(rankId)
  if rankTemplate == nil then
    return ""
  end
  return rankTemplate.small_icon
end

HeroRankTemplateManager.__init = __init
HeroRankTemplateManager.__delete = __delete
HeroRankTemplateManager.GetTemplate = GetTemplate
HeroRankTemplateManager.GetRankName = GetRankName
HeroRankTemplateManager.GetRankSmallIcon = GetRankSmallIcon
return HeroRankTemplateManager
