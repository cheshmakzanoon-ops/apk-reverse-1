local UITrainPrepareSceneView = BaseClass("UITrainPrepareSceneView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bidirectionalHorizontalLayoutGroup = typeof(CS.BidirectionalHorizontalLayoutGroup)
local btn_back_path = "Root/BottomBar/BtnBack"
local Carriage = require("UI.UILWRailway.UITrainPrepareScene.Component.PrepareSceneCarriage")
local Driver = require("UI.UILWRailway.UITrainPrepareScene.Component.PrepareSceneDriver")
local PrepareScenePark = require("UI.UILWRailway.UITrainPrepareScene.Component.PrepareScenePark")
local RightsItem = require("UI.UILWRailway.UITrainPrepareScene.Component.UITrainRightsItemComponent")
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local mid_notice_root_path = "Root/BottomBar/MidNoticeRoot"
local thanks_notice_path = "Root/BottomBar/MidNoticeRoot/ThanksNotice"
local head_path = "Root/BottomBar/MidNoticeRoot/ThanksNotice/Head"
local warning_path = "Root/BottomBar/MidNoticeRoot/ThanksNotice/Warning"
local bottom_notice_root_path = "Root/BottomBar/BottomNoticeRoot"
local thanks_notice_bottom_warning_path = "Root/BottomBar/BottomNoticeRoot/ThanksNoticeBottomWarning"
local mask_path = "Mask"
local root_path = "Root"
local tip_anim_path = "Root/TipAnim"
local tip_root_path = "Root/TipAnim/TipRoot"
local tip_title_path = "Root/TipAnim/TipRoot/TipTitle"
local tip_content_path = "Root/TipAnim/TipRoot/TipContent"
local mask_tip_root_path = "Mask/MaskTipRoot"
local mask_tip_text_path = "Mask/MaskTipRoot/MaskTipText"
local refresh_tips_text_path = "Root/BottomBar/RefreshTipsText"
local u_i_train_save_high_goods_content_path = "Root/BottomBar/UITrainSaveHighGoodsContent"
local X1 = -338
local step = 96.6
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")
local UILWTrainSaveHighGoodsComponent = require("UI.UILWRailway.UITrainPrepareScene.Component.UILWTrainSaveHighGoodsComponent")

function UITrainPrepareSceneView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.isVipSelfRewardOpen = LuaEntry.DataConfig:CheckSwitch("train_vip_reward")
end

function UITrainPrepareSceneView:OnDestroy()
  self:ClearRandomToggleCanvasGroupTween()
  self:ClearTrainChangeDelayTimer()
  self:ClearTrainEnterDelayTimer()
  self:ClearDriverAnimDelayTimer()
  self:ComponentDestroy()
  self:ClearFinger()
  self:ClearFirstDriverTimer()
  if self.rootTween then
    self.rootTween:Kill()
    self.rootTween = nil
  end
  self.carriageTransList = nil
  self.mainCamera = nil
  self.driverTrans = nil
  self.randomToggleTrans = nil
  self.trainData = nil
  self.maxPriceValue = nil
  self:ClearWaitRefreshTrain()
  base.OnDestroy(self)
  DataCenter.LWTrainPrepareSceneManager:TryExit()
end

function UITrainPrepareSceneView:ComponentDefine()
  self.__waitRefresh = false
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(function()
    self:CloseSelf()
  end)
  self.refreshBtnGroup = self:AddComponent(UIBaseContainer, "Root/BottomBar/RefreshBtnGroup")
  self.refreshBtn = self:AddComponent(UIButton, "Root/BottomBar/RefreshBtnGroup/refreshBtn")
  self.refreshBtn.ignoreSound = true
  self.refreshBtn:SetOnClick(function()
    self:OnClickRefresh()
  end)
  self.freeRefreshBtn = self:AddComponent(UIButton, "Root/BottomBar/RefreshBtnGroup/freeRefreshBtn")
  self.freeRefreshBtn:SetOnClick(function()
    self:OnClickRefresh()
  end)
  self.freeRefreshBtnDesText = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/RefreshBtnGroup/freeRefreshBtn/TxtDes")
  self.freeRefreshBtnTimesText = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/RefreshBtnGroup/freeRefreshBtn/TxtTimes")
  self.freeRefreshBtnDesText:SetLocalText("alliance_train_free_refresh_btn")
  self.infoBtn = self:AddComponent(UIButton, "Root/Top/Title/infoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfo()
  end)
  self.downArrowBtn = self:AddComponent(UIButton, "Root/BottomBar/downArrow")
  self.downArrowBtn:SetOnClick(function()
    self:OnClickDownArrow()
  end)
  self.upArrowBtn = self:AddComponent(UIButton, "Root/Top/upArrow")
  self.upArrowBtn:SetOnClick(function()
    self:OnClickUpArrow()
  end)
  self.title = self:AddComponent(UIText, "Root/Top/Title")
  self.costTxt = self:AddComponent(UIText, "Root/BottomBar/RefreshBtnGroup/refreshBtn/costTxt")
  self.time = self:AddComponent(UIText, "Root/Top/txtTime")
  self.tipRoot = self:AddComponent(UICanvasGroup, "Root/BottomBar/TipRoot")
  self.tipText = self:AddComponent(UITextMeshProUGUIEx, "Root/BottomBar/TipRoot/TipText")
  self.tipRoot:SetActive(false)
  self.carriage = {}
  for i = 1, 4 do
    self.carriage[i] = self:AddComponent(Carriage, "Root/Middle/PrepareSceneCarriage" .. i)
  end
  self.driver = self:AddComponent(Driver, "Root/Middle/Driver")
  self.driverAnim = self.driver.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  self.mid_notice_root = self:AddComponent(UIBaseContainer, mid_notice_root_path)
  self.thanks_notice = self:AddComponent(UIButton, thanks_notice_path)
  self.thanks_notice:SetOnClick(function()
    self:OnThanksNoticeClick()
  end)
  self.warning = self:AddComponent(UIImage, warning_path)
  self.bottom_notice_root = self:AddComponent(UIBaseContainer, bottom_notice_root_path)
  self.thanks_notice_bottom_warning = self:AddComponent(UIImage, thanks_notice_bottom_warning_path)
  self.thanks_notice:SetActive(false)
  self.thanks_notice_bottom_warning:SetActive(false)
  self.parkList = {}
  for i = 1, 3 do
    self.parkList[i] = self:AddComponent(PrepareScenePark, "Root/Middle/PrepareScenePark" .. i)
    self.parkList[i]:SetActive(false)
  end
  self.randomToggle = self:AddComponent(UIToggle, "Root/Middle/randomToggle")
  self.randomToggleText = self:AddComponent(UITextMeshProUGUIEx, "Root/Middle/randomToggle/randomToggleText")
  self.randomToggleText:SetText(Localization:GetString("alliance_train_013"))
  self.randomToggle:SetOnValueChanged(function(isOn)
    self:OnRandomToggleChanged(isOn)
  end)
  self.randomToggleCanvasGroup = self.randomToggle.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  if self.randomToggleCanvasGroup then
    self.randomToggleCanvasGroup.alpha = 1
  end
  self.mask = self:AddComponent(UIButton, mask_path)
  self.mask:SetActive(false)
  self.mask:SetOnClick(function()
    self:OnMaskClick()
  end)
  local time = 0
  self.maskLastClick = time
  self.root = self:AddComponent(UICanvasGroup, root_path)
  self.root:SetShow(true)
  self.tip_anim = self:AddComponent(UIBaseContainer, tip_anim_path)
  self.VipTrain = self:AddComponent(UIImage, "Root/Middle/VipTrain")
  self.VipTrainIcon = self:AddComponent(UIImage, "Root/Middle/VipTrain/icon")
  self.VipTrainTitleText = self:AddComponent(UILWScienceDetailDesc, "Root/Middle/VipTrain/vipTitle")
  self.VipTrainNameText = self:AddComponent(UIText, "Root/Middle/VipTrain/Name")
  self.VipTrainPowerText = self:AddComponent(UIText, "Root/Middle/VipTrain/Power")
  self.VipTrainHead = self:AddComponent(UICommonHead, "Root/Middle/VipTrain/Head")
  self.VipTrainHead:SetEnableClickShowInfo(true, true)
  self.VipTrainBtn = self:AddComponent(UIButton, "Root/Middle/VipTrain/thumbsUpBtn")
  self.VipTrainBtn:SetOnClick(function()
    self:VipTrainBtnOnClick()
  end)
  self.hideBtn = self:AddComponent(UIButton, "Root/hideBtn")
  self.hideBtn:SetActive(false)
  self.hideBtn:SetOnClick(function()
    self.hideBtn:SetActive(false)
    self.rect_chat:SetActive(self.IAmVip and self.curPage == TrainPreparePage.Passenger)
    for i = 1, 4 do
      self.carriage[i]:RefreshGlow(false)
      self.carriage[i]:SetHideState(true)
      self.carriage[i]:SetEffectState(true)
      self.driver:SetTipsState(true)
    end
  end)
  self.RightsItemList = self:AddComponent(UIBaseContainer, "Root/Middle/RightsItemList")
  self.RightsItemBubbleContent = self:AddComponent(UIBaseContainer, "Root/Middle/RightsItemBubbleContent")
  self.RightsItemBubbleBtn = self:AddComponent(UIButton, "Root/Middle/RightsItemBubbleContent/RightsItemBubbleBtn")
  self.RightsItemBubbleBtn:SetOnClick(function()
    self.RightsItemBubbleContent:SetActive(false)
  end)
  self.RightsItemArrow = self:AddComponent(UIBaseContainer, "Root/Middle/RightsItemBubbleContent/arrow")
  self.RightsItemTitle = self:AddComponent(UILWScienceDetailDesc, "Root/Middle/RightsItemBubbleContent/RightsItemKuang/RightsItemTitle")
  self.RightsItemDesc = self:AddComponent(UITextMeshProUGUIEx, "Root/Middle/RightsItemBubbleContent/RightsItemKuang/RightsItemDesc")
  self.vipSelectRewardBg = self:AddComponent(UIBaseContainer, "Root/Middle/rect_chat/vipSelectRewardBg")
  self.vipSelectTipsText = self:AddComponent(UITextMeshProUGUIEx, "Root/Middle/rect_chat/vipSelectRewardBg/vipSelectTipsText")
  self.rect_chat = self:AddComponent(UIBaseContainer, "Root/Middle/rect_chat")
  self.chatPrivateBtn = self:AddComponent(UIButton, "Root/Middle/rect_chat/ChatPrivateBtn")
  self.chatPrivateBtn:SetOnClick(function()
    self:OnClickChat()
  end)
  self.tip_title = self:AddComponent(UITextMeshProUGUIEx, tip_title_path)
  self.tip_content = self:AddComponent(UITextMeshProUGUIEx, tip_content_path)
  self.tip_title:SetText(Localization:GetString("alliance_train_045"))
  self.tip_content:SetText(Localization:GetString("alliance_train_046"))
  self.mask_tip_root = self:AddComponent(UIBaseContainer, mask_tip_root_path)
  self.mask_tip_text = self:AddComponent(UITextMeshProUGUIEx, mask_tip_text_path)
  self.mask_tip_text:SetText(Localization:GetString("alliance_train_062"))
  self.mask_tip_root:SetActive(false)
  self.tip_anim:SetActive(false)
  self.showTrainEnter = false
  self.showDriverAnim = false
  if self.driverAnim then
    self.driverAnim.enabled = false
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.vipSelectRewardBg.transform:SetSiblingIndex(self.chatPrivateBtn.transform:GetSiblingIndex() + 1)
  end
  self.comp_reward_change_entrance = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, "Root/Top/topBtnLayout/RewardChangeBtn")
  self.refresh_tips_text = self:TryAddComponent(UITextMeshProUGUIEx, refresh_tips_text_path)
  self.u_i_train_save_high_goods_content = self:TryAddComponent(UILWTrainSaveHighGoodsComponent, u_i_train_save_high_goods_content_path)
  self.driverIntroBtn = self:AddComponent(UIButton, "Root/Top/topBtnLayout/DriverIntroBtn")
  self.driverIntroBtn:SetOnClick(function()
    self:OnClickDriverIntro()
  end)
