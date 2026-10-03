local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local FrontBreakoutSunday = BaseClass("FrontBreakoutSunday", base)
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local StageState = {
  Start = 1,
  Success = 2,
  Fail = 3
}
local soliderBubbleMinY = -264
local soliderBubbleMaxY = 20

local function OnCreate(self)
  base.OnCreate(self)
  DataCenter.LWBattleManager:SetBattleExitEndTime(BattleExitTimeLogType.ActFrontBreakSunday)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
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
  self.textTitle = self:AddComponent(UIText, "Content/Detail/Title")
  self.btnInfo = self:AddComponent(UIButton, "Content/Detail/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnGift = self:AddComponent(UIButton, "Content/Detail/BtnGroup/GiftBtn")
  self.btnGift:SetOnClick(function()
    self:OnBtnGiftClick()
  end)
  self.textGiftLabel = self:AddComponent(UIText, "Content/Detail/BtnGroup/GiftBtn/GiftLabel")
  self.textGiftLabel:SetText(Localization:GetString("activity_breakthrough_tips_2"))
  self.compGiftRedPoint = self:AddComponent(UIBaseContainer, "Content/Detail/BtnGroup/GiftBtn/GiftRedPoint")
  self.textGiftRedNum = self:AddComponent(UIText, "Content/Detail/BtnGroup/GiftBtn/GiftRedPoint/GiftRedNum")
  self.btnRank = self:AddComponent(UIButton, "Content/Detail/BtnGroup/RankBtn")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRankLabel = self:AddComponent(UIText, "Content/Detail/BtnGroup/RankBtn/RankLabel")
  self.textRankLabel:SetText(Localization:GetString("activity_breakthrough_tips_3"))
  self.compRankRedPoint = self:AddComponent(UIBaseContainer, "Content/Detail/BtnGroup/RankBtn/RankRedPoint")
  self.textRankRedNum = self:AddComponent(UIText, "Content/Detail/BtnGroup/RankBtn/RankRedPoint/RankRedNum")
  self.btnDesc = self:AddComponent(UIButton, "Content/Detail/BtnGroup/DescBtn")
  self.btnDesc:SetOnClick(function()
    self:OnBtnDescClick()
  end)
  self.textDescLabel = self:AddComponent(UIText, "Content/Detail/BtnGroup/DescBtn/DescLabel")
  self.textDescLabel:SetText(Localization:GetString("activity_breakthrough_tips_4"))
  self.compDescRedPoint = self:AddComponent(UIBaseContainer, "Content/Detail/BtnGroup/DescBtn/DescRedPoint")
  self.textDescRedNum = self:AddComponent(UIText, "Content/Detail/BtnGroup/DescBtn/DescRedPoint/DescRedNum")
  self.textRemainTime = self:AddComponent(UIText, "Content/Detail/TimeBg/remainTime")
  self.textRewardTitle = self:AddComponent(UIText, "Content/Detail/reward/reward_title")
  self.textRewardTitle:SetText(Localization:GetString("activity_breakthrough_tips_5"))
  self.compRewardContent = self:AddComponent(UIBaseContainer, "Content/Detail/reward/ScrollView/Viewport/RewardContent")
  self.compRewardItem = self:AddComponent(UIBaseContainer, "Content/Detail/reward/ScrollView/Viewport/RewardItem")
  self.btnChallenge = self:AddComponent(UIButton, "Content/BtnChallenge")
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.textChallengeLabel = self:AddComponent(UIText, "Content/BtnChallenge/ChallengeLabel")
  self.textChallengeLabel:SetLocalText("activity_breakthrough_tips_6")
  self.compChallengeRedPoint = self:AddComponent(UIBaseContainer, "Content/BtnChallenge/ChallengeRedPoint")
  self.btnRestartChallenge = self:AddComponent(UIButton, "Content/BtnGroup/BtnRestartChallenge")
  self.btnRestartChallenge:SetOnClick(function()
    self:OnBtnRestartChallengeClick()
  end)
  self.textRestartChallengeLabel = self:AddComponent(UIText, "Content/BtnGroup/BtnRestartChallenge/RestartLabel")
  self.textRestartChallengeLabel:SetLocalText("activity_breakthrough_tips_7")
  self.btnResumeChallenge = self:AddComponent(UIButton, "Content/BtnGroup/BtnResumeChallenge")
  self.btnResumeChallenge:SetOnClick(function()
    self:OnBtnResumeChallengeClick()
  end)
  self.textResumeChallengeLabel = self:AddComponent(UIText, "Content/BtnGroup/BtnResumeChallenge/ResumeLabel")
  self.scrollRectScrollView = self:AddComponent(UIScrollRect, "Content/Detail/reward/ScrollView")
  self.theRewardCellGameObject = self.compRewardItem.gameObject
  self.theRewardCellGameObject:SetActive(false)
  self.theRewardCellGameObject:GameObjectCreatePool()
  self.btnRestartChallenge:SetActive(false)
  self.btnResumeChallenge:SetActive(false)
  self.btnChallenge:SetActive(false)
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:OnTick()
  self.saveSoldierInfoRoot = self:AddComponent(UIBaseContainer, "Content/Detail/SaveSoldierInfo")
  self.bubbleSaveSoliderRoot = self:AddComponent(UIImage, "Content/Detail/SaveSoldierInfo/imgSaveBubbleBg")
  self.bubbleSaveSoliderRoot:SetActive(false)
  self.textSaveNum = self:AddComponent(UITextMeshProUGUIEx, "Content/Detail/SaveSoldierInfo/imgSaveBubbleBg/textSaveNum")
  self.textSaveNumDesc = self:AddComponent(UITextMeshProUGUIEx, "Content/Detail/SaveSoldierInfo/textSaveNumDesc")
  self.textSaveNumDesc:SetLocalText("frontline_weekend_soldier_title_01")
  self.textSaveProgress = self:AddComponent(UITextMeshProUGUIEx, "Content/Detail/SaveSoldierInfo/progress/textProgress")
  self.sliderSaveProgress = self:AddComponent(UISlider, "Content/Detail/SaveSoldierInfo/slider")
  self.imgProgressSolider = self:AddComponent(UIImage, "Content/Detail/SaveSoldierInfo/progress/imgProgressSolider")
  self.btnSolider = self:AddComponent(UIButton, "Content/Detail/SaveSoldierInfo/btnSolider")
  self.btnSolider:SetOnClick(function()
    self:OnBtnSoliderClick()
  end)
  self.imgBtnSolider = self:AddComponent(UIImage, "Content/Detail/SaveSoldierInfo/btnSolider/imgBtnSolider")
  self.boxCompList = {}
  for i = 1, 3 do
    local root = self:AddComponent(UIBaseContainer, "Content/Detail/SaveSoldierInfo/progress/box" .. i)
    local sliderTargetVal = 0
    if i == 1 or i == 2 then
      sliderTargetVal = 0.25 * i
    else
      sliderTargetVal = 1
    end
    self.boxCompList[i] = {
      root = root,
      btnBox = root:AddComponent(UIButton, "btnBox"),
      imgHasGot = root:AddComponent(UIImage, "hasGot"),
      effectCanGet = root:AddComponent(UIBaseContainer, "VFX_ui_zhoukabaoxiang_xiao"),
      sliderTargetVal = sliderTargetVal
    }
    self.boxCompList[i].btnBox:SetOnClick(function()
      self:OnBoxClick(i)
    end)
  end
  self.rawImgBanner = self:AddComponent(UIRawImage, "Content/Mask/Banner")
  self.saveSoldierInfoRoot:SetActive(DataCenter.ActFrontBreakSundayDataManager:IsSaveSoliderOpen())
end

local function ComponentDestroy(self)
  self.compRewardContent:RemoveComponents(UICommonResItem)
  self.theRewardCellGameObject:GameObjectRecycleAll()
  for _, v in ipairs(self.compRewardContent.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:StopSoliderFlyAnimTimer()
  self:StopBubbleTimer()
  self.refreshActEndRedPoint = nil
  self.lastTickActNotEnd = false
  self.content = nil
  self.reward_title = nil
  base.OnDestroy(self)
  self.textTitle = nil
  self.btnInfo = nil
  self.btnGift = nil
  self.textGiftLabel = nil
  self.compGiftRedPoint = nil
  self.textGiftRedNum = nil
  self.btnRank = nil
  self.textRankLabel = nil
  self.compRankRedPoint = nil
  self.textRankRedNum = nil
  self.btnDesc = nil
  self.textDescLabel = nil
  self.compDescRedPoint = nil
  self.textDescRedNum = nil
  self.textRemainTime = nil
  self.textRewardTitle = nil
  self.compRewardContent = nil
  self.compRewardItem = nil
  self.btnChallenge = nil
  self.textChallengeLabel = nil
  self.scrollRectScrollView = nil
  self.saveSoldierInfoRoot = nil
  self.bubbleSaveSoliderRoot = nil
  self.textSaveNum = nil
  self.textSaveNumDesc = nil
  self.textSaveProgress = nil
  self.sliderSaveProgress = nil
  self.imgProgressSolider = nil
  self.btnSolider = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function FrontBreakoutSunday:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:Refresh()
  self:CheckNeedPlayFlyAnim()
  if DataCenter.ActivityListDataManager:CheckIsSend(self.activityData) then
    SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.activityId))
    return
  end
