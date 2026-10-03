local base = UIBaseContainer
local UICapacityBoxSelectNewHeroComponent = BaseClass("UICapacityBoxSelectNewHeroComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")

function UICapacityBoxSelectNewHeroComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UICapacityBoxSelectNewHeroComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICapacityBoxSelectNewHeroComponent:ComponentDefine()
  self.textName = self:AddComponent(UIText, "NameText")
  self.textDesc = self:AddComponent(UIText, "DesContent/ContentScroll/Viewport/ContentTxt/DescText")
  self.textLevel = self:AddComponent(UIText, "LevelContent/LevelLayout/LevelText")
  self.compHeroRankStar = self:AddComponent(LWHeroRankStar, "LevelContent/LevelLayout/HeroRankStar")
  self.btnInfo = self:AddComponent(UIButton, "LevelContent/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textOwn = self:AddComponent(UIText, "LevelContent/OwnText")
end

function UICapacityBoxSelectNewHeroComponent:ComponentDestroy()
  self.textName = nil
  self.textDesc = nil
  self.textLevel = nil
  self.compHeroRankStar = nil
  self.btnInfo = nil
  self.textOwn = nil
end

function UICapacityBoxSelectNewHeroComponent:DataDefine()
end

function UICapacityBoxSelectNewHeroComponent:DataDestroy()
end

function UICapacityBoxSelectNewHeroComponent:ReInit(itemId)
  self.itemId = itemId
  if self.itemId == nil then
    return
  end
  local name = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.itemId)
  self.textName:SetText(name)
  local desc = DataCenter.RewardManager:GetDescByType(RewardType.GOODS, self.itemId)
  self.textDesc:SetText(desc)
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if not itemTemplate then
    return
  end
  if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
    self:UpdateWeapon()
  elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
    self:UpdateHero()
  elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
    self:UpdateHeroAwaken()
  end
end

function UICapacityBoxSelectNewHeroComponent:UpdateWeapon()
  local heroId = self.view.ctrl:ItemIdToHeroId(self.itemId)
  if not heroId then
    return
  end
  local text1 = ""
  local text2 = ""
  self.compHeroRankStar:SetActive(false)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  local hasWeapon = false
  if heroData then
    local level = heroData:GetUniqueWeaponLv()
    if level and 0 < level then
      hasWeapon = true
    end
  end
  local haveNum = DataCenter.ItemData:GetItemCount(self.itemId)
  if hasWeapon then
    local level = heroData:GetUniqueWeaponLv()
    local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, level)
    local isMax = weaponTemplate:IsMaxLevel()
    local canEnhance = heroData:IsUnlockedEnhanceUW() or heroData:CanUnlockEnhanceUW()
    if isMax then
      if canEnhance then
        if heroData:IsAllUnitMaxLv() or self.view.ctrl:IsUWEnhanceItemMax(heroId, self.itemId) then
          text2 = Localization:GetString("optional_box_desc9", tostring(haveNum)) .. " " .. Localization:GetString("optional_box_desc13")
        else
          text2 = Localization:GetString("optional_box_desc9", tostring(haveNum))
        end
      else
        text2 = Localization:GetString("optional_box_desc9", tostring(haveNum)) .. " " .. Localization:GetString("optional_box_desc13")
      end
    else
      local nextWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, level + 1)
      if nextWeaponTemplate then
        local costs = nextWeaponTemplate:GetSortedCosts()
        for i, v in pairs(costs) do
          if v.itemId == self.itemId then
            text2 = Localization:GetString("optional_box_desc8", tostring(haveNum) .. "/" .. tostring(v.itemNum))
            break
          end
        end
      end
      if self.view.ctrl:IsUniqueWeaponUpgradeItemMax(heroId, self.itemId) then
        text2 = text2 .. " " .. Localization:GetString("optional_box_desc13")
      end
    end
    if isMax and canEnhance then
      text1 = Localization:GetString("hero_unique_unit_optional_box_desc", tostring(level), heroData:GetAllUnitLvSum())
    end
    if string.IsNullOrEmpty(text1) then
      text1 = Localization:GetString("optional_box_desc7", tostring(level))
    end
  else
    text1 = Localization:GetString("optional_box_desc18")
    local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, 1)
    if weaponTemplate then
      local costs = weaponTemplate:GetSortedCosts()
      for i, v in pairs(costs) do
        if v.itemId == self.itemId then
          text2 = Localization:GetString("optional_box_desc8", tostring(haveNum) .. "/" .. tostring(v.itemNum))
          break
        end
      end
    end
  end
  self.textLevel:SetText(text1)
  self.textOwn:SetText(text2)
end

