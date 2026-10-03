local BattlefieldDsbDuelActTemplateInfo = BaseClass("BattlefieldDsbDuelActTemplateInfo")
local LWDsbLeagueGuideTemplate = require("DataCenter.BattlefieldDsbDuel.Template.LWDsbLeagueGuideTemplate")
local LWDsbLeagueRankRewardTemplate = require("DataCenter.BattlefieldDsbDuel.Template.LWDsbLeagueRankRewardTemplate")

function BattlefieldDsbDuelActTemplateInfo:__init()
  self.lwDsbLeagueGuideTemplates = {}
  self.currentServerLeagueOpen = nil
  self.lwDsbLeagueRankRewardTemplates = {}
end

function BattlefieldDsbDuelActTemplateInfo:__delete()
  self.lwDsbLeagueGuideTemplates = nil
  self.currentServerLeagueOpen = nil
  self.lwDsbLeagueRankRewardTemplates = nil
end

function BattlefieldDsbDuelActTemplateInfo:InitLWDsbLeagueGuideTemplates()
  self.lwDsbLeagueGuideTemplates = {}
  LocalController:instance():visitTable(TableName.LW_DSB_LEAGUE_GUIDE, function(id, rowData)
    local template = LWDsbLeagueGuideTemplate.New()
    template:UpdateData(rowData)
    self.lwDsbLeagueGuideTemplates[template.id] = template
  end)
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueGuideTemplate(id)
  if not self.lwDsbLeagueGuideTemplates or not next(self.lwDsbLeagueGuideTemplates) then
    self:InitLWDsbLeagueGuideTemplates()
  end
  return self.lwDsbLeagueGuideTemplates[id]
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueGuideTemplatesByType(type)
  if not self.lwDsbLeagueGuideTemplates or not next(self.lwDsbLeagueGuideTemplates) then
    self:InitLWDsbLeagueGuideTemplates()
  end
  local result = {}
  for _, template in pairs(self.lwDsbLeagueGuideTemplates) do
    if template.type == type then
      table.insert(result, template)
    end
  end
  table.sort(result, function(a, b)
    return a.sequence < b.sequence
  end)
  return result
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueGuideTemplatesByTypeAndSubType(type, subType)
  if not self.lwDsbLeagueGuideTemplates or not next(self.lwDsbLeagueGuideTemplates) then
    self:InitLWDsbLeagueGuideTemplates()
  end
  local result = {}
  for _, template in pairs(self.lwDsbLeagueGuideTemplates) do
    if template.type == type and template.sub_type == subType then
      table.insert(result, template)
    end
  end
  table.sort(result, function(a, b)
    return a.sequence < b.sequence
  end)
  return result
end

function BattlefieldDsbDuelActTemplateInfo:GetFirstBattleWeekGuideSequence()
  if not self.lwDsbLeagueGuideTemplates or not next(self.lwDsbLeagueGuideTemplates) then
    self:InitLWDsbLeagueGuideTemplates()
  end
  local minSequence = 999
  for k, v in pairs(self.lwDsbLeagueGuideTemplates) do
    if v.sub_type == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE1_SUBTYPE.Battle1 or v.sub_type == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE1_SUBTYPE.Battle2 then
      minSequence = math.min(minSequence, v.sequence)
    end
  end
  return minSequence
end

function BattlefieldDsbDuelActTemplateInfo:InitLWDsbLeagueRankRewardTemplates()
  self.lwDsbLeagueRankRewardTemplates = {}
  LocalController:instance():visitTable(TableName.LW_DSB_LEAGUE_RANK_REWARD, function(id, rowData)
    local template = LWDsbLeagueRankRewardTemplate.New()
    template:UpdateData(rowData)
    self.lwDsbLeagueRankRewardTemplates[template.id] = template
  end)
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueRankRewardTemplate(id)
  if not self.lwDsbLeagueRankRewardTemplates or not next(self.lwDsbLeagueRankRewardTemplates) then
    self:InitLWDsbLeagueRankRewardTemplates()
  end
  return self.lwDsbLeagueRankRewardTemplates[id]
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueRankRewardTemplatesBySeasonAndType(season, type)
  if not self.lwDsbLeagueRankRewardTemplates or not next(self.lwDsbLeagueRankRewardTemplates) then
    self:InitLWDsbLeagueRankRewardTemplates()
  end
  local result = {}
  for _, template in pairs(self.lwDsbLeagueRankRewardTemplates) do
    if template.season == season and template.type == type then
      table.insert(result, template)
    end
  end
  return result
end

function BattlefieldDsbDuelActTemplateInfo:GetLWDsbLeagueRankRewardByRank(season, type, rank)
  local templates = self:GetLWDsbLeagueRankRewardTemplatesBySeasonAndType(season, type)
  for _, template in ipairs(templates) do
    if template:IsInRankRange(rank) then
      return template
    end
  end
  return nil
end

return BattlefieldDsbDuelActTemplateInfo
