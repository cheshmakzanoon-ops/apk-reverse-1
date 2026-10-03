local PlayerPowerDataManager = BaseClass("PlayerPowerDataManager")

local function __init(self)
  self.uid = 0
  self.playerPower = 0
  self.heroPower = 0
  self.armyPower = 0
  self.buildingPower = 0
  self.sciencePower = 0
  self.squadEquipPower = 0
  self.heroLevelPower = 0
  self.heroRankPower = 0
  self.heroSkillPower = 0
  self.heroEquipPower = 0
  self.heroHonorPower = 0
  self.heroWeaponPower = 0
  self.heroDecoPower = 0
  self.heroAwakenPower = 0
  self.weaponChipPower = 0
  self.weaponEquipPower = 0
  self.weaponLevelPower = 0
  self.buildingDecoPower = 0
  self.buildingWorkerPower = 0
  self.baseArmyPower = 0
  self.soldierElevenPower = 0
  self.isReceiveData = false
end

local function __delete(self)
  self.uid = nil
  self.playerPower = nil
  self.heroPower = nil
  self.armyPower = nil
  self.buildingPower = nil
  self.sciencePower = nil
  self.squadEquipPower = nil
  self.heroLevelPower = nil
  self.heroRankPower = nil
  self.heroSkillPower = nil
  self.heroEquipPower = nil
  self.heroHonorPower = nil
  self.heroWeaponPower = nil
  self.heroDecoPower = nil
  self.heroAwakenPower = nil
  self.weaponChipPower = nil
  self.weaponEquipPower = nil
  self.weaponLevelPower = nil
  self.buildingDecoPower = nil
  self.buildingWorkerPower = nil
  self.baseArmyPower = nil
  self.soldierElevenPower = nil
  self.isReceiveData = nil
end

local function RefreshPowerData(self, message)
  self.uid = message.uid or 0
  self.playerPower = message.playerPower or 0
  self.heroPower = message.heroPower or 0
  self.armyPower = message.armyPower or 0
  self.buildingPower = message.buildingPower or 0
  self.sciencePower = message.sciencePower or 0
  self.squadEquipPower = message.squadEquipPower or 0
  self.dominatorPower = message.dominatorPower or 0
  self.tacticalCardPower = message.battleCardPower or 0
  local powerDetail = message.powerDetail or {}
  self.heroLevelPower = powerDetail.heroLevelPower or 0
  self.heroRankPower = powerDetail.heroRankPower or 0
  self.heroSkillPower = powerDetail.heroSkillPower or 0
  self.heroEquipPower = powerDetail.heroEquipPower or 0
  self.heroHonorPower = powerDetail.heroHonorPower or 0
  self.heroWeaponPower = powerDetail.heroWeaponPower or 0
  self.heroDecoPower = powerDetail.heroDecoPower or 0
  self.heroAwakenPower = powerDetail.heroAwakenPower or 0
  self.weaponChipPower = powerDetail.weaponChipPower or 0
  self.weaponEquipPower = powerDetail.weaponEquipPower or 0
  self.weaponLevelPower = powerDetail.weaponLevelPower or 0
  self.buildingDecoPower = powerDetail.buildingDecoPower or 0
  self.buildingWorkerPower = powerDetail.buildingWorkerPower or 0
  self.dominatorBasePower = powerDetail.dominatorBasePower or 0
  self.dominatorTrainLvPower = powerDetail.dominatorTrainLvPower or 0
  self.dominatorTrainStarPower = powerDetail.dominatorTrainStarPower or 0
  self.dominatorRankPower = powerDetail.dominatorRankPower or 0
  self.dominatorSkillPower = powerDetail.dominatorSkillPower or 0
  self.tacticalCardBasePower = powerDetail.battleCardBasePower or 0
  self.tacticalCardLevelPower = powerDetail.battleCardLevelPower or 0
  self.tacticalCardStarPower = powerDetail.battleCardStarPower or 0
  self.baseArmyPower = powerDetail.baseArmyPower or 0
  self.soldierElevenPower = powerDetail.soldierElevenPower or 0
  self.isReceiveData = true
end

