local UILWDominatorPropertyDetailCtrl = BaseClass("UILWDominatorPropertyDetailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWDominatorPropertyDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorPropertyDetail)
end

function UILWDominatorPropertyDetailCtrl:GetHeroPropertyDetailGroupList(dominatorInfo, propertyType)
  local groupDataList = {}
  local baseData = {}
  baseData.title = 151099
  baseData.showTitleType = HeroPropertyDetailShowTitle.Base
  baseData.itemList = {}
  table.insert(baseData.itemList, self:GetBaseAttack(dominatorInfo))
  table.insert(baseData.itemList, self:GetBaseHp(dominatorInfo))
  table.insert(baseData.itemList, self:GetBaseDefend(dominatorInfo))
  table.insert(baseData.itemList, self:GetBaseSolider(dominatorInfo))
  table.insert(groupDataList, baseData)
  local heroData = dominatorInfo:GetHeroInfo()
  if heroData then
    local heroAttackData = self:GetHeroAttackOrDefend(heroData, EffectOverviewType.DominatorAttack)
    heroAttackData.title = "building_center_desc4"
    heroAttackData.showTitleType = HeroPropertyDetailShowTitle.Attack
    local heroDefendData = self:GetHeroAttackOrDefend(heroData, EffectOverviewType.DominatorDefend)
    heroDefendData.title = "building_center_desc5"
    heroDefendData.showTitleType = HeroPropertyDetailShowTitle.Defend
    table.insert(groupDataList, heroAttackData)
    table.insert(groupDataList, heroDefendData)
  end
  return groupDataList
end

function UILWDominatorPropertyDetailCtrl:GetHeroAttackOrDefend(heroData, effectOverviewType)
  local overviewInfoList = DataCenter.LWEffectOverviewManager:GetTemplateListByType(effectOverviewType)
  local data = {}
  data.itemList = {}
  local armyTypeLimit = heroData.heroType
  for _, v in ipairs(overviewInfoList) do
    local template = v.template
    if template.armyType == 0 or armyTypeLimit ~= 0 and template.armyType == armyTypeLimit then
      local isShow = false
      local item = {}
      item.isShowDetail = true
      item.mainTotalTitle = template.name
      local totalValue = v:GetAllTotalValue() * 100
      item.mainTotalValue = string.format(" %s%%", string.format("%.2f", totalValue))
      item.order = template.index
      item.propertyList = {}
      local effectSourceList = DataCenter.LWEffectOverviewManager:GetUnlockEffectSourceList(template.id)
      for i = 1, table.count(effectSourceList) do
        local property = {}
        local effectSourceType = effectSourceList[i]
        property.name = self:GetEffectNameBySourcePoint(effectSourceType)
        local effectValue = v:GetEffectValueDataByEffectSourceType(effectSourceType)
        local effectIds = template:GetEffectIdListByEffectSourceType(effectSourceType)
        if 0 < effectValue then
          isShow = true
          if 0 < table.count(effectIds) then
            local describe, text = WorkerUtil.GetEffectText(effectIds[1], effectValue, true)
            property.value = text
          else
            property.value = effectValue
          end
          table.insert(item.propertyList, property)
        end
      end
      item.hasRows = effectSourceList ~= nil and 0 < #effectSourceList
      if isShow then
        table.insert(data.itemList, item)
      end
    end
  end
  table.sort(data.itemList, function(a, b)
    return a.order < b.order
  end)
  return data
end

function UILWDominatorPropertyDetailCtrl:GetBaseAttack(dominatorInfo)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = "effect_number_name_52014"
  item.mainTotalValue = math.max(math.floor(dominatorInfo:GetEffect(HeroEffectDefine.DominatorFinalAttack)), 0)
  item.propertyList = {}
  item.hasRows = true
  local valTable = dominatorInfo:GetAtkSourceDict()
  if 0 < valTable.rankVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_1"),
      value = valTable.rankVal
    })
  end
  if 0 < valTable.normalTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_3"),
      value = valTable.normalTrainVal
    })
  end
  if 0 < valTable.mainTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_4"),
      value = valTable.mainTrainVal
    })
  end
  if 0 < valTable.buildVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_2"),
      value = valTable.buildVal
    })
  end
  if 0 < valTable.tacticalWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = valTable.tacticalWeaponVal
    })
  end
  return item
end

function UILWDominatorPropertyDetailCtrl:GetBaseHp(dominatorInfo)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = "effect_number_name_52004"
  item.mainTotalValue = math.max(math.floor(dominatorInfo:GetEffect(HeroEffectDefine.DominatorFinalHp)), 0)
  item.propertyList = {}
  item.hasRows = true
  local valTable = dominatorInfo:GetHpSourceDict()
  if 0 < valTable.rankVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_1"),
      value = valTable.rankVal
    })
  end
  if 0 < valTable.normalTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_3"),
      value = valTable.normalTrainVal
    })
  end
  if 0 < valTable.mainTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_4"),
      value = valTable.mainTrainVal
    })
  end
  if 0 < valTable.buildVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_2"),
      value = valTable.buildVal
    })
  end
  if 0 < valTable.tacticalWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = valTable.tacticalWeaponVal
    })
  end
  return item
end

function UILWDominatorPropertyDetailCtrl:GetBaseDefend(dominatorInfo)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = "effect_number_name_52024"
  item.mainTotalValue = math.max(math.floor(dominatorInfo:GetEffect(HeroEffectDefine.DominatorFinalDefence)), 0)
  item.propertyList = {}
  item.hasRows = true
  local valTable = dominatorInfo:GetDefSourceDict()
  if 0 < valTable.rankVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_1"),
      value = valTable.rankVal
    })
  end
  if 0 < valTable.normalTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_3"),
      value = valTable.normalTrainVal
    })
  end
  if 0 < valTable.mainTrainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_4"),
      value = valTable.mainTrainVal
    })
  end
  if 0 < valTable.buildVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_2"),
      value = valTable.buildVal
    })
  end
  if 0 < valTable.tacticalWeaponVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110310),
      value = valTable.tacticalWeaponVal
    })
  end
  return item
end

function UILWDominatorPropertyDetailCtrl:GetBaseSolider(dominatorInfo)
  local item = {}
  item.isShowDetail = true
  item.mainTotalTitle = 211245
  item.mainTotalValue = math.max(math.floor(dominatorInfo:GetSoldierCapacity()), 0)
  item.propertyList = {}
  item.hasRows = true
  local valTable = dominatorInfo:GetSCSourceDict()
  if 0 < valTable.trainVal then
    table.insert(item.propertyList, {
      name = Localization:GetString("dominator_attr_desc_4"),
      value = valTable.trainVal
    })
  end
  if 0 < valTable.buildVal then
    table.insert(item.propertyList, {
      name = Localization:GetString(110311),
      value = valTable.buildVal
    })
  end
  return item
end

function UILWDominatorPropertyDetailCtrl:GetEffectNameBySourcePoint(type)
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
  elseif type == EffectOverviewSourcePoint.DominatorTrainLevel then
    name = Localization:GetString("overview_20")
  end
  return name
end

return UILWDominatorPropertyDetailCtrl
