local UIDigTreasureView = BaseClass("UIDigTreasureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DiggingMap = require("UI.DigTreasure.Component.DiggingMap.DigTreasureMap")
local DiggingHelpItem = require("UI.LWSeason3.DiggingGame.DiggingLevelSingle.Component.DiggingHelpItem")
local DiggingBlockInfo = require("UI.DigTreasure.Component.DiggingMap.DigTreasureBlockInfo")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local RewardUtil = require("Util.RewardUtil")
local LEVELS_NUM_PER_GROUP = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ShowHelpList(DataCenter.DigTreasureManager:GetHelpList())
  SFSNetwork.SendMessage(MsgDefines.DigTreasureGameInfo)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.ArrowManager:RemoveFingerArrow()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnInfo = self:AddComponent(UIButton, "safeArea/Root/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnClose = self:AddComponent(UIButton, "safeArea/Root/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnGetMore = self:AddComponent(UIButton, "safeArea/Root/UseItemTop/bg")
  self.btnGetMore:SetOnClick(function()
    self:OnBtnGetMoreClick()
  end)
  self.btnShare = self:AddComponent(UIButton, "safeArea/Root/Bottom/SelfInfo/ShareBtn")
  self.btnShare:SetOnClick(function()
    self:OnBtnShareClick()
  end)
  self.objRewardArea = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea")
  self.objCountDownArea = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea")
  self.sliderCountDown = self:AddComponent(UISlider, "safeArea/Root/CountDownArea/UnFinishState/Slider")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDown")
  self.textCountDownDes1 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes1")
  self.textCountDownDes2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes2")
  self.textItemNum = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/UseItemTop/ItemNumText")
  self.objHelpRoot = self:AddComponent(UIBaseContainer, "safeArea/Root/Bottom/SelfInfo/HelpRoot")
  self.objDiggingHelpItem = self:AddComponent(UIBaseContainer, "safeArea/Root/Bottom/SelfInfo/HelpRoot/DiggingHelpItem")
  self.sliderReward = self:AddComponent(UISlider, "safeArea/Root/RewardArea/SliderReward")
  self.objDigTreasureBlockInfo = self:AddComponent(UIBaseContainer, "safeArea/Root/Top/Door/bg2/bgBlock/DigTreasureBlockInfo")
  self.objBlockRoot = self:AddComponent(UIBaseContainer, "safeArea/Root/Top/Door/bg2/bgBlock")
  self.btnGiveUp = self:AddComponent(UIButton, "safeArea/Root/Bottom/btnGiveUp")
  self.btnGiveUp:SetOnClick(function()
    self:OnBtnGiveUpClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/Title")
  self.textGiveUp = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/Bottom/btnGiveUp/Text")
  self.panelAnimator = self:AddComponent(UIAnimator, "")
  self.objRewardFly = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/rewardFly")
  self.imgRewardBox = self:AddComponent(UIImage, "safeArea/Root/Top/Cave/RewardObj/Image")
  self.imgRewardFly = self:AddComponent(UIImage, "safeArea/Root/RewardArea/rewardFly")
  self.btnResetMask = self:AddComponent(UIButton, "safeArea/Root/resetMask")
  self.btnResetMask:SetOnClick(function()
    self:OnBtnResetMaskClick()
  end)
  self.textResetCountdown = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/resetMask/textResetCountdown")
  self.objFinishState = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea/FinishState")
  self.objUnFinishState = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea/UnFinishState")
  self.textFinishDes = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/FinishState/finishDes")
  self.btnBackMask = self:AddComponent(UIButton, "safeArea/Root/backMask")
  self.btnBackMask:SetOnClick(function()
    self:OnBtnBackMaskClick()
  end)
  self.objRewardSelect = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/imgSelect_animation")
  self.textResetCountdown2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/resetMask/textResetCountdown2")
  self.timeLimitRewardAnimator = self:AddComponent(UIAnimator, "safeArea/Root/Top/Cave/RewardObj/Image_xianshi")
  self.btnImageXianshi1 = self:AddComponent(UIButton, "safeArea/Root/Top/Cave/RewardObj/Image_xianshi/Image_xianshi1")
  self.btnImageXianshi1:SetOnClick(function()
    self:OnClickTimeLimitReward()
  end)
  self.effectProgress = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/SliderReward/Fill Area/Fill/Eff_UIDigTreasure_jindutiao")
  self.rawImgFire1 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg3")
  self.rawImgFire2 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg4")
  self.btnPreview = self:AddComponent(UIButton, "safeArea/Root/PreviewBtn")
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
  self.imgUseItem = self:AddComponent(UIImage, "safeArea/Root/UseItemTop/ItemImg")
  self.btnExchange = self:AddComponent(UIButton, "safeArea/Root/ExchangeBtn")
  self.btnExchange:SetOnClick(function()
    self:OnBtnExchangeClick()
  end)
  self.objRewardEnter = self:AddComponent(UIBaseContainer, "safeArea/Root/Bottom/rewardEnter")
  self.textCountDownDes1:SetLocalText("treasure_map_special_level_03")
  self.textCountDownDes2:SetLocalText("treasure_map_special_level_02")
  self.textGiveUp:SetLocalText("110075")
  self.textResetCountdown2:SetLocalText("treasure_map_level_end_01")
  self.btnTimeLimitReward = self:AddComponent(UIButton, "safeArea/Root/Top/Cave/RewardObj/Image")
  self.fly = self.objRewardFly.transform:GetComponent(typeof(CS.UIGoodsFly))
  self.fly.transform.gameObject:SetActive(false)
  self.DiggingMap = self:AddComponent(DiggingMap, "safeArea/Root/DiggingMap")
  self.tRewardList = {}
  for i = 1, LEVELS_NUM_PER_GROUP do
    local obj = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/layout/Reward" .. i)
    self.tRewardList[i] = {
      rootObj = obj,
      imgReward = obj:AddComponent(UIImage, "btnReward"),
      imgGet = obj:AddComponent(UIImage, "imgGet"),
      btnReward = obj:AddComponent(UIButton, "btnReward"),
      textDes = obj:AddComponent(UITextMeshProUGUIEx, "text"),
      effectCanGet = obj:AddComponent(UIBaseContainer, "effectCanGet"),
      effectFlyFinish = obj:AddComponent(UIVfx, "effectFlyFinish", VfxAssets.DigTreasureRewardFlyFinish, {
        lifeType = UIVfxLifeType.DestroyAfterOnce
      })
    }
    self.tRewardList[i].btnReward:SetOnClick(function()
      self:OnClickReward(i)
    end)
  end
  self.HelpObj = self.objDiggingHelpItem.gameObject
  self.HelpObj:GameObjectCreatePool()
  self.HelpObj:SetActive(false)
  self.BlockItemObj = self.objDigTreasureBlockInfo.gameObject
  self.BlockItemObj:GameObjectCreatePool()
  self.BlockItemObj:SetActive(false)
  self.btnGiveUp:SetActive(false)
end

local function ComponentDestroy(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.tweenSeqLimitMap then
    self.tweenSeqLimitMap:Kill()
    self.tweenSeqLimitMap = nil
  end
  self.objHelpRoot:RemoveComponents(DiggingHelpItem)
  self.HelpObj:GameObjectRecycleAll()
  self.objBlockRoot:RemoveComponents(DiggingBlockInfo)
  self.BlockItemObj:GameObjectRecycleAll()
  self.btnInfo = nil
  self.btnClose = nil
  self.btnGetMore = nil
  self.btnShare = nil
  self.objRewardArea = nil
  self.objCountDownArea = nil
  self.sliderCountDown = nil
  self.textCountDown = nil
  self.textCountDownDes1 = nil
  self.textCountDownDes2 = nil
  self.textItemNum = nil
  self.objHelpRoot = nil
  self.objDiggingHelpItem = nil
  self.sliderReward = nil
  self.objDigTreasureBlockInfo = nil
  self.objBlockRoot = nil
  self.btnGiveUp = nil
  self.textTitle = nil
  self.textGiveUp = nil
  self.panelAnimator = nil
  self.objRewardFly = nil
  self.imgRewardBox = nil
  self.imgRewardFly = nil
  self.btnResetMask = nil
  self.textResetCountdown = nil
  self.objFinishState = nil
  self.objUnFinishState = nil
  self.textFinishDes = nil
  self.btnBackMask = nil
  self.objRewardSelect = nil
  self.textResetCountdown2 = nil
  self.timeLimitRewardAnimator = nil
  self.btnImageXianshi1 = nil
  self.effectProgress = nil
  self.rawImgFire1 = nil
  self.rawImgFire2 = nil
  self.btnPreview = nil
  self.imgUseItem = nil
  self.btnExchange = nil
  self.objRewardEnter = nil
end

local function DataDefine(self)
  self.tMapData = nil
  self.tHelpItemList = {}
  self.tBlockItemList = {}
  self.bGetAllReward = false
  self.bShowEndMessageTips = false
  self.bIsShowFinger = false
  self.bIsShowFingerTimeLimit = false
  self.nFingerIntervalTime = 5
  self.nCurIntervalTime = 0
  self.nCurIntervalTimeLimit = 0
  self.bDuringChangeToLimitMap = false
  self.bDuringChangeToNormalMap = false
  self.bFirstShowReward = true
end

local function DataDestroy(self)
  self.tMapData = nil
  self.tHelpItemList = nil
  self.tBlockItemList = nil
  self.bGetAllReward = nil
  self.bShowEndMessageTips = nil
  self.bIsShowFinger = false
  self.bIsShowFingerTimeLimit = false
  self.nCurIntervalTime = 0
  self.nCurIntervalTimeLimit = 0
  self.bDuringChangeToLimitMap = false
  self.bDuringChangeToNormalMap = false
  self.bFirstShowReward = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshUseItemNum)
  self:AddUIListener(EventId.DigTreasureUpdateRewardData, self.RefreshReward)
  self:AddUIListener(EventId.DigTreasureUpdateMapData, self.OnUpdateMapData)
  self:AddUIListener(EventId.DigTreasureGetHelp, self.OnGetHelp)
  self:AddUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:AddUIListener(EventId.DigTreasureUpdateActivityData, self.RefreshAll)
  self:AddUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.CheckIsGetAllReward)
  self:AddUIListener(EventId.DigTreasureGiveUp, self.RefreshTimelimitMapState)
  self:AddUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  self:AddUIListener(EventId.DigTreasureBeginTimeLimitMap, self.OnBeginTimeLimitMap)
  self:AddUIListener(EventId.DigTreasureOpenRewardBlock, self.OnOpenRewardBlock)
  self:AddUIListener(EventId.DigTreasureGetReward, self.OnGetReward)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshUseItemNum)
  self:RemoveUIListener(EventId.DigTreasureUpdateRewardData, self.RefreshReward)
  self:RemoveUIListener(EventId.DigTreasureUpdateMapData, self.OnUpdateMapData)
  self:RemoveUIListener(EventId.DigTreasureGetHelp, self.OnGetHelp)
  self:RemoveUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:RemoveUIListener(EventId.DigTreasureUpdateActivityData, self.RefreshAll)
  self:RemoveUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.CheckIsGetAllReward)
  self:RemoveUIListener(EventId.DigTreasureGiveUp, self.RefreshTimelimitMapState)
  self:RemoveUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  self:RemoveUIListener(EventId.DigTreasureBeginTimeLimitMap, self.OnBeginTimeLimitMap)
  self:RemoveUIListener(EventId.DigTreasureOpenRewardBlock, self.OnOpenRewardBlock)
  self:RemoveUIListener(EventId.DigTreasureGetReward, self.OnGetReward)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  self:ShowHowToPlay()
