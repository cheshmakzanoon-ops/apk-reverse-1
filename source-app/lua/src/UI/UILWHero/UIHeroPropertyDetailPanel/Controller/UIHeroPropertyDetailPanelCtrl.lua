local UIHeroPropertyDetailPanelCtrl = BaseClass("UIHeroPropertyDetailPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPropertyDetailPanel)
end

local function GetHeroPropertyGroupies(self, heroData, propertyType)
  local sortedHeroPropertyGroupDic = {}
  if propertyType == UIHeroPropertyDetailType.Hero then
    sortedHeroPropertyGroupDic = DataCenter.EffectNumberTemplateManager:GetSortedAllEffectNumberGroup()
  elseif propertyType == UIHeroPropertyDetailType.Equip then
    sortedHeroPropertyGroupDic = DataCenter.EffectNumberTemplateManager:GetSortedAllEquipEffectNumberGroup()
  else
    return {}
  end
  local heroPropertyGroupies = {}
  for i = 1, #sortedHeroPropertyGroupDic do
    local k = sortedHeroPropertyGroupDic[i]
    local v = {}
    if propertyType == UIHeroPropertyDetailType.Hero then
      v = DataCenter.EffectNumberTemplateManager:GetNumberEffectGroup(sortedHeroPropertyGroupDic[i])
    else
      v = DataCenter.EffectNumberTemplateManager:GetEquipNumberEffectGroup(sortedHeroPropertyGroupDic[i])
    end
    local heroPropertyGroup = {}
    for j = 1, #v do
      local effectNumberId = v[j].id
      local effectValue = 0
      local sequence = 0
      if propertyType == UIHeroPropertyDetailType.Hero then
        effectValue = heroData:GetProperty(effectNumberId)
        sequence = v[j].sequence
      elseif propertyType == UIHeroPropertyDetailType.Equip then
        effectValue = heroData:GetEquipProperty(effectNumberId)
        sequence = v[j].equip_sequence
      end
      table.insert(heroPropertyGroup, {
        id = effectNumberId,
        name = v[j].name,
        value = HeroUtils.GetFormattedPropertyValue(effectNumberId, effectValue),
        desc = v[j].desc,
        sequence = sequence
      })
    end
    table.sort(heroPropertyGroup, function(a, b)
      return a.sequence < b.sequence
    end)
    local data = {id = k, data = heroPropertyGroup}
    table.insert(heroPropertyGroupies, data)
  end
  return heroPropertyGroupies
end

local function GetHeroPropertyDetailGroupList(self, heroData, propertyType)
  if propertyType == UIHeroPropertyDetailType.Equip then
    return self:GetHeroPropertyGroupies(heroData, propertyType)
  end
  local groupDataList = {}
  local baseData = {}
  baseData.title = 151099
  baseData.showTitleType = HeroPropertyDetailShowTitle.Base
  baseData.itemList = {}
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelCtrl.GetBaseAttack(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelCtrl.GetBaseHp(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelCtrl.GetBaseDefend(heroData))
  table.insert(baseData.itemList, UIHeroPropertyDetailPanelCtrl.GetBaseSolider(heroData))
  local heroAttackData = UIHeroPropertyDetailPanelCtrl.GetHeroAttackOrDefend(EffectOverviewType.HeroAttack)
  heroAttackData.title = "building_center_desc4"
  heroAttackData.showTitleType = HeroPropertyDetailShowTitle.Attack
  local heroDefendData = UIHeroPropertyDetailPanelCtrl.GetHeroAttackOrDefend(EffectOverviewType.HeroDefend)
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
        property.name = UIHeroPropertyDetailPanelCtrl.GetEffectNameBySourcePoint(effectSourceType)
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
  local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal = UIHeroPropertyDetailPanelCtrl.CalcHeroAtkSource(heroData)
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
  return item
end

local function GetBaseHp(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 110297
  item.mainTotalValue = heroData:GetMaxHp()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, equipVal, rankVal, buildVal, honorVal, weaponVal, uniqueWeaponVal, dominatorVal = UIHeroPropertyDetailPanelCtrl.CalcHeroHpSource(heroData)
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
  return item
end

local function GetBaseDefend(heroData)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 110299
  item.mainTotalValue = heroData:GetDef()
  item.propertyList = {}
  item.hasRows = true
  local levelVal, equipVal, rankVal, buildVal, weaponVal, uniqueWeaponVal, dominatorVal = UIHeroPropertyDetailPanelCtrl.CalcHeroDefSource(heroData)
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
  local hp = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateHp(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.hpFactor
  local levelVal = math.floor(hp * factor * (1 + heroData:GetProperty(HeroEffectDefine.HpAddRate) + heroData:GetProperty(HeroEffectDefine.TankHeroHpAddRate) + heroData:GetProperty(HeroEffectDefine.MissileHeroHpAddRate) + heroData:GetProperty(HeroEffectDefine.AircraftHeroHpAddRate)))
  local equipVal = math.floor(heroData:GetProperty(HeroEffectDefine.Equip_HP_Result))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_HP_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Life)
  local tacticalWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.TacticalWeaponHp_Result))
  local uniqueWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_result) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_UW_Unit_Self) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponHp_UW_Unit_All))
  local dominatorVal = math.floor(heroData:GetProperty(HeroEffectDefine.DominatorAffordHeroHp))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  local honorVal = math.floor(heroData:GetProperty(HeroEffectDefine.Honor_HP_Result))
  return levelVal, equipVal, rankVal, buildVal, honorVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
