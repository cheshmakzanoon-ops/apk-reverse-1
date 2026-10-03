local UIMonopolyDigTreasureView = BaseClass("UIMonopolyDigTreasureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DiggingMap = require("UI.DigMap.Monopoly.Component.DigMapMonopoly")
local DiggingBlockInfo = require("UI.DigTreasure.Component.DiggingMap.DigTreasureBlockInfo")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local LEVELS_NUM_PER_GROUP = 5

local function OnCreate(self)
  base.OnCreate(self)
  self.tMapData = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.ArrowManager:RemoveFingerArrow()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshAll()
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
  self.objCountDownArea = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea")
  self.sliderCountDown = self:AddComponent(UISlider, "safeArea/Root/CountDownArea/UnFinishState/Slider")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDown")
  self.textCountDownDes1 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes1")
  self.textCountDownDes2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes2")
  self.textItemNum = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/UseItemTop/ItemNumText")
  self.objDigTreasureBlockInfo = self:AddComponent(UIBaseContainer, "safeArea/Root/Top/Door/bg2/bgBlock/DigTreasureBlockInfo")
  self.objBlockRoot = self:AddComponent(UIBaseContainer, "safeArea/Root/Top/Door/bg2/bgBlock")
  self.btnGiveUp = self:AddComponent(UIButton, "safeArea/Root/Bottom/btnGiveUp")
  self.btnGiveUp:SetOnClick(function()
    self:OnBtnGiveUpClick()
  end)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/Title")
  self.textGiveUp = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/Bottom/btnGiveUp/Text")
  self.panelAnimator = self:AddComponent(UIAnimator, "")
  self.imgRewardBox = self:AddComponent(UIImage, "safeArea/Root/Top/Cave/RewardObj/Image")
  self.btnResetMask = self:AddComponent(UIButton, "resetMask")
  self.btnResetMask:SetOnClick(function()
    self:OnBtnResetMaskClick()
  end)
  self.textResetCountdown = self:AddComponent(UITextMeshProUGUIEx, "resetMask/textResetCountdown")
  self.objFinishState = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea/FinishState")
  self.objUnFinishState = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea/UnFinishState")
  self.textFinishDes = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/FinishState/finishDes")
  self.btnBackMask = self:AddComponent(UIButton, "safeArea/Root/backMask")
  self.btnBackMask:SetOnClick(function()
    self:OnBtnBackMaskClick()
  end)
  self.textResetCountdown2 = self:AddComponent(UITextMeshProUGUIEx, "resetMask/textResetCountdown2")
  self.timeLimitRewardAnimator = self:AddComponent(UIAnimator, "safeArea/Root/Top/Cave/RewardObj/Image_xianshi")
  self.btnImageXianshi1 = self:AddComponent(UIButton, "safeArea/Root/Top/Cave/RewardObj/Image_xianshi/Image_xianshi1")
  self.btnImageXianshi1:SetOnClick(function()
    self:OnBtnImageXianshi1Click()
  end)
  self.rawImgFire1 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg3")
  self.rawImgFire2 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg4")
  self.btnPreview = self:AddComponent(UIButton, "safeArea/Root/PreviewBtn")
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
  self.textTitle:SetLocalText("dig_game_activity_name_01")
  self.textCountDownDes1:SetLocalText("treasure_map_special_level_03")
  self.textCountDownDes2:SetLocalText("monopoly_dig_level_title_01")
  self.textGiveUp:SetLocalText("110075")
  self.textResetCountdown2:SetLocalText("treasure_map_level_end_01")
  self.btnTimeLimitReward = self:AddComponent(UIButton, "safeArea/Root/Top/Cave/RewardObj/Image")
  self.DiggingMap = self:AddComponent(DiggingMap, "safeArea/Root/DigMap")
  self.BlockItemObj = self.objDigTreasureBlockInfo.gameObject
  self.BlockItemObj:GameObjectCreatePool()
  self.BlockItemObj:SetActive(false)
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
  self.objBlockRoot:RemoveComponents(DiggingBlockInfo)
  self.BlockItemObj:GameObjectRecycleAll()
  self.btnInfo = nil
  self.btnClose = nil
  self.btnGetMore = nil
  self.btnShare = nil
  self.objCountDownArea = nil
  self.sliderCountDown = nil
  self.textCountDown = nil
  self.textCountDownDes1 = nil
  self.textCountDownDes2 = nil
  self.textItemNum = nil
  self.objDigTreasureBlockInfo = nil
  self.objBlockRoot = nil
  self.btnGiveUp = nil
  self.textTitle = nil
  self.textGiveUp = nil
  self.panelAnimator = nil
  self.imgRewardBox = nil
  self.btnResetMask = nil
  self.textResetCountdown = nil
  self.objFinishState = nil
  self.objUnFinishState = nil
  self.textFinishDes = nil
  self.btnBackMask = nil
  self.textResetCountdown2 = nil
  self.timeLimitRewardAnimator = nil
  self.btnImageXianshi1 = nil
  self.rawImgFire1 = nil
  self.rawImgFire2 = nil
  self.btnPreview = nil
end

local function DataDefine(self)
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
  self.delayTimer = nil
end

local function DataDestroy(self)
  self.tMapData = nil
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
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
    DataCenter.MonopolyDigTreasureManager:UnlockMonopoly()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:AddUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  self:AddUIListener(EventId.MonopolyDigGameFail, self.OnGameFail)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.DiggingGameOpen, self.OnOpen)
  self:RemoveUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  self:RemoveUIListener(EventId.MonopolyDigGameFail, self.OnGameFail)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  local param = {}
  param.activityRulesStr = Localization:GetString("monopoly_dig_level_rules_01")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
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
  UIUtil.ShowMessage(Localization:GetString("monopoly_dig_level_tips_04"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:CloseSelf()
  end, function()
  end)
end

local function OnBtnGetMoreClick(self)
  local nItemId = DataCenter.DigTreasureManager:GetUseItemId()
  LWResourceLackUtil:GotoGoodsItemLack(nItemId, 1)
end

local function RefreshAll(self)
  if self.tMapData == nil then
    return
  end
  self:RefreshMap()
  self:InitAnim()
  self:RefreshUseItemNum()
end

local function Update1000MS(self)
  if self.bShowEndMessageTips or self.tMapData.rewardState == DigRewardState.CanGet then
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nEndTime = self.tMapData.endTime
  local nLeftTime = nEndTime - nCurTime
  if nLeftTime < 0 then
    self.sliderCountDown:SetValue(1)
    self.textCountDown:SetLocalText(170009)
    self.bShowEndMessageTips = true
    
    local function closeSelf()
      self.view.ctrl:CloseSelf()
    end
    
    UIUtil.ShowMessage(Localization:GetString("monopoly_dig_level_tips_01"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeSelf, closeSelf, closeSelf, "2900005")
    return
  end
  local nCurProgress = Mathf.Clamp(nLeftTime / (self.nTotalLimitTime * 1000), 0, 1)
  self.sliderCountDown:SetValue(nCurProgress)
  self.textCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, nLeftTime)))
