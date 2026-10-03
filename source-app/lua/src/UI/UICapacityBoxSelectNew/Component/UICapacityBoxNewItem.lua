local UICapacityBoxNewItem = BaseClass("UICapacityBoxNewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UICapacityBoxNewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxNewItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxNewItem:OnEnable()
  base.OnEnable(self)
end

function UICapacityBoxNewItem:OnDisable()
  base.OnDisable(self)
end

function UICapacityBoxNewItem:ComponentDefine()
  self.commonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.compNotOwn = self:AddComponent(UIBaseContainer, "NotOwn")
  self.textNotOwn = self:AddComponent(UIText, "NotOwn/NotOwnText")
  self.compMax = self:AddComponent(UIBaseContainer, "Max")
  self.textMax = self:AddComponent(UIText, "Max/MaxText")
  self.textMax:SetText("MAX")
  
  function self.clickCallBack()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end
end

function UICapacityBoxNewItem:ComponentDestroy()
  self.commonResItem = nil
  self.clickCallBack = nil
  self.compNotOwn = nil
  self.textNotOwn = nil
  self.compMax = nil
  self.textMax = nil
end

function UICapacityBoxNewItem:DataDefine()
  self.param = {}
end

function UICapacityBoxNewItem:DataDestroy()
  self.param = nil
end

function UICapacityBoxNewItem:RefreshData(param, itemTemplate)
  self.param = param
  self.itemTemplate = itemTemplate
  param.clickCallBack = self.clickCallBack
  self.commonResItem:ReInit(param)
  local isShowNotOwn, notOwnText = self:ShowNotOwned()
  self.compNotOwn:SetActive(isShowNotOwn)
  if isShowNotOwn then
    self.textNotOwn:SetText(notOwnText)
  end
  self.compMax:SetActive(self:ShowMax())
end

function UICapacityBoxNewItem:OnBtnClick()
  if self.param.callback ~= nil then
    self.param.callback(self.transform, self.param.index, self.param.itemId)
  end
end

function UICapacityBoxNewItem:RefreshCount(count)
  if not self.param then
    return
  end
  if self.param.perCount then
    self.param.count = count * self.param.perCount
  else
    self.param.count = count
  end
  self.commonResItem:ReInit(self.param)
end

function UICapacityBoxNewItem:ShowNotOwned()
  if self.itemTemplate == nil then
    return false
  end
  if self.itemTemplate.popupType == GOODS_POPUP_TYPE.Decoration then
    local baseBuildingId = self.view.ctrl:ItemIdToBuildingBaseId(self.param.itemId)
    if baseBuildingId then
      local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
      if not hasBuilding then
        local curCount = BuildingUtils.GetDecorateCountByLevel(baseBuildingId, 1)
        if curCount <= 0 then
          return true, Localization:GetString("optional_box_desc1")
        end
      end
    end
  elseif self.itemTemplate.popupType == GOODS_POPUP_TYPE.Hero then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if itemTemplate then
      local heroId = self.view.ctrl:ItemIdToHeroId(self.param.itemId)
      if heroId then
        if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
          local hasWeapon = false
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local level = heroData:GetUniqueWeaponLv()
            if level and 0 < level then
              hasWeapon = true
            end
          end
          return not hasWeapon, Localization:GetString("optional_box_desc1")
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          return heroData == nil, Localization:GetString("optional_box_desc1")
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          return heroData == nil or not heroData:IsHeroAwakened(), Localization:GetString("optional_box_desc20")
        end
      end
    end
  elseif self.itemTemplate.popupType == GOODS_POPUP_TYPE.Dominator then
    local dominatorId = self.view.ctrl:ItemIdToDominatorId(self.param.itemId)
    if dominatorId then
      local dominatorData = DataCenter.DominatorManager:GetInfoById(dominatorId)
      return dominatorData == nil, Localization:GetString("optional_box_desc1")
    end
  end
  return false
end

function UICapacityBoxNewItem:ShowMax()
  if self.itemTemplate == nil then
    return false
  end
  if self.itemTemplate.popupType == GOODS_POPUP_TYPE.Decoration then
    local baseBuildingId = self.view.ctrl:ItemIdToBuildingBaseId(self.param.itemId)
    if baseBuildingId then
      local hasBuilding = DataCenter.BuildManager:HasBuilding(baseBuildingId, true)
      if hasBuilding then
        local buildData = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(baseBuildingId, true)
        if buildData then
          local baseBuildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(baseBuildingId)
          if baseBuildTemplate and buildData.level >= baseBuildTemplate.max_level then
            return true
          end
        end
      end
    end
  elseif self.itemTemplate.popupType == GOODS_POPUP_TYPE.Hero then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if itemTemplate then
      local heroId = self.view.ctrl:ItemIdToHeroId(self.param.itemId)
      if heroId then
        if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local level = heroData:GetUniqueWeaponLv()
            if level and 0 < level then
              local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, level)
              if weaponTemplate then
                local isMax = weaponTemplate:IsMaxLevel()
                if isMax then
                  if heroData:IsAllUnitMaxLv() then
                    return true
                  end
                  local canEnhance = heroData:IsUnlockedEnhanceUW() or heroData:CanUnlockEnhanceUW()
                  if canEnhance then
                    return false
                  else
                    return true
                  end
                end
              end
            end
          end
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            local curRank = heroData:GetRank()
            local maxRank = heroData.meta.maxRank
            if curRank >= maxRank then
              local isHonorMax = heroData:IsReachMaxHonorLevel()
              return isHonorMax
            end
          end
        elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
          local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
          if heroData then
            return heroData:IsHeroAwakenReachMaxLevel()
          end
        end
      end
    end
  elseif self.itemTemplate.popupType == GOODS_POPUP_TYPE.Dominator then
    local dominatorId = self.view.ctrl:ItemIdToDominatorId(self.param.itemId)
    if dominatorId then
      local dominatorData = DataCenter.DominatorManager:GetInfoById(dominatorId)
      if dominatorData then
        local curRankTemplate = dominatorData:GetCurRankTemplate()
        if curRankTemplate then
          local isMaxRank = curRankTemplate:IsMaxRank()
          if isMaxRank then
            return true
          end
        end
      end
    end
  end
  return false
end

return UICapacityBoxNewItem