end

local function OnBtnPreviewClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTreasureGetBoxReward, {anim = true}, TreasureRewardType.DigTreasure)
end

local function ShowHowToPlay(self)
  local tActivityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DigTreasure.Type)
  if tActivityList and tActivityList[1] then
    self.activityInfoData = tActivityList[1]
  end
  if not self.activityInfoData then
    return
  end
  local param = {}
  param.howToPlayList = self.activityInfoData.howtoplay
  param.defaultTitle = self.activityInfoData.name
  local sRule = Localization:GetString("treasure_map_activity_desc_01", 5, 20, 25, 5)
  param.customRuleStr = sRule
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTreasure.Type)
  if actList and 0 < #actList then
    local actId = tonumber(actList[1].id)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, actId)
  end
end

local function OnBtnGetMoreClick(self)
  local nItemId = DataCenter.DigTreasureManager:GetUseItemId()
  LWResourceLackUtil:GotoGoodsItemLack(nItemId, 1)
end

local function OnBtnShareClick(self)
  DataCenter.DigTreasureManager:GoToShare()
end

local function RefreshAll(self)
  if DataCenter.DigTreasureManager:GetCurMapData() == nil then
    return
  end
  self:RefreshReward()
  self:RefreshMap()
  self:RefreshUseItemNum()
  self:RefreshRewardBoxIcon()
  self:InitAnim()
  self:CheckIsGetAllReward()
  self:SetSelectImg(false)
