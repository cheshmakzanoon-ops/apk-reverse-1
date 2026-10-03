local UIHeroInfoView = BaseClass("UIHeroInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeroModelViewer = require("UI.UIHero2.UIHeroInfo.Component.HeroModelViewer")
local UIHeroInfoDetail = require("UI.UIHero2.UIHeroInfo.Component.UIHeroInfoDetail")
local UIHeroInfoSkill = require("UI.UIHero2.UIHeroInfo.Component.UIHeroInfoSkill")
local UIHeroInfoStory = require("UI.UIHero2.UIHeroInfo.Component.UIHeroInfoStory")
local UIHeroInfoLeft = require("UI.UIHero2.UIHeroInfo.Component.UIHeroInfoLeft")
local UIGray = CS.UIGray
local Tabs = {
  Detail = 1,
  Skill = 2,
  Equip = 3,
  Story = 4
}
local FromType = {
  HeroList = 1,
  HeroMap = 2,
  SingleHeroId = 3,
  HeroDetail = 4
}

local function OnCreate(self)
  self.eventHandler = {}
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self.fromType = nil
  self.camp = nil
  self.tagDescList = nil
  if self.bgModel ~= nil then
    self.bgModel:Destroy()
    self.bgModel = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.nodeRoot = self:AddComponent(UIBaseContainer, "Root")
  local btn_back = self:AddComponent(UIButton, "Root/BtnBack")
  btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.modelViewer = self:AddComponent(HeroModelViewer, "RawImage", true, BindCallback(self, self.OnDrag), BindCallback(self, self.OnTimeLineEvent))
  self.modelViewer:SetHeroLoadedCallback(BindCallback(self, self.OnHeroLoadedCallback))
  self.modelViewer:SetBeginDragListener(BindCallback(self, self.OnBeginDrag))
  self.modelViewer:SetEndDragListener(BindCallback(self, self.OnEndDrag))
  self.pages = {}
  self.pages[Tabs.Detail] = self:AddComponent(UIHeroInfoDetail, "Root/PageRoot/PageDetail")
  self.tabButtons = {}
  self.tabButtons[Tabs.Detail] = self:AddComponent(UIButton, "Root/PageRoot/TabContent/BtnDetail")
  for k, v in pairs(self.tabButtons) do
    v:SetOnClick(function()
      self:SwitchTab(k)
    end)
  end
  self.componentLeft = self:AddComponent(UIHeroInfoLeft, "Root/NodeHeroInfo")
  self.btnLeft = self:AddComponent(UIEventTrigger, "Root/BtnLeft")
  self.btnRight = self:AddComponent(UIEventTrigger, "Root/BtnRight")
  self.btnLeft:OnPointerUp(function()
    self:ChangeHero(true)
  end)
  self.btnRight:OnPointerUp(function()
    self:ChangeHero(false)
  end)
  self.nodeRecruit = self:AddComponent(UIText, "Root/NodeRecruit")
  self.textTipMap = self:AddComponent(UIText, "Root/NodeRecruit/TextTipMap")
  self.textRecruit = self:AddComponent(UIText, "Root/NodeRecruit/TextRecruit")
  self.btnRecruit = self:AddComponent(UIButton, "Root/NodeRecruit/TextRecruit/BtnRecruit")
  self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
  self.textTipMap:SetLocalText(128010)
  self.textRecruit:SetLocalText(128011)
  self.nodePower = self:AddComponent(UIBaseContainer, "Root/ImgPowerBg")
  self.textPower = self:AddComponent(UIText, "Root/ImgPowerBg/TextPower")
  self.imgAlpha = self:AddComponent(UIImage, "Root/PageRoot/ImgBg/ImgAlpha")
end

local function SwitchTab(self, tabIdx)
  if self.currentTab == tabIdx then
    return
  end
  self.currentTab = tabIdx
  for k, tabObj in pairs(self.tabButtons) do
    tabObj:SetActive(k ~= tabIdx)
  end
  for k, pageObj in pairs(self.pages) do
    pageObj:SetActive(k == tabIdx)
  end
  if tabIdx == Tabs.Detail and self.isArrow and self.isArrow == 1 then
    TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.positionType = PositionType.Screen
      param.position = self.pages[Tabs.Detail]:GetBtnUpSizeDelta()
      param.isReversal = true
      if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
      end
      self.isArrow = nil
    end, 0.5)
  end
  if self.skillId then
    local skillId = self.skillId
    TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.positionType = PositionType.Screen
      param.position = self.pages[Tabs.Detail]:GetBtnSkill(skillId)
      if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
      end
    end, 0.5)
    self.skillId = nil
  end
