local UIBuildingDigTreasureView = BaseClass("UIBuildingDigTreasureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DiggingMap = require("UI.DigMap.Building.Component.DigMapBuilding")
local DiggingBlockInfo = require("UI.DigTreasure.Component.DiggingMap.DigTreasureBlockInfo")
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local LEVELS_NUM_PER_GROUP = 5

local function OnCreate(self)
  base.OnCreate(self)
  local data = self:GetUserData()
  self.tBuildingData = data
  self.tMapData = data.buildingDigGame.gameInfo
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
  self.objRewardArea = self:AddComponent(UIBaseContainer, "safeArea/Root/RewardArea")
  self.objCountDownArea = self:AddComponent(UIBaseContainer, "safeArea/Root/CountDownArea")
  self.sliderCountDown = self:AddComponent(UISlider, "safeArea/Root/CountDownArea/UnFinishState/Slider")
  self.textCountDown = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDown")
  self.textCountDownDes1 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes1")
  self.textCountDownDes2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/CountDownArea/UnFinishState/textCountDownDes2")
  self.textItemNum = self:AddComponent(UITextMeshProUGUIEx, "safeArea/Root/UseItemTop/ItemNumText")
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
  self.objRewardArea = nil
  self.objCountDownArea = nil
  self.sliderCountDown = nil
  self.textCountDown = nil
  self.textCountDownDes1 = nil
  self.textCountDownDes2 = nil
  self.textItemNum = nil
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
  self:AddUIListener(EventId.DigTreasureUpdateMapData, self.OnUpdateMapData)
  self:AddUIListener(EventId.BuildingDigGameOpen, self.OnOpen)
  self:AddUIListener(EventId.DigTreasureUpdateActivityData, self.RefreshAll)
  self:AddUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.CheckIsGetAllReward)
  self:AddUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  self:AddUIListener(EventId.OnGetFreeHammer, self.OnGetFreeHammer)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshUseItemNum)
  self:RemoveUIListener(EventId.DigTreasureUpdateRewardData, self.RefreshReward)
  self:RemoveUIListener(EventId.DigTreasureUpdateMapData, self.OnUpdateMapData)
  self:RemoveUIListener(EventId.BuildingDigGameOpen, self.OnOpen)
  self:RemoveUIListener(EventId.DigTreasureUpdateActivityData, self.RefreshAll)
  self:RemoveUIListener(EventId.DigTreasureCanGetReward, self.OnCanGetReward)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.CheckIsGetAllReward)
  self:RemoveUIListener(EventId.DiggingGetBlockAnim, self.OnGetBlockAnim)
  self:RemoveUIListener(EventId.OnGetFreeHammer, self.OnGetFreeHammer)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  local param = {}
  param.activityRulesStr = Localization:GetString("building_dig_rules_01")
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
  local nItemId = DataCenter.BuildingDigTreasureManager:GetUseItemId()
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
  self:SetSelectImg(false)
end

local function RefreshReward(self)
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
  local nCurLevelIndex = -1
  for i = 1, LEVELS_NUM_PER_GROUP do
    local tData = tRewardData[i]
    if not tData then
      break
    end
    local tConfig = DataCenter.DiggingDataTemplateManager:GetConfigData(tData.mapConfigId)
    self.tRewardList[i].textDes:SetLocalText("treasure_map_level_name_01", tConfig.layer)
    if tData.rewardState == DigRewardState.CanNotGet or tData.rewardState == DigRewardState.NotBegin then
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

local function Update1000MS2(self)
  if self.bShowEndMessageTips then
    return
  end
  local nCurTime = UITimeManager:GetInstance():GetServerTime()
  local nResetTime = DataCenter.BuildingDigTreasureManager:GetActivityResetTime()
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
  if self.nCurLevelIndex == 5 and not table.IsNullOrEmpty(self.tRewardList) and not self.bIsShowFinger and self:IsGroupLastBoxCanGet() then
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
  local nEndTime = self.tMapData.endTime
  local nLeftTime = nEndTime - nCurTime
  if nLeftTime < 0 then
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
  self.tMapData = DataCenter.BuildingDigTreasureManager:GetCurMapData()
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
  self.bIsTimeLimitMap = false
  local bIsNotBegin = self.tMapData.rewardState == DigRewardState.NotBegin
  self.DiggingMap:OnRefresh(self.tMapData, self.tMapData.rewardState > 0 and not self.bIsTimeLimitMap and not bIsNotBegin)
  if self.bIsTimeLimitMap then
    self.objCountDownArea:SetActive(true)
    self.objRewardArea:SetActive(false)
    self.nTotalLimitTime = tMapCfg.level_limit_time
    self:RefreshTimelimitMapState()
    self:Update1000MS()
  else
    self.objCountDownArea:SetActive(false)
    self.objRewardArea:SetActive(true)
    self.btnGiveUp:SetActive(false)
  end
  self:RefreshBlock()
  self:RefreshLayer()
  self:RefreshFireRawImage()