end

function UITrainPrepareSceneView:ComponentDestroy()
  self:RemoveItems()
  self.btn_back = nil
  self.mid_notice_root = nil
  self.thanks_notice = nil
  self.warning = nil
  self.bottom_notice_root = nil
  self.thanks_notice_bottom_warning = nil
  self.carriage = {}
  self.mask = nil
  self.root = nil
  self.tip_anim = nil
  self.tip_title = nil
  self.tip_content = nil
  self.showTrainEnter = false
  self.showDriverAnim = false
  self.driverAnim = nil
  self.VipTrain = nil
  self.VipTrainIcon = nil
  self.VipTrainTitleText = nil
  self.VipTrainNameText = nil
  self.VipTrainPowerText = nil
  self.VipTrainBtn = nil
  self.VipTrainHead = nil
  self.RightsItemList = nil
  self.RightsItemBubbleContent = nil
  self.RightsItemBubbleBtn = nil
  self.RightsItemArrow = nil
  self.RightsItemTitle = nil
  self.RightsItemDesc = nil
  self.vipSelectRewardBg = nil
  self.vipSelectTipsText = nil
  self.chatPrivateBtn = nil
  self.rect_chat = nil
  self.refresh_tips_text = nil
  self.u_i_train_save_high_goods_content = nil
