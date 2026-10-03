local base = UIBaseView
local UIFirstPayView = BaseClass("UIFirstPayView", base)
local Localization = CS.GameEntry.Localization
local FirstPayRewardItem = require("UI.UIFirstPay.Component.FirstPayRewardItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local OPEN_DELAY = 0.5
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIGray = CS.UIGray
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local BuildingExpComponent = require("UI.UIFirstPay.Component.BuildingExpComponent")
local building_exp_path = "ImgBg/Center/Rewards/BuildingExp"

local function AddTimer(self)
  if self.timer ~= nil then
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
  self.timer_action()
end

local function RemoveTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function RefreshTime(self)
  local endTime = DataCenter.FirstPayManager:GetFixEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = endTime - curTime
  if 0 < time then
    local remainTimeStr = Localization:GetString(2000317, UITimeManager:GetInstance():MilliSecondToFmtString(time))
    self.state1Text:SetText(remainTimeStr)
    self.getRewardStateText:SetText(remainTimeStr)
  else
    self.state1Text:SetLocalText(2000323)
    self.getRewardStateText:SetLocalText(2000323)
    RemoveTimer(self)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.ArrowManager:RemoveFingerArrow()
  self:RefreshAll()
end

local function OnDestroy(self)
  if self.delayShow then
    self.delayShow:Stop()
    self.delayShow = nil
  end
  RemoveTimer(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnClickHeroInfoBtn(self)
  if self.heroConfig == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = true}, self.heroConfig.fragId, {
    self.heroConfig.fragId
  })
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "Panel")
  self.bgCloseBtn:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.closeBtnN = self:AddComponent(UIButton, "ImgBg/Top/closeBtn")
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.spineParentA = self:AddComponent(UIBaseContainer, "ImgBg/Center/hero_icon_Katyusha/New SkeletonGraphic")
  self.bgA = self:AddComponent(UIBaseContainer, "ImgBg/bg_adv/bg_hero")
  self.spineParentA:SetActive(true)
  self.bgA:SetActive(true)
  self.spine = self.transform:Find("ImgBg/Center/hero_icon_Katyusha/New SkeletonGraphic"):GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
  self.isFirstPayB = LuaEntry.Player:IsFirstPayB()
  local extraRewardPath = self.isFirstPayB and "ImgBg/Center/Rewards/ExtraReward/ExtraReward_B" or "ImgBg/Center/Rewards/ExtraReward/ExtraReward_A"
  local otherExtraRewardPath = self.isFirstPayB and "ImgBg/Center/Rewards/ExtraReward/ExtraReward_A" or "ImgBg/Center/Rewards/ExtraReward/ExtraReward_B"
  self.extraReward = self:AddComponent(UIBaseComponent, extraRewardPath)
  self.otherExtraReward = self:AddComponent(UIBaseComponent, otherExtraRewardPath)
  self.extraReward:SetActive(true)
  self.otherExtraReward:SetActive(false)
  self.anim = self:AddComponent(UIAnimator, "")
  self.bg_go = self:AddComponent(UIBaseContainer, "ImgBg")
  self.panel_go = self:AddComponent(UIBaseContainer, "Panel")
  self.rewardContentN = self:AddComponent(UIBaseContainer, "ImgBg/Center/Rewards/FreeReward/RewardScrollView/Viewport/RewardContent")
  self.extraRewardContent = self:AddComponent(UIBaseContainer, extraRewardPath .. "/ExtraRewardScrollView/Viewport/ExtraRewardContent")
  self.rewardTemplateN = self:AddComponent(UIBaseContainer, "ImgBg/Center/Rewards/rewardItem")
  self.rewardTemplateN.gameObject:GameObjectCreatePool()
  self.showHeroBtn = self:AddComponent(UIButton, "ImgBg/showHero")
  self.showKill = self:AddComponent(UIButton, extraRewardPath .. "/showSkill")
  self.showHeroBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel, {anim = false}, 50009, {50009}, nil, true)
  end)
  self.showKill:SetOnClick(function()
    DataCenter.FirstPayManager:TryOpenNewSkillPreview()
  end)
  self.discountText = self:AddComponent(UIText, extraRewardPath .. "/DiscountInfo/Bg/DiscountText")
  self.discountPercentText = self:AddComponent(UIText, extraRewardPath .. "/DiscountInfo/Bg/DiscountTextPercent")
  self.heroQualityIcon = self:AddComponent(UIImage, "ImgBg/Center/HeroInfo/QualityInfo")
  self.heroNameText = self:AddComponent(UIText, "ImgBg/Center/HeroInfo/NameGroup/NameText")
  self.heroDetailInfoBtn = self:AddComponent(UIButton, "ImgBg/Center/HeroInfo/NameGroup/InfoBtn")
  self.heroDetailInfoBtn:SetOnClick(function()
    OnClickHeroInfoBtn(self)
  end)
  self.fixBtn = self:AddComponent(UIButton, "ImgBg/Center/FixBtn")
  self.fixBtn:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.LimitGiftOp, 1)
  end)
  self.fixBtnText = self:AddComponent(UIText, "ImgBg/Center/FixBtn/FixBtnText")
  self.speedUpBtn = self:AddComponent(UIButton, "ImgBg/Center/SpeedUpBtn")
  self.speedUpBtn:SetOnClick(function()
    self:OnClickPayBtn()
  end)
  self.speedUpBtn:SetSafeClickMode(true)
  self.speedUpBtnText = self:AddComponent(UIText, "ImgBg/Center/SpeedUpBtn/SpeedUpBtnText")
  self.speedUpCostText = self:AddComponent(UIText, "ImgBg/Center/SpeedUpBtn/SpeedUpCostText")
  self.getRewardBtn = self:AddComponent(UIButton, "ImgBg/Center/GetRewardBtn")
  self.getRewardBtn:SetOnClick(function()
    SFSNetwork.SendMessage(MsgDefines.LimitGiftOp, 2)
  end)
  self.getRewardBtnText = self:AddComponent(UIText, "ImgBg/Center/GetRewardBtn/GetRewardBtnText")
  self.getExtraRewardBtn = self:AddComponent(UIButton, "ImgBg/Center/GetExtraRewardBtn")
  self.getExtraRewardBtn:SetOnClick(function()
    self:OnClickPayBtn()
  end)
  self.getExtraRewardBtn:SetSafeClickMode(true)
  self.getExtraRewardBtnText = self:AddComponent(UIText, "ImgBg/Center/GetExtraRewardBtn/GetExtraRewardBtnText")
  self.getExtraRewardCostText = self:AddComponent(UIText, "ImgBg/Center/GetExtraRewardBtn/GetExtraRewardCostText")
  self.state1Text = self:AddComponent(UIText, "ImgBg/Center/State1Text")
  self.getRewardStateText = self:AddComponent(UIText, "ImgBg/Center/GetRewardStateText")
  self.extraRewardText = self:AddComponent(UIText, extraRewardPath .. "/Reward2Text")
  self.buyBtn = self:AddComponent(LWBtnBuyRefundRemind, "ImgBg/Center/BuyBtn")
  self.buyBtn:SetBuyClickAction(function()
    self:OnClickPayBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.freeReward = self:AddComponent(UIBaseContainer, "ImgBg/Center/Rewards/FreeReward")
  self.bubble = self:AddComponent(UIBaseContainer, "ImgBg/bubble")
  self.bubbleText = self:AddComponent(UIText, "ImgBg/bubble/bubbleText")
  if self.isFirstPayB then
    self.heroIcon = self:AddComponent(UIButton, "ImgBg/Center/Rewards/ExtraReward/ExtraReward_B/heroIcon")
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_InitialBuyPack, false)
  PostEventLog.Track(PostEventLog.Defines.OpenFirstPayUI, {
    param1 = tostring(DataCenter.MonopolyManager.player.curId)
  })
  self.buildExpCpt = self:AddComponent(BuildingExpComponent, building_exp_path)
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.closeBtnN = nil
  self.anim = nil
  self.bg_go = nil
  self.panel_go = nil
  if self.rewardContentN then
    self.rewardContentN:RemoveComponents(FirstPayRewardItem)
  end
  self.rewardContentN = nil
  if self.extraRewardContent then
    self.extraRewardContent:RemoveComponents(FirstPayRewardItem)
  end
  self.extraRewardContent = nil
  if self.rewardTemplateN then
    self.rewardTemplateN.gameObject:GameObjectRecycleAll()
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.rewardTemplateN = nil
  self.heroN = nil
  self.heroIconN = nil
  self.heroBgN = nil
  self.discountText = nil
  self.discountPercentText = nil
  self.heroQualityIcon = nil
  self.heroNameText = nil
  self.heroDetailInfoBtn = ni
  self.fixBtn = nil
  self.fixBtnText = nil
  self.speedUpBtn = nil
  self.speedUpBtnText = nil
  self.speedUpCostText = nil
  self.getRewardBtn = nil
  self.getRewardBtnText = nil
  self.getExtraRewardBtn = nil
  self.getExtraRewardBtnText = nil
  self.getExtraRewardCostText = nil
  self.state1Text = nil
  self.getRewardStateText = nil
  self.extraRewardText = nil
  self.buyBtn = nil
  self.freeReward = nil
  self.extraReward = nil
  self.spine = nil