end

local function ComponentDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.btnLeft ~= nil then
    self.btnLeft:SetActive(false)
  end
  if self.btnRight ~= nil then
    self.btnRight:SetActive(false)
  end
  self:SwitchTab(Tabs.Detail)
  TimerManager:GetInstance():DelayInvoke(function()
    if not IsNull(self.gameObject) and self.enableCallback then
      self:enableCallback()
    end
  end, 0.5)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroBeyondSuccess, self.OnHeroBeyondSuccess)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.RefreshHeroInfo)
  self:AddUIListener(EventId.SkillUpgradeEnd, self.RefreshHeroInfo)
  self:AddUIListener(EventId.HeroMedalExchanged, self.CheckSkillRedPoint)
  self:AddUIListener(EventId.HeroAdvanceSuccess, self.OnHeroAdvanceSuccess)
  self:AddUIListener(EventId.ToggleHeroPreviewScene, self.OnToggleUI)
  self:AddUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  self:AddUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosedHandler)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAdvanceSuccessClosed, self.OnAdvanceSuccessClosedHandler)
  self:RemoveUIListener(EventId.HeroBeyondSuccess, self.OnHeroLvUpSuccess)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.RefreshHeroInfo)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, self.RefreshHeroInfo)
  self:RemoveUIListener(EventId.HeroMedalExchanged, self.CheckSkillRedPoint)
  self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.OnHeroAdvanceSuccess)
  self:RemoveUIListener(EventId.ToggleHeroPreviewScene, self.OnToggleUI)
  self:RemoveUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  base.OnRemoveListener(self)
end

local function OnHeroAdvanceSuccess(self)
  if self.heroUuid ~= nil then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData == nil then
      return
    end
  end
  self:RefreshHeroInfo()
  if self.pages[Tabs.Detail] ~= nil then
    self.pages[Tabs.Detail]:OnHeroAdvanceSuccess()
  end
end

local function OnHeroBeyondSuccess(self, uuid)
  local advanceHero = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
  if advanceHero ~= nil then
    local openedSkill
    for _, v in pairs(advanceHero.skillDict) do
      if v ~= nil and v.level == 1 and v.unlockHeroLv == advanceHero.level then
        openedSkill = v.skillId
        break
      end
    end
    if openedSkill ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillAdvanceSuccess, uuid, openedSkill)
    end
  end
end

local function RefreshHeroInfo(self)
  local heroId, heroUuid, quality, camp, param, showMapTip, canUpgradeRank, curAttack, curDefence
  local skillPower = 0
  if self.fromType == self.FromType.HeroList then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    heroId = heroData.heroId
    heroUuid = heroData.uuid
    quality = heroData.quality
    camp = heroData.camp
    param = self.heroUuid
    showMapTip = false
    skillPower = heroData:GetSkillPower()
    curAttack, curDefence = heroData:GetAttrByQuality(quality)
  elseif self.fromType == self.FromType.HeroMap then
    heroId = self.heroMapData.heroId
    heroUuid = self.heroMapData.uuid
    quality = self.heroMapData.quality
    camp = self.heroMapData.camp
    param = self.heroMapData.uuid
    showMapTip = not DataCenter.HeroDataManager:IsInHistory(heroId)
    curAttack, curDefence = HeroUtils.GetMaxAttrForHeroMap(heroId)
  elseif self.fromType == self.FromType.SingleHeroId then
    heroId = self.heroMapData.heroId
    heroUuid = self.heroMapData.uuid
    quality = self.heroMapData.quality
    camp = self.heroMapData.camp
    param = self.heroMapData.uuid
    showMapTip = false
    curAttack, curDefence = HeroUtils.GetMaxAttrForHeroMap(heroId)
  elseif self.fromType == self.FromType.HeroDetail then
    heroId = self.heroMapData.heroId
    heroUuid = self.heroMapData.uuid
    quality = self.heroMapData.quality
    camp = self.heroMapData.camp
    param = self.heroMapData
    showMapTip = false
    curAttack, curDefence = HeroUtils.GetHeroAttr(heroId, quality, self.heroMapData.level, HeroUtils.GetBeyondTimesByLevel(self.heroMapData.level), self.heroMapData.rank)
  end
  self.camp = camp
  self.componentLeft:InitData(heroId, heroUuid, quality, camp)
  for _, v in pairs(self.pages) do
    v:InitData(param, self.fromType)
  end
  self.nodeRecruit:SetActive(showMapTip)
  if showMapTip then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.nodeRecruit.rectTransform)
  end
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  self.textPower:SetText(Mathf.Round((curAttack + curDefence) * k1) + skillPower)
  self.nodePower:SetActive(self.fromType == self.FromType.HeroList)
