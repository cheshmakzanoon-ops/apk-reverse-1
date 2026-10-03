local UIHeroAdvanceSuccessView = BaseClass("UIHeroAdvanceSuccessView", UIBaseView)
local base = UIBaseView
local HeroModelViewer = require("UI.UIHero2.UIHeroInfo.Component.HeroModelViewer")
local Localization = CS.GameEntry.Localization
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIHeroSlot = require("UI.UIHero2.UIHeroAdvanceSuccess.Component.UIHeroSlot")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self.heroUuid = self:GetUserData()
  self:InitView()
end

local function InitView(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.exchangeBtn:SetActive(HeroUtils.HeroIsCanDebrisExchange(heroData.heroId))
  self.modelViewer:SetHeroId(heroData.heroId, false)
  self:RefreshAdvance()
  self:ShowEnterAnimation()
end

local function ShowEnterAnimation(self)
  self.animator:SetTrigger("show")
end

local function OnHeroStarUpBack(self, message)
  if DataCenter.GuideManager:InGuide() then
    self:RefreshAdvance()
  else
    self:RefreshSuccess(message)
  end
end

local function RefreshSuccess(self, message)
  self.message = message
  HeroAdvanceController:GetInstance():SetAdvanceHeroUuid(nil)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.successTopHero3:SetData(self.heroUuid, nil, nil, true)
  self.successTopHero3:ShowStarProgress()
  self.successTopHero3:ShowUpgradeStarEffect()
  self:RefreshAttr(heroData.quality - 1, heroData.quality)
  local ret, time = self.animator:GetAnimationReturnTime("V_ui_hero_advance_success_advance_xiaoshi")
  if ret then
    self.animator:SetTrigger("success")
    TimerManager:GetInstance():DelayInvoke(function()
      self.advance:SetActive(false)
      self.success:SetActive(true)
      self.caidai:SetActive(false)
      self.caidai:SetActive(true)
    end, time)
  else
    self.advance:SetActive(false)
    self.success:SetActive(true)
  end
end

local function RefreshAdvance(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.success:SetActive(false)
  self.advance:SetActive(true)
  self.advanceTopHero1:SetData(self.heroUuid, nil, nil, true)
  self.advanceTopHero2:SetData(self.heroUuid, nil, nil, true)
  self.advanceTopHero2:SetQuality(heroData.quality + 1, not heroData.isMaster)
  self.advanceTopHero1:ShowStarProgress()
  self.advanceTopHero2:ShowStarProgress()
  local curAttack, curDefence = heroData:GetAttrByQuality(heroData.quality)
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  self.textPower:SetText(Mathf.Round((curAttack + curDefence) * k1) + heroData:GetSkillPower())
  self:RefreshItem()
  self:RefreshAttr(heroData.quality, heroData.quality + 1)
end

local function RefreshAttr(self, fromQuality, toQuality)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local curAttack, curDefence = heroData:GetAttrByQuality(fromQuality)
  local nextAttack, nextDefence = heroData:GetAttrByQuality(toQuality)
  local curTroop = HeroUtils.GetArmyLimit(heroData.level, heroData:GetCurMilitaryRankId(), heroData.rarity, heroData.heroId, fromQuality)
  local nextTroop = HeroUtils.GetArmyLimit(heroData.level, heroData:GetCurMilitaryRankId(), heroData.rarity, heroData.heroId, toQuality)
  self.textValueCurAttack:SetText(Mathf.Round(curAttack))
  self.textValueNextAttack:SetText(Mathf.Round(nextAttack))
  self.textValueCurDefence:SetText(Mathf.Round(curDefence))
  self.textValueNextDefence:SetText(Mathf.Round(nextDefence))
  self.textValueCurTroop:SetText(Mathf.Round(curTroop))
  self.textValueNextTroop:SetText(Mathf.Round(nextTroop))
  local curLvMax = HeroUtils.GetMaxLevelByQuality(heroData.heroId, fromQuality)
  local nextLvMax = HeroUtils.GetMaxLevelByQuality(heroData.heroId, toQuality)
  self.textValueCurLevel:SetText(Mathf.Round(curLvMax))
  self.textValueNextLevel:SetText(Mathf.Round(nextLvMax))
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  self.textValueCurMaxPower:SetText(Mathf.Round((curAttack + curDefence) * k1))
  self.textValueNextMaxPower:SetText(Mathf.Round((nextAttack + nextDefence) * k1))
end

local function OnDestroy(self)
  self.nodeAttr2:SetPosition(self.attrPos2)
  self.nodeAttr3:SetPosition(self.attrPos3)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.callback = nil
end

local function ComponentDefine(self)
  local btnClose = self:AddComponent(UIButton, "Panel")
  btnClose:SetOnClick(BindCallback(self, self.BackToAdvance))
  local btn_back = self:AddComponent(UIButton, "safeArea/BtnBack")
  btn_back:SetOnClick(BindCallback(self, self.PlayCloseAni))
  self.titleText = self:AddComponent(UIText, "safeArea/BtnBack/PanelTitleText")
  self.titleText:SetLocalText(129249)
  self.modelViewer = self:AddComponent(HeroModelViewer, "RawImage", false, nil, nil)
  self.modelViewer:SetCameraOffset(Vector3.New(0.13, 0, 0))
  self.success = self:AddComponent(UIBaseContainer, "safeArea/Root/success")
  self.successTopHero3 = self:AddComponent(UIHeroCell, "safeArea/Root/success/SuccessTopHero3")
  self.textTitleSuccess = self:AddComponent(UIText, "safeArea/Root/success/TextTitleSuccess")
  self.clickAnyWhere = self:AddComponent(UIText, "safeArea/Root/success/ClickAnyWhere")
  self.textTitleSuccess:SetLocalText(129219)
  self.clickAnyWhere:SetLocalText(129074)
  self.caidai = self:AddComponent(UIBaseContainer, "safeArea/VFX_ui_heroadvancesuccess_caidai")
  self.caidai:SetActive(false)
  self.advance = self:AddComponent(UIBaseContainer, "safeArea/Root/advance")
  self.advanceTopHero1 = self:AddComponent(UIHeroCell, "safeArea/Root/advance/AdvanceTopHero1")
  self.advanceTopHero2 = self:AddComponent(UIHeroCell, "safeArea/Root/advance/AdvanceTopHero2")
  self.advanceTitle = self:AddComponent(UIText, "safeArea/Root/advance/AdvanceTitle")
  self.advanceTitle:SetLocalText(129250)
  self.advanceBtn = self:AddComponent(UIButton, "safeArea/Root/advance/BtnAdvance")
  self.advanceBtnText = self:AddComponent(UIText, "safeArea/Root/advance/BtnAdvance/BtnAdvanceText")
  self.advanceBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAdvanceClick()
  end)
  self.advanceBtnText:SetLocalText(129249)
  self.nodePower = self:AddComponent(UIBaseContainer, "safeArea/Root/advance/ImgPowerBg")
  self.textPower = self:AddComponent(UIText, "safeArea/Root/advance/ImgPowerBg/TextPower")
  self.exchangeBtn = self:AddComponent(UIButton, "safeArea/ExchangeItemBtn")
  self.exchangeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnExchangeClick()
  end)
  self.exchangeItemIcon = self:AddComponent(UIImage, "safeArea/ExchangeItemBtn/ExchangeItemIcon")
  self.exchangeItemNum = self:AddComponent(UIText, "safeArea/ExchangeItemBtn/ExchangeItemNumText")
  local exchangeItemText = self:AddComponent(UIText, "safeArea/ExchangeItemBtn/ExchangeItemText")
  exchangeItemText:SetLocalText(110029)
  self.upgradeStarItemProgress = self:AddComponent(UISlider, "safeArea/Root/advance/UpgradeStarItemProgress")
  self.upgradeStarItemIcon = self:AddComponent(UIImage, "safeArea/Root/advance/UpgradeStarItemProgress/UpgradeStarItemIcon")
  self.upgradeStarItemAddBtn = self:AddComponent(UIButton, "safeArea/Root/advance/UpgradeStarItemProgress/UpgradeStarItemExchangeBtn")
  self.upgradeStarItemAddBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnLackClick()
  end)
  self.upgradeStarItemNumText = self:AddComponent(UIText, "safeArea/Root/advance/UpgradeStarItemProgress/UpgradeStarItemNumText")
  self.nodeAttr1 = self:AddComponent(UIBaseContainer, "safeArea/Root/layout/ImgBgAttr1")
  self.nodeAttr2 = self:AddComponent(UIBaseContainer, "safeArea/Root/layout/ImgBgAttr2")
  self.nodeAttr3 = self:AddComponent(UIBaseContainer, "safeArea/Root/layout/ImgBgAttr3")
  self.attrPos1 = self.nodeAttr1:GetPosition()
  self.attrPos2 = self.nodeAttr2:GetPosition()
  self.attrPos3 = self.nodeAttr3:GetPosition()
  self.nodeAttr0 = self:AddComponent(UIBaseContainer, "safeArea/Root/layout/ImgBgAttr0")
  self.textValueCurMaxPower = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr0/aim0/TextValueCurMaxPower")
  self.textValueNextMaxPower = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr0/aim0/TextValueNextMaxPower")
  self.TextTitlePower = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr0/aim0/TextTitlePower")
  self.TextTitlePower:SetLocalText(100644)
  self.textTitleMaxLevel = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr1/aim1/TextTitleMaxLevel")
  self.textTitleMaxLevel:SetLocalText(129112)
  self.textValueCurLevel = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr1/aim1/TextValueCurMaxLevel")
  self.textValueNextLevel = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr1/aim1/TextValueNextMaxLevel")
  self.textTitleAttack = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr2/aim2/TextTitleAttack")
  self.textValueCurAttack = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr2/aim2/TextValueCurAttack")
  self.textValueNextAttack = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr2/aim2/TextValueNextAttack")
  self.textTitleDefence = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr3/aim3/TextTitleDefence")
  self.textValueCurDefence = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr3/aim3/TextValueCurDefence")
  self.textValueNextDefence = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr3/aim3/TextValueNextDefence")
  self.textTitleTroop = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr4/aim4/TextTitleTroop")
  self.textValueCurTroop = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr4/aim4/TextValueCurTroop")
  self.textValueNextTroop = self:AddComponent(UIText, "safeArea/Root/layout/ImgBgAttr4/aim4/TextValueNextTroop")
  self.nodeSkill = self:AddComponent(UIBaseContainer, "safeArea/Root/NodeSkill")
  self.imgSkillIcon = self:AddComponent(UIImage, "safeArea/Root/NodeSkill/SkillBg/IconSkill")
  self.textTitleSkill = self:AddComponent(UIText, "safeArea/Root/NodeSkill/TextTitleSkill")
  self.textValueSkill = self:AddComponent(UIText, "safeArea/Root/NodeSkill/TextValueSkill")
  self.textTitleSkill:SetLocalText(161009)
  self.nodeSkill:SetActive(false)
  self.textTitleAttack:SetLocalText(150101)
  self.textTitleDefence:SetLocalText(150102)
  self.textTitleTroop:SetLocalText(100508)
  self.animator = self:AddComponent(UIAnimator, "")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textTitleAttack = nil
  self.textValueCurAttack = nil
  self.textValueNextAttack = nil
  self.textTitleDefence = nil
  self.textValueCurDefence = nil
  self.textValueNextDefence = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  local message = self.message
  if message ~= nil then
    local retItems = message.retItem or {}
    if message.money ~= nil then
      table.insert(retItems, {
        id = ResourceType.Food,
        add = message.money
      })
    end
    if next(retItems) ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetSuccess, nil, retItems, true)
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroStarUpBack, self.OnHeroStarUpBack)
  self:AddUIListener(EventId.RefreshItems, self.OnItemDataChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemDataChange)
  self:RemoveUIListener(EventId.HeroStarUpBack, self.OnHeroStarUpBack)