end

local function DataDefine(self)
  self.packageInfo = nil
  self.heroId = nil
  self.hasInitData = false
  self.timer_action = BindCallback(self, self.RefreshTime)
end

local function DataDestroy(self)
  self.packageInfo = nil
  self.heroId = nil
  self.heroConfig = nil
  self.hasInitData = false
  self.timer_action = nil
end

local function RefreshAll(self)
  local param = self:GetUserData()
  local delay = param.delay
  local showHeroExhibit = param and param.todayShow
  local bubbleTip = param.bubbleTip
  self.bubble:SetActive(false)
  self.bg_go:SetActive(true)
  self.panel_go:SetActive(true)
  self:RefreshPackage()
  self.hasInitData = true
  if not CommonUtil.IsJapanABTest() then
    self.spine.AnimationState:SetAnimation(0, "into", false)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(self.spine) then
        self.spine.AnimationState:SetAnimation(0, "idle", true)
      end
    end, 5.3)
  end
  CS.GameEntry.Setting:SetBool(SettingKeys.FIRST_PAY_SHOWN .. LuaEntry.Player.uid, true)
  if string.IsNullOrEmpty(bubbleTip) then
    bubbleTip = LuaEntry.DataConfig:TryGetStr("first_cost_intensifying", "k3")
  end
  if not string.IsNullOrEmpty(bubbleTip) then
    self.bubble:SetActive(true)
    self.bubbleText:SetText(Localization:GetString(bubbleTip))
  end
  if param then
    local isPopup = param.isPopup
    if isPopup and self.rechargeId then
      WelfareController.AddPopupTimes(self.rechargeId)
    end
  end
  if not showHeroExhibit then
    local dubName = LuaEntry.DataConfig:TryGetStr("first_pay_lw", "k8")
    if not string.IsNullOrEmpty(dubName) then
      self.dubHandle = DataCenter.LWSoundManager:PlayDub(dubName)
    end
  end
  self.isBuildUpgradeGetExpFunctionOn = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn()
  if self.isBuildUpgradeGetExpFunctionOn then
    local ok, error = pcall(function()
      self.buildExpCpt:RefreshView()
    end)
    if not ok then
      Logger.LogError(error)
    end
  end