end

function UITrainPrepareSceneView:OnEnable()
  base.OnEnable(self)
  self.carriageTransList = DataCenter.LWTrainPrepareSceneManager.carriageList
  self.mainCamera = DataCenter.LWTrainPrepareSceneManager.controlCamera
  self.driverTrans = DataCenter.LWTrainPrepareSceneManager.driverBubble
  self.randomToggleTrans = DataCenter.LWTrainPrepareSceneManager.randomToggleRoot
  if self.driverAnim then
    self.driverAnim.enabled = false
  end
  self:Refresh(true)
  if self.trainData then
    if self.trainData:IsMyTrain() then
      DataCenter.LWAllyStationDataManager:GetAllianceTrainThumbsUpList(1, true)
    elseif not string.IsNullOrEmpty(self.trainData.ownerId) then
      DataCenter.LWAllyStationDataManager:GetAllianceTrainHasThumbs(1)
    end
  end
  DataCenter.LWAllyStationDataManager:SendAllianceTrainVipHasThumbsUp(1)
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TruckActivity.Type)
  if dataList and dataList[1] then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(dataList[1].activityId)
    if activityData then
      self.comp_reward_change_entrance:ReInit(activityData, nil, true)
    end
  end
end

function UITrainPrepareSceneView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:AddUIListener(EventId.AllianceTrainRefreshMessageSuccess, self.RefreshBtn)
  self:AddUIListener(EventId.ChangeTruckItemNumChange, self.RefreshBtn)
  self:AddUIListener(EventId.TrainPrepareScenePageChanged, self.OnTrainPrepareScenePageChanged)
  self:AddUIListener(EventId.TrainPrepareScenePageBeginMove, self.OnTrainPrepareScenePageBeginMove)
  self:AddUIListener(EventId.AllianceTrainThumbsUpListReceived, self.OnAllianceTrainThumbsUpListReceived)
  self:AddUIListener(EventId.OnPushAllianceTrainThumbsUp, self.OnPushAllianceTrainThumbsUp)
  self:AddUIListener(EventId.AllianceTrainThumbsUpReceived, self.OnAllianceTrainThumbsUpReceived)
  self:AddUIListener(EventId.TrainPrepareSceneEnterFinish, self.OnTrainPrepareSceneEnterFinish)
  self:AddUIListener(EventId.TrainPrepareSceneDriverAnimStart, self.TrainPrepareSceneDriverAnimStart)
  self:AddUIListener(EventId.AllianceTrainRefreshCallback, self.OnAllianceTrainRefreshCallback)
  self:AddUIListener(EventId.AllianceTrainVipRewardSelectHide, self.SetHideBtnStateIsTrue)
  self:AddUIListener(EventId.AllianceTrainVipThumbsUpResult, self.UpdateThumbsUpBtnState)
end

function UITrainPrepareSceneView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTrainStationView, self.Refresh)
  self:RemoveUIListener(EventId.AllianceTrainRefreshMessageSuccess, self.RefreshBtn)
  self:RemoveUIListener(EventId.ChangeTruckItemNumChange, self.RefreshBtn)
  self:RemoveUIListener(EventId.TrainPrepareScenePageChanged, self.OnTrainPrepareScenePageChanged)
  self:RemoveUIListener(EventId.TrainPrepareScenePageBeginMove, self.OnTrainPrepareScenePageBeginMove)
  self:RemoveUIListener(EventId.AllianceTrainThumbsUpListReceived, self.OnAllianceTrainThumbsUpListReceived)
  self:RemoveUIListener(EventId.OnPushAllianceTrainThumbsUp, self.OnPushAllianceTrainThumbsUp)
  self:RemoveUIListener(EventId.AllianceTrainThumbsUpReceived, self.OnAllianceTrainThumbsUpReceived)
  self:RemoveUIListener(EventId.TrainPrepareSceneEnterFinish, self.OnTrainPrepareSceneEnterFinish)
  self:RemoveUIListener(EventId.TrainPrepareSceneDriverAnimStart, self.TrainPrepareSceneDriverAnimStart)
  self:RemoveUIListener(EventId.AllianceTrainRefreshCallback, self.OnAllianceTrainRefreshCallback)
  self:RemoveUIListener(EventId.AllianceTrainVipRewardSelectHide, self.SetHideBtnStateIsTrue)
  self:RemoveUIListener(EventId.AllianceTrainVipThumbsUpResult, self.UpdateThumbsUpBtnState)
  base.OnRemoveListener(self)
end