end

local function RefreshMap(self)
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
  self.DiggingMap:OnRefresh(self.tMapData)
  self.objCountDownArea:SetActive(true)
  self.nTotalLimitTime = tMapCfg.level_limit_time
  self:Update1000MS()
  self:RefreshBlock()
  self:RefreshFireRawImage()
end

local function RefreshUseItemNum(self)
  self.textItemNum:SetText(DataCenter.MonopolyDigTreasureManager:GetUseItemNum())
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
  if not openData then
    return
  end
  self:RefreshUseItemNum()
  if openData.rewardState == DigRewardState.CanGet then
    self.DiggingMap:OpenBrick()
  end
end

local function InitAnim(self)
  self.panelAnimator:Play("UIDigTreasureIn")
end

local function OnCanGetReward(self)
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.MonopolyDigTreasureManager:UnlockMonopoly()
  end, 7)
  self.btnTimeLimitReward:SetActive(true)
  self.timeLimitRewardAnimator:Play("UIDigTreasureXianshibaoxiangIdle")
  self.imgRewardBox:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "wxy_S3_xiusai_wabao_box_02"))
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(2)
  self.tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureViewChange")
  end)
  self.tweenSeq:AppendInterval(4)
  self.tweenSeq:AppendCallback(function()
    self.timeLimitRewardAnimator:Play("UIDigTreasureXianshibaoxiangOpen")
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  end)
end