end

function UIFirstPayView:CheckAndPlayOpenAni()
  local aniName = DataCenter.FirstPayManager:IsBuildingUpgradeGetExpFunctionOn() and "WithBuildingExp" or "Normal"
  self.anim:SetTrigger(aniName)
end

local function RefreshRewards(self)
  if self.isNewFirstPay then
    self.freeReward:SetActive(false)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.extraReward:SetLocalPositionXYZ(23.7, -2, 0)
    else
      self.extraReward:SetLocalPositionXYZ(-23.7, -2, 0)
    end
  else
    self.freeReward:SetActive(true)
    self.extraReward:SetLocalPositionXYZ(-73, 81.4, 0)
  end
  self.rewardContentN:RemoveComponents(FirstPayRewardItem)
  self.extraRewardContent:RemoveComponents(FirstPayRewardItem)
  self.rewardTemplateN.gameObject:GameObjectRecycleAll()
  local rewardsList = {}
  if not self.isNewFirstPay then
    rewardsList = DataCenter.FirstPayManager:GetRewardList()
  end
  local extraRewardList = DataCenter.FirstPayManager:GetPackageItems()
  if not table.IsNullOrEmpty(rewardsList) then
    for i, v in pairs(rewardsList) do
      local item = self.rewardTemplateN.gameObject:GameObjectSpawn(self.rewardContentN.transform)
      item:SetActive(true)
      item.name = "item" .. i
      local obj = self.rewardContentN:AddComponent(FirstPayRewardItem, item.name)
      if v.rewardType == RewardType.HERO then
        v.clickCallBack = nil
        
        function v.clickCallBack()
          local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
          if not heroWindow then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.itemId, {
              v.itemId
            }, nil, {
              arrowType = HeroDetailGuideArrowType.SkillPreview
            })
          end
        end
      end
      obj:ReInit(v)
    end
  end
  if not table.IsNullOrEmpty(extraRewardList) then
    for i, v in pairs(extraRewardList) do
      if self.isFirstPayB and v.rewardType == RewardType.HERO then
        if self.heroIcon then
          self.heroIcon:SetOnClick(function()
            local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIFirstPayHeroTip)
            if window then
              return
            end
            local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.FirstPayHeroTip)
            param.heroId = v.itemId
            local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(v.itemId)
            param.heroLv = 150
            param.heroRank = heroTemplate.maxRank
            param.alignObject = self.heroIcon.gameObject
            param.yPosFix = 78
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPayHeroTip, {anim = false}, param)
            PostEventLog.Track(PostEventLog.Defines.on_firstpay_herotip_open, {})
          end)
        end
      else
        local item = self.rewardTemplateN.gameObject:GameObjectSpawn(self.extraRewardContent.transform)
        item:SetActive(true)
        item.name = "item" .. i
        local obj = self.extraRewardContent:AddComponent(FirstPayRewardItem, item.name)
        if v.rewardType == RewardType.HERO then
          v.clickCallBack = nil
          
          function v.clickCallBack()
            local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
            if not heroWindow then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, v.itemId, {
                v.itemId
              }, nil, {
                arrowType = HeroDetailGuideArrowType.SkillPreview
              })
            end
          end
        end
        if self.isFirstPayB then
          obj:SetNumTextScale(1.33)
        else
          obj:SetNumTextScale(1)
        end
        obj:ReInit(v)
      end
    end
  end
