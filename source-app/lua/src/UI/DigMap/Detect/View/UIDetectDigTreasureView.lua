local UIDetectDigTreasureView = BaseClass("UIDetectDigTreasureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DiggingMap = require("UI.DigMap.Detect.Component.DigMapDetect")
local DiggingBlockInfo = require("UI.DigTreasure.Component.DiggingMap.DigTreasureBlockInfo")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local LEVELS_NUM_PER_GROUP = 1

local function OnCreate(self)
  base.OnCreate(self)
  local data = self:GetUserData()
  self.tDetectData = data
  self.tMapData = data.digGameInfo
  DataCenter.DetectDigTreasureManager:SetCurData(data)
  self:ComponentDefine()
  self:DataDefine()
  self:CheckCanGetFreeHammer()
  self:CheckNeedShowDigGuide()
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
  self.objRewardArea = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea")
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
  self.objRewardFly = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/rewardFly")
  self.imgRewardBox = self:AddComponent(UIImage, "safeArea/Root/Top/Cave/RewardObj/Image")
  self.imgRewardFly = self:AddComponent(UIImage, "safeArea/Root/RewardArea/rewardFly")
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
  self.objRewardSelect = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea/imgSelect_animation")
  self.textResetCountdown2 = self:AddComponent(UITextMeshProUGUIEx, "resetMask/textResetCountdown2")
  self.rawImgFire1 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg3")
  self.rawImgFire2 = self:AddComponent(UIRawImage, "safeArea/Root/Top/Door/bg4")
  self.btnPreview = self:AddComponent(UIButton, "safeArea/Root/PreviewBtn")
  self.btnPreview:SetOnClick(function()
    self:OnBtnPreviewClick()
  end)
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/Top/textDesc")
  self.imgUseItem = self:AddComponent(UIImage, "safeArea/Root/UseItemTop/ItemImg")
  if self:IsRewardCanGet() then
    self.textDesc:SetLocalText("detect_dig_level_tips_01")
  else
    self.textDesc:SetLocalText("detect_dig_level_title_01")
  end
  self.textTitle:SetLocalText("dig_game_activity_name_01")
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
  self.objRewardArea = nil
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
  self.rawImgFire1 = nil
  self.rawImgFire2 = nil
  self.btnPreview = nil
  self.textDesc = nil
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
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshUseItemNum)
  self:AddUIListener(EventId.DigTreasureUpdateRewardData, self.RefreshReward)
  self:AddUIListener(EventId.DetectDigGameOpen, self.OnOpen)
  self:AddUIListener(EventId.DetectDigGameCanGetReward, self.OnCanGetReward)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  self:AddUIListener(EventId.OnGetFreeHammer, self.OnGetFreeHammer)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshUseItemNum)
  self:RemoveUIListener(EventId.DigTreasureUpdateRewardData, self.RefreshReward)
  self:RemoveUIListener(EventId.DetectDigGameOpen, self.OnOpen)
  self:RemoveUIListener(EventId.DetectDigGameCanGetReward, self.OnCanGetReward)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnRewardGetPanelClose)
  self:RemoveUIListener(EventId.OnGetFreeHammer, self.OnGetFreeHammer)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  local param = {}
  param.activityRulesStr = Localization:GetString("detect_dig_level_rules_01")
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
  self.ctrl:CloseSelf()
end

local function OnBtnGetMoreClick(self)
  local nItemId = DataCenter.DetectDigTreasureManager:GetUseItemId()
  LWResourceLackUtil:GotoGoodsItemLack(nItemId, 1)
end

local function RefreshAll(self)
  if self.tMapData == nil then
    return
  end
  self:RefreshReward()
  self:RefreshMap()
  self:RefreshUseItemNum()
  self:RefreshRewardBoxIcon()
  self:InitAnim()
end