end

local function RefreshUseItemNum(self)
  local nNum = DataCenter.BuildingDigTreasureManager:GetUseItemNum()
  self.textItemNum:SetText(nNum)
end

local function OnClickReward(self, i)
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
  local bChangingMap = self.bDuringChangeToLimitMap or self.bDuringChangeToNormalMap
  if bChangingMap or tRewardData[i].rewardState ~= DigRewardState.CanGet then
    self:ShowRewardTip(i)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BuildingGetDigGameReward, self.tBuildingData.uuid)
end

local function OnClickTimeLimitReward(self)
  if not self.bIsTimeLimitMap then
    return
  end
  local nCurState = self.tMapData.rewardState
  local bIsFailOrCanGet = nCurState == DigRewardState.Fail or nCurState == DigRewardState.CanGet
  if self.tMapData.endTime > UITimeManager:GetInstance():GetServerTime() and not bIsFailOrCanGet then
    return
  end
  self.timeLimitRewardAnimator:Play("UIDigTreasureXianshibaoxiangOpen")
  TimerManager:GetInstance():DelayInvoke(function()
    SFSNetwork.SendMessage(MsgDefines.DigTreasureGameGetTimeLimitReward, self.tMapData.uuid)
  end)
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
  if not openData then
    return
  end
  if openData.uuid ~= self.tMapData.uuid then
    return
  end
  if DataCenter.BuildingDigTreasureManager:CheckIsShowGuide() then
    DataCenter.ArrowManager:RemoveFingerArrow()
  end
  if openData.rewardState == DigRewardState.CanGet then
    self.DiggingMap:OpenBrick()
  end
end

local function InitAnim(self)
  if self.nCurLevelIndex == -1 or self:IsGroupLastBoxCanGet() then
    self.btnTimeLimitReward:SetActive(false)
    self.panelAnimator:Play("UIDigTreasureCaveIdle")
  else
    self.btnTimeLimitReward:SetActive(true)
    self.panelAnimator:Play("UIDigTreasureIn")
  end
end

local function OnUpdateMapData(self)
  DataCenter.ArrowManager:RemoveFingerArrow()
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
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
    if false then
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
  self:SetBoxIconNormal()
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
  self.ctrl:CloseSelf()
end

local function CheckIsGetAllReward(self)
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
  local bGetAllNormalReward = true
  for i = 1, #tRewardData do
    if tRewardData[i].rewardState ~= DigRewardState.HaveGot then
      bGetAllNormalReward = false
      break
    end
  end
  if bGetAllNormalReward then
    self.ctrl.CloseSelf()
  end
end

local function RefreshLayer(self)
  local nCurLayer = DataCenter.BuildingDigTreasureManager:GetCurLayer()
  local nMaxLayer = DataCenter.BuildingDigTreasureManager:GetMaxLayer()
  local sTitle = Localization:GetString("dig_game_activity_name_01")
  local sText = string.format("%s(%s/%s)", sTitle, nCurLayer, nMaxLayer)
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
  if false then
    return
  end
  if self.nCurLevelIndex ~= 5 then
    return
  end
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
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
    self.btnGiveUp:SetActive(false)
  elseif self.tMapData.rewardState == DigRewardState.CanGet then
    self.btnBackMask.transform.gameObject:SetActive(false)
    self.objFinishState:SetActive(true)
    self.objUnFinishState:SetActive(false)
    self.textFinishDes:SetLocalText("treasure_map_special_level_09")
    self.btnGiveUp:SetActive(false)
  else
    self.btnGiveUp:SetActive(true)
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
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
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
  local tRewardData = DataCenter.BuildingDigTreasureManager:GetRewardData()
  local bCanGet = false
  if self.nCurLevelIndex == LEVELS_NUM_PER_GROUP and tRewardData[self.nCurLevelIndex].rewardState == DigRewardState.CanGet then
    bCanGet = true
  else
    bCanGet = false
  end
  return bCanGet
end

local function CheckCanGetFreeHammer(self)
  if self.tMapData.rewardState == DigRewardState.NotBegin then
    DataCenter.BuildingDigTreasureManager:ReceiveFreeHammer()
  end