end

local function RefreshReward(self)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local nCurLevelIndex = -1
  for i = 1, LEVELS_NUM_PER_GROUP do
    local tData = tRewardData[i]
    if not tData then
      break
    end
    local tConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(tData.mapConfigId)
    self.tRewardList[i].textDes:SetLocalText("treasure_map_level_name_01", tConfig.layer)
    if tData.rewardState == DigRewardState.CanNotGet then
      if nCurLevelIndex == -1 then
        nCurLevelIndex = i
      end
      if i ~= LEVELS_NUM_PER_GROUP then
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_yin2"))
      else
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2"))
      end
      self.tRewardList[i].imgGet:SetActive(false)
      self.tRewardList[i].effectCanGet:SetActive(false)
    elseif tData.rewardState == DigRewardState.CanGet then
      if nCurLevelIndex == -1 and i == LEVELS_NUM_PER_GROUP then
        nCurLevelIndex = i
      end
      if i ~= LEVELS_NUM_PER_GROUP then
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_yin2"))
      else
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2"))
      end
      self.tRewardList[i].imgGet:SetActive(false)
      if self.bFirstShowReward then
        self.tRewardList[i].effectCanGet:SetActive(true)
      end
    elseif tData.rewardState == DigRewardState.HaveGot then
      if i ~= LEVELS_NUM_PER_GROUP then
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_yin3"))
      else
        self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin3"))
      end
      self.tRewardList[i].imgGet:SetActive(true)
      self.tRewardList[i].effectCanGet:SetActive(false)
    end
    self.tRewardList[i].imgReward:SetNativeSize()
  end
  self.nCurLevelIndex = nCurLevelIndex
  self.sliderReward:SetValue((nCurLevelIndex - 1) / (LEVELS_NUM_PER_GROUP - 1))
  self.bIsShowFinger = false
  DataCenter.ArrowManager:RemoveFingerArrow()
  self.nCurIntervalTime = 0
  self.bFirstShowReward = false
end