end

local function CalcHeroAtkSource(heroData)
  local atk = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateAtk(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.atkFactor
  local levelVal = math.floor(atk * factor * (1 + heroData:GetProperty(HeroEffectDefine.AllAttackAddRate) + heroData:GetProperty(HeroEffectDefine.TankAttackAddRate) + heroData:GetProperty(HeroEffectDefine.MissileAttackAddRate) + heroData:GetProperty(HeroEffectDefine.AircraftAttackAddRate)))
  local equipVal = math.floor(heroData:GetProperty(HeroEffectDefine.Equip_ATK_Result))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_ATK_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Attack)
  local tacticalWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.TacticalWeaponAtk_Result))
  local uniqueWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_result) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_Self) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponAtk_UW_Unit_All))
  local dominatorVal = math.floor(heroData:GetProperty(HeroEffectDefine.DominatorAffordHeroAtk))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
end

local function CalcHeroDefSource(heroData)
  local def = DataCenter.HeroLevelPropertyTemplateManager:GetTemplateDef(heroData.propertyTemplateType, heroData.level)
  local factor = heroData.meta.defFactor
  local levelVal = math.floor(def * factor * (1 + heroData:GetProperty(HeroEffectDefine.AllDefenseAddRate) + heroData:GetProperty(HeroEffectDefine.TankDefenseAddRate) + heroData:GetProperty(HeroEffectDefine.MissileDefenseAddRate) + heroData:GetProperty(HeroEffectDefine.AircraftDefenseAddRate)))
  local equipVal = math.floor(heroData:GetProperty(HeroEffectDefine.Equip_DEF_Result))
  local rankVal = math.floor(heroData:GetProperty(HeroEffectDefine.Hero_DEF_Result)) - levelVal
  local buildVal = heroData:GetBuildingAdditionByType(HeroicForceType.Defence)
  local tacticalWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.TacticalWeaponDef_Result))
  local uniqueWeaponVal = math.floor(heroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_result) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_UW_Unit_Self) + heroData:GetProperty(HeroEffectDefine.UniqueWeaponDef_UW_Unit_All))
  local dominatorVal = math.floor(heroData:GetProperty(HeroEffectDefine.DominatorAffordHeroDef))
  levelVal = math.max(levelVal, 0)
  equipVal = math.max(equipVal, 0)
  rankVal = math.max(rankVal, 0)
  buildVal = math.max(buildVal, 0)
  tacticalWeaponVal = math.max(tacticalWeaponVal, 0)
  uniqueWeaponVal = math.max(uniqueWeaponVal, 0)
  dominatorVal = math.max(dominatorVal, 0)
  return levelVal, equipVal, rankVal, buildVal, tacticalWeaponVal, uniqueWeaponVal, dominatorVal
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

UIHeroPropertyDetailPanelCtrl.CloseSelf = CloseSelf
UIHeroPropertyDetailPanelCtrl.GetHeroPropertyGroupies = GetHeroPropertyGroupies
UIHeroPropertyDetailPanelCtrl.GetHeroPropertyDetailGroupList = GetHeroPropertyDetailGroupList
UIHeroPropertyDetailPanelCtrl.GetBaseHp = GetBaseHp
UIHeroPropertyDetailPanelCtrl.GetBaseAttack = GetBaseAttack
UIHeroPropertyDetailPanelCtrl.GetBaseDefend = GetBaseDefend
UIHeroPropertyDetailPanelCtrl.GetBaseSolider = GetBaseSolider
UIHeroPropertyDetailPanelCtrl.CalcHeroHpSource = CalcHeroHpSource
UIHeroPropertyDetailPanelCtrl.CalcHeroAtkSource = CalcHeroAtkSource
UIHeroPropertyDetailPanelCtrl.CalcHeroDefSource = CalcHeroDefSource
UIHeroPropertyDetailPanelCtrl.CalcHeroSCSource = CalcHeroSCSource
UIHeroPropertyDetailPanelCtrl.GetHeroAttackOrDefend = GetHeroAttackOrDefend
UIHeroPropertyDetailPanelCtrl.GetEffectNameBySourcePoint = GetEffectNameBySourcePoint
return UIHeroPropertyDetailPanelCtrl