end

local function RefreshShowedReward(self)
  self.compRewardContent:RemoveComponents(UICommonResItem)
  self.theRewardCellGameObject:GameObjectRecycleAll()
  local actData = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId)
  local rewards = actData.showRewards
  local isGetAll = actData:IsAllRewardsClaimed()
  if rewards then
    for i, item in ipairs(rewards) do
      local theName = "item_" .. i
      local goItem = self.theRewardCellGameObject:GameObjectSpawn(self.compRewardContent.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local theItem = self.compRewardContent:AddComponent(UICommonResItem, theName)
      item.isShowReceFlag = isGetAll
      theItem:ReInit(item)
    end
  end
end

function FrontBreakoutSunday:Refresh()
  if not self.activityData then
    return
  end
  self.textTitle:SetLocalText("activity_breakthrough_tips_1")
  if not string.IsNullOrEmpty(self.activityData.para_6) then
    self.rawImgBanner:LoadSpriteAuto(self.activityData.para_6)
  end
  RefreshShowedReward(self)
end

function FrontBreakoutSunday:RefreshPlayRedDot()
  if not DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info then
    self.compChallengeRedPoint:SetActive(false)
    return
  end
  local hasPlayed = DataCenter.ActFrontBreakSundayDataManager:HasPlayed(self.activityId)
  local canPlay = DataCenter.ActFrontBreakSundayDataManager:CanPlay(self.activityId)
  self.compChallengeRedPoint:SetActive(not hasPlayed and canPlay)
end

function FrontBreakoutSunday:RefreshRewardRedDot()
  if not DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info then
    self.compGiftRedPoint:SetActive(false)
    return
  end
  local count = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info.rewardCount
  self.compGiftRedPoint:SetActive(0 < count)
  self.textGiftRedNum:SetText(count)
end

function FrontBreakoutSunday:RefreshStage()
  if not DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info then
    return
  end
  local nextStageId = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId):GetNextStageId()
  if not nextStageId or nextStageId == -1 then
    self.btnRestartChallenge:SetActive(false)
    self.btnResumeChallenge:SetActive(false)
    self.btnChallenge:SetActive(false)
  else
    local nextStageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId):GetStageIndex(nextStageId)
    local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).stageIds
    if nextStageIdIndex == 1 then
      self.btnRestartChallenge:SetActive(false)
      self.btnResumeChallenge:SetActive(false)
      self.btnChallenge:SetActive(true)
    else
      self.btnRestartChallenge:SetActive(true)
      self.btnResumeChallenge:SetActive(true)
      self.textResumeChallengeLabel:SetLocalText("activity_breakthrough_tips_8", nextStageIdIndex, stagesCount)
      self.btnChallenge:SetActive(false)
    end
  end