end

local function OnItemDataChange(self)
  if self.advance:GetActive() then
    self:RefreshItem()
  end
end

local function RefreshItem(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if not HeroUtils.IsReachStarLimit(heroData) then
    local needNum = HeroUtils.GetHeroStarCostByHeroData(heroData)
    local upgradeItemId = HeroUtils.GetHeroDebrisIdByHeroId(heroData.heroId)
    local hasNum = DataCenter.ItemData:GetItemCount(upgradeItemId)
    local percent = hasNum / needNum
    percent = Mathf.Clamp(percent, 0, 1)
    self.upgradeStarItemProgress:SetValue(percent)
    self.upgradeStarItemNumText:SetText(hasNum .. "/" .. needNum)
    self.upgradeStarItemIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(upgradeItemId))
    local exchangeItemId = HeroUtils.GetCommonExchangeItemId(heroData.heroId)
    self.exchangeItemIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(exchangeItemId))
    local num = DataCenter.ItemData:GetItemCount(exchangeItemId)
    self.exchangeItemNum:SetText(string.GetFormattedSeperatorNum(num))
    self.advanceBtn:SetActive(true)
    self.upgradeStarItemProgress:SetActive(true)
  else
    self.advanceBtn:SetActive(false)
    self.upgradeStarItemProgress:SetActive(false)
  end