local function Update1000MS(self)
  if self.bShowEndMessageTips then
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nResetTime = DataCenter.DigTreasureManager:GetActivityResetTime()
  local nResetLeftTime = nResetTime - nCurTime
  if nResetLeftTime < 0 then
    self.bShowEndMessageTips = true
    
    local function closeSelf()
      self.view.ctrl:CloseSelf()
    end
    
    UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeSelf, closeSelf, closeSelf, "2900005")
  elseif self.bGetAllReward then
    local sFmtTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, nResetLeftTime))
    self.textResetCountdown:SetLocalText("popUI_desc_003", sFmtTime)
  end
  if self.nCurLevelIndex == 5 and not table.IsNullOrEmpty(self.tRewardList) and not self.bIsShowFinger and not DataCenter.DigTreasureManager:IsHaveTimeLimitMap() and self:IsGroupLastBoxCanGet() then
    self.nCurIntervalTime = self.nCurIntervalTime + 1
    if self.nCurIntervalTime > self.nFingerIntervalTime then
      local param = {}
      param.positionType = PositionType.Screen
      local pos = self.tRewardList[self.nCurLevelIndex].rootObj.transform.position
      param.position = pos + Vector3.New(30, -30, 0)
      DataCenter.ArrowManager:ShowFingerArrow(param)
      self.bIsShowFinger = true
    end
  end
  if not (self.bIsTimeLimitMap and self.nTotalLimitTime) or self.tMapData.rewardState == DigRewardState.Fail then
    return
  end
  if self.tMapData.rewardState == DigRewardState.CanGet and not self.bIsShowFingerTimeLimit then
    self.nCurIntervalTimeLimit = self.nCurIntervalTimeLimit + 1
    if self.nCurIntervalTimeLimit > self.nFingerIntervalTime then
      local param = {}
      param.positionType = PositionType.Screen
      local pos = self.btnTimeLimitReward.transform.position
      param.position = pos + Vector3.New(35, -30, 0)
      DataCenter.ArrowManager:ShowFingerArrow(param)
      self.bIsShowFingerTimeLimit = true
    end
  end
  local bIsNotBegin = self.tMapData.rewardState == DigRewardState.NotBegin
  local nEndTime = self.tMapData.endTime
  local nLeftTime = nEndTime - nCurTime
  if bIsNotBegin then
    self.sliderCountDown:SetValue(1)
    self.textCountDown:SetLocalText("372853")
    return
  elseif nLeftTime < 0 then
    self.sliderCountDown:SetValue(1)
    self.textCountDown:SetLocalText(170009)
    self:RefreshTimelimitMapState()
    return
  end
  local nCurProgress = Mathf.Clamp(nLeftTime / (self.nTotalLimitTime * 1000), 0, 1)
  self.sliderCountDown:SetValue(nCurProgress)
  self.textCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, nLeftTime)))
end

local function RefreshMap(self)
  self.tMapData = DataCenter.DigTreasureManager:GetCurMapData()
  if not self.tMapData then
    Logger.LogError("\230\140\150\229\174\157\229\156\176\229\155\190\230\149\176\230\141\174\228\184\186\231\169\186")
    return
  end
  local tMapCfg = DataCenter.DiggingDataTemplateManager:GetConfigData(self.tMapData.mapConfigId)
  if not tMapCfg then
    Logger.LogError("\230\140\150\229\174\157\229\156\176\229\155\190\233\133\141\231\189\174\232\161\168\228\184\141\229\173\152\229\156\168\239\188\140id = " .. self.tMapData.mapConfigId)
    return
  end
  self.tMapCfg = tMapCfg
  self.bIsTimeLimitMap = DataCenter.DigTreasureManager:IsHaveTimeLimitMap()
  local bNeedHideBrick
  if self.bIsTimeLimitMap then
    bNeedHideBrick = self.tMapData.rewardState == DigRewardState.CanGet
  else
    bNeedHideBrick = self.tMapData.rewardState > 0
  end
  self.DiggingMap:OnRefresh(self.tMapData, bNeedHideBrick)
  if self.bIsTimeLimitMap then
    self.objCountDownArea:SetActive(true)
    self.objRewardArea:SetActive(false)
    self.nTotalLimitTime = tMapCfg.level_limit_time
    self:RefreshTimelimitMapState()
    self:Update1000MS()
  else
    self.objCountDownArea:SetActive(false)
    self.objRewardArea:SetActive(true)
  end
  self:RefreshBlock()
  self:RefreshLayer()
  self:RefreshFireRawImage()
end

local function RefreshUseItemNum(self)
  local nNum = DataCenter.DigTreasureManager:GetUseItemNum()
  self.textItemNum:SetText(nNum)
end

local function OnClickReward(self, i)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local bChangingMap = self.bDuringChangeToLimitMap or self.bDuringChangeToNormalMap
  if bChangingMap or tRewardData[i].rewardState ~= DigRewardState.CanGet then
    self:ShowRewardTip(i)
    return
  end
  if i == LEVELS_NUM_PER_GROUP then
    for j = 1, LEVELS_NUM_PER_GROUP do
      self.tRewardList[j].imgGet:SetActive(true)
      self.tRewardList[j].effectCanGet:SetActive(false)
    end
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.DigTreasureGameGetReward)
    end, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameGetReward)
  end
end

local function OnClickTimeLimitReward(self)
  if not self.bIsTimeLimitMap or self.tMapData.rewardState == DigRewardState.NotBegin then
    return
  end
  local nCurState = self.tMapData.rewardState
  local bIsFailOrCanGet = nCurState == DigRewardState.Fail or nCurState == DigRewardState.CanGet
  if self.tMapData.endTime > UITimeManager:GetInstance():GetServerTime() and not bIsFailOrCanGet then
    return
  end
  self.timeLimitRewardAnimator:Play("UIDigTreasureXianshibaoxiangOpen")
  TimerManager:GetInstance():DelayInvoke(function()
    if self.tMapData then
      SFSNetwork.SendMessage(MsgDefines.DigTreasureGameGetTimeLimitReward, self.tMapData.uuid)
    end
  end)
end

