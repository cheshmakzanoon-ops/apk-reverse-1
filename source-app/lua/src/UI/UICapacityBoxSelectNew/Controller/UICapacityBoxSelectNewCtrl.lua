local UICapacityBoxSelectNewCtrl = BaseClass("UICapacityBoxSelectNewCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UICapacityBoxSelectNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityBoxSelectNew)
end

function UICapacityBoxSelectNewCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

function UICapacityBoxSelectNewCtrl:InitData()
end

function UICapacityBoxSelectNewCtrl:UseItem(type, uuid, count, param)
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = uuid,
    num = count,
    para1 = tostring(param)
  })
  self:CloseSelf()
end

function UICapacityBoxSelectNewCtrl:ItemIdToBuildingBaseId(itemId)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate ~= nil and not string.IsNullOrEmpty(itemTemplate.para2) then
    return tonumber(itemTemplate.para2)
  end
end

function UICapacityBoxSelectNewCtrl:ItemIdToHeroId(itemId)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate ~= nil and not string.IsNullOrEmpty(itemTemplate.para2) then
    return tonumber(itemTemplate.para2)
  end
end

function UICapacityBoxSelectNewCtrl:ItemIdToDominatorId(itemId)
  if not itemId then
    return 0
  end
  local dominatorId = DataCenter.DominatorTemplateManager:GetDominatorIdByUpgradeRankItem(itemId)
  return dominatorId
end

function UICapacityBoxSelectNewCtrl:GetQuickUseItemCount(boxItemId, itemId)
  local res = -1
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  local boxItemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(boxItemId)
  if itemTemplate and boxItemTemplate then
    if boxItemTemplate.popupType == GOODS_POPUP_TYPE.Decoration then
      local baseBuildingId = self:ItemIdToBuildingBaseId(itemId)
      if baseBuildingId then
        local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
        if baseBuildTemplate then
          local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
          if buildData ~= nil then
            if buildData.level < baseBuildTemplate.max_level then
              local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, buildData.level)
              if buildTemplate then
                local curCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
                if buildTemplate.decorationUpgradeType == DecorationUpgradeType.AdvanceUpgrade then
                  local prodStatus = buildData.prodStatus or 0
                  res = tonumber(buildTemplate.para2) - (prodStatus + curCount)
                else
                  res = tonumber(buildTemplate.para2) - curCount
                end
              end
            end
          else
            res = 1
          end
        end
      end
    elseif boxItemTemplate.popupType == GOODS_POPUP_TYPE.Hero then
      if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
        local curWeaponLevel = 0
        local heroId = self:ItemIdToHeroId(itemId)
        if heroId then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          local isMax = false
          if heroData then
            curWeaponLevel = heroData:GetUniqueWeaponLv()
            isMax = heroData:IsUniqueWeaponMaxLevel()
          end
          if not isMax then
            local nextWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, curWeaponLevel + 1)
            if nextWeaponTemplate then
              local needCount = 0
              local costs = nextWeaponTemplate:GetSortedCosts()
              for i, v in pairs(costs) do
                if v.itemId == itemId then
                  needCount = needCount + v.itemNum
                end
              end
              res = needCount
            end
          else
            local canEnhance = heroData:IsUnlockedEnhanceUW() or heroData:CanUnlockEnhanceUW()
            if canEnhance then
              local boxCount = DataCenter.ItemData:GetItemCount(boxItemId)
              local curItemCount = DataCenter.ItemData:GetItemCount(itemId)
              local isExceed, remain = self:IsUWEnhanceItemMax(heroId, itemId, boxCount)
              if not isExceed and 0 < remain then
                res = remain - curItemCount
                if res < 0 then
                  res = 0
                end
              end
            end
          end
        end
      elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
        local heroId = self:ItemIdToHeroId(itemId)
        if heroId then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local curRank = heroData:GetRank()
            local maxRank = heroData.meta.maxRank
            if curRank < maxRank then
              res = heroData:GetUpgradeRankCost()
            elseif not heroData:IsReachMaxHonorLevel() then
              res = heroData:GetHonorLevelUpgradeCost()
            end
          else
            res = HeroUtils.GetJigsawCost(itemId)
          end
        end
      elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
        local heroId = self:ItemIdToHeroId(itemId)
        if heroId then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local isMaxRank = heroData:IsHeroAwakenReachMaxLevel()
            if not isMaxRank then
              local rankTemplate = heroData:GetHeroAwakenRankTemplate()
              if rankTemplate then
                res = rankTemplate:GetRankUpgradeCostItemCount()
              end
            end
          end
        end
      end
    elseif boxItemTemplate.popupType == GOODS_POPUP_TYPE.Dominator then
      local dominatorId = self:ItemIdToDominatorId(itemId)
      if dominatorId then
        local dominatorData = DataCenter.DominatorManager:GetInfoById(dominatorId)
        if dominatorData then
          local rankTemplate = dominatorData:GetCurRankTemplate()
          if rankTemplate then
            local isMaxRank = rankTemplate:IsMaxRank()
            if not isMaxRank then
              res = dominatorData:GetUpgradeRankCostItemNum()
            end
          end
        end
      end
    end
  end
  return res
end