end

local function OnGetFreeHammer(self)
  local sPath = string.format(LoadPath.UIDigTreasureSpritePath, "FX_S3_xiusaiqi_jidongduiwabao_chuizi_icon")
  UIUtil.DoFlyCustom(sPath, nil, 5, self.DiggingMap.transform.position, self.imgUseItem.transform.position)
end

local function CheckNeedShowDigGuide(self)
  if DataCenter.BuildingDigTreasureManager:CheckIsShowGuide() then
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

UIBuildingDigTreasureView.OnCreate = OnCreate
UIBuildingDigTreasureView.OnDestroy = OnDestroy
UIBuildingDigTreasureView.OnEnable = OnEnable
UIBuildingDigTreasureView.OnDisable = OnDisable
UIBuildingDigTreasureView.ComponentDefine = ComponentDefine
UIBuildingDigTreasureView.ComponentDestroy = ComponentDestroy
UIBuildingDigTreasureView.DataDefine = DataDefine
UIBuildingDigTreasureView.DataDestroy = DataDestroy
UIBuildingDigTreasureView.OnAddListener = OnAddListener
UIBuildingDigTreasureView.OnRemoveListener = OnRemoveListener
UIBuildingDigTreasureView.OnBtnInfoClick = OnBtnInfoClick
UIBuildingDigTreasureView.OnBtnCloseClick = OnBtnCloseClick
UIBuildingDigTreasureView.OnBtnGetMoreClick = OnBtnGetMoreClick
UIBuildingDigTreasureView.RefreshReward = RefreshReward
UIBuildingDigTreasureView.RefreshMap = RefreshMap
UIBuildingDigTreasureView.OnClickReward = OnClickReward
UIBuildingDigTreasureView.RefreshUseItemNum = RefreshUseItemNum
UIBuildingDigTreasureView.RefreshAll = RefreshAll
UIBuildingDigTreasureView.Update1000MS = Update1000MS
UIBuildingDigTreasureView.OnClickTimeLimitReward = OnClickTimeLimitReward
UIBuildingDigTreasureView.OnBtnGiveUpClick = OnBtnGiveUpClick
UIBuildingDigTreasureView.RefreshBlock = RefreshBlock
UIBuildingDigTreasureView.UpdateBlock = UpdateBlock
UIBuildingDigTreasureView.OnOpen = OnOpen
UIBuildingDigTreasureView.InitAnim = InitAnim
UIBuildingDigTreasureView.OnUpdateMapData = OnUpdateMapData
UIBuildingDigTreasureView.RefreshRewardBoxIcon = RefreshRewardBoxIcon
UIBuildingDigTreasureView.OnBtnResetMaskClick = OnBtnResetMaskClick
UIBuildingDigTreasureView.CheckIsGetAllReward = CheckIsGetAllReward
UIBuildingDigTreasureView.RefreshLayer = RefreshLayer
UIBuildingDigTreasureView.SetSelectImg = SetSelectImg
UIBuildingDigTreasureView.OnCanGetReward = OnCanGetReward
UIBuildingDigTreasureView.RefreshTimelimitMapState = RefreshTimelimitMapState
UIBuildingDigTreasureView.OnBtnBackMaskClick = OnBtnBackMaskClick
UIBuildingDigTreasureView.OnGetBlockAnim = OnGetBlockAnim
UIBuildingDigTreasureView.ShowRewardTip = ShowRewardTip
UIBuildingDigTreasureView.RefreshFireRawImage = RefreshFireRawImage
UIBuildingDigTreasureView.SetBoxIconNormal = SetBoxIconNormal
UIBuildingDigTreasureView.SetBoxIconTimeLimit = SetBoxIconTimeLimit
UIBuildingDigTreasureView.AddRewardFly = AddRewardFly
UIBuildingDigTreasureView.AddFakeChange = AddFakeChange
UIBuildingDigTreasureView.IsGroupLastBoxCanGet = IsGroupLastBoxCanGet
UIBuildingDigTreasureView.ShowHowToPlay = ShowHowToPlay
UIBuildingDigTreasureView.OnBtnPreviewClick = OnBtnPreviewClick
UIBuildingDigTreasureView.CheckCanGetFreeHammer = CheckCanGetFreeHammer
UIBuildingDigTreasureView.OnGetFreeHammer = OnGetFreeHammer
UIBuildingDigTreasureView.CheckNeedShowDigGuide = CheckNeedShowDigGuide
return UIBuildingDigTreasureView