local function ShowHelpList(self, tHelpList)
  self.objHelpRoot:RemoveComponents(DiggingHelpItem)
  self.HelpObj:GameObjectRecycleAll()
  self.tHelpItemList = {}
  if table.IsNullOrEmpty(tHelpList) then
    return
  end
  for i, v in ipairs(tHelpList) do
    TimerManager:GetInstance():DelayInvoke(function()
      if not (self.objHelpRoot and self.tHelpItemList) or self.tHelpItemList[i] ~= nil then
        return
      end
      local helpItem = self.HelpObj:GameObjectSpawn(self.objHelpRoot.transform)
      helpItem.name = string.format("DiggingHelpItem_%d", i)
      helpItem:SetActive(true)
      helpItem = self.objHelpRoot:AddComponent(DiggingHelpItem, helpItem.name)
      helpItem:ReInit(v, "treasure_map_help_tips_01", 2, true)
      helpItem:ShowFadeInEffect()
      self.tHelpItemList[i] = helpItem
    end, i * 0.2)
  end
  SFSNetwork.SendMessage(MsgDefines.DigTreasureReadHelp)
end

local function OnGetHelp(self, tPlayerInfo)
  local t = {}
  table.insert(t, tPlayerInfo)
  self:ShowHelpList(t)
end

local function OnBtnGiveUpClick(self)
  local message = Localization:GetString("treasure_map_special_level_05")
  UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameGiveUp, self.tMapData.uuid)
  end)
end

local function RefreshBlock(self)
  self.objBlockRoot:RemoveComponents(DiggingBlockInfo)
  self.BlockItemObj:GameObjectRecycleAll()
  self.tBlockItemList = {}
  if not self.tMapCfg then
    return
  end
  local nCount = self.tMapCfg.block and #self.tMapCfg.block or 0
  if nCount == 0 then
    return
  end
  for i, blockId in ipairs(self.tMapCfg.block) do
    self:UpdateBlock(blockId, i, DataCenter.DiggingDataManager:GetBlock(blockId, self.tMapData.blockInfo))
  end
end

local function UpdateBlock(self, bid, i, blockInfo)
  local theItem = self.tBlockItemList[i]
  if not theItem then
    theItem = self.BlockItemObj:GameObjectSpawn(self.objBlockRoot.transform)
    theItem.name = string.format("DiggingBlockInfo_%d", i)
    if not self.tMapCfg.block_position then
      theItem:SetActive(false)
      return
    end
    local blockPosInfo = self.tMapCfg.block_position[i]
    theItem.transform.localPosition = Vector3.New(blockPosInfo.x, blockPosInfo.y, 0)
    theItem:SetActive(true)
    theItem = self.objBlockRoot:AddComponent(DiggingBlockInfo, theItem.name)
    theItem:ReInit(i, bid, blockInfo, blockPosInfo)
    self.tBlockItemList[i] = theItem
  end
end

local function OnOpen(self, openData)
  if not openData or not self.tMapData then
    return
  end
  if openData.uuid ~= self.tMapData.uuid then
    return
  end
  if openData.rewardState == DigRewardState.CanGet then
    self.DiggingMap:OpenBrick()
    self:RefreshTimelimitMapState()
  end
end

local function InitAnim(self)
  if DataCenter.DigTreasureManager:IsHaveTimeLimitMap() then
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  elseif self.nCurLevelIndex == -1 or self:IsGroupLastBoxCanGet() then
    self.btnTimeLimitReward:SetActive(false)
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  else
    self.btnTimeLimitReward:SetActive(true)
    self.panelAnimator:Play("UIDigTreasureIn")
  end
end

local function OnUpdateMapData(self)
  if not self.nCurLevelIndex then
    return
  end
  DataCenter.ArrowManager:RemoveFingerArrow()
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  if self.bIsTimeLimitMap then
    self:SetBoxIconNormal()
    self.btnTimeLimitReward:SetActive(false)
    if tRewardData[self.nCurLevelIndex].rewardState == DigRewardState.CanGet then
      self.panelAnimator:Play("UIDigTreasureCaveIdle")
    else
      self.panelAnimator:Play("UIDigTreasureViewChangeBaoxiang")
    end
    self:RefreshMap()
    self:SetSelectImg(false)
  else
    self:SetBoxIconNormal()
    self.btnTimeLimitReward:SetActive(true)
    if DataCenter.DigTreasureManager:IsHaveTimeLimitMap() then
      if self.bDuringChangeToLimitMap then
        return
      end
      self.bDuringChangeToLimitMap = true
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(2)
      self.tweenSeq:AppendCallback(function()
        self.panelAnimator:Play("UIDigTreasureViewChange")
      end)
      self.tweenSeq:AppendInterval(4)
      local nTarget
      if self:IsGroupLastBoxCanGet() then
        nTarget = self.nCurLevelIndex
      else
        nTarget = self.nCurLevelIndex - 1
      end
      self:AddRewardFly(self.tweenSeq, nTarget)
      self:AddFakeChange(self.tweenSeq)
      self.tweenSeq:AppendCallback(function()
        self.bDuringChangeToLimitMap = false
        self:SetBoxIconTimeLimit()
        self:RefreshMap()
      end)
    elseif self.nCurLevelIndex == 1 then
      if self.tweenSeq then
        self.tweenSeq:Kill()
        self.tweenSeq = nil
      end
      self.btnTimeLimitReward:SetActive(false)
      self:RefreshMap()
      self:SetSelectImg(false)
      self.panelAnimator:Play("UIDigTreasureViewChangeBaoxiang")
    else
      self.bDuringChangeToNormalMap = true
      self.tweenSeq = DOTween.Sequence()
      self.tweenSeq:AppendInterval(2)
      self.tweenSeq:AppendCallback(function()
        self.panelAnimator:Play("UIDigTreasureViewChange")
      end)
      self.tweenSeq:AppendInterval(4)
      local nTarget = self.nCurLevelIndex - 1
      self:AddRewardFly(self.tweenSeq, nTarget)
      self.tweenSeq:AppendCallback(function()
        self.btnTimeLimitReward:SetActive(false)
        self.panelAnimator:Play("UIDigTreasureViewChangeBaoxiang")
        self.bDuringChangeToNormalMap = false
        self:RefreshMap()
      end)
    end
  end