end

local function OnOpen(self)
  HeroUtils.NeedCheckedOptimal = true
  self.nodeRoot.transform:Set_localScale(0, 0, 0)
  local fromType, para2, para3, onClose, para4, isArrow, enableCallback, skillId = self:GetUserData()
  self.fromType = fromType
  self.ctrl.onClose = onClose
  self.guideFlag = tonumber(para4)
  self.isArrow = isArrow or nil
  self.skillId = skillId or nil
  self.enableCallback = enableCallback
  if self.guideFlag ~= nil and self.guideFlag == 1 then
    self:CheckDoUpGradeGuide()
  end
  if fromType == self.FromType.HeroList then
    self.heroUuid = para2
    self.heroUuidList = para3
    self.curHeroIndex = table.indexof(self.heroUuidList, self.heroUuid)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    self.modelViewer:SetHeroId(heroData.heroId, heroData.uuid, true)
  elseif fromType == self.FromType.HeroMap then
    self.heroMapData = para2
    self.heroMapDataList = para3
    self.curHeroIndex = table.indexof(self.heroMapDataList, self.heroMapData)
    self.modelViewer:SetHeroId(self.heroMapData.heroId, self.heroMapData.uuid, true)
  elseif fromType == self.FromType.SingleHeroId then
    local heroId = para2
    local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
    local maxQuality = config.max_quality_level
    local maxLevel = HeroUtils.GetMaxLevelByQuality(heroId, maxQuality)
    local camp = config.camp
    local rarity = config.rarity
    self.heroMapData = {
      heroId = heroId,
      camp = camp,
      rarity = rarity,
      quality = maxQuality,
      level = maxLevel
    }
    self.modelViewer:SetHeroId(heroId, true)
  elseif self.FromType.HeroDetail then
    self.heroMapData = para2
    self.modelViewer:SetHeroId(self.heroMapData.uuid, true)
  end
  self:RefreshHeroInfo()
  self:SwitchTab(Tabs.Detail)
end

local function OnHeroLoadedCallback(self)
  self.nodeRoot.transform:Set_localScale(1, 1, 1)
end

local function ChangeHero(self, isLeft)
  local index = self.curHeroIndex + (isLeft and -1 or 1)
  if self.fromType == self.FromType.HeroList then
    local heroUuid = self.heroUuidList[index]
    if heroUuid == nil then
      return
    end
    self.heroUuid = heroUuid
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    self.modelViewer:SetHeroId(heroData.uuid, true)
    DataCenter.HeroDataManager:RemoveNewHeroTag(heroUuid)
  elseif self.fromType == self.FromType.HeroMap then
    local heroMapData = self.heroMapDataList[index]
    if heroMapData == nil then
      return
    end
    self.heroMapData = heroMapData
    self.modelViewer:SetHeroId(heroMapData.uuid, true)
  end
  self.curHeroIndex = index
  self.timeLineFinish = false
  self:CheckArrowBtns()
  self:RefreshHeroInfo()
end

local function CheckArrowBtns(self)
  if self.fromType ~= self.FromType.HeroList and self.fromType ~= self.FromType.HeroMap then
    self.btnLeft:SetActive(false)
    self.btnRight:SetActive(false)
    return false
  end
  if self.btnLeft == nil or self.btnRight == nil then
    return
  end
  local visibility = self.timeLineFinish and not self.isDragging
  self.btnLeft:SetActive(visibility)
  self.btnRight:SetActive(visibility)
  if not visibility then
    return
  end
end

local function OnDrag(self, isLeft)
end

local function OnBeginDrag(self)
  self.isDragging = true
  self:CheckArrowBtns()
end

local function OnEndDrag(self)
  self.isDragging = false
  self:CheckArrowBtns()
end

local function OnTimeLineEvent(self, event)
  Logger.Log("step in UIHeroInfoView:OnTimeLineEvent  event:", tostring(event))
  if event ~= "stop" then
    return
  end
  self.timeLineFinish = true
  self:CheckArrowBtns()
end

local function StartRotateModel(self, isLeft)
  self.modelViewer:StartRotateModel(isLeft)
end

local function StopRotateModel(self)
  self.modelViewer:StopRotateModel()
end

local function GetFromType(self)
  return self.fromType
end

local function OnBtnRecruitClick(self)
  DataCenter.HeroLackTipManager:GotoGetHero(self.heroMapData.uuid)
end

local function CheckSkillRedPoint(self)
end

