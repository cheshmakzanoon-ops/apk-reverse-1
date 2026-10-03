local UIHeroAdvanceCell = BaseClass("UIHeroAdvanceCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroDebrisCellSmall = require("UI.UIHero2.Common.UIHeroDebrisCellSmall")
local ShowAdvanceTipType = {
  TIP_TYPE_NULL = 0,
  TIP_TYPE_BIG = 1,
  TIP_TYPE_SMALL = 2
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.isAlreadySelect = false
  self.canBeEaten = false
end

local function OnDestroy(self)
  self.parent = nil
  self.heroUuid = nil
  self.heroData = nil
  self.isAlreadySelect = nil
  self.canBeEaten = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.heroCell = self:AddComponent(UIHeroCell, "UIHeroCellSmall")
  self.heroCell:ToggleRayCast(false)
  self.debris = self:AddComponent(UIHeroDebrisCellSmall, "UIHeroDebrisCellSmall")
  self.stateChecked = self:AddComponent(UIBaseContainer, "Normal/StateCheck")
  self.stateLocked = self:AddComponent(UIImage, "Normal/StateLocked")
  self.stateCanConsume = self:AddComponent(UIBaseContainer, "Normal/StateCanConsume")
  self.nodeCanAdvance = self:AddComponent(UIBaseContainer, "Normal/ImgCanAdvance")
  self.nodeCanAdvance1 = self:AddComponent(UIBaseContainer, "Normal/ImgCanAdvance1")
  self.newDot = self:AddComponent(UIBaseContainer, "NewDot")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.heroCell = nil
  self.stateChecked = nil
  self.stateLocked = nil
  self.stateCanConsume = nil
  self.nodeCanAdvance = nil
  if self.halfRequest ~= nil then
    self.halfRequest:Destroy()
  end
  if self.oneRequest ~= nil then
    self.oneRequest:Destroy()
  end
  self.halfRequest = nil
  self.oneRequest = nil
  self.halfStarEffect = nil
  self.OneStarEffect = nil
end

local function SetData(self, heroUuid, canShowAdvanceArrow, foodMinRarity, isAdvanceNew, showAdvanceParticle, maxMasterAdvanceRarity)
  self.heroUuid = heroUuid
  self.foodMinRarity = foodMinRarity
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if self.heroData ~= nil then
    self.heroCell:SetActive(true)
    self.debris:SetActive(false)
    self.canShowAdvanceArrow = canShowAdvanceArrow
    self.isAdvanceNew = isAdvanceNew
    self.maxMasterAdvanceRarity = maxMasterAdvanceRarity
    self.showAdvanceParticle = showAdvanceParticle
    local rankId = self.heroData:GetRank()
    self.heroCell:SetData(heroUuid, nil, 18 <= rankId)
    self.heroCell:SetCampActive(false)
    self.heroCell:ToggleLevel(self.heroData.isMaster)
    self.stateLocked:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/ui_poster_lock.png")
    self.newDot:SetActive(self.isAdvanceNew == true)
    if self.halfStarEffect ~= nil then
      self.halfStarEffect:SetActive(false)
    end
    if self.OneStarEffect ~= nil then
      self.OneStarEffect:SetActive(false)
    end
    if self.isAdvanceNew == true and self.showAdvanceParticle[self.heroUuid] == nil then
      if self.heroData.quality % 2 == 0 then
        self:addHalfStarEffect()
      else
        self:addOneStarEffect()
      end
    end
    self:UpdateHeroState()
  else
    self.debris:SetActive(true)
    self.heroCell:SetActive(false)
    self.debris:SetData(self.heroUuid)
  end
end

local function addHalfStarEffect(self)
  if self.halfStarEffect ~= nil then
    self.halfStarEffect:SetActive(true)
    self.halfStarEffect.transform.position = self.heroCell:GetLastStarPos()
    self.showAdvanceParticle[self.heroUuid] = 1
    return
  end
  if self.halfRequest ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/_Art/Effect/prefab/ui/VFX_ui_shengxing_half.prefab")
  self.halfRequest = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.heroCell.gameObject.transform)
    self.halfStarEffect = request.gameObject
    self.halfStarEffect.transform.position = self.heroCell:GetLastStarPos()
    self.halfStarEffect:SetActive(self.isAdvanceNew == true)
    self.showAdvanceParticle[self.heroUuid] = 1
  end)
end

local function addOneStarEffect(self)
  if self.OneStarEffect ~= nil then
    self.OneStarEffect:SetActive(true)
    self.OneStarEffect.transform.position = self.heroCell:GetLastStarPos()
    self.showAdvanceParticle[self.heroUuid] = 1
    return
  end
  if self.oneRequest ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/_Art/Effect/prefab/ui/VFX_ui_shengxing_one.prefab")
  self.oneRequest = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(self.heroCell.gameObject.transform)
    self.OneStarEffect = request.gameObject
    self.OneStarEffect.transform.position = self.heroCell:GetLastStarPos()
    self.OneStarEffect:SetActive(self.isAdvanceNew == true)
    self.showAdvanceParticle[self.heroUuid] = 1
  end)