end

local function RefreshPackage(self)
  self.isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
  self.packageInfo, self.rechargeId = DataCenter.FirstPayManager:GetFirstPayPack()
  self.buyBtn:Init(self.packageInfo)
  self:RefreshRewards()
  self:RefreshPayState()
end

local function SetRewardHero(self, rewardData)
  self.heroId = LuaEntry.DataConfig:TryGetNum("first_purchase_hero", "k1")
  if self.heroId == 0 then
    self.heroId = 50009
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(self.heroId)
  if heroConfig ~= nil then
    self.heroConfig = heroConfig
  end
end

local function RefreshPayState(self)
  if self.isNewFirstPay then
    self.getRewardStateText:SetActive(false)
    self.fixBtn:SetActive(false)
    self.speedUpBtn:SetActive(false)
    self.getRewardBtn:SetActive(false)
    self.getExtraRewardBtn:SetActive(false)
    self.buyBtn:SetActive(true)
    self.buyBtn:RefreshPoint()
    if self.packageInfo then
      self.state1Text:SetText(self.packageInfo:getNameText())
      self.buyBtn:SetActive(true)
    else
      self.buyBtn:SetActive(false)
    end
    self.extraRewardText:SetLocalText("2000357")
  else
    self.buyBtn:SetActive(false)
    self.extraRewardText:SetLocalText("2000319")
    RemoveTimer(self)
    local firstPayState = DataCenter.FirstPayManager:GetState()
    if firstPayState <= FirstPayState.DontHaveBuilding or firstPayState >= FirstPayState.HasReceivedNormalReward then
      return
    end
    if firstPayState == FirstPayState.Repairing then
      local endTime = DataCenter.FirstPayManager:GetFixEndTime()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if endTime > curTime then
        self.getRewardStateText:SetActive(true)
        AddTimer(self)
        self.speedUpBtn:SetActive(true)
        if self.packageInfo then
          self.speedUpCostText:SetText(self.packageInfo:getPriceText())
        end
        self.fixBtn:SetActive(false)
        self.getRewardBtn:SetActive(false)
        self.getExtraRewardBtn:SetActive(false)
      else
        self.state1Text:SetLocalText(2000322)
        self.speedUpBtn:SetActive(false)
        self.fixBtn:SetActive(false)
        self.getRewardBtn:SetActive(true)
        self.getExtraRewardBtn:SetActive(true)
        if self.packageInfo then
          self.getExtraRewardCostText:SetText(self.packageInfo:getPriceText())
        end
        self.getRewardStateText:SetLocalText(2000323)
        self.getRewardStateText:SetActive(true)
      end
    elseif firstPayState == FirstPayState.Unrepaired then
      self.state1Text:SetLocalText(2000324)
      self.speedUpBtn:SetActive(false)
      self.fixBtn:SetActive(true)
      self.getRewardBtn:SetActive(false)
      self.getExtraRewardBtn:SetActive(false)
      self.getRewardStateText:SetActive(false)
    end
  end
  if self.packageInfo ~= nil then
    self.discountText:SetLocalText("320002", string.format("%s", self.packageInfo:getPercent()))
    self.discountPercentText:SetText("%")
  end
