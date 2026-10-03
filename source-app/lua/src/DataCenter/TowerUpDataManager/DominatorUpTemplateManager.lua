local DominatorUpTemplateManager = BaseClass("DominatorUpTemplateManager")
local DominatorUpTemplate = require("DataCenter.TowerUpDataManager.DominatorUpTemplate")

local function __init(self)
  self.firstRewardStage = nil
  self.stageCache = {}
  self.tRewardProbability = nil
end

local function __delete(self)
  self.firstRewardStage = nil
  self.stageCache = nil
  self.tRewardProbability = nil
end

local function GetTableName(self)
  return TableName.LW_Dominator_Up
end

local function GetFirstRewardStage(self)
  if self.firstRewardStage == nil then
    self.firstRewardStage = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
      local first_rewarad = lineData:getValue("first_reward")
      if not string.IsNullOrEmpty(first_rewarad) then
        table.insert(self.firstRewardStage, id)
      end
    end)
    table.sort(self.firstRewardStage, function(a, b)
      return a < b
    end)
  end
  return self.firstRewardStage
end

local function GetDominatorUpTemplate(self, id)
  id = tonumber(id)
  local template = self.stageCache[id]
  if 0 < id and template == nil then
    local cfg = LocalController:instance():tryGetLine(self:GetTableName(), id)
    if cfg then
      template = DominatorUpTemplate.New()
      template:InitData(cfg)
      self.stageCache[id] = template
    end
  end
  return template
end

local function GetDominatorUpUnlockTemplate(self, id)
  local template = self:GetDominatorUpTemplate(id)
  if template and not template:IsUnlock() then
    template = nil
  end
  return template
end

local function GetRewardProbability(self)
  if self.tRewardProbability ~= nil then
    return self.tRewardProbability
  end
  self.tRewardProbability = {}
  local sLevel = LuaEntry.DataConfig:TryGetStr("dominator_idle_reward_show", "k1")
  local sReward = LuaEntry.DataConfig:TryGetStr("dominator_idle_reward_show", "k2")
  local tLevelList = string.string2array_num(sLevel, ";", "|")
  local tRewardList = string.string2array_num(sReward, ";", "|")
  if table.length(tLevelList) == 0 or table.length(tRewardList) == 0 then
    return self.tRewardProbability
  end
  for i, tLevelArray in ipairs(tLevelList) do
    self.tRewardProbability[i] = {}
    self.tRewardProbability[i].nBeginOrderId = tLevelArray[1]
    self.tRewardProbability[i].nEndOrderId = tLevelArray[2]
    local tRewards = tRewardList[i]
    local tItemRateMap = {}
    for _, rewardId in ipairs(tRewards) do
      local tRewardCfg = LocalController:instance():tryGetLine(TableName.RewardConfig, rewardId)
      local sRate = tRewardCfg:getValue("rate")
      local tRate = string.split_ii_array(sRate, ";")
      local nTotalRate = 0
      for j, rate in ipairs(tRate) do
        nTotalRate = nTotalRate + rate
      end
      local sItem = tRewardCfg:getValue("item")
      local tItem = string.split_ii_array(sItem, ";")
      local sNum = tRewardCfg:getValue("num")
      local tNum = string.split_ii_array(sNum, ";")
      for k, itemId in ipairs(tItem) do
        if 0 < itemId then
          local nItemRate = tRate[k]
          local nRate = nItemRate / nTotalRate
          local nNum = tNum[k]
          local tItemRate = {}
          tItemRate.nItemId = itemId
          tItemRate.nRate = nRate
          tItemRate.nNum = nNum
          table.insert(tItemRateMap, tItemRate)
        end
      end
    end
    self.tRewardProbability[i].tItemRateMap = tItemRateMap
  end
  return self.tRewardProbability
end

DominatorUpTemplateManager.__init = __init
DominatorUpTemplateManager.__delete = __delete
DominatorUpTemplateManager.GetDominatorUpUnlockTemplate = GetDominatorUpUnlockTemplate
DominatorUpTemplateManager.GetDominatorUpTemplate = GetDominatorUpTemplate
DominatorUpTemplateManager.GetTableName = GetTableName
DominatorUpTemplateManager.GetFirstRewardStage = GetFirstRewardStage
DominatorUpTemplateManager.GetRewardProbability = GetRewardProbability
return DominatorUpTemplateManager
