local ActBattlePassTemplateManager = BaseClass("ActBattlePassTemplateManager", Singleton)
local ActBattlePassTemplate = require("DataCenter.ActivityListData.ActBattlePassTemplate")

local function __init(self)
  self.tempDict = {}
  self.bp_new_dic = {}
  self.bp_new_highReward = {}
  self.highReward = {}
end

local function __delete(self)
  self.tempDict = nil
  self.highReward = nil
  self.bp_new_dic = nil
  self.bp_new_highReward = nil
end

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.BattlePass, function(id, lineData)
    local item = ActBattlePassTemplate.New()
    item:InitData(lineData)
    if self.tempDict[item.actId] == nil then
      self.tempDict[item.actId] = {}
    end
    if self.highReward[item.actId] == nil then
      self.highReward[item.actId] = {}
    end
    table.insert(self.tempDict[item.actId], item)
    if item.highReward ~= "" and item.highReward ~= nil then
      table.insert(self.highReward[item.actId], item)
    end
  end)
  LocalController:instance():visitTable(TableName.LW_BattlePassV2, function(id, lineData)
    local item = ActBattlePassTemplate.New()
    item:InitData(lineData)
    if self.bp_new_dic[item.type] == nil then
      self.bp_new_dic[item.type] = {}
    end
    if self.bp_new_highReward[item.type] == nil then
      self.bp_new_highReward[item.type] = {}
    end
    table.insert(self.bp_new_dic[item.type], item)
    if item.highReward ~= "" and item.highReward ~= nil then
      table.insert(self.bp_new_highReward[item.type], item)
    end
  end)
end

function ActBattlePassTemplateManager:GetData(actId, type)
  local data
  if type == EnumActivity.BattlePass_new.Type then
    local type = GetTableData(TableName.Activity, actId, "tableInfoType") or ""
    data = self.bp_new_dic[type]
  else
    data = self.tempDict[actId]
  end
  return data
end

local function GetTemplateById(self, actId, lv, type)
  if not next(self.tempDict) then
    self:InitAllTemplate()
  end
  local data = self:GetData(actId, type)
  if data == nil then
    return nil
  end
  for i = 1, #data do
    if data[i].level == lv then
      return data[i]
    end
  end
end

local function GetTemplateHighRewardById(self, actId, lv, type)
  if not next(self.highReward) then
    self:InitAllTemplate()
  end
  local data = self:GetData(actId, type)
  if data then
    table.sort(data, function(a, b)
      if a.level < b.level then
        return true
      end
      return false
    end)
  end
  return data
end

local function GetActMaxLv(self, actId, type)
  if not next(self.tempDict) then
    self:InitAllTemplate()
  end
  local data
  if type == EnumActivity.BattlePass_new.Type then
    data = self.bp_new_dic[actId]
    return #data
  end
  data = self.tempDict[actId]
  return #data
end

local function GetLevelNeedExp(self, actId, level, type)
  if not next(self.tempDict) then
    self:InitAllTemplate()
  end
  local data = self:GetData(actId, type)
  if data == nil then
    return 0
  end
  for i = 1, #data do
    if data[i].level == level then
      return data[i].levelUpExp
    end
  end
  return 0
end

local function GetLevelNeedAccuExp(self, actId, level, type)
  if not next(self.tempDict) then
    self:InitAllTemplate()
  end
  local data = self:GetData(actId, type)
  if data == nil then
    return 0
  end
  local exp = 0
  for i = 0, level - 1 do
    local needExp = GetLevelNeedExp(self, actId, i, type)
    exp = exp + needExp
  end
  return exp
end

local function GetMaxExp(self, actId, type)
  if not next(self.tempDict) then
    self:InitAllTemplate()
  end
  local data = self:GetData(actId, type)
  if data == nil then
    return 0
  end
  local exp = 0
  for i = 1, #data - 1 do
    local level = i - 1
    local needExp = GetLevelNeedExp(self, actId, level, type)
    exp = exp + needExp
  end
  return exp
end

ActBattlePassTemplateManager.__init = __init
ActBattlePassTemplateManager.__delete = __delete
ActBattlePassTemplateManager.InitAllTemplate = InitAllTemplate
ActBattlePassTemplateManager.GetTemplateById = GetTemplateById
ActBattlePassTemplateManager.GetTemplateHighRewardById = GetTemplateHighRewardById
ActBattlePassTemplateManager.GetActMaxLv = GetActMaxLv
ActBattlePassTemplateManager.GetLevelNeedExp = GetLevelNeedExp
ActBattlePassTemplateManager.GetLevelNeedAccuExp = GetLevelNeedAccuExp
ActBattlePassTemplateManager.GetMaxExp = GetMaxExp
return ActBattlePassTemplateManager