local function GetValByPowerType(self, powerType)
  local val = 0
  if powerType == PowerOverviewPowerType.playerPower then
    val = LuaEntry.Player.power
  elseif powerType == PowerOverviewPowerType.heroPower then
    val = self.heroPower
  elseif powerType == PowerOverviewPowerType.armyPower then
    val = self.armyPower
  elseif powerType == PowerOverviewPowerType.buildingPower then
    val = self.buildingPower
  elseif powerType == PowerOverviewPowerType.sciencePower then
    val = self.sciencePower
  elseif powerType == PowerOverviewPowerType.squadEquipPower then
    val = self.squadEquipPower
  elseif powerType == PowerOverviewPowerType.dominatorPower then
    val = self.dominatorPower
  elseif powerType == PowerOverviewPowerType.tacticalCard then
    val = self.tacticalCardPower
  elseif powerType == PowerOverviewPowerType.superSoldierPower then
    val = self.baseArmyPower + self.soldierElevenPower
  end
  return val
end

local function GetValByPowerSourceType(self, sourceType)
  local val = 0
  if sourceType == PowerOverviewPowerSourceType.heroLevelPower then
    val = self.heroLevelPower
  elseif sourceType == PowerOverviewPowerSourceType.heroRankPower then
    val = self.heroRankPower
  elseif sourceType == PowerOverviewPowerSourceType.heroSkillPower then
    val = self.heroSkillPower
  elseif sourceType == PowerOverviewPowerSourceType.heroEquipPower then
    val = self.heroEquipPower
  elseif sourceType == PowerOverviewPowerSourceType.heroHonorPower then
    val = self.heroHonorPower
  elseif sourceType == PowerOverviewPowerSourceType.heroWeaponPower then
    val = self.heroWeaponPower
  elseif sourceType == PowerOverviewPowerSourceType.heroDecoPower then
    val = self.heroDecoPower
  elseif sourceType == PowerOverviewPowerSourceType.heroAwakenPower then
    val = self.heroAwakenPower
  elseif sourceType == PowerOverviewPowerSourceType.weaponChipPower then
    val = self.weaponChipPower
  elseif sourceType == PowerOverviewPowerSourceType.weaponEquipPower then
    val = self.weaponEquipPower
  elseif sourceType == PowerOverviewPowerSourceType.weaponLevelPower then
    val = self.weaponLevelPower
  elseif sourceType == PowerOverviewPowerSourceType.buildingDecoPower then
    val = self.buildingDecoPower
  elseif sourceType == PowerOverviewPowerSourceType.buildingWorkerPower then
    val = self.buildingWorkerPower
  elseif sourceType == PowerOverviewPowerSourceType.playerPower then
    val = LuaEntry.Player.power
  elseif sourceType == PowerOverviewPowerSourceType.armyPower then
    val = self.armyPower
  elseif sourceType == PowerOverviewPowerSourceType.sciencePower then
    val = self.sciencePower
  elseif sourceType == PowerOverviewPowerSourceType.dominatorBasePower then
    val = self.dominatorBasePower
  elseif sourceType == PowerOverviewPowerSourceType.dominatorRankPower then
    val = self.dominatorRankPower
  elseif sourceType == PowerOverviewPowerSourceType.dominatorSkillPower then
    val = self.dominatorSkillPower
  elseif sourceType == PowerOverviewPowerSourceType.dominatorTrainLvPower then
    val = self.dominatorTrainLvPower
  elseif sourceType == PowerOverviewPowerSourceType.dominatorTrainStarPower then
    val = self.dominatorTrainStarPower
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardBasePower then
    val = self.tacticalCardBasePower
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardLevelPower then
    val = self.tacticalCardLevelPower
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardStarPower then
    val = self.tacticalCardStarPower
  elseif sourceType == PowerOverviewPowerSourceType.baseArmyPower then
    val = self.baseArmyPower
  elseif sourceType == PowerOverviewPowerSourceType.soldierElevenPower then
    val = self.soldierElevenPower
  end
  return val
end

function PlayerPowerDataManager:IsReceiveData()
  return self.isReceiveData
end

PlayerPowerDataManager.__init = __init
PlayerPowerDataManager.__delete = __delete
PlayerPowerDataManager.RefreshPowerData = RefreshPowerData
PlayerPowerDataManager.GetValByPowerType = GetValByPowerType
PlayerPowerDataManager.GetValByPowerSourceType = GetValByPowerSourceType
return PlayerPowerDataManager