local function OnToggleUI(self, visible)
  local t = visible and 1 or 0
  self.nodeRoot.transform:Set_localScale(t, t, t)
  self.nodeRoot.gameObject:SetActive(visible)
  if not visible then
    self.modelViewer:ChangeToRank()
    self.timeLineFinish = true
    self:CheckArrowBtns()
  else
    self.modelViewer:HideHeroAdvanceEffect()
    self.modelViewer:ChangeToPreview()
  end
end

local function OnHandleRankUpSuccess(self)
  self.modelViewer:ShowHeroAdvanceEffect()
end

local function CheckDoUpGradeGuide(self)
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UseHeroExp, SaveGuideDoneValue)
end

local function OnBtnAdvanceClick(self)
  self.modelViewer:ToggleSceneVisible(false)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceSuccess, self.heroUuid)
end

local function OnBackFromAdvance(self)
  if self.fromType ~= self.FromType.HeroList then
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.curHeroIndex = table.indexof(self.heroUuidList, self.heroUuid)
  self.modelViewer:ToggleSceneVisible(true)
end

local function OnAdvanceSuccessClosedHandler(self)
  self:OnBackFromAdvance()
end

local function GetGuideStarUpBtn(self)
  return self.pages[Tabs.Detail]:GetGuideStarUpBtn()
end

local function ShowHeroStarUpHoleImg(self)
  self.pages[Tabs.Detail]:ShowHeroStarUpHoleImg()
end

local function HideHeroStarUpHoleImg(self)
  self.pages[Tabs.Detail]:HideHeroStarUpHoleImg()
end

local function ShowArrowToUpgradeStar(self)
  self.pages[Tabs.Detail]:ShowArrowToUpgradeStar()
end

local function ShowArrowToBeyond(self)
  self.pages[Tabs.Detail]:ShowArrowToBeyond()
end

UIHeroInfoView.Tabs = Tabs
UIHeroInfoView.OnAdvanceSuccessClosedHandler = OnAdvanceSuccessClosedHandler
UIHeroInfoView.FromType = FromType
UIHeroInfoView.GetFromType = GetFromType
UIHeroInfoView.GetGuideStarUpBtn = GetGuideStarUpBtn
UIHeroInfoView.ShowHeroStarUpHoleImg = ShowHeroStarUpHoleImg
UIHeroInfoView.HideHeroStarUpHoleImg = HideHeroStarUpHoleImg
UIHeroInfoView.OnCreate = OnCreate
UIHeroInfoView.OnDestroy = OnDestroy
UIHeroInfoView.OnEnable = OnEnable
UIHeroInfoView.OnDisable = OnDisable
UIHeroInfoView.ComponentDefine = ComponentDefine
UIHeroInfoView.ComponentDestroy = ComponentDestroy
UIHeroInfoView.OnAddListener = OnAddListener
UIHeroInfoView.OnRemoveListener = OnRemoveListener
UIHeroInfoView.RefreshHeroInfo = RefreshHeroInfo
UIHeroInfoView.CheckSkillRedPoint = CheckSkillRedPoint
UIHeroInfoView.OnOpen = OnOpen
UIHeroInfoView.OnHeroLoadedCallback = OnHeroLoadedCallback
UIHeroInfoView.ChangeHero = ChangeHero
UIHeroInfoView.StartRotateModel = StartRotateModel
UIHeroInfoView.StopRotateModel = StopRotateModel
UIHeroInfoView.SwitchTab = SwitchTab
UIHeroInfoView.OnDrag = OnDrag
UIHeroInfoView.OnBeginDrag = OnBeginDrag
UIHeroInfoView.OnEndDrag = OnEndDrag
UIHeroInfoView.CheckArrowBtns = CheckArrowBtns
UIHeroInfoView.OnTimeLineEvent = OnTimeLineEvent
UIHeroInfoView.OnBtnRecruitClick = OnBtnRecruitClick
UIHeroInfoView.OnToggleUI = OnToggleUI
UIHeroInfoView.OnHandleRankUpSuccess = OnHandleRankUpSuccess
UIHeroInfoView.CheckDoUpGradeGuide = CheckDoUpGradeGuide
UIHeroInfoView.OnBtnAdvanceClick = OnBtnAdvanceClick
UIHeroInfoView.OnHeroAdvanceSuccess = OnHeroAdvanceSuccess
UIHeroInfoView.OnBackFromAdvance = OnBackFromAdvance
UIHeroInfoView.OnHeroBeyondSuccess = OnHeroBeyondSuccess
UIHeroInfoView.ShowArrowToUpgradeStar = ShowArrowToUpgradeStar
UIHeroInfoView.ShowArrowToBeyond = ShowArrowToBeyond
return UIHeroInfoView
