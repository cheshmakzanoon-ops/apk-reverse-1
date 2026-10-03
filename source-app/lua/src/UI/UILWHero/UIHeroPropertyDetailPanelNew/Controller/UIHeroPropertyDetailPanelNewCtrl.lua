local UIHeroPropertyDetailPanelNewCtrl = BaseClass("UIHeroPropertyDetailPanelNewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPropertyDetailPanelNew)
end

local function GetHeroPropertyDetailGroupList(self, heroData, propertyType)
  local groupDataList = {}
  local baseData = {}
  baseData.title = 151099
  baseData.showTitleType = HeroPropertyDetailShowTitle.Base
  baseData.itemList = {}
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelNewCtrl.GetBaseAttack(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelNewCtrl.GetBaseHp(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelNewCtrl.GetBaseDefend(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelNewCtrl.GetBaseSolider(heroData))
  local heroAttackData = UIHeroPropertyDetailPanelNewCtrl.GetHeroAttackOrDefend(EffectOverviewType.HeroAttack)
  heroAttackData.title = "building_center_desc4"
  heroAttackData.showTitleType = HeroPropertyDetailShowTitle.Attack
  local heroDefendData = UIHeroPropertyDetailPanelNewCtrl.GetHeroAttackOrDefend(EffectOverviewType.HeroDefend)
  heroDefendData.title = "building_center_desc5"
  heroDefendData.showTitleType = HeroPropertyDetailShowTitle.Defend
  table.insert(groupDataList, baseData)
  table.insert(groupDataList, heroAttackData)
  table.insert(groupDataList, heroDefendData)
  return groupDataList
end

local function GetHeroAttackOrDefend(effectOverviewType)
  local overviewInfoList = DataCenter.LWEffectOverviewManager:GetTemplateListByType(effectOverviewType)
  local data = {}
  data.itemList = {}
  local armyTypeLimit = 0
  local showHeroUuid = DataCenter.HeroDataManager:GetShowHeroUuidCache()
  if showHeroUuid ~= nil then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(showHeroUuid)
    if heroData ~= nil then
      armyTypeLimit = heroData.heroType
    end
  end
  for _, v in ipairs(overviewInfoList) do
    local template = v.template
    if template.armyType == 0 or armyTypeLimit ~= 0 and template.armyType == armyTypeLimit then
      local item = {}
      item.isShowDetail = true
      item.mainTotalTitle = template.name
      item.mainTotalValue = string.format(" %s%%", string.format("%.2f", v:GetAllTotalValue() * 100))
      item.order = template.index
      item.propertyList = {}
      local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(template.id)
      for i = 1, table.count(effectSourceList) do
        local property = {}
        local effectSourceType = effectSourceList[i]
        property.name = UIHeroPropertyDetailPanelNewCtrl.GetEffectNameBySourcePoint(effectSourceType)
        local effectValue = v:GetEffectValueDataByEffectSourceType(effectSourceType)
        local effectIds = template:GetEffectIdListByEffectSourceType(effectSourceType)
        if 0 < table.count(effectIds) then
          local describe, text = WorkerUtil.GetEffectText(effectIds[1], effectValue, true)
          property.value = text
        else
          property.value = effectValue
        end
        table.insert(item.propertyList, property)
      end
      item.hasRows = effectSourceList ~= nil and 0 < #effectSourceList
      table.insert(data.itemList, item)
    end
  end
  table.sort(data.itemList, function(a, b)
    return a.order < b.order
  end)
  return data
end

local function GetBaseAttack(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 110298
  item.mainTotalValue = heroData:GetAtk()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal, awakenVal = UIHeroPropertyDetailPanelNewCtrl.CalcHeroAtkSource(heroData)
  table.insert(item.propertyList, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < weaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = weaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return item
end

local function GetBaseHp(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 110297
  item.mainTotalValue = heroData:GetMaxHp()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, equipVal, rankVal, buildVal, honorVal, weaponVal, uniqueWeaponVal, dominatorVal, awakenVal = UIHeroPropertyDetailPanelNewCtrl.CalcHeroHpSource(heroData)
  table.insert(item.propertyList, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < honorVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110303),
      value = honorVal
    })
  end
  if 0 < weaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = weaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return item
end

local function GetBaseDefend(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 110299
  item.mainTotalValue = heroData:GetDef()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal, awakenVal = UIHeroPropertyDetailPanelNewCtrl.CalcHeroDefSource(heroData)
  table.insert(item.propertyList, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110301),
    value = equipVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110302),
    value = rankVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  if 0 < weaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = weaponVal
    })
  end
  if 0 < uniqueWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_unique_weapon_title3"),
      value = uniqueWeaponVal
    })
  end
  if 0 < dominatorVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_train_bonus"),
      value = dominatorVal
    })
  end
  if 0 < awakenVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("hero_awaken_desc_23"),
      value = awakenVal
    })
  end
  return item