end

function FrontBreakoutSunday:OnTick()
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if not self.activityData then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.activityData.endTime - curTime
  if 0 < remainTime then
    self.textRemainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    self.lastTickActNotEnd = true
    if remainTime < 599999 and not self.refreshActEndRedPoint then
      self.refreshActEndRedPoint = true
      self:OnActivityInfoChanged(self.activityId)
    end
  else
    if self.lastTickActNotEnd then
      self.lastTickActNotEnd = false
      UIUtil.ShowTips(Localization:GetString("458272"))
    end
    self.textRemainTime:SetText("00:00:00")
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.FrontBreakSundayActivityInfoChanged, self.OnActivityInfoChanged)
  self:AddUIListener(EventId.FrontBreakSundayGetSaveSoliderReward, self.RefreshSaveSoliderInfo)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.FrontBreakSundayActivityInfoChanged, self.OnActivityInfoChanged)
  self:RemoveUIListener(EventId.FrontBreakSundayGetSaveSoliderReward, self.RefreshSaveSoliderInfo)
  base.OnRemoveListener(self)
end

function FrontBreakoutSunday:OnActivityInfoChanged(activityId)
  if self.activityId == activityId then
    self:RefreshRewardRedDot()
    self:RefreshPlayRedDot()
    self:RefreshStage()
    self:RefreshShowedReward()
    self:RefreshSaveSoliderInfo()
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