end

local function AddFakeChange(self, tweenSeq)
  tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureViewChangeBaoxiang")
  end)
  self.tweenSeq:AppendInterval(0.4)
  tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  end)
end

local function RefreshRewardBoxIcon(self)
  if DataCenter.DigTreasureManager:IsHaveTimeLimitMap() then
    self:SetBoxIconTimeLimit()
  else
    self:SetBoxIconNormal()
  end
end

local function SetBoxIconNormal(self)
  self.timeLimitRewardAnimator.transform.gameObject:SetActive(false)
  self.btnTimeLimitReward:SetActive(true)
  local sIconName
  if self:IsGroupLastBoxCanGet() then
    sIconName = "wxy_S3_xiusai_wabao_box_02"
  else
    sIconName = "wxy_S3_xiusai_wabao_box_01"
  end
  self.imgRewardBox:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, sIconName))
  self.imgRewardFly:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, sIconName))
end

local function SetBoxIconTimeLimit(self)
  self.timeLimitRewardAnimator.transform.gameObject:SetActive(true)
  self.timeLimitRewardAnimator:Play("UIDigTreasureXianshibaoxiangIdle")
  self.btnTimeLimitReward:SetActive(false)
end

local function OnBtnResetMaskClick(self)
end

local function CheckIsGetAllReward(self)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local bGetAllNormalReward = true
  for i = 1, #tRewardData do
    if tRewardData[i].rewardState ~= DigRewardState.HaveGot then
      bGetAllNormalReward = false
      break
    end
  end
  local bHaveTimeLimitMap = DataCenter.DigTreasureManager:IsHaveTimeLimitMap()
  self.bGetAllReward = bGetAllNormalReward and not bHaveTimeLimitMap
  if self.bGetAllReward then
    self:Update1000MS()
    self.btnResetMask:SetActive(true)
  else
    self.btnResetMask:SetActive(false)
  end
  self.bIsShowFingerTimeLimit = false
end

local function RefreshLayer(self)
  local nCurLayer = DataCenter.DigTreasureManager:GetCurLayer()
  local nMaxLayer = DataCenter.DigTreasureManager:GetMaxLayer()
  local sTitle = Localization:GetString("treasure_map_activity_name_01")
  local sText = string.format("%s (%s/%s)", sTitle, nCurLayer, nMaxLayer)
  self.textTitle:SetText(sText)
end

local function SetSelectImg(self, bPlayAnim)
  if not bPlayAnim then
    local nStartPosX = CommonUtil.IsArabicAutoMirrorOpen() and 311 or -311
    local nDeltaX = CommonUtil.IsArabicAutoMirrorOpen() and -154 or 154
    self.nCurSelectIndex = self.nCurLevelIndex
    self.objRewardSelect.transform:Set_localPosition(nStartPosX + (self.nCurSelectIndex - 1) * nDeltaX, 4, 0)
    return
  end
end

local function OnCanGetReward(self)
  if DataCenter.DigTreasureManager:IsHaveTimeLimitMap() then
    return
  end
  if self.nCurLevelIndex ~= 5 then
    return
  end
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  if tRewardData[self.nCurLevelIndex].rewardState ~= DigRewardState.CanGet then
    return
  end
  self.btnTimeLimitReward:SetActive(true)
  self.imgRewardBox:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "wxy_S3_xiusai_wabao_box_02"))
  self.imgRewardFly:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "wxy_S3_xiusai_wabao_box_02"))
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(2)
  self.tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureViewChange")
  end)
  self.tweenSeq:AppendInterval(4)
  local nTarget = LEVELS_NUM_PER_GROUP
  self:AddRewardFly(self.tweenSeq, nTarget)
  self.tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  end)
end

local function AddRewardFly(self, tweenSeq, nTarget)
  tweenSeq:AppendCallback(function()
    self.btnTimeLimitReward:SetActive(false)
    self.fly.transform.gameObject:SetActive(true)
    self.fly.transform.position = self.btnTimeLimitReward.transform.position
    self.fly.transform.localScale = Vector3.New(1, 1, 1)
    self.fly:DoParabolaAnim(self.tRewardList[nTarget].rootObj.transform.position, self.fly.transform.position, function()
      if not self.tMapData then
        return
      end
      self.fly.transform.gameObject:SetActive(false)
      self.tRewardList[nTarget].effectFlyFinish:Replay()
      self.tRewardList[nTarget].effectCanGet:SetActive(true)
    end)
  end)
  tweenSeq:AppendInterval(0.5)
  tweenSeq:Append(self.fly.transform:DOScale(Vector3.New(0.3, 0.3, 0.3), 0.5))
  tweenSeq:AppendInterval(0.2)
  local nStartPosX = CommonUtil.IsArabicAutoMirrorOpen() and 311 or -311
  local nDeltaX = CommonUtil.IsArabicAutoMirrorOpen() and -154 or 154
  tweenSeq:Append(self.objRewardSelect.transform:DOLocalMoveX(nStartPosX + (self.nCurLevelIndex - 1) * nDeltaX, 0.5))