function UITrainPrepareSceneView:Refresh(init)
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if not trainData then
    self:CloseSelf()
    return
  end
  self.trainData = trainData
  local rightsOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_train_vip")
  if rightsOpenState then
    self:SetTrainRightsList()
  end
  local isMyTrain = trainData:IsMyTrain()
  if isMyTrain then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 2)
    local key = "TRAIN_DRIVER_HAVE_SEEN_BUBBLE"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainData.uuid ~= trainUuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    end
    key = "TRAIN_DRIVER_HAVE_SEEN"
    trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainData.uuid ~= trainUuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
    end
    self:CheckIsFirstDriverTrain()
  else
    local key = "TRAIN_PASSENGER_HAVE_SEEN_BUBBLE"
    local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainUuid ~= trainData.uuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
    end
    key = "TRAIN_PASSENGER_HAVE_SEEN"
    trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
    if trainUuid ~= trainData.uuid then
      CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
      EventManager:GetInstance():Broadcast(EventId.RefreshTrainStationView)
    end
  end
  self.driverIntroBtn:SetActive(isMyTrain)
  local key = "TRAIN_HAVE_SEEN_BUBBLE"
  local trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
  if trainUuid ~= trainData.uuid then
    CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
  end
  key = "TRAIN_HAVE_SEEN"
  trainUuid = CommonUtil.PlayerPrefsGetLong(key, 0)
  if trainUuid ~= trainData.uuid then
    CommonUtil.PlayerPrefsSetLong(key, trainData.uuid)
  end
  local platformData = DataCenter.LWAllyStationDataManager:GetPlatform(1)
  self.platformState = platformData.state
  local showTeleportEffect = false
  if self.platformState == TrainPlatformState.TrainNoDriver then
    self.readyEndTime = nil
    self.time:SetActive(false)
    self.tipText:SetText(Localization:GetString("alliance_train_028"))
    self.refreshBtnGroup:SetActive(false)
    if self.refresh_tips_text then
      self.refresh_tips_text:SetActive(false)
    end
    self.tipRoot:SetActive(true)
  else
    self.readyEndTime = platformData.readyEndTime
    self.time:SetActive(true)
    self.tipRoot:SetActive(false)
  end
  self:Update1000MS()
  self.driver:Refresh(nil, showTeleportEffect)
  for i = 1, 4 do
    self.carriage[i]:Refresh(i + 1)
  end
  for i = 1, 3 do
    self.parkList[i]:Refresh(i, trainData.teamList[i])
  end
  local random = LuaEntry.Player:GetUserSetting(UserSettingKey.ALLIANCE_TRAIN_RANDOM)
  self.toggleOn = random ~= nil and random == "1"
  self.randomToggle:SetIsOn(self.toggleOn)
  self:OnTrainPrepareScenePageChanged()
  self:RefreshBtn()
  DataCenter.LWTrainPrepareSceneManager:RefreshPassenger()
  local showSelect = false
  self.IAmVip = false
  self.vipSelectReward = false
  self.cacheVipSelectRewardVersion = -1
  if self.trainData.vipInfo then
    self.nums = self.trainData.vipInfo.vipReward
    self.IAmVip = self.trainData.vipInfo.vipId == LuaEntry.Player.uid
    self.vipSelectReward = self.trainData.selfSelect
    self.vipSelectRewardVersion = self.trainData.vipInfo.version or 0
    DataCenter.LWTrainPrepareSceneManager:RefreshVIPPassenger(isMyTrain, self.trainData.vipInfo.vipId)
    showSelect = isMyTrain or self.IAmVip
    if self.trainData.vipInfo.vipType == TrainVipType.isLucky and isMyTrain then
      SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 2)
    end
  elseif isMyTrain then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 2)
  end
  if self.IAmVip then
    SFSNetwork.SendMessage(MsgDefines.AllianceTrainFormation, 2)
  end
  self.VipTrainBtn:SetActive(not self.IAmVip)
  local changeVersion = false
  for i = 1, 4 do
    self.carriage[i]:ThisIsMyTrain(showSelect, self.IAmVip, self.vipSelectReward)
    if showSelect then
      if self.isVipSelfRewardOpen then
        if init then
          changeVersion = true
          self.carriage[i]:RefreshSelect(self.nums)
        elseif self.vipSelectRewardVersion > self.cacheVipSelectRewardVersion then
          changeVersion = true
          self.carriage[i]:RefreshSelect(self.nums)
        end
      else
        self.carriage[i]:RefreshSelect(self.nums)
      end
    end
  end
  if changeVersion then
    self.cacheVipSelectRewardVersion = self.vipSelectRewardVersion
  end
  self.rect_chat:SetActive(self.IAmVip and not self.hideBtn:GetActive())
  self:UpdateVipSelectRewardTips()
  if self.showTrainEnter then
    DataCenter.LWTrainPrepareSceneManager:RefreshTrain(true)
    return
  end
  local showTrainEnter = DataCenter.LWTrainPrepareSceneManager.showTrainEnter
  if showTrainEnter then
    self.showTrainEnter = true
    self:ShowTrainEnter()
    DataCenter.LWTrainPrepareSceneManager:RefreshTrain(true)
    return
  end
  if self.showDriverAnim then
    DataCenter.LWTrainPrepareSceneManager:RefreshTrain(true)
    return
  end
  local showDriverAnim, delay = DataCenter.LWTrainPrepareSceneManager:RefreshShowDriverAnim(trainData)
  if showDriverAnim then
    self.showDriverAnim = true
    self:ShowDriverAnim(delay)
    DataCenter.LWTrainPrepareSceneManager:RefreshTrain(true)
    return
  end
  local showEffect = DataCenter.LWTrainPrepareSceneManager:RefreshTrain()
  if showEffect then
    self:ShowTrainChange()
  end
end

function UITrainPrepareSceneView:OnTrainPrepareScenePageBeginMove()
  self.tipRoot:SetAlpha(0)
end