local function OnBtnGiftClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityFrontBreakSundayRewards, {anim = true}, self.activityId)
end

local function OnBtnRankClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFrontBreakSundayRank, {anim = false}, self.activityId)
end

local function OnBtnDescClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 5)
end

local function RequestToEnterStage(stageId)
  DataCenter.ActFrontBreakSundayDataManager:RequestToEnterStage(stageId)
end

local function OnBtnChallengeClick(self)
  if not DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info then
    return
  end
  local stageIds = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).stageIds
  if stageIds and 0 < #stageIds then
    RequestToEnterStage(stageIds[1])
  end
end

local function OnBtnRestartChallengeClick(self)
  OnBtnChallengeClick(self)
end

local function OnBtnResumeChallengeClick(self)
  if not DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info then
    return
  end
  local nextStageId = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId):GetNextStageId()
  if nextStageId and nextStageId ~= -1 then
    RequestToEnterStage(nextStageId)
  end
end

local function OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
    howToPlayList = {100041}
  })
end

function FrontBreakoutSunday:RefreshSaveSoliderInfo()
  if not DataCenter.ActFrontBreakSundayDataManager:IsSaveSoliderOpen() then
    return
  end
  local data = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId)
  local curSaveSoliderNum = data.info.globalSoldierNum or 0
  local maxTargetNum = data.maxTargetNum or 1
  local maxStageIndex = #data.info.soldierBox
  local curStageIndex = maxStageIndex
  for i, boxData in ipairs(data.info.soldierBox) do
    if boxData.state == FrontBreakSundayBoxState.NotAchieved then
      curStageIndex = i
      break
    end
  end
  if curStageIndex == maxStageIndex then
    self.sliderSaveProgress:SetValue(curSaveSoliderNum / maxTargetNum)
  else
    local targetVal = self.boxCompList[curStageIndex].sliderTargetVal
    local targetNum = data.info.soldierBox[curStageIndex].target
    local progressToCurrentBox = 0
    if curStageIndex == 1 then
      progressToCurrentBox = math.min(curSaveSoliderNum / targetNum, 1.0)
      self.sliderSaveProgress:SetValue(progressToCurrentBox * targetVal)
    else
      local prevTargetNum = data.info.soldierBox[curStageIndex - 1].target
      progressToCurrentBox = math.min((curSaveSoliderNum - prevTargetNum) / (targetNum - prevTargetNum), 1.0)
      local prevTargetVal = self.boxCompList[curStageIndex - 1].sliderTargetVal
      self.sliderSaveProgress:SetValue(prevTargetVal + progressToCurrentBox * (targetVal - prevTargetVal))
    end
  end
  local progress = math.min(math.floor(curSaveSoliderNum / maxTargetNum * 100), 100)
  self.textSaveProgress:SetText(string.format("%d%%", progress))
  self.textSaveNum:SetText(string.GetFormattedStr(curSaveSoliderNum))
  local posY = soliderBubbleMinY + (soliderBubbleMaxY - soliderBubbleMinY) * (curSaveSoliderNum / maxTargetNum)
  local curPos = self.bubbleSaveSoliderRoot.transform.localPosition
  self.bubbleSaveSoliderRoot:SetAnchoredPositionXY(curPos.x, posY)
  local boxInfoList = data.info.soldierBox
  for i, boxData in ipairs(boxInfoList) do
    local boxComp = self.boxCompList[i]
    if boxComp then
      local hasGot = boxData.state == FrontBreakSundayBoxState.HasGot
      boxComp.imgHasGot:SetActive(hasGot)
      local canGet = boxData.state == FrontBreakSundayBoxState.CanGet
      boxComp.effectCanGet:SetActive(canGet)
    end
  end