end

local function RefreshTimelimitMapState(self)
  if not self.bIsTimeLimitMap then
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local bIsEnd = nCurTime > self.tMapData.endTime
  if self.tMapData.rewardState == DigRewardState.Fail or bIsEnd and self.tMapData.rewardState == DigRewardState.CanNotGet then
    self.btnBackMask.transform.gameObject:SetActive(true)
    self.objFinishState:SetActive(true)
    self.objUnFinishState:SetActive(false)
    self.textFinishDes:SetLocalText("treasure_map_special_level_10")
    DataCenter.DigTreasureManager:ShowTimeLimitMapRewardWhenFail()
  elseif self.tMapData.rewardState == DigRewardState.CanGet then
    self.btnBackMask.transform.gameObject:SetActive(false)
    self.objFinishState:SetActive(true)
    self.objUnFinishState:SetActive(false)
    self.textFinishDes:SetLocalText("treasure_map_special_level_09")
  else
    self.btnBackMask.transform.gameObject:SetActive(false)
    self.objFinishState:SetActive(false)
    self.objUnFinishState:SetActive(true)
  end
  self:SetBoxIconTimeLimit()
end

local function OnBtnBackMaskClick(self)
  SFSNetwork.SendMessage(MsgDefines.DigTreasureVerifyFail, self.tMapData.uuid)
  self.btnBackMask.transform.gameObject:SetActive(false)
end

local function OnGetBlockAnim(self, param)
  if not (self.bIsTimeLimitMap and param and param.blockInfo) or not param.blockInfo.get then
    return
  end
  if param.fly and param.fly.transform then
    self.tweenSeqLimitMap = DOTween.Sequence()
    self.tweenSeqLimitMap:AppendCallback(function()
      param.fly:SetActive(true)
    end)
    self.tweenSeqLimitMap:AppendInterval(0.5)
    self.tweenSeqLimitMap:Append(param.fly.transform:DOMove(self.imgRewardBox.transform.position, 0.6)):SetEase(CS.DG.Tweening.Ease.Linear)
    self.tweenSeqLimitMap:Join(param.fly.transform:DOScale(Vector3.New(1, 1, 1), 0.6))
    self.tweenSeqLimitMap:AppendCallback(function()
      param.fly:SetActive(false)
    end)
  end
end

local function ShowRewardTip(self, nIndex)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local nConfigId = tRewardData[nIndex].mapConfigId
  local tConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(nConfigId)
  local sReward = tConfig.reward
  local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
  param.position = self.tRewardList[nIndex].rootObj:GetPosition()
  if nIndex == 1 or nIndex == 2 then
    param.dir = CommonUtil.IsArabicAutoMirrorOpen() and UIPersonalArmsRewardTipView.Direction.RIGHT or UIPersonalArmsRewardTipView.Direction.LEFT
  else
    param.dir = CommonUtil.IsArabicAutoMirrorOpen() and UIPersonalArmsRewardTipView.Direction.LEFT or UIPersonalArmsRewardTipView.Direction.RIGHT
  end
  param.rewardList = DataCenter.RewardTemplateManager:GetList(sReward)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
end

local function RefreshFireRawImage(self)
  local bIsLast = self.nCurLevelIndex == LEVELS_NUM_PER_GROUP
  local sRawImageName = bIsLast and "FX_S3_xiusaiqi_jidongduiwabao_02_banner" or "FX_S3_xiusaiqi_jidongduiwabao_01_banner"
  local tPos1 = {}
  local tPos2 = {}
  if CommonUtil.IsArabicAutoMirrorOpen() then
    tPos1 = bIsLast and {x = 254, y = 300} or {x = 304, y = 347}
    tPos2 = bIsLast and {x = -261, y = 300} or {x = -312, y = 347}
  else
    tPos1 = bIsLast and {x = -254, y = 300} or {x = -304, y = 347}
    tPos2 = bIsLast and {x = 261, y = 300} or {x = 312, y = 347}
  end
  self.rawImgFire1:LoadSprite(string.format(LoadPath.UIDigTreasureTexturePath, sRawImageName))
  self.rawImgFire1:SetNativeSize()
  self.rawImgFire2:LoadSprite(string.format(LoadPath.UIDigTreasureTexturePath, sRawImageName))
  self.rawImgFire2:SetNativeSize()
  self.rawImgFire1.transform:Set_localPosition(tPos1.x, tPos1.y, 0)
  self.rawImgFire2.transform:Set_localPosition(tPos2.x, tPos2.y, 0)
end

local function IsGroupLastBoxCanGet(self)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local bCanGet = false
  if self.nCurLevelIndex == LEVELS_NUM_PER_GROUP and tRewardData[self.nCurLevelIndex].rewardState == DigRewardState.CanGet then
    bCanGet = true
  else
    bCanGet = false
  end
  return bCanGet
end

local function CheckNeedBeginMap(self)
  if self.bIsTimeLimitMap and self.tMapData.rewardState == DigRewardState.NotBegin then
    DataCenter.DigTreasureManager:ShowBeginTimeLimitMapWindow()
  end
end

local function OnBeginTimeLimitMap(self)
  self.tMapData = DataCenter.DigTreasureManager:GetCurMapData()
  local sPath = string.format(LoadPath.UIDigTreasureSpritePath, "FX_S3_xiusaiqi_jidongduiwabao_chuizi_icon")
  UIUtil.DoFlyCustom(sPath, nil, 5, self.DiggingMap.transform.position, self.imgUseItem.transform.position)