function UITrainPrepareSceneView:OnTrainPrepareScenePageChanged()
  self.tipRoot:SetAlpha(1)
  self.curPage = DataCenter.LWTrainPrepareSceneManager.curPage
  self.title:SetLocalText(self.curPage == TrainPreparePage.Passenger and "alliance_train_012" or "alliance_train_011")
  self.driver:RefreshPage(self.curPage)
  DataCenter.LWTrainPrepareSceneManager:RefreshBubbleTip(self.curPage)
  local isDriver = self.curPage == TrainPreparePage.Driver
  if isDriver and self.trainData.vipInfo then
    self.VipTrain:SetActive(true)
    self:RefreshVIPTrainCardInfo()
  else
    self.VipTrain:SetActive(false)
  end
  self.RightsItemList:SetActive(isDriver)
  if isDriver then
    self.tipRoot:SetAnchoredPositionXY(0, 420)
  else
    self.tipRoot:SetAnchoredPositionXY(0, 22)
  end
  for i = 1, 4 do
    self.carriage[i]:RefreshPage(self.curPage)
  end
  self.rect_chat:SetActive(self.IAmVip and self.curPage == TrainPreparePage.Passenger)
  self.upArrowBtn:SetActive(self.curPage == TrainPreparePage.Passenger)
  self.downArrowBtn:SetActive(isDriver)
  self.mid_notice_root:SetActive(self.curPage == TrainPreparePage.Passenger)
  self.bottom_notice_root:SetActive(isDriver)
  for i = 1, 3 do
    self.parkList[i]:RefreshPage(self.curPage)
  end
  if self.trainData then
    if self.trainData:IAmBigBrotherVip() then
      self.randomToggle:SetActive(isDriver)
    elseif self.trainData.vipInfo and self.trainData.vipInfo.vipType == TrainVipType.isBigBro and self.trainData.vipInfo.vipId ~= LuaEntry.Player.uid then
      self.randomToggle:SetActive(false)
    elseif self.trainData:IsMyTrain() then
      self.randomToggle:SetActive(isDriver)
    else
      self.randomToggle:SetActive(false)
    end
  else
    self.randomToggle:SetActive(false)
  end
  local refreshBtnShow = self.trainData and self.trainData:IsMyTrain()
  self.refreshBtnGroup:SetActive(refreshBtnShow and self.curPage == TrainPreparePage.Passenger and self.platformState ~= TrainPlatformState.TrainNoDriver)
  local isURTrain = RailwayUtil.IsUR(self.trainData.cfgId)
  local isShowTips = refreshBtnShow and self.curPage == TrainPreparePage.Passenger and self.platformState ~= TrainPlatformState.TrainNoDriver and not isURTrain
  if self.refresh_tips_text then
    self.refresh_tips_text:SetActive(isShowTips)
  end
  if isShowTips and self.refresh_tips_text then
    local curTimes = self.trainData.changeCountByGold
    local targetTimes = DataCenter.LWAllyStationDataManager:GetRefreshGoldTrainTimes()
    self.refresh_tips_text:SetLocalText("alliance_train_golden_progress_limit_15", curTimes, targetTimes)
  end
  if self.u_i_train_save_high_goods_content then
    self.u_i_train_save_high_goods_content:RefreshShow(self.curPage, self.trainData, self.platformState)
  end
end

function UITrainPrepareSceneView:Update()
  if self.carriage and self.carriageTransList then
    for i = 1, 4 do
      local ca = self.carriage[i]
      local tr = self.carriageTransList[i]
      CS.CSUtils.WorldPositionToUITransform(tr, self.mainCamera, ca.rectTransform, 4, -0.7)
    end
  end
  if self.driver and self.driverTrans then
    CS.CSUtils.WorldPositionToUITransform(self.driverTrans, self.mainCamera, self.driver.rectTransform, 4)
  end
  if self.randomToggle and self.randomToggleTrans then
    CS.CSUtils.WorldPositionToUITransform(self.randomToggleTrans, self.mainCamera, self.randomToggle.rectTransform)
  end
  for i = 1, 3 do
    self.parkList[i]:OnUpdate()
  end
end

function UITrainPrepareSceneView:Update1000MS()
  if not self.readyEndTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < self.readyEndTime then
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.readyEndTime - now)
    self.time:SetText(str)
  else
    self:CloseSelf()
  end
end

function UITrainPrepareSceneView:OnClickUpArrow()
  DataCenter.LWTrainPrepareSceneManager:MoveToFront()
end

function UITrainPrepareSceneView:OnClickDownArrow()
  DataCenter.LWTrainPrepareSceneManager:MoveToBack()
end

function UITrainPrepareSceneView:DriverAnim()
  return false
end

function UITrainPrepareSceneView:RefreshBtn()
  local freeRefreshTimes = DataCenter.LWAllyStationDataManager:GetFreeRefreshTimes()
  if 0 < freeRefreshTimes then
    self.freeRefreshBtn:SetActive(true)
    self.refreshBtn:SetActive(false)
    local maxTimes = DataCenter.LWAllyStationDataManager:GetMaxFreeRefreshTimes()
    local useNum = maxTimes - freeRefreshTimes
    self.freeRefreshBtnTimesText:SetLocalText("alliance_train_free_refresh_progress", useNum, maxTimes)
    return
  else
    self.freeRefreshBtn:SetActive(false)
    self.refreshBtn:SetActive(true)
  end
  local have = DataCenter.ItemData:GetItemCount(DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM)
  local need = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_NUM
  self.costTxt:SetText(have .. "/" .. need)
  self.costTxt:SetColor(have >= need and GreenColor or RedColor)
end

function UITrainPrepareSceneView:OnAllianceTrainRefreshCallback()
  self:ClearWaitRefreshTrain()
end