function UICapacityBoxSelectNewCtrl:GetDecorationValue(baseBuildingId, curLevel, nextLevel)
  local temp, temp1
  local paramList = {}
  if curLevel < nextLevel then
    local levelTemplate
    local nextLevelTemp = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, nextLevel)
    if 0 < curLevel then
      levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, curLevel)
    end
    local param
    for id, value in pairs(nextLevelTemp.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.name = temp
      param.addValue = temp1
      if levelTemplate and levelTemplate.building_effect_last[id] then
        temp, temp1 = WorkerUtil.GetEffectText(id, levelTemplate.building_effect_last[id], true)
        param.curValue = temp1
      else
        param.curValue = 0
      end
      table.insert(paramList, param)
    end
  elseif curLevel == nextLevel then
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, curLevel)
    local param
    for id, value in pairs(levelTemplate.building_effect_last) do
      temp, temp1 = WorkerUtil.GetEffectText(id, value, true)
      param = {}
      param.name = temp
      param.curValue = temp1
      table.insert(paramList, param)
    end
  end
  return paramList
end

function UICapacityBoxSelectNewCtrl:IsDecorationUpgradeItemMax(baseBuildingId, itemId)
  local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
  if baseBuildTemplate == nil then
    return false
  end
  local curLevel = 0
  local totalNeedCount = 0
  local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
  if buildData then
    if buildData.level >= baseBuildTemplate.max_level then
      return true
    else
      curLevel = buildData.level
    end
  end
  while curLevel < baseBuildTemplate.max_level do
    if curLevel == 0 then
      totalNeedCount = totalNeedCount + 1
    else
      local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, curLevel)
      if levelTemplate then
        totalNeedCount = totalNeedCount + tonumber(levelTemplate.para2)
      end
    end
    curLevel = curLevel + 1
  end
  local haveNum = 0
  local curBuildItemCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
  if buildData then
    local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(baseBuildingId, buildData.level)
    if curLevelTemplate then
      if curLevelTemplate.decorationUpgradeType == DecorationUpgradeType.AdvanceUpgrade then
        local prodStatus = buildData.prodStatus or 0
        haveNum = curBuildItemCount + prodStatus
      else
        haveNum = curBuildItemCount
      end
    end
  end
  return totalNeedCount <= haveNum
end

function UICapacityBoxSelectNewCtrl:IsHeroRankUpgradeItemMax(heroId, itemId, selectCount)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local curRank = heroData:GetRank()
    local maxRank = heroData.meta.maxRank
    local curHonorLevel = heroData.honorLevel
    local maxHonorLevel = heroData.maxHonorLevel
    local totalNeedCount = 0
    local usePromotion = heroData.meta ~= nil and not string.IsNullOrEmpty(heroData.meta.hero_promotion_peace_num)
    local key = "shard_need"
    if usePromotion then
      key = "shard_need_promotion"
    end
    if curRank >= maxRank then
      if heroData:IsReachMaxHonorLevel() then
        return true
      end
    else
      while curRank < maxRank do
        local rankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(curRank)
        if rankTemplate then
          if usePromotion then
            totalNeedCount = totalNeedCount + rankTemplate.shard_need_promotion
          else
            totalNeedCount = totalNeedCount + rankTemplate.shard_need
          end
        end
        curRank = curRank + 1
      end
    end
    while curHonorLevel < maxHonorLevel do
      totalNeedCount = totalNeedCount + GetTableData(TableName.LW_Hero_HonorLevel, curHonorLevel, key) or 0
      curHonorLevel = curHonorLevel + 1
    end
    local haveNum = DataCenter.ItemData:GetItemCount(itemId)
    local totalCurNum = haveNum + (selectCount or 0)
    return totalNeedCount <= totalCurNum
  end
  return false
end

function UICapacityBoxSelectNewCtrl:IsUniqueWeaponUpgradeItemMax(heroId, itemId)
  local curWeaponLevel = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    curWeaponLevel = heroData:GetUniqueWeaponLv()
  end
  local heroMaxLevelTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelTemplate(heroId)
  if heroMaxLevelTemplate then
    if curWeaponLevel >= heroMaxLevelTemplate.lv then
      return true
    end
    local totalNeedCount = 0
    while curWeaponLevel < heroMaxLevelTemplate.lv do
      local nextWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, curWeaponLevel + 1)
      if nextWeaponTemplate then
        local costs = nextWeaponTemplate:GetSortedCosts()
        for i, v in pairs(costs) do
          if v.itemId == itemId then
            totalNeedCount = totalNeedCount + v.itemNum
          end
        end
      end
      curWeaponLevel = curWeaponLevel + 1
    end
    local haveNum = DataCenter.ItemData:GetItemCount(itemId)
    return totalNeedCount <= haveNum
  end
  return false
end

function UICapacityBoxSelectNewCtrl:IsUWEnhanceItemMax(heroId, itemId, canChooseCnt)
  local haveNum = DataCenter.ItemData:GetItemCount(itemId)
  canChooseCnt = canChooseCnt or 0
  local total = haveNum + canChooseCnt
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if not heroData then
    return false, 0
  end
  if heroData:IsAllUnitMaxLv() then
    return true, total
  end
  for i = HeroUWEnhanceUnitType.Weapon, HeroUWEnhanceUnitType.Armor do
    local curLv = heroData:GetUWUnitLv(i)
    local maxLv = DataCenter.HeroUWEnhanceTemplateManager:GetMaxLevel(heroId, i)
    for j = curLv + 1, maxLv do
      local upgradeInfo = heroData:GetUnitUpgradeInfo(i)
      if upgradeInfo then
        total = total - upgradeInfo.cost
      end
      if total <= 0 then
        return false, 0
      end
    end
  end
  return true, total
end

return UICapacityBoxSelectNewCtrl