end

local function SetParent(self, parent)
  self.parent = parent
end

local function GetShowAdvanceTipType(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  local isSelectCore = curAdvanceUuid == nil or curAdvanceUuid == 0
  local showAdvanceTip = isSelectCore and self:CanShowAdvanceTip()
  if self.heroData == nil or not showAdvanceTip then
    return ShowAdvanceTipType.TIP_TYPE_NULL
  end
  if self.heroData.isMaster then
    if self.maxMasterAdvanceRarity ~= nil and self.heroData.rarity <= self.maxMasterAdvanceRarity then
      return ShowAdvanceTipType.TIP_TYPE_BIG
    end
    return ShowAdvanceTipType.TIP_TYPE_SMALL
  else
    if self.heroData.rarity == HeroUtils.RarityType.B or self.heroData.rarity == HeroUtils.RarityType.C then
      if self.heroData.quality <= Poster_Show_Bubble_Quality then
        return ShowAdvanceTipType.TIP_TYPE_BIG
      end
      return ShowAdvanceTipType.TIP_TYPE_SMALL
    end
    return ShowAdvanceTipType.TIP_TYPE_SMALL
  end
end

local function UpdateHeroState(self)
  local selfHeroData = self.heroData
  self.isAlreadySelect = false
  self.canBeEaten = false
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  local isSelectCore = curAdvanceUuid == nil or curAdvanceUuid == 0
  local selfIsCore = curAdvanceUuid == self.heroUuid
  local advanceType = self:GetShowAdvanceTipType()
  self.nodeCanAdvance:SetActive(advanceType == ShowAdvanceTipType.TIP_TYPE_SMALL)
  self.nodeCanAdvance1:SetActive(advanceType == ShowAdvanceTipType.TIP_TYPE_BIG)
  if isSelectCore or selfIsCore then
    self.stateCanConsume:SetActive(false)
    self.stateLocked:SetActive(false)
    self.stateChecked:SetActive(selfIsCore)
    self.stateChecked.transform:Find("CheckCore").gameObject:SetActive(selfIsCore)
    self.stateChecked.transform:Find("CheckFood").gameObject:SetActive(false)
    return
  end
  local selfIsAlreadySelect = HeroAdvanceController:GetInstance():IsAlreadySelect(self.heroUuid)
  self.isAlreadySelect = selfIsAlreadySelect
  if selfIsAlreadySelect then
    self.stateCanConsume:SetActive(false)
    self.stateLocked:SetActive(false)
    self.stateChecked:SetActive(true)
    self.stateChecked.transform:Find("CheckCore").gameObject:SetActive(false)
    self.stateChecked.transform:Find("CheckFood").gameObject:SetActive(true)
    return
  end
  local isConsumeFull = HeroAdvanceController:GetInstance():IsConsumeFull()
  self.stateChecked:SetActive(false)
  local coreHeroData = DataCenter.HeroDataManager:GetHeroByUuid(curAdvanceUuid)
  self.canBeEaten = HeroAdvanceController:GetInstance():CanEatHero(coreHeroData, selfHeroData)
  self.isOccupy, self.marchState = self:IsOccupy()
  local isSelf = coreHeroData:CanAdvanceEatOther(selfHeroData, HeroAdvanceConsumeType.ConsumeType_Same_Hero)
  self.stateCanConsume:SetActive(not isConsumeFull and self.canBeEaten and not self.isOccupy and (isSelf or self.heroData.rarity == self.foodMinRarity))
  self.stateLocked:SetActive(not self.canBeEaten)
end

local function CanShowAdvanceTip(self)
  if self.canShowAdvanceArrow and self.heroData.rarity == HeroUtils.RarityType.A and not self.heroData.isMaster then
    local masterUid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.heroData.heroId)
    local master = DataCenter.HeroDataManager:GetHeroByUuid(masterUid)
    if master ~= nil then
      return master.quality >= Purple_Poster_Hero_Show_AdvanceFlag_Need_Master_Level, true
    end
  end
  if self.heroData.rarity == HeroUtils.RarityType.C and self.heroData.isMaster then
    return false, true
  end
  return self.canShowAdvanceArrow
end

local function IsOccupy(self)
  local isInFormation, formationId, marchState = self.heroData:IsInFormation()
  if isInFormation then
    return true, marchState
  end
  return false
end