function UITrainPrepareSceneView:OnClickRefresh()
  local trainData = DataCenter.LWAllyStationDataManager:GetTrainByPlatformId(1)
  if trainData and trainData:IsMyTrain() then
    local itemId = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_ITEM
    local have = DataCenter.ItemData:GetItemCount(itemId)
    local need = DataCenter.LWAllyStationDataManager.CHANGE_TRAIN_COST_NUM
    local freeRefreshTimes = DataCenter.LWAllyStationDataManager:GetFreeRefreshTimes()
    if 0 < freeRefreshTimes or have >= need then
      if self.__waitRefresh then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_refresh_reward, false)
        return
      end
      local diamondPrice = trainData:GetFullReward2DiamondPrice()
      local maxPriceValue = self:GetMaxPriceValue()
      if diamondPrice >= maxPriceValue then
        local param = {
          contentText = Localization:GetString("alliance_train_golden_check_desc"),
          btnNum = 2,
          confirmBtnParam = {
            action = function()
              self:SendAllianceTrainRefreshMsg()
            end
          }
        }
        UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.TrainRefreshSecondConfirm, param)
      else
        self:SendAllianceTrainRefreshMsg()
      end
    else
      LWResourceLackUtil:GotoGoodsItemLack(itemId, need - have)
    end
  else
    UIUtil.ShowTipsId(458550)
  end
end

function UITrainPrepareSceneView:SendAllianceTrainRefreshMsg()
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainRefresh)
  DataCenter.LWSoundManager:PlaySound(50010, false)
  self:SetWaitRefreshTrain()
end

function UITrainPrepareSceneView:SetWaitRefreshTrain()
  if not self.__waitRefresh then
    self.__waitRefresh = true
    if self.delayWaitRefreshTrain then
      self.delayWaitRefreshTrain:Stop()
    end
    self.delayWaitRefreshTrain = TimerManager:GetInstance():DelayInvoke(function()
      self.__waitRefresh = false
      self.delayWaitRefreshTrain = nil
    end, 30)
  end
end

function UITrainPrepareSceneView:ClearWaitRefreshTrain()
  self.__waitRefresh = false
  if self.delayWaitRefreshTrain then
    self.delayWaitRefreshTrain:Stop()
    self.delayWaitRefreshTrain = nil
  end
end

function UITrainPrepareSceneView:OnClickInfo()
  RailwayUtil.ShowTrainActivityConstruction()
end

function UITrainPrepareSceneView:OnThanksNoticeClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainPrepareThanksRecord, {anim = true})
end

function UITrainPrepareSceneView:OnAllianceTrainThumbsUpListReceived()
  local list = DataCenter.LWAllyStationDataManager:GetThumbsUpList()
  local count = #list
  local show = 0 < count and self.trainData and self.trainData:IsMyTrain()
  self.thanks_notice:SetActive(show)
  if show then
    local canReward = DataCenter.LWAllyStationDataManager:ThumbsUpCanReward()
    self.thanks_notice_bottom_warning:SetActive(canReward)
    self.warning:SetActive(canReward)
  else
    self.thanks_notice_bottom_warning:SetActive(false)
  end
end

function UITrainPrepareSceneView:OnAllianceTrainThumbsUpReceived()
  if self.trainData then
    local msg = Localization:GetString("alliance_train_038", self.trainData.name or "")
    UIUtil.ShowTips(msg)
  end
end

function UITrainPrepareSceneView:OnPushAllianceTrainThumbsUp(msg)
  if self.trainData and self.trainData:IsMyTrain() then
    local canReward = DataCenter.LWAllyStationDataManager:ThumbsUpCanReward()
    self.thanks_notice_bottom_warning:SetActive(canReward)
  end
end

function UITrainPrepareSceneView:ShowDriverAnim(delay)
  self:ClearDriverAnimDelayTimer()
  self.mask:SetActive(true)
  if self.randomToggleCanvasGroup then
    self.randomToggleCanvasGroup.alpha = 0
  end
  for i = 1, 3 do
    self.parkList[i]:CanvasHide()
  end
  if 0 < delay then
    self.driver:HeadVisible(false)
    self.driverAnimStartDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.driverAnim then
        self.driverAnim.enabled = true
        self.driverAnim:Play("Eff_ui_ani_UITrainPrepareScene_", 0, 0)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.leader_selected, false)
      end
    end, delay)
  else
    delay = 0
    if self.driverAnim then
      self.driverAnim.enabled = true
      self.driverAnim:Play("Eff_ui_ani_UITrainPrepareScene_", 0, 0)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.leader_selected, false)
    end
  end
  self.driverAnimDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.driverAnimDelayTimer = nil
    self.showDriverAnim = false
    self.mask:SetActive(false)
    self:DriverFadeFinish()
  end, delay + 4)
end

function UITrainPrepareSceneView:TrainPrepareSceneDriverAnimStart()
  if self.showDriverAnim and self.driverAnimStartDelayTimer ~= nil then
    self:ClearDriverAnimDelayTimer()
    self.driver:HeadVisible(true)
    if self.driverAnim then
      self.driverAnim.enabled = true
      self.driverAnim:Play("Eff_ui_ani_UITrainPrepareScene_", 0, 0)
    end
    self.driverAnimDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.driverAnimDelayTimer = nil
      self.showDriverAnim = false
      self.mask:SetActive(false)
      self:DriverFadeFinish()
    end, 4)
  end
end

function UITrainPrepareSceneView:BreakDriverAnim()
  if self.showDriverAnim then
    self.showDriverAnim = false
    self:ClearDriverAnimDelayTimer()
    self.mask:SetActive(false)
    if self.driverAnim then
      self.driverAnim.enabled = true
      self.driverAnim:Play("Eff_ui_ani_UITrainPrepareScene_", 0, 1)
    end
    self:DriverFadeFinish()
  end
end

function UITrainPrepareSceneView:DriverFadeFinish()
  self:ClearRandomToggleCanvasGroupTween()
  if self.randomToggleCanvasGroup then
    self.randomToggleCanvasGroupTween = self.randomToggleCanvasGroup:DOFade(1, 0.2)
  end
  for i = 1, 3 do
    self.parkList[i]:FadeShow()
  end
end

function UITrainPrepareSceneView:ClearRandomToggleCanvasGroupTween()
  if self.randomToggleCanvasGroupTween then
    self.randomToggleCanvasGroupTween:Kill()
    self.randomToggleCanvasGroupTween = nil
  end
end