end

local function OnClickPayBtn(self)
  self.ctrl:BuyGift(self.packageInfo)
end

local function OnClickCloseBtn(self)
  self.ctrl:CloseSelf()
end

local function OnClickHeroBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.heroBtnN.transform.position + Vector3.New(60, 10, 0) * scaleFactor
  local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.heroId)
  local param = UIHeroTipsView.Param.New()
  param.heroId = self.heroId
  param.title = Localization:GetString(heroConfig.name)
  param.content = Localization:GetString(heroConfig.brief_desc)
  param.dir = UIHeroTipsView.Direction.ABOVE
  param.defWidth = 300
  param.pivot = 0.5
  param.position = position
  param.bindObject = self.heroBtnN.gameObject
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, {anim = false}, param)
end

local function OnRefreshFirstPay(self)
  local firstPayState = DataCenter.FirstPayManager:GetState()
  if firstPayState >= FirstPayState.HasReceivedNormalReward then
    self.ctrl:CloseSelf()
    return
  end
  self:RefreshPackage()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:AddUIListener(EventId.UpdateFirstPayState, OnRefreshFirstPay)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if not self or not self.__event_handlers then
    return
  end
  self:RemoveUIListener(EventId.UpdateFirstPayState, OnRefreshFirstPay)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  self.hasInitData = false
  self:CheckAndPlayOpenAni()
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  self.hasInitData = false
  self:ClearDubHandle()
end

function UIFirstPayView:ClearDubHandle()
  if self.dubHandle ~= nil then
    DataCenter.LWSoundManager:FadeOutAndPlayMusic(self.dubHandle, 0.1)
    self.dubHandle = nil
  end
end

UIFirstPayView.OnCreate = OnCreate
UIFirstPayView.OnDestroy = OnDestroy
UIFirstPayView.OnAddListener = OnAddListener
UIFirstPayView.OnRemoveListener = OnRemoveListener
UIFirstPayView.ComponentDefine = ComponentDefine
UIFirstPayView.ComponentDestroy = ComponentDestroy
UIFirstPayView.DataDefine = DataDefine
UIFirstPayView.DataDestroy = DataDestroy
UIFirstPayView.RefreshAll = RefreshAll
UIFirstPayView.RefreshRewards = RefreshRewards
UIFirstPayView.SetRewardHero = SetRewardHero
UIFirstPayView.RefreshPayState = RefreshPayState
UIFirstPayView.OnClickPayBtn = OnClickPayBtn
UIFirstPayView.OnClickCloseBtn = OnClickCloseBtn
UIFirstPayView.OnClickHeroBtn = OnClickHeroBtn
UIFirstPayView.OnEnable = OnEnable
UIFirstPayView.OnDisable = OnDisable
UIFirstPayView.RefreshPackage = RefreshPackage
UIFirstPayView.RefreshTime = RefreshTime
return UIFirstPayView