end

function FrontBreakoutSunday:OnBoxClick(i)
  local boxInfoList = DataCenter.ActFrontBreakSundayDataManager:GetActData(self.activityId).info.soldierBox
  if not boxInfoList or not boxInfoList[i] then
    return
  end
  local curState = boxInfoList[i].state
  if curState == FrontBreakSundayBoxState.NotAchieved or curState == FrontBreakSundayBoxState.HasGot then
    local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
    param.position = self.boxCompList[i].root.transform.position
    if CommonUtil.IsArabicAutoMirrorOpen() then
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
    else
      param.dir = UIPersonalArmsRewardTipView.Direction.LEFT
    end
    param.rewardList = boxInfoList[i].reward
    param.customTitleIcon = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png"
    local targetNum = boxInfoList[i].target
    local str = string.GetFormattedStr(targetNum)
    param.customTitleStr = Localization:GetString("frontline_weekend_soldier_01", str)
    param.hideResIconCount = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FrontBreakSundaySaveSoliderReward, tostring(self.activityId), 0)
end

function FrontBreakoutSunday:OnBtnSoliderClick()
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = Localization:GetString("frontline_weekend_savesoldier_desc_01")
  param.isLocal = true
  param.alignObject = self.imgBtnSolider
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function FrontBreakoutSunday:CheckNeedPlayFlyAnim()
  if DataCenter.ActFrontBreakSundayDataManager:GetNeedPlaySoliderFlyAnim() then
    self:StartSoliderFlyAnimTimer()
    self.bubbleSaveSoliderRoot:SetActive(true)
    self:StartBubbleTimer()
    DataCenter.ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(false)
  end
end

function FrontBreakoutSunday:DoFlyAnim()
  local pic = "Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_zaobing.png"
  local startPos = self.transform.position
  local endPos = self.imgProgressSolider.transform.position
  UIUtil.DoFlyCustom(pic, nil, 5, startPos, endPos)
end

function FrontBreakoutSunday:StartSoliderFlyAnimTimer()
  self:StopSoliderFlyAnimTimer()
  self.soliderFlyTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.imgProgressSolider then
      self:DoFlyAnim()
    end
  end, 0.5)
end

function FrontBreakoutSunday:StopSoliderFlyAnimTimer()
  if self.soliderFlyTimer then
    self.soliderFlyTimer:Stop()
    self.soliderFlyTimer = nil
  end
end

function FrontBreakoutSunday:StartBubbleTimer()
  self:StopBubbleTimer()
  self.bubbleTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.bubbleSaveSoliderRoot then
      self.bubbleSaveSoliderRoot:SetActive(false)
    end
  end, 3.5)
end

function FrontBreakoutSunday:StopBubbleTimer()
  if self.bubbleTimer then
    self.bubbleTimer:Stop()
    self.bubbleTimer = nil
  end
end

FrontBreakoutSunday.OnCreate = OnCreate
FrontBreakoutSunday.OnDestroy = OnDestroy
FrontBreakoutSunday.OnEnable = OnEnable
FrontBreakoutSunday.OnDisable = OnDisable
FrontBreakoutSunday.ComponentDefine = ComponentDefine
FrontBreakoutSunday.ComponentDestroy = ComponentDestroy
FrontBreakoutSunday.DataDefine = DataDefine
FrontBreakoutSunday.DataDestroy = DataDestroy
FrontBreakoutSunday.OnAddListener = OnAddListener
FrontBreakoutSunday.OnRemoveListener = OnRemoveListener
FrontBreakoutSunday.OnBtnInfoClick = OnBtnInfoClick
FrontBreakoutSunday.OnBtnGiftClick = OnBtnGiftClick
FrontBreakoutSunday.OnBtnRankClick = OnBtnRankClick
FrontBreakoutSunday.OnBtnDescClick = OnBtnDescClick
FrontBreakoutSunday.OnBtnChallengeClick = OnBtnChallengeClick
FrontBreakoutSunday.OnBtnRestartChallengeClick = OnBtnRestartChallengeClick
FrontBreakoutSunday.OnBtnResumeChallengeClick = OnBtnResumeChallengeClick
FrontBreakoutSunday.RefreshShowedReward = RefreshShowedReward
return FrontBreakoutSunday