function UITrainPrepareSceneView:ClearDriverAnimDelayTimer()
  if self.driverAnimDelayTimer then
    self.driverAnimDelayTimer:Stop()
    self.driverAnimDelayTimer = nil
  end
  if self.driverAnimStartDelayTimer then
    self.driverAnimStartDelayTimer:Stop()
    self.driverAnimStartDelayTimer = nil
  end
end

function UITrainPrepareSceneView:ShowTrainEnter()
  self:ClearTrainEnterDelayTimer()
  self:ClearTrainChangeDelayTimer()
  self:ClearDriverAnimDelayTimer()
  self.root:SetShow(false)
  self.mask:SetActive(true)
  self.mask_tip_root:SetActive(true)
  self.delayEnterTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayEnterTimer = nil
    self.showTrainEnter = false
    self:ShowRoot()
  end, 9)
end

function UITrainPrepareSceneView:ClearTrainEnterDelayTimer()
  if self.delayEnterTimer then
    self.delayEnterTimer:Stop()
    self.delayEnterTimer = nil
  end
end

function UITrainPrepareSceneView:OnBreakTrainEnter()
  if self.showTrainEnter then
    self.showTrainEnter = false
    self:ClearTrainEnterDelayTimer()
    self:ShowRoot()
  end
end

function UITrainPrepareSceneView:OnTrainPrepareSceneEnterFinish()
  self:OnBreakTrainEnter()
end

function UITrainPrepareSceneView:ShowTrainChange()
  self:ClearTrainChangeDelayTimer()
  self:ClearTrainEnterDelayTimer()
  self.root:SetShow(false)
  self.mask:SetActive(true)
  self.tip_anim:SetActive(true)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.train_turn_gold1, false)
  self.changeTipDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.changeTipDelayTimer = nil
    self.tip_anim:SetActive(false)
  end, 2)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayTimer = nil
    self:ShowRoot()
  end, 4.5)
end

function UITrainPrepareSceneView:ClearTrainChangeDelayTimer()
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.changeTipDelayTimer then
    self.changeTipDelayTimer:Stop()
    self.changeTipDelayTimer = nil
  end
end

function UITrainPrepareSceneView:OnMaskClick()
  local time = Time.realtimeSinceStartup
  if time - self.maskLastClick < 0.5 then
    if self.showTrainEnter then
      self:OnBreakTrainEnter()
      DataCenter.LWTrainPrepareSceneManager:BreakTrainEnter()
    elseif self.showDriverAnim then
      self:BreakDriverAnim()
      DataCenter.LWTrainPrepareSceneManager:BreakDriverAnim()
    else
      self:ClearTrainChangeDelayTimer()
      self:ShowRoot()
    end
  end
  self.maskLastClick = time
end

function UITrainPrepareSceneView:ShowRoot()
  if self.root then
    self.mask:SetActive(false)
    self.mask_tip_root:SetActive(false)
    self.root:SetInteractable(true)
    self.root:SetBlocksRaycasts(true)
    if self.rootTween then
      self.rootTween:Kill()
      self.rootTween = nil
    end
    self.rootTween = self.root:FadeIn(0.2)
  end
end

function UITrainPrepareSceneView:OnRandomToggleChanged(isOn)
  if self.toggleOn == isOn then
    return
  end
  self.toggleOn = isOn
  if isOn then
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_TRAIN_RANDOM, "1")
  else
    SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.ALLIANCE_TRAIN_RANDOM, "0")
  end
end

function UITrainPrepareSceneView:CloseSelf()
  self.ctrl:CloseSelf()
end

function UITrainPrepareSceneView:RefreshVIPTrainCardInfo()
  if self.trainData then
    if self.trainData.vipInfo then
      self.VipTrain.gameObject:SetActive(true)
      if self.trainData.vipInfo.vipType == TrainVipType.isLucky then
        self.VipTrain:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_fen.png")
        self.VipTrainIcon:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_xingyun.png")
        self.VipTrainTitleText:SetTextAndParam(Localization:GetString("alliance_train_vip002"))
      elseif self.trainData.vipInfo.vipType == TrainVipType.isBigBro then
        self.VipTrain:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_huang.png")
        self.VipTrainIcon:LoadSprite("Assets/Main/Sprites/UI/UILWRailwayTrain/zxl_huochevip_baobiao.png")
        self.VipTrainTitleText:SetTextAndParam(Localization:GetString("alliance_train_vip003"))
      end
      self.VipTrainPowerText:SetText(string.GetFormattedStr2(self.trainData.vipInfo.power))
      self.VipTrainNameText:SetText(self.trainData.vipInfo.name)
      self.VipTrainHead:SetHeadAndFrame(self.trainData.vipInfo.vipId, self.trainData.vipInfo.headPic, self.trainData.vipInfo.headPicVer, false, self.trainData.vipInfo.headSkinId, self.trainData.vipInfo.headSkinET)
    else
      self.VipTrain.gameObject:SetActive(false)
    end
  end
end

function UITrainPrepareSceneView:VipTrainBtnOnClick()
  if self.trainData and self.trainData.vipInfo then
    DataCenter.LWAllyStationDataManager:SendAllianceTrainVipThumbsUp(1)
    self.VipTrainBtn:SetActive(false)
  end
end

function UITrainPrepareSceneView:UpdateThumbsUpBtnState(alreadyThumbsUpVip)
  self.VipTrainBtn:SetActive(not alreadyThumbsUpVip and not self.IAmVip)
end

function UITrainPrepareSceneView:OnVipToggleSelect(index)
  if not self.isVipSelfRewardOpen then
    local select = DataCenter.LWAllyStationDataManager:GetToggleNumSelect()
    if select ~= nil and not select then
      UIUtil.ShowTipsId(120289)
    end
  end
  for _, v in ipairs(self.nums) do
    if v == index then
      return
    end
  end
  table.remove(self.nums, 1)
  table.insert(self.nums, index)
  DataCenter.LWAllyStationDataManager:SetToggleNumSelect(false)
  self.cacheVipSelectRewardVersion = self.cacheVipSelectRewardVersion + 1
  SFSNetwork.SendMessage(MsgDefines.AllianceTrainVipRewardSelect, self.nums, 1)
end