local function RefreshReward(self)
  for i = 1, LEVELS_NUM_PER_GROUP do
    self.tRewardList[i].textDes:SetLocalText("treasure_map_level_name_01", 1)
    if self.tMapData.rewardState == DigRewardState.CanNotGet or self.tMapData.rewardState == DigRewardState.NotBegin then
      self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2"))
      self.tRewardList[i].imgGet:SetActive(false)
      self.tRewardList[i].effectCanGet:SetActive(false)
    elseif self.tMapData.rewardState == DigRewardState.CanGet then
      self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin2"))
      self.tRewardList[i].imgGet:SetActive(false)
      if self.bFirstShowReward then
        self.tRewardList[i].effectCanGet:SetActive(true)
      end
    elseif self.tMapData.rewardState == DigRewardState.HaveGot then
      self.tRewardList[i].imgReward:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "lyt_S3_xiusaiqi_jidongduiwabao_baoxiang_jin3"))
      self.tRewardList[i].imgGet:SetActive(true)
      self.tRewardList[i].effectCanGet:SetActive(false)
    end
    self.tRewardList[i].imgReward:SetNativeSize()
  end
  self.nCurLevelIndex = 1
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
  local nEndTime = self.tDetectData.endTime
  local nLeftTime = nEndTime - nCurTime
  if nLeftTime < 0 then
    self.bShowEndMessageTips = true
    
    local function closeSelf()
      self.view.ctrl:CloseSelf()
    end
    
    UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeSelf, closeSelf, closeSelf, "2900005")
  end
  if self.nCurLevelIndex == 1 and not table.IsNullOrEmpty(self.tRewardList) and not self.bIsShowFinger and self:IsRewardCanGet() then
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
  self.DiggingMap:OnRefresh(self.tMapData, self.tMapData.rewardState > 0 and self.tMapData.rewardState ~= DigRewardState.NotBegin)
  self.objCountDownArea:SetActive(false)
  self.objRewardArea:SetActive(true)
  self.btnGiveUp:SetActive(false)
  self:RefreshBlock()
  self:RefreshFireRawImage()
end

local function RefreshUseItemNum(self)
  local nNum = DataCenter.DetectDigTreasureManager:GetUseItemNum()
  self.textItemNum:SetText(nNum)
end

local function OnClickReward(self, i)
  local bCanGet = self:IsRewardCanGet()
  if not bCanGet then
    self:ShowRewardTip(i)
    return
  end
  self.bIsShowFinger = true
  DataCenter.ArrowManager:RemoveFingerArrow()
  DataCenter.DetectDigTreasureManager:GetReward()
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
  if openData.uuid ~= self.tMapData.uuid then
    return
  end
  if DataCenter.DetectDigTreasureManager:CheckIsShowGuide() then
    DataCenter.ArrowManager:RemoveFingerArrow()
  end
  if openData.rewardState == DigRewardState.CanGet then
    self.DiggingMap:OpenBrick()
  end
end

local function InitAnim(self)
  if not self.tMapData then
    return
  end
  self.btnTimeLimitReward:SetActive(false)
  if self:IsRewardCanGet() then
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  else
    self.panelAnimator:Play("UIDigTreasureIn")
  end
end

local function RefreshRewardBoxIcon(self)
  self:SetBoxIconNormal()
end

local function SetBoxIconNormal(self)
  self.btnTimeLimitReward:SetActive(true)
  local sIconName
  if self:IsRewardCanGet() then
    sIconName = "wxy_S3_xiusai_wabao_box_02"
  else
    sIconName = "wxy_S3_xiusai_wabao_box_01"
  end
  self.imgRewardBox:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, sIconName))
  self.imgRewardFly:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, sIconName))
end

local function OnRewardGetPanelClose(self)
  if self.tMapData.rewardState == DigRewardState.HaveGot then
    self.ctrl.CloseSelf()
  end
end

local function OnCanGetReward(self)
  self.tMapData.rewardState = DigRewardState.CanGet
  self.btnTimeLimitReward:SetActive(true)
  self.imgRewardBox:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "wxy_S3_xiusai_wabao_box_02"))
  self.imgRewardFly:LoadSprite(string.format(LoadPath.UIDigTreasureSpritePath, "wxy_S3_xiusai_wabao_box_02"))
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(2)
  self.tweenSeq:AppendCallback(function()
    self.panelAnimator:Play("UIDigTreasureViewChange")
    self.textDesc:SetText("")
  end)
  self.tweenSeq:AppendInterval(4)
  local nTarget = 1
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
      self.textDesc:SetLocalText("detect_dig_level_tips_01")
    end)
  end)
  tweenSeq:AppendInterval(0.5)
  tweenSeq:Append(self.fly.transform:DOScale(Vector3.New(0.3, 0.3, 0.3), 0.5))
  tweenSeq:AppendInterval(0.2)