end

local function PlayCloseAni(self)
  local ret, time = self.animator:GetAnimationReturnTime("V_ui_hero_advance_success_hide")
  if ret then
    self.animator:SetTrigger("close")
    TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
    end, time)
  else
    self.ctrl:CloseSelf()
  end
end

local function OnAdvanceClick(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local toId = HeroUtils.GetHeroDebrisIdByHeroId(heroData.heroId)
  local needNum = HeroUtils.GetHeroStarCostByHeroData(heroData)
  local hasNum = DataCenter.ItemData:GetItemCount(toId)
  if needNum > hasNum then
    UIUtil.ShowTipsId(120021)
    return
  end
  local param = {}
  param.uuid = self.heroUuid
  SFSNetwork.SendMessage(MsgDefines.HeroStarUp, param)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnExchangeClick(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local fromId = HeroUtils.GetCommonExchangeItemId(heroData.heroId)
  local toId = HeroUtils.GetHeroDebrisIdByHeroId(heroData.heroId)
  local needNum = HeroUtils.GetHeroStarCostByHeroData(heroData)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDebrisExchange, fromId, toId, heroData.heroId, needNum)
end

local function OnLackClick(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local needNum = HeroUtils.GetHeroStarCostByHeroData(heroData)
  DataCenter.HeroLackTipManager:GotoGetHero(heroData.heroId, needNum)
end

local function BackToAdvance(self)
  if self.success:GetActive() then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if not HeroUtils.IsReachStarLimit(heroData) then
      self:RefreshAdvance()
      self:ShowEnterAnimation()
    else
      self:PlayCloseAni()
    end
  end
end

UIHeroAdvanceSuccessView.OnDisable = OnDisable
UIHeroAdvanceSuccessView.OnCreate = OnCreate
UIHeroAdvanceSuccessView.OnDestroy = OnDestroy
UIHeroAdvanceSuccessView.OnEnable = OnEnable
UIHeroAdvanceSuccessView.ComponentDefine = ComponentDefine
UIHeroAdvanceSuccessView.ComponentDestroy = ComponentDestroy
UIHeroAdvanceSuccessView.PlayCloseAni = PlayCloseAni
UIHeroAdvanceSuccessView.OnAdvanceClick = OnAdvanceClick
UIHeroAdvanceSuccessView.RefreshSuccess = RefreshSuccess
UIHeroAdvanceSuccessView.RefreshAdvance = RefreshAdvance
UIHeroAdvanceSuccessView.RefreshAttr = RefreshAttr
UIHeroAdvanceSuccessView.OnAddListener = OnAddListener
UIHeroAdvanceSuccessView.OnRemoveListener = OnRemoveListener
UIHeroAdvanceSuccessView.ShowEnterAnimation = ShowEnterAnimation
UIHeroAdvanceSuccessView.OnExchangeClick = OnExchangeClick
UIHeroAdvanceSuccessView.OnItemDataChange = OnItemDataChange
UIHeroAdvanceSuccessView.RefreshItem = RefreshItem
UIHeroAdvanceSuccessView.BackToAdvance = BackToAdvance
UIHeroAdvanceSuccessView.InitView = InitView
UIHeroAdvanceSuccessView.OnLackClick = OnLackClick
UIHeroAdvanceSuccessView.OnHeroStarUpBack = OnHeroStarUpBack
return UIHeroAdvanceSuccessView