local function OnBtnClick(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  if curAdvanceUuid == nil or curAdvanceUuid == 0 then
    if self.heroData:IsMaxQuality() then
      if not self.heroData.isMaster and self.heroData.rarity == HeroUtils.RarityType.A then
        local k7 = LuaEntry.DataConfig:TryGetStr("hero_reset", "k7")
        if not string.IsNullOrEmpty(k7) then
          local vec = string.split(k7, ";")
          if table.count(vec) == 3 and DataCenter.BuildManager.MainLv < toInt(vec[2]) then
            UIUtil.ShowTips(Localization:GetString("129231", vec[2]))
            return
          end
        end
      end
      UIUtil.ShowTipsId(162060)
      return
    end
    local flag, flag1 = self:CanShowAdvanceTip()
    if not flag and flag1 == nil then
      local canAdvanceWithoutCheckMasterQuality = HeroAdvanceController:GetInstance():HasFullDogForCore(self.heroData, false)
      if canAdvanceWithoutCheckMasterQuality then
        UIUtil.ShowTipsId(129223)
        return
      end
    end
    self.view:GetPageAdvance():OnSelectCore(self.heroUuid)
    return
  end
  if self.heroData == nil then
    local goodsList = DataCenter.CommonShopManager:GetGoodsListByShopType(CommonShopType.HeroReset)
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.heroUuid)
    if goodsList ~= nil and template ~= nil then
      for _, good in ipairs(goodsList) do
        if not string.IsNullOrEmpty(good.hero) and good.hero == template.para2 then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExchange, {anim = true}, good)
          break
        end
      end
    end
  else
    if curAdvanceUuid == self.heroUuid then
      self.view:GetPageAdvance():OnCancelCore()
      return
    end
    if self.isAlreadySelect then
      self.view:GetPageAdvance():OnToggleDogFood(self.heroUuid)
      return
    end
    if HeroAdvanceController:GetInstance():IsConsumeFull() then
      return
    end
    if self.heroData:IsLocked() then
      UIUtil.ShowTipsId(150502)
      return
    end
    if self.isOccupy then
      if self.marchState and self.marchState == ArmyFormationState.March then
        UIUtil.ShowTipsId(129214)
      else
        UIUtil.ShowMessage(Localization:GetString("129215"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          self.view:GetPageAdvance():OnToggleDogFood(self.heroUuid)
        end, function()
        end)
      end
      return
    end
    if self.heroData:GetBelongFormation() ~= nil then
      UIUtil.ShowTipsId(162197)
      return
    end
    if not self.canBeEaten then
      UIUtil.ShowTipsId(150161)
      return
    end
    self.view:GetPageAdvance():OnToggleDogFood(self.heroUuid)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HideAdvanceNew, self.OnHideAdvanceNew)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HideAdvanceNew, self.OnHideAdvanceNew)
  base.OnRemoveListener(self)
end

local function OnHideAdvanceNew(self)
  self.newDot:SetActive(false)
  if self.halfStarEffect ~= nil then
    self.halfStarEffect:SetActive(false)
  end
  if self.OneStarEffect ~= nil then
    self.OneStarEffect:SetActive(false)
  end
end

local function GetGuideClickBtn(self)
  return self.btn
end

local function GetDogFoodGuideBtn(self)
  local curAdvanceUuid = HeroAdvanceController:GetInstance():GetAdvanceHeroUuid()
  if self.heroData == nil or curAdvanceUuid == nil or curAdvanceUuid == 0 or curAdvanceUuid == self.heroData.uuid or self.isAlreadySelect or not self:GetActive() then
    return nil
  end
  return self.btn
end

UIHeroAdvanceCell.GetDogFoodGuideBtn = GetDogFoodGuideBtn
UIHeroAdvanceCell.GetGuideClickBtn = GetGuideClickBtn
UIHeroAdvanceCell.OnCreate = OnCreate
UIHeroAdvanceCell.OnDestroy = OnDestroy
UIHeroAdvanceCell.OnEnable = OnEnable
UIHeroAdvanceCell.OnDisable = OnDisable
UIHeroAdvanceCell.ComponentDefine = ComponentDefine
UIHeroAdvanceCell.ComponentDestroy = ComponentDestroy
UIHeroAdvanceCell.SetData = SetData
UIHeroAdvanceCell.SetParent = SetParent
UIHeroAdvanceCell.OnAddListener = OnAddListener
UIHeroAdvanceCell.OnRemoveListener = OnRemoveListener
UIHeroAdvanceCell.UpdateHeroState = UpdateHeroState
UIHeroAdvanceCell.IsOccupy = IsOccupy
UIHeroAdvanceCell.CanShowAdvanceTip = CanShowAdvanceTip
UIHeroAdvanceCell.GetShowAdvanceTipType = GetShowAdvanceTipType
UIHeroAdvanceCell.OnBtnClick = OnBtnClick
UIHeroAdvanceCell.OnHideAdvanceNew = OnHideAdvanceNew
UIHeroAdvanceCell.addHalfStarEffect = addHalfStarEffect
UIHeroAdvanceCell.addOneStarEffect = addOneStarEffect
return UIHeroAdvanceCell
