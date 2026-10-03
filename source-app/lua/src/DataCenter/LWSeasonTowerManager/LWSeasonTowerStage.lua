local LWSeasonTowerStage = BaseClass("LWSeasonTowerStage")
local LWSeasonTowerStageTemplate = require("DataCenter/LWSeasonTowerManager/LWSeasonTowerStageTemplate")

function LWSeasonTowerStage:__init()
  self.stageId = 0
  self.openTime = 0
  self.floor = 0
  self.stageRewardList = {}
  self.heroes = {}
  self.template = nil
  self.chipEquipGroup = 0
end

function LWSeasonTowerStage:__delete()
  self.stageId = 0
  self.openTime = 0
  self.floor = 0
  self.stageRewardList = {}
  self.heroes = {}
  self.template = nil
  self.chipEquipGroup = 0
end

function LWSeasonTowerStage:InitData(msg)
  self.stageId = msg.stageId or 0
  self.openTime = msg.openTime or 0
  self.floor = msg.floor or 0
  if string.IsNullOrEmpty(msg.stageRewardList) then
    self.stageRewardList = {}
  else
    self.stageRewardList = string.split(msg.stageRewardList, ";")
  end
  self.heroes = msg.heroes or {}
  self.chipEquipGroup = msg.chipEquipGroup
end

function LWSeasonTowerStage:GetTemplate()
  if self.template == nil then
    self.template = LWSeasonTowerStageTemplate.New()
    self.template:InitData(self.stageId)
  end
  return self.template
end

function LWSeasonTowerStage:GetStageRewardList()
  return self.stageRewardList
end

function LWSeasonTowerStage:SetStageRewardList(stageRewardListStr)
  if string.IsNullOrEmpty(stageRewardListStr) then
    self.stageRewardList = {}
  else
    self.stageRewardList = string.split(stageRewardListStr, ";")
  end
end

function LWSeasonTowerStage:IsStageOpen()
  local now = UITimeManager:GetInstance():GetServerTime()
  return now > self.openTime
end

function LWSeasonTowerStage:IsStageUnChallenge()
  return self.floor == 0
end

function LWSeasonTowerStage:IsStageFinish()
  return self:GetMaxFloor() == self.floor
end

function LWSeasonTowerStage:GetMaxFloor()
  return self:GetTemplate():GetMaxFloor()
end

function LWSeasonTowerStage:GetArmy()
  local template = self:GetTemplate()
  local armyList = template.armyList
  local armyInfo
  for i = #armyList, 1, -1 do
    armyInfo = armyList[i]
    if self.floor >= armyInfo.floor then
      break
    end
  end
  return armyInfo
end

function LWSeasonTowerStage:GetArmyByFloor(floor)
  local template = self:GetTemplate()
  local armyList = template.armyList
  local armyInfo
  for i = #armyList, 1, -1 do
    armyInfo = armyList[i]
    if floor >= armyInfo.floor then
      break
    end
  end
  return armyInfo
end

function LWSeasonTowerStage:GetArmyTemplateByFloor(floor)
  local template = self:GetTemplate()
  local armyList = template.armyList
  local armyInfo, nextArmyInfo
  for i = #armyList, 1, -1 do
    armyInfo = armyList[i]
    if floor >= armyInfo.floor then
      nextArmyInfo = armyList[i + 1] or armyInfo
      break
    end
  end
  local newTemplate = DataCenter.LWSeasonTowerArmyTemplateManager:GetInterpolationTemplate(armyInfo, nextArmyInfo, floor)
  return newTemplate
end

function LWSeasonTowerStage:UpdateHeroes(heroes)
  self.heroes = heroes
end

return LWSeasonTowerStage