function UICapacityBoxSelectNewHeroComponent:UpdateHero()
  local heroId = self.view.ctrl:ItemIdToHeroId(self.itemId)
  if not heroId then
    return
  end
  local text1 = ""
  local text2 = ""
  self.compHeroRankStar:SetActive(true)
  local haveNum = DataCenter.ItemData:GetItemCount(self.itemId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local curRank = heroData:GetRank()
    local maxRank = heroData.meta.maxRank
    if curRank >= maxRank then
      text1 = Localization:GetString("optional_box_desc15", tostring(heroData.honorLevel))
      local isHonorMax = heroData:IsReachMaxHonorLevel()
      if isHonorMax then
        text2 = Localization:GetString("optional_box_desc9", tostring(haveNum))
      else
        local needCount = heroData:GetHonorLevelUpgradeCost()
        text2 = Localization:GetString("optional_box_desc8", tostring(haveNum) .. "/" .. tostring(needCount))
      end
      self.compHeroRankStar:SetActive(false)
    else
      local costFragCount = heroData:GetUpgradeRankCost()
      text1 = Localization:GetString("optional_box_desc11")
      text2 = Localization:GetString("optional_box_desc12", tostring(haveNum) .. "/" .. tostring(costFragCount))
      self.compHeroRankStar:SetActive(true)
      self.compHeroRankStar:ShowRank(curRank, maxRank)
    end
    if self.view.ctrl:IsHeroRankUpgradeItemMax(heroId, self.itemId) then
      text2 = text2 .. " " .. Localization:GetString("optional_box_desc13")
    end
  else
    text1 = Localization:GetString("optional_box_desc16")
    local needCount = HeroUtils.GetJigsawCost(self.itemId)
    text2 = Localization:GetString("optional_box_desc17", tostring(haveNum) .. "/" .. tostring(needCount))
    self.compHeroRankStar:SetActive(false)
  end
  self.textLevel:SetText(text1)
  self.textOwn:SetText(text2)
end

function UICapacityBoxSelectNewHeroComponent:UpdateHeroAwaken()
  local heroId = self.view.ctrl:ItemIdToHeroId(self.itemId)
  if not heroId then
    return
  end
  local text1 = ""
  local text2 = ""
  self.compHeroRankStar:SetActive(true)
  local haveNum = DataCenter.ItemData:GetItemCount(self.itemId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local curRank = heroData:GetRank()
    local maxRank = heroData.meta.maxRank
    local curAwakenLv = heroData:GetHeroAwakenRankLevel()
    local isAwakenMax = heroData:IsHeroAwakenReachMaxLevel()
    if isAwakenMax then
      text1 = Localization:GetString("optional_box_limit6", tostring(curAwakenLv))
      text2 = Localization:GetString("optional_box_desc9", tostring(haveNum))
    else
      local isAwakened = heroData:IsHeroAwakened()
      if isAwakened then
        text1 = Localization:GetString("optional_box_limit6", tostring(curAwakenLv))
        local rankTemplate = heroData:GetHeroAwakenRankTemplate()
        if rankTemplate then
          local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
          text2 = Localization:GetString("optional_box_desc12", tostring(haveNum) .. "/" .. tostring(costItemCount))
        end
      else
        text1 = Localization:GetString("optional_box_desc20")
        local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(heroData.heroId, 0)
        if rankTemplate then
          local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
          text2 = Localization:GetString("optional_box_desc12", tostring(haveNum) .. "/" .. tostring(costItemCount))
        end
      end
    end
    self.compHeroRankStar:SetActive(true)
    self.compHeroRankStar:ShowRank(curRank, maxRank, curAwakenLv)
  else
    text1 = Localization:GetString("optional_box_desc16")
    self.compHeroRankStar:SetActive(false)
  end
  self.textLevel:SetText(text1)
  self.textOwn:SetText(text2)
end

function UICapacityBoxSelectNewHeroComponent:OnAddListener()
  base.OnAddListener(self)
end

function UICapacityBoxSelectNewHeroComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICapacityBoxSelectNewHeroComponent:OnBtnInfoClick()
  if not self.itemId then
    return
  end
  local heroId = self.view.ctrl:ItemIdToHeroId(self.itemId)
  if not heroId then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if heroData then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if not itemTemplate then
      return
    end
    if itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 then
      local arrowData = {
        arrowType = HeroDetailGuideArrowType.UniqueWeapon,
        heroUid = heroData.uuid
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
        heroData.uuid
      }, nil, arrowData)
    elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 then
      local function GotoHeroRank()
        local arrowData = {
          arrowType = HeroDetailGuideArrowType.Rank,
          
          heroUid = heroData.uuid
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroData.uuid, {
          heroData.uuid
        }, nil, arrowData)
      end
      
      local curRank = heroData:GetRank()
      local maxRank = heroData.meta.maxRank
      if curRank >= maxRank then
        local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[heroData.heroType])
        local unlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
        if typeBuilding and unlockLevel <= typeBuilding.level then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, heroData.heroType, heroData.uuid)
        else
          GotoHeroRank()
        end
      else
        GotoHeroRank()
      end
    elseif itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191 then
      GoToUtil.GotoHeroAwaken(heroId)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
  end
end

return UICapacityBoxSelectNewHeroComponent
