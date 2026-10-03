local TowerUpSaveDataManager = BaseClass("TowerUpSaveDataManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.saveData = nil
  self.oneKeySweep = nil
  self.sweepReward = nil
  self.sweepNum = 0
end

local function __delete(self)
  self.saveData = nil
  self.oneKeySweep = nil
  self.sweepReward = nil
  self.sweepNum = nil
end

local function IsAutoNextStage(self)
  local result = CS.GameEntry.Setting:GetBool(SettingKeys.TOWER_UP_AUTO_NEXT_STAGE, false)
  return result
end

local function SetAutoNextStage(self, state)
  CS.GameEntry.Setting:SetBool(SettingKeys.TOWER_UP_AUTO_NEXT_STAGE, state)
end

function TowerUpSaveDataManager:IsSquadDataValidInDominator(squadData, formationPositionType)
  if squadData == nil then
    return false, 1
  end
  local dominatorUuid = squadData:GetLocalDominatorUuid()
  if dominatorUuid == nil or dominatorUuid <= 0 then
    return false, 2
  end
  local heroesExceptDominator = squadData:GetLocalAllHeroes()
  local isCanHaveDominatorOnly = false
  if formationPositionType == ArmyFormationPositionType.DominatorAndHero345 then
    local heroUuid1 = squadData:GetLocalHeroAtSlotIndex(ArmyFormationSlot.Hero1)
    if heroUuid1 ~= nil then
      return false, 3
    end
    local heroUuid2 = squadData:GetLocalHeroAtSlotIndex(ArmyFormationSlot.Hero2)
    if heroUuid2 ~= nil then
      return false, 4
    end
  elseif formationPositionType == ArmyFormationPositionType.OnlyDominator then
    isCanHaveDominatorOnly = true
    if not table.IsNullOrEmpty(heroesExceptDominator) then
      return false, 5
    else
    end
  end
  if not isCanHaveDominatorOnly and table.IsNullOrEmpty(heroesExceptDominator) then
    return false, 6
  end
  return true, 0
end

function TowerUpSaveDataManager:IsCanAutoNextStageDominator()
  for i, v in pairs(DominatorTowerupFormationInfoDict) do
    local squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(v.saveType)
    if squadData == nil then
      return false
    end
    local checkRes, failedReason = self:IsSquadDataValidInDominator(squadData, v.positionType)
    if not checkRes then
      Logger.LogCustom("IsCanAutoNextStageDominator " .. failedReason)
      return false
    end
  end
  return true
end

function TowerUpSaveDataManager:IsCanAutoNextStageTowerUp()
  local squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(1)
  if squadData == nil then
    return false
  end
  local heroes = squadData:GetLocalAllHeroes()
  if table.IsNullOrEmpty(heroes) then
    return false
  end
  return true
end

function TowerUpSaveDataManager:SetOneKeySweep(isSweep)
  self.oneKeySweep = isSweep
  if not isSweep then
    self.sweepReward = nil
    self.sweepNum = 0
  end
end

function TowerUpSaveDataManager:GetOneKeySweep()
  return self.oneKeySweep
end

function TowerUpSaveDataManager:AddSweepStage(reward, isWin)
  if self.oneKeySweep then
    if reward then
      if self.sweepReward == nil then
        self.sweepReward = {}
      end
      local rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(reward)
      for i, v in ipairs(rewardList) do
        table.insert(self.sweepReward, v)
      end
      self.sweepReward = DataCenter.RewardManager:CombineRewardList(self.sweepReward)
    end
    if isWin then
      self.sweepNum = self.sweepNum + 1
    end
  end
end

function TowerUpSaveDataManager:ShowSweepReward(pageType, resultType, callback)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIJeepAdventureSweepBattleResultPanel) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureSweepBattleResultPanel, {anim = true}, pageType, resultType, self.sweepReward, self.sweepNum, callback)
  end
  self:SetOneKeySweep(false)
end

TowerUpSaveDataManager.__init = __init
TowerUpSaveDataManager.__delete = __delete
TowerUpSaveDataManager.IsAutoNextStage = IsAutoNextStage
TowerUpSaveDataManager.SetAutoNextStage = SetAutoNextStage
return TowerUpSaveDataManager