end

local function ShowRewardTip(self, nIndex)
  local nConfigId = self.tMapData.mapConfigId
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

local function IsRewardCanGet(self)
  return self.tMapData.rewardState == DigRewardState.CanGet
end

local function CheckCanGetFreeHammer(self)
  if self.tMapData.rewardState == DigRewardState.NotBegin then
    DataCenter.DetectDigTreasureManager:ReceiveFreeHammer()
  end
end

local function OnGetFreeHammer(self)
  local sPath = string.format(LoadPath.UIDigTreasureSpritePath, "FX_S3_xiusaiqi_jidongduiwabao_chuizi_icon")
  UIUtil.DoFlyCustom(sPath, nil, 5, self.DiggingMap.transform.position, self.imgUseItem.transform.position)
end

local function CheckNeedShowDigGuide(self)
  if DataCenter.DetectDigTreasureManager:CheckIsShowGuide() then
    return
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if not self.tMapData then
      return
    end
    local param = {}
    param.positionType = PositionType.Screen
    local pos = self.DiggingMap.transform.position
    param.position = pos
    DataCenter.ArrowManager:ShowFingerArrow(param)
  end, 1)
end

UIDetectDigTreasureView.OnCreate = OnCreate
UIDetectDigTreasureView.OnDestroy = OnDestroy
UIDetectDigTreasureView.OnEnable = OnEnable
UIDetectDigTreasureView.OnDisable = OnDisable
UIDetectDigTreasureView.ComponentDefine = ComponentDefine
UIDetectDigTreasureView.ComponentDestroy = ComponentDestroy
UIDetectDigTreasureView.DataDefine = DataDefine
UIDetectDigTreasureView.DataDestroy = DataDestroy
UIDetectDigTreasureView.OnAddListener = OnAddListener
UIDetectDigTreasureView.OnRemoveListener = OnRemoveListener
UIDetectDigTreasureView.OnBtnInfoClick = OnBtnInfoClick
UIDetectDigTreasureView.OnBtnCloseClick = OnBtnCloseClick
UIDetectDigTreasureView.OnBtnGetMoreClick = OnBtnGetMoreClick
UIDetectDigTreasureView.RefreshReward = RefreshReward
UIDetectDigTreasureView.RefreshMap = RefreshMap
UIDetectDigTreasureView.OnClickReward = OnClickReward
UIDetectDigTreasureView.RefreshUseItemNum = RefreshUseItemNum
UIDetectDigTreasureView.RefreshAll = RefreshAll
UIDetectDigTreasureView.RefreshBlock = RefreshBlock
UIDetectDigTreasureView.UpdateBlock = UpdateBlock
UIDetectDigTreasureView.OnOpen = OnOpen
UIDetectDigTreasureView.InitAnim = InitAnim
UIDetectDigTreasureView.RefreshRewardBoxIcon = RefreshRewardBoxIcon
UIDetectDigTreasureView.OnRewardGetPanelClose = OnRewardGetPanelClose
UIDetectDigTreasureView.OnCanGetReward = OnCanGetReward
UIDetectDigTreasureView.ShowRewardTip = ShowRewardTip
UIDetectDigTreasureView.RefreshFireRawImage = RefreshFireRawImage
UIDetectDigTreasureView.SetBoxIconNormal = SetBoxIconNormal
UIDetectDigTreasureView.AddRewardFly = AddRewardFly
UIDetectDigTreasureView.IsRewardCanGet = IsRewardCanGet
UIDetectDigTreasureView.ShowHowToPlay = ShowHowToPlay
UIDetectDigTreasureView.OnBtnPreviewClick = OnBtnPreviewClick
UIDetectDigTreasureView.Update1000MS = Update1000MS
UIDetectDigTreasureView.CheckCanGetFreeHammer = CheckCanGetFreeHammer
UIDetectDigTreasureView.OnGetFreeHammer = OnGetFreeHammer
UIDetectDigTreasureView.CheckNeedShowDigGuide = CheckNeedShowDigGuide
return UIDetectDigTreasureView