end

local function OnBtnExchangeClick(self)
  local tExchangeInfo = DataCenter.DigTreasureManager:GetExchangeInfo()
  local nUseItemNum = DataCenter.DigTreasureManager:GetUseItemNum()
  local nMinNeedCount = tExchangeInfo[1].nCount
  if nUseItemNum < nMinNeedCount then
    UIUtil.ShowTips(Localization:GetString("treasure_map_exchange_05", nMinNeedCount))
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHammerExchange)
end

local function OnGetReward(self)
  self.DiggingMap:FlyAllReward(self.objRewardEnter.transform.position)
end

local function OnOpenRewardBlock(self, param)
  local nPos = param.pos
  local rewards = param.reward
  local transBlock = self.DiggingMap:GetBlockIconTrans(nPos)
  if IsNull(transBlock) then
    return
  end
  local startPos = transBlock.position
  TimerManager:GetInstance():DelayInvoke(function()
    if not self.tMapData then
      return
    end
    self:PlayFlyRewardToBag(rewards, startPos)
  end, 1)
end

local function PlayFlyRewardToBag(self, rewards, startPos)
  local list = DataCenter.RewardManager:ReturnRewardParamForMessage(rewards) or {}
  for i, reward in pairs(list) do
    local pic = RewardUtil.GetPic(reward.rewardType, reward.itemId)
    UIUtil.DoFly(reward.rewardType, 1, pic, startPos, self.objRewardEnter.transform.position)
  end
end

UIDigTreasureView.OnCreate = OnCreate
UIDigTreasureView.OnDestroy = OnDestroy
UIDigTreasureView.OnEnable = OnEnable
UIDigTreasureView.OnDisable = OnDisable
UIDigTreasureView.ComponentDefine = ComponentDefine
UIDigTreasureView.ComponentDestroy = ComponentDestroy
UIDigTreasureView.DataDefine = DataDefine
UIDigTreasureView.DataDestroy = DataDestroy
UIDigTreasureView.OnAddListener = OnAddListener
UIDigTreasureView.OnRemoveListener = OnRemoveListener
UIDigTreasureView.OnBtnInfoClick = OnBtnInfoClick
UIDigTreasureView.OnBtnCloseClick = OnBtnCloseClick
UIDigTreasureView.OnBtnGetMoreClick = OnBtnGetMoreClick
UIDigTreasureView.OnBtnShareClick = OnBtnShareClick
UIDigTreasureView.RefreshReward = RefreshReward
UIDigTreasureView.RefreshMap = RefreshMap
UIDigTreasureView.OnClickReward = OnClickReward
UIDigTreasureView.RefreshUseItemNum = RefreshUseItemNum
UIDigTreasureView.RefreshAll = RefreshAll
UIDigTreasureView.ShowHelpList = ShowHelpList
UIDigTreasureView.Update1000MS = Update1000MS
UIDigTreasureView.OnClickTimeLimitReward = OnClickTimeLimitReward
UIDigTreasureView.OnGetHelp = OnGetHelp
UIDigTreasureView.OnBtnGiveUpClick = OnBtnGiveUpClick
UIDigTreasureView.RefreshBlock = RefreshBlock
UIDigTreasureView.UpdateBlock = UpdateBlock
UIDigTreasureView.OnOpen = OnOpen
UIDigTreasureView.InitAnim = InitAnim
UIDigTreasureView.OnUpdateMapData = OnUpdateMapData
UIDigTreasureView.RefreshRewardBoxIcon = RefreshRewardBoxIcon
UIDigTreasureView.OnBtnResetMaskClick = OnBtnResetMaskClick
UIDigTreasureView.CheckIsGetAllReward = CheckIsGetAllReward
UIDigTreasureView.RefreshLayer = RefreshLayer
UIDigTreasureView.SetSelectImg = SetSelectImg
UIDigTreasureView.OnCanGetReward = OnCanGetReward
UIDigTreasureView.RefreshTimelimitMapState = RefreshTimelimitMapState
UIDigTreasureView.OnBtnBackMaskClick = OnBtnBackMaskClick
UIDigTreasureView.OnGetBlockAnim = OnGetBlockAnim
UIDigTreasureView.ShowRewardTip = ShowRewardTip
UIDigTreasureView.RefreshFireRawImage = RefreshFireRawImage
UIDigTreasureView.SetBoxIconNormal = SetBoxIconNormal
UIDigTreasureView.SetBoxIconTimeLimit = SetBoxIconTimeLimit
UIDigTreasureView.AddRewardFly = AddRewardFly
UIDigTreasureView.AddFakeChange = AddFakeChange
UIDigTreasureView.IsGroupLastBoxCanGet = IsGroupLastBoxCanGet
UIDigTreasureView.ShowHowToPlay = ShowHowToPlay
UIDigTreasureView.OnBtnPreviewClick = OnBtnPreviewClick
UIDigTreasureView.CheckNeedBeginMap = CheckNeedBeginMap
UIDigTreasureView.OnBeginTimeLimitMap = OnBeginTimeLimitMap
UIDigTreasureView.OnBtnExchangeClick = OnBtnExchangeClick
UIDigTreasureView.OnOpenRewardBlock = OnOpenRewardBlock
UIDigTreasureView.OnGetReward = OnGetReward
UIDigTreasureView.PlayFlyRewardToBag = PlayFlyRewardToBag
return UIDigTreasureView