end

local function GetBaseSolider(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 211245
  item.mainTotalValue = heroData:GetSoldierCapacity()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, survivorVal, buildVal, sciVal = heroData:CalcHeroSCSource()
  table.insert(item.propertyList, {
    name = Localization:GetString(110300),
    value = levelVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString("overview_8"),
    value = survivorVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110311),
    value = buildVal
  })
  table.insert(item.propertyList, {
    name = Localization:GetString(110292),
    value = sciVal
  })
  return item
end

local function CalcHeroHpSource(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData then
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
    return levelVal, equipVal, rankVal, buildVal, honorVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal, awakenVal
  end
end

local function CalcHeroAtkSource(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData then
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
    return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal, awakenVal
  end
end

local function CalcHeroDefSource(heroData)
  local propertyGroupedDetailData = heroData:GetPropertyGroupedDetailData()
  if propertyGroupedDetailData then
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
    return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal, awakenVal
  end
end

local function CalcHeroSCSource(heroData)
  return heroData:CalcHeroSCSource()
end

local function GetEffectNameBySourcePoint(type)
  local name = ""
  if type == EffectOverviewSourcePoint.Tech then
    name = Localization:GetString("110292")
  elseif type == EffectOverviewSourcePoint.Drone then
    name = Localization:GetString("overview_1")
  elseif type == EffectOverviewSourcePoint.HonorWall then
    name = Localization:GetString("overview_2")
  elseif type == EffectOverviewSourcePoint.Vip then
    name = Localization:GetString("overview_3")
  elseif type == EffectOverviewSourcePoint.Building then
    name = Localization:GetString("110291")
  elseif type == EffectOverviewSourcePoint.AllianceTech then
    name = Localization:GetString("110293")
  elseif type == EffectOverviewSourcePoint.OccupiedCity then
    name = Localization:GetString("overview_4")
  elseif type == EffectOverviewSourcePoint.ProfessionSpecialization then
    name = Localization:GetString("overview_5")
  elseif type == EffectOverviewSourcePoint.SeasonBuilding then
    name = Localization:GetString("overview_6")
  elseif type == EffectOverviewSourcePoint.SuperMonthCard then
    name = Localization:GetString("overview_7")
  elseif type == EffectOverviewSourcePoint.Survivor then
    name = Localization:GetString("overview_8")
  elseif type == EffectOverviewSourcePoint.Decoration then
    name = Localization:GetString("overview_9")
  elseif type == EffectOverviewSourcePoint.Offices then
    name = Localization:GetString("457025")
  elseif type == EffectOverviewSourcePoint.Equip then
    name = Localization:GetString("129024")
  elseif type == EffectOverviewSourcePoint.HeroSkill then
    name = Localization:GetString("150001")
  elseif type == EffectOverviewSourcePoint.HeroUniqueWeapon then
    name = Localization:GetString("hero_unique_weapon_title3")
  elseif type == EffectOverviewSourcePoint.DominatorRankLevel then
    name = Localization:GetString("overview_21")
  elseif type == EffectOverviewSourcePoint.DominatorTrainLevelLevel then
    name = Localization:GetString("overview_20")
  end
  return name
end

UIHeroPropertyDetailPanelNewCtrl.CloseSelf = CloseSelf
UIHeroPropertyDetailPanelNewCtrl.GetHeroPropertyDetailGroupList = GetHeroPropertyDetailGroupList
UIHeroPropertyDetailPanelNewCtrl.GetBaseHp = GetBaseHp
UIHeroPropertyDetailPanelNewCtrl.GetBaseAttack = GetBaseAttack
UIHeroPropertyDetailPanelNewCtrl.GetBaseDefend = GetBaseDefend
UIHeroPropertyDetailPanelNewCtrl.GetBaseSolider = GetBaseSolider
UIHeroPropertyDetailPanelNewCtrl.CalcHeroHpSource = CalcHeroHpSource
UIHeroPropertyDetailPanelNewCtrl.CalcHeroAtkSource = CalcHeroAtkSource
UIHeroPropertyDetailPanelNewCtrl.CalcHeroDefSource = CalcHeroDefSource
UIHeroPropertyDetailPanelNewCtrl.CalcHeroSCSource = CalcHeroSCSource
UIHeroPropertyDetailPanelNewCtrl.GetHeroAttackOrDefend = GetHeroAttackOrDefend
UIHeroPropertyDetailPanelNewCtrl.GetEffectNameBySourcePoint = GetEffectNameBySourcePoint
return UIHeroPropertyDetailPanelNewCtrl
