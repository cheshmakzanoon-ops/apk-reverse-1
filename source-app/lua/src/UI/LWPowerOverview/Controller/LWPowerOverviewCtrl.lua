local LWPowerOverviewCtrl = BaseClass("LWPowerOverviewCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWPowerOverview, {anim = useAnimation})
end

local function GetNameKeyByPowerType(self, powerType)
  local nameKey = "power_stats_21"
  if powerType == PowerOverviewPowerType.playerPower then
    nameKey = "power_stats_21"
  elseif powerType == PowerOverviewPowerType.heroPower then
    nameKey = "power_stats_21"
  elseif powerType == PowerOverviewPowerType.armyPower then
    nameKey = "power_stats_24"
  elseif powerType == PowerOverviewPowerType.buildingPower then
    nameKey = "power_stats_23"
  elseif powerType == PowerOverviewPowerType.sciencePower then
    nameKey = "power_stats_25"
  elseif powerType == PowerOverviewPowerType.squadEquipPower then
    nameKey = "power_stats_22"
  elseif powerType == PowerOverviewPowerType.dominatorPower then
    nameKey = "dominator_power"
  elseif powerType == PowerOverviewPowerType.tacticalCard then
    nameKey = "battle_card_power_title"
  elseif powerType == PowerOverviewPowerType.superSoldierPower then
    nameKey = "power_stats_24"
  end
  return nameKey
end

local function GetIconPathByPowerType(self, powerType)
  local iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_zhuangshi_icon.png"
  local sizeX, sizeY
  if powerType == PowerOverviewPowerType.heroPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/mjc_icon_s_yingxiong.png"
  elseif powerType == PowerOverviewPowerType.armyPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_shibing_icon.png"
  elseif powerType == PowerOverviewPowerType.buildingPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_zhuangshi_icon.png"
  elseif powerType == PowerOverviewPowerType.sciencePower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_keji_icon.png"
  elseif powerType == PowerOverviewPowerType.squadEquipPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_wurenji_icon.png"
  elseif powerType == PowerOverviewPowerType.dominatorPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/mjc_icon_s_zhuzai1.png"
  elseif powerType == PowerOverviewPowerType.tacticalCard then
    iconPath = UIAssets.TacticalCardSystemIcon
    sizeX = 50
    sizeY = 50
  elseif powerType == PowerOverviewPowerType.superSoldierPower then
    iconPath = "Assets/Main/Sprites/UI/UILWMail/zyf_zhanbao_shibing_icon.png"
  end
  return iconPath, sizeX, sizeY
end

local function GetNameKeyBySourceType(self, sourceType)
  local nameKey = "power_stats_1"
  if sourceType == PowerOverviewPowerSourceType.heroLevelPower then
    nameKey = "power_stats_1"
  elseif sourceType == PowerOverviewPowerSourceType.heroRankPower then
    nameKey = "power_stats_2"
  elseif sourceType == PowerOverviewPowerSourceType.heroSkillPower then
    nameKey = "power_stats_3"
  elseif sourceType == PowerOverviewPowerSourceType.heroEquipPower then
    nameKey = "power_stats_4"
  elseif sourceType == PowerOverviewPowerSourceType.heroHonorPower then
    nameKey = "power_stats_5"
  elseif sourceType == PowerOverviewPowerSourceType.heroWeaponPower then
    nameKey = "power_stats_6"
  elseif sourceType == PowerOverviewPowerSourceType.heroDecoPower then
    nameKey = "power_stats_7"
  elseif sourceType == PowerOverviewPowerSourceType.heroAwakenPower then
    nameKey = "hero_awaken_tab_9"
  elseif sourceType == PowerOverviewPowerSourceType.weaponChipPower then
    nameKey = "power_stats_8"
  elseif sourceType == PowerOverviewPowerSourceType.weaponEquipPower then
    nameKey = "power_stats_9"
  elseif sourceType == PowerOverviewPowerSourceType.weaponLevelPower then
    nameKey = "power_stats_10"
  elseif sourceType == PowerOverviewPowerSourceType.buildingDecoPower then
    nameKey = "power_stats_11"
  elseif sourceType == PowerOverviewPowerSourceType.buildingWorkerPower then
    nameKey = "power_stats_12"
  elseif sourceType == PowerOverviewPowerSourceType.dominatorRankPower then
    nameKey = "dominator_power_rank"
  elseif sourceType == PowerOverviewPowerSourceType.dominatorSkillPower then
    nameKey = "dominator_power_skill"
  elseif sourceType == PowerOverviewPowerSourceType.dominatorTrainLvPower then
    nameKey = "dominator_power_train_level"
  elseif sourceType == PowerOverviewPowerSourceType.dominatorTrainStarPower then
    nameKey = "dominator_power_train_evl"
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardBasePower then
    nameKey = "battle_card_base_power"
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardLevelPower then
    nameKey = "battle_card_upgrade_power"
  elseif sourceType == PowerOverviewPowerSourceType.tacticalCardStarPower then
    nameKey = "battle_card_star_power"
  elseif sourceType == PowerOverviewPowerSourceType.baseArmyPower then
    nameKey = "soldier_power_type_01"
  elseif sourceType == PowerOverviewPowerSourceType.soldierElevenPower then
    nameKey = "soldier_power_type_02"
  end
  return nameKey
end

LWPowerOverviewCtrl.CloseSelf = CloseSelf
LWPowerOverviewCtrl.GetNameKeyByPowerType = GetNameKeyByPowerType
LWPowerOverviewCtrl.GetIconPathByPowerType = GetIconPathByPowerType
LWPowerOverviewCtrl.GetNameKeyBySourceType = GetNameKeyBySourceType
return LWPowerOverviewCtrl