function UITrainPrepareSceneView:SetHideBtnStateIsTrue()
  if not self.hideBtn:GetActive() then
    self.hideBtn:SetActive(true)
    if self.isVipSelfRewardOpen and self.vipSelectReward then
      self.rect_chat:SetActive(false)
    end
    for i = 1, 4 do
      self.carriage[i]:ClearGlow(true)
      self.carriage[i]:SetHideState(false)
      self.driver:SetTipsState(false)
      self.carriage[i]:SetEffectState(false)
    end
    return
  end
end

function UITrainPrepareSceneView:SetTrainRightsList()
  self:RemoveItems()
  self.rightsItem = self.rightsItem or {}
  local nowGiftLevel = self.trainData.giftLv
  local TemplatesIsTrainRightsDict = DataCenter.LWAllianceRightShowTemplateManager:GetTemplatesIsTrainRights(1)
  for i, value in ipairs(TemplatesIsTrainRightsDict) do
    if value then
      self.rightsItem[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainRightsItem.prefab", function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.RightsItemList.transform)
        go.transform:Set_localScale(1, 1, 1)
        local nameStr = tostring(i)
        go.name = nameStr
        local cell = self.RightsItemList:AddComponent(RightsItem, nameStr)
        cell:SetRightInfo(TemplatesIsTrainRightsDict[i], nowGiftLevel, i)
      end)
    end
  end
end

function UITrainPrepareSceneView:RemoveItems()
  self.RightsItemList:RemoveComponents(RightsItem)
  if self.rightsItem then
    for _, v in pairs(self.rightsItem) do
      v:Destroy()
    end
  end
  self.rightsItem = {}
end

function UITrainPrepareSceneView:SetBubbleInfo(rightInfo, IsBuy)
  if rightInfo then
    self.RightsItemBubbleContent:SetActive(true)
    self.RightsItemTitle:SetTextAndParam(Localization:GetString(rightInfo.title))
    local desc = Localization:GetString(rightInfo.desc)
    if rightInfo.satisfyCondition or IsBuy then
      self.RightsItemDesc:SetText(desc)
    else
      local lv = Localization:GetString("alliance_train_vip022", rightInfo.needLv)
      self.RightsItemDesc:SetText(desc .. [[

<color=#f85967>]] .. lv .. "</color>")
    end
    local posX = X1 + (rightInfo.index - 1) * step
    local currentPos = self.RightsItemArrow:GetAnchoredPosition()
    self.RightsItemArrow:SetAnchoredPositionXY(posX, currentPos.y)
  end
end

function UITrainPrepareSceneView:UpdateVipSelectRewardTips()
  if self.IAmVip and self.nums and #self.nums >= 2 then
    if self.vipSelectReward then
      self.vipSelectTipsText:SetLocalText("alliance_train_vip049", self.nums[1], self.nums[2])
    else
      self.vipSelectTipsText:SetLocalText("alliance_train_vip017", self.nums[1], self.nums[2])
    end
  end
end

function UITrainPrepareSceneView:OnClickChat()
  if UIManager.Instance:IsWindowOpen(UIWindowNames.UIChatNew_v2) then
    local windows = {}
    for k, v in pairs(UIManager.Instance.windows) do
      windows[k] = v
    end
    for k, v in pairs(windows) do
      if v.Name ~= UIWindowNames.UIChatNew_v2 and v.Name ~= UIWindowNames.UIMain and v.Name ~= UIWindowNames.UIJeepAdventureMainView and v.Name ~= UIWindowNames.LWLLBattleMainUIView and not BattlefieldConfig.IsBattlefieldMainUI(v.Name) then
        UIManager.Instance:DestroyWindow(v.Name)
      end
    end
    local userInfo = {}
    userInfo.uid = self.trainData.ownerId
    userInfo.userName = self.trainData.name
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_TALK_TO_PRIVATE, userInfo)
  else
    local userInfo = {}
    userInfo.uid = self.trainData.ownerId
    userInfo.userName = self.trainData.name
    local data = {}
    data.privateUserInfo = userInfo
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
    GoToUtil.OpenChatView(false, {anim = false}, data)
    local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
    local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
    if curBattleType == PVEType.Arena3V3 and curEnterType == PVEEnterType.Arena3V3 then
      DataCenter.LWBattleManager:Exit(nil, "chat")
    end
  end
end

function UITrainPrepareSceneView:OnIAmVipToggleSelect()
  self:ClearFinger()
  self.fingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
  self.fingerHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(handle)
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
    transform:Set_localPosition(0, -620, 0)
    transform:Set_localScale(0.5, 0.5, 1)
    self.fingerDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.fingerDelay = nil
      if self.fingerHandle then
        self.fingerHandle:Destroy()
        self.fingerHandle = nil
      end
    end, 2)
  end)
end

function UITrainPrepareSceneView:ClearFinger()
  if self.fingerDelay then
    self.fingerDelay:Stop()
    self.fingerDelay = nil
  end
  if self.fingerHandle then
    self.fingerHandle:Destroy()
    self.fingerHandle = nil
  end
end

function UITrainPrepareSceneView:CheckIsFirstDriverTrain()
  local isFirstDriverTrain = Setting:GetPrivateBool("IsFirstDriverTrain", true)
  if isFirstDriverTrain then
    self:ClearFirstDriverTimer()
    self.firstDriverTimer = TimerManager:GetInstance():DelayInvoke(function()
      Setting:SetPrivateBool("IsFirstDriverTrain", false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainDriverIntroduce)
    end, 1)
  end
end

function UITrainPrepareSceneView:ClearFirstDriverTimer()
  if self.firstDriverTimer then
    self.firstDriverTimer:Stop()
    self.firstDriverTimer = nil
  end
end

function UITrainPrepareSceneView:OnClickDriverIntro()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITrainDriverIntroduce)
end

function UITrainPrepareSceneView:GetMaxPriceValue()
  if self.maxPriceValue == nil then
    self.maxPriceValue = LuaEntry.DataConfig:TryGetNum("alliance_train", "k26")
  end
  return self.maxPriceValue
end

return UITrainPrepareSceneView