local function ShowRewardTip(self, nIndex)
  local tRewardData = DataCenter.DigTreasureManager:GetRewardData()
  local nConfigId = tRewardData[nIndex].mapConfigId
  local tConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(nConfigId)
  local sReward = tConfig.reward
  local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
  param.position = self.transform.position
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

local function OnRewardGetPanelClose(self)
  self.ctrl:CloseSelf()
end

local function OnGameFail(self)
  if self.bShowEndMessageTips then
    return
  end
  self.bShowEndMessageTips = true
  UIUtil.ShowMessage(Localization:GetString("monopoly_dig_level_tips_02"), 1, GameDialogDefine.CONFIRM, nil, function()
    self.ctrl:CloseSelf()
  end, nil, function()
    self.ctrl:CloseSelf()
  end)
end

UIMonopolyDigTreasureView.OnCreate = OnCreate
UIMonopolyDigTreasureView.OnDestroy = OnDestroy
UIMonopolyDigTreasureView.OnEnable = OnEnable
UIMonopolyDigTreasureView.OnDisable = OnDisable
UIMonopolyDigTreasureView.ComponentDefine = ComponentDefine
UIMonopolyDigTreasureView.ComponentDestroy = ComponentDestroy
UIMonopolyDigTreasureView.DataDefine = DataDefine
UIMonopolyDigTreasureView.DataDestroy = DataDestroy
UIMonopolyDigTreasureView.OnAddListener = OnAddListener
UIMonopolyDigTreasureView.OnRemoveListener = OnRemoveListener
UIMonopolyDigTreasureView.OnBtnInfoClick = OnBtnInfoClick
UIMonopolyDigTreasureView.OnBtnCloseClick = OnBtnCloseClick
UIMonopolyDigTreasureView.OnBtnGetMoreClick = OnBtnGetMoreClick
UIMonopolyDigTreasureView.RefreshMap = RefreshMap
UIMonopolyDigTreasureView.RefreshUseItemNum = RefreshUseItemNum
UIMonopolyDigTreasureView.RefreshAll = RefreshAll
UIMonopolyDigTreasureView.Update1000MS = Update1000MS
UIMonopolyDigTreasureView.RefreshBlock = RefreshBlock
UIMonopolyDigTreasureView.UpdateBlock = UpdateBlock
UIMonopolyDigTreasureView.OnOpen = OnOpen
UIMonopolyDigTreasureView.InitAnim = InitAnim
UIMonopolyDigTreasureView.OnCanGetReward = OnCanGetReward
UIMonopolyDigTreasureView.ShowRewardTip = ShowRewardTip
UIMonopolyDigTreasureView.RefreshFireRawImage = RefreshFireRawImage
UIMonopolyDigTreasureView.ShowHowToPlay = ShowHowToPlay
UIMonopolyDigTreasureView.OnBtnPreviewClick = OnBtnPreviewClick
UIMonopolyDigTreasureView.OnRewardGetPanelClose = OnRewardGetPanelClose
UIMonopolyDigTreasureView.OnGameFail = OnGameFail
return UIMonopolyDigTreasureView
