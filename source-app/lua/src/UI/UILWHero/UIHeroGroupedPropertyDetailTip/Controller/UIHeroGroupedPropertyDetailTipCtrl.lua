local UIHeroGroupedPropertyDetailTipCtrl = BaseClass("UIHeroGroupedPropertyDetailTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIHeroGroupedPropertyDetailTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroGroupedPropertyDetailTip)
end

function UIHeroGroupedPropertyDetailTipCtrl:GetShowData(heroData, propertyType)
  if propertyType == 0 then
    return self:GetAtkShowData(heroData)
  elseif propertyType == 1 then
    return self:GetHpShowData(heroData)
  elseif propertyType == 2 then
    return self:GetDefShowData(heroData)
  end
end

function UIHeroGroupedPropertyDetailTipCtrl:GetAtkShowData(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData == nil then
    return
  end
  local showData = {}
  showData.mainPropName = Localization:GetString(110298)
  showData.mainPropValue = heroData:GetAtk()
  local atk = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateAtk(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.atkFactor
  local atkAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.AllAttackAddRate)
  local tankAtkAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.TankAttackAddRate)
  local missileAtkAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.MissileAttackAddRate)
  local aircraftAtkAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.AircraftAttackAddRate)
  local levelVal = math.floor(atk * factor * (1 + atkAddRate + tankAtkAddRate + missileAtkAddRate + aircraftAtkAddRate))
  local equipVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.EquipPhysicalAttack, HeroUtils.HeroPropertyGroupType.Equip))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_ATK_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Attack)
  local tacticalWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.TacticalWeaponAtk_Result, HeroUtils.HeroPropertyGroupType.Level))
  local uniqueWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_result, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Weapon))
  local dominatorVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.DominatorAffordHeroAtk, HeroUtils.HeroPropertyGroupType.DominatorTrain))
  local awakenVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_result, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Awaken))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  awakenVal = math.max(awakenVal, 0)
  showData.splitProp = {}
  table.insert(showData.splitProp, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < tacticalWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString(110310),
      value = tacticalWeaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return showData
end

function UIHeroGroupedPropertyDetailTipCtrl:GetHpShowData(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData == nil then
    return
  end
  local showData = {}
  showData.mainPropName = Localization:GetString(110297)
  showData.mainPropValue = heroData:GetMaxHp()
  local hp = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateHp(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.hpFactor
  local hpAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.HpAddRate)
  local tankHpAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.TankHeroHpAddRate)
  local missileHpAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.MissileHeroHpAddRate)
  local aircraftHpAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.AircraftHeroHpAddRate)
  local levelVal = math.floor(hp * factor * (1 + hpAddRate + tankHpAddRate + missileHpAddRate + aircraftHpAddRate))
  local equipVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.EquipHealthPoint, HeroUtils.HeroPropertyGroupType.Equip))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_HP_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Life)
  local tacticalWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.TacticalWeaponHp_Result, HeroUtils.HeroPropertyGroupType.Level))
  local uniqueWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_result, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Weapon))
  local dominatorVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.DominatorAffordHeroHp, HeroUtils.HeroPropertyGroupType.DominatorTrain))
  local awakenVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_result, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponHp_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Awaken))
  local honorVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.Honor_HP, HeroUtils.HeroPropertyGroupType.Honor))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  awakenVal = math.max(awakenVal, 0)
  honorVal = math.max(honorVal, 0)
  showData.splitProp = {}
  table.insert(showData.splitProp, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < honorVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString(110303),
      value = honorVal
    })
  end
  if 0 < tacticalWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString(110310),
      value = tacticalWeaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return showData
end

function UIHeroGroupedPropertyDetailTipCtrl:GetDefShowData(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData == nil then
    return
  end
  local showData = {}
  showData.mainPropName = Localization:GetString(110299)
  showData.mainPropValue = heroData:GetDef()
  local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateDef(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.defFactor
  local defAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.AllDefenseAddRate)
  local tankDefAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.TankDefenseAddRate)
  local missileDefAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.MissileDefenseAddRate)
  local aircraftDefAddRate = propertyGroupedDetailData:GetTotalPropertyValueInAllGroup(HeroEffectDefine.AircraftDefenseAddRate)
  local levelVal = math.floor(def * factor * (1 + defAddRate + tankDefAddRate + missileDefAddRate + aircraftDefAddRate))
  local equipVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.EquipPhysicalDefense, HeroUtils.HeroPropertyGroupType.Equip))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_DEF_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Defence)
  local tacticalWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.TacticalWeaponDef_Result, HeroUtils.HeroPropertyGroupType.Level))
  local uniqueWeaponVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_result, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Weapon) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Weapon))
  local dominatorVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.DominatorAffordHeroDef, HeroUtils.HeroPropertyGroupType.DominatorTrain))
  local awakenVal = math.floor(propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_result, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_UW_Unit_Self, HeroUtils.HeroPropertyGroupType.Awaken) + propertyGroupedDetailData:GetTotalPropertyValueInGroup(HeroEffectDefine.UniqueWeaponDef_UW_Unit_All, HeroUtils.HeroPropertyGroupType.Awaken))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  awakenVal = math.max(awakenVal, 0)
  showData.splitProp = {}
  table.insert(showData.splitProp, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(showData.splitProp, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < tacticalWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString(110310),
      value = tacticalWeaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(showData.splitProp, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return showData
end

return UIHeroGroupedPropertyDetailTipCtrl
