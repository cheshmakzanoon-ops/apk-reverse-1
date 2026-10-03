local LWTrailTowerTemplate = BaseClass("LWTrailTowerTemplate")
local LWTrailTowerLevelTemplate = require("DataCenter.LWTrailTowerManager.LWTrailTowerLevelTemplate")

function LWTrailTowerTemplate:__init()
  self.trailTowerLevelDic = {}
  self.id = 0
  self.name = ""
  self.des = ""
  self.bannerPath = ""
  self.baseLevel = 0
  self.conditionStr = {}
  self.condition = nil
  self.challengeLimit = 0
  self.levelList = {}
  self.levelRewardShowStr = {}
  self.levelRewardShow = nil
  self.levelPower = {}
  self.levelSoldier = {}
  self.difficultyGroup2CombatPower = {}
  self.difficultyGroup2ArmyLevel = {}
  self.maxDifficultyGroup = 0
end

function LWTrailTowerTemplate:__delete()
  self.trailTowerLevelDic = nil
  self.id = nil
  self.name = nil
  self.des = nil
  self.bannerPath = nil
  self.baseLevel = nil
  self.conditionStr = nil
  self.condition = nil
  self.challengeLimit = nil
  self.levelList = nil
  self.levelRewardShowStr = nil
  self.levelRewardShow = nil
  self.levelPower = nil
  self.levelSoldier = nil
  self.difficultyGroup2CombatPower = nil
  self.difficultyGroup2ArmyLevel = nil
  self.maxDifficultyGroup = nil
end

function LWTrailTowerTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.name = row:getValue("name") or ""
  self.des = row:getValue("desc") or ""
  self.bannerPath = row:getValue("bannerpath") or ""
  self.baseLevel = row:getValue("baselevel") or 0
  self.conditionStr = row:getValue("condition") or {}
  self.challengeLimit = row:getValue("challenge_limit") or 0
  self.levelList = row:getValue("levellist") or {}
  self.levelRewardShowStr = row:getValue("level_rewardshow") or {}
  self.levelPower = row:getValue("level_power") or {}
  self.levelSoldier = row:getValue("level_soldier") or {}
  local levelCount = #self.levelList
  local powerCount = #self.levelPower
  local soldierCount = #self.levelSoldier
  if levelCount == powerCount and levelCount == soldierCount then
    for i = 1, levelCount do
      local difficultyGroup = self.levelList[i]
      if difficultyGroup > self.maxDifficultyGroup then
        self.maxDifficultyGroup = difficultyGroup
      end
      self.difficultyGroup2CombatPower[difficultyGroup] = self.levelPower[i]
      self.difficultyGroup2ArmyLevel[difficultyGroup] = self.levelSoldier[i]
    end
  end
end

function LWTrailTowerTemplate:GetCondition()
  if self.condition == nil then
    self.condition = {}
    for k, conditionStr in ipairs(self.conditionStr) do
      local conditionType, param1, param2 = string.match(conditionStr, "(%d+)[,;](%d+)[,;](%d+)")
      local conditionData = {}
      conditionData.conditionType = tonumber(conditionType)
      conditionData.param1 = tonumber(param1)
      conditionData.param2 = tonumber(param2)
      table.insert(self.condition, conditionData)
    end
  end
  return self.condition
end

function LWTrailTowerTemplate:GetDifficultyGroup2Reward(difficultyGroup)
  if self.levelRewardShow == nil then
    self.levelRewardShow = {}
    for k, rewardStr in ipairs(self.levelRewardShowStr) do
      local itemList = {}
      local group = 0
      local temp = string.split(rewardStr, ";")
      if temp ~= nil and 1 < #temp then
        for i = 1, #temp do
          if i == 1 then
            local groupData = string.split(temp[i], "-")
            if groupData ~= nil and #groupData == 2 then
              group = tonumber(groupData[2])
            end
          else
            local itemData = {}
            itemData.rewardType = RewardType.GOODS
            itemData.itemId = tonumber(temp[i])
            table.insert(itemList, itemData)
          end
        end
      end
      if group ~= 0 then
        self.levelRewardShow[group] = itemList
      end
    end
  end
  local tempGroupId = 0
  local targetRewardList
  for i, rewardList in pairs(self.levelRewardShow) do
    if difficultyGroup <= i and (tempGroupId == 0 or i < tempGroupId) then
      tempGroupId = i
      targetRewardList = rewardList
    end
  end
  return targetRewardList
end

function LWTrailTowerTemplate:GetDifficultyGroup2Power(difficultyGroup)
  if self.difficultyGroup2CombatPower[difficultyGroup] then
    return self.difficultyGroup2CombatPower[difficultyGroup]
  end
  return 0
end

function LWTrailTowerTemplate:GetDifficultyGroup2SoldierLevel(difficultyGroup)
  if self.difficultyGroup2ArmyLevel[difficultyGroup] then
    return self.difficultyGroup2ArmyLevel[difficultyGroup]
  end
  return 0
end

function LWTrailTowerTemplate:GetTrailTowerLevelTemplateList(targetLevelGroup)
  if self.trailTowerLevelDic[targetLevelGroup] == nil then
    local trailTowerLevelList = {}
    LocalController:instance():visitTable(TableName.LW_Trail_Tower_Level, function(id, lineData)
      if lineData ~= nil then
        local towerId = lineData:getValue("tower_id")
        local levelGroup = lineData:getValue("level_group")
        if levelGroup == targetLevelGroup and self.id == towerId then
          local item = LWTrailTowerLevelTemplate.New()
          item:InitData(lineData)
          table.insert(trailTowerLevelList, item)
        end
      end
    end)
    table.sort(trailTowerLevelList, function(a, b)
      return a.levelOrder < b.levelOrder
    end)
    self.trailTowerLevelDic[targetLevelGroup] = trailTowerLevelList
  end
  return self.trailTowerLevelDic[targetLevelGroup]
end

function LWTrailTowerTemplate:GetTrailTowerLevelTemplate(targetLevelGroup, targetStageId)
  local list = self:GetTrailTowerLevelTemplateList(targetLevelGroup)
  for k, template in ipairs(list) do
    if template.id == targetStageId then
      return template
    end
  end
  return nil
end

function LWTrailTowerTemplate:GetTrailTowerLevelTemplateByOrder(targetLevelGroup, targetOrder)
  local list = self:GetTrailTowerLevelTemplateList(targetLevelGroup)
  for k, template in ipairs(list) do
    if template.levelOrder == targetOrder then
      return template
    end
  end
  return nil
end

return LWTrailTowerTemplate
