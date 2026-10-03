local SeasonGoldTreeTemplateManager = BaseClass("SeasonGoldTreeTemplateManager")
local GoldTreeCardTemplate = require("DataCenter.SeasonGoldTree.Temp.GoldTreeCardTemplate")
local GoldTreeCardMultiplierTemplate = require("DataCenter.SeasonGoldTree.Temp.GoldTreeCardMultiplierTemplate")
local GoldTreeCombinations = require("DataCenter.SeasonGoldTree.Temp.GoldTreeCombinations")

function SeasonGoldTreeTemplateManager:__init()
  self.cardDic = nil
  self.cardMultiplierDic = nil
  self.cardCombinationsDic = nil
  self.cardCombinationsList = nil
end

function SeasonGoldTreeTemplateManager:__delete()
  self.cardDic = nil
  self.cardMultiplierDic = nil
  self.cardCombinationsDic = nil
  self.cardCombinationsList = nil
end

function SeasonGoldTreeTemplateManager:Startup()
end

function SeasonGoldTreeTemplateManager:GetGoldTreeTemp(key)
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  local treeId = seasonConfig and seasonConfig.season_golden_tree
  local meta = treeId and LocalController:instance():getLine(TableName.SEASON_GOLDEN_TREE, tostring(treeId))
  if meta then
    return meta:getValue(key)
  end
end

function SeasonGoldTreeTemplateManager:GetCardTemp(cardId)
  if self.cardDic == nil then
    self.cardDic = {}
  end
  local temp = self.cardDic[cardId]
  if not temp then
    local meta = LocalController:instance():getLine(TableName.SEASON_GOLDEN_TREE_CARD_POOL, tostring(cardId))
    if meta then
      temp = GoldTreeCardTemplate.New()
      temp:InitData(meta)
      self.cardDic[temp.id] = temp
    end
  end
  return temp
end

function SeasonGoldTreeTemplateManager:GetCardMultiplierTemp(cardId)
  if self.cardMultiplierDic == nil then
    self.cardMultiplierDic = {}
  end
  local temp = self.cardMultiplierDic[cardId]
  if not temp then
    local meta = LocalController:instance():getLine(TableName.SEASON_GOLDEN_TREE_CARD_MULTIPLIER, tostring(cardId))
    if meta then
      temp = GoldTreeCardMultiplierTemplate.New()
      temp:InitData(meta)
      self.cardMultiplierDic[temp.id] = temp
    end
  end
  return temp
end

function SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(cardId)
  self:InitCombinations()
  return self.cardCombinationsDic[cardId]
end

function SeasonGoldTreeTemplateManager:GetCardCombinationsList(groupId)
  self:InitCombinations()
  if not groupId then
    local combinationGroup = DataCenter.SeasonGoldTreeTemplateManager:GetGoldTreeTemp("season_golden_tree_combinations")
    groupId = not string.IsNullOrEmpty(combinationGroup) and tonumber(combinationGroup) or groupId
  end
  local list = {}
  for k, v in pairs(self.cardCombinationsDic) do
    if v.group == groupId and v.hide ~= 1 then
      table.insert(list, v)
    end
  end
  table.sort(list, function(a, b)
    if a.weight == b.weight then
      return a.id < b.id
    end
    return a.weight > b.weight
  end)
  return list
end

function SeasonGoldTreeTemplateManager:GetCardCombinationsId(cards)
  if not cards or #cards == 0 then
    return 0
  end
  self:InitCombinations()
  if not self.cardCombinationsList then
    return 0
  end
  local combinationId = 0
  for i, v in ipairs(self.cardCombinationsList) do
    combinationId = v:GetCardCombinationsId(cards)
    if 0 < combinationId then
      break
    end
  end
  return combinationId
end

function SeasonGoldTreeTemplateManager:InitCombinations()
  if self.cardCombinationsDic == nil then
    self.cardCombinationsDic = {}
    self.cardCombinationsList = {}
    local index = 0
    LocalController:instance():visitTable(TableName.SEASON_GOLDEN_TREE_COMBINATIONS, function(id, lineData)
      local temp = GoldTreeCombinations.New()
      temp:InitData(lineData)
      self.cardCombinationsDic[temp.id] = temp
      index = index + 1
      self.cardCombinationsList[index] = temp
    end)
    table.sort(self.cardCombinationsList, function(a, b)
      if a.weight == b.weight then
        return a.id < b.id
      end
      return a.weight > b.weight
    end)
  end
end

return SeasonGoldTreeTemplateManager
