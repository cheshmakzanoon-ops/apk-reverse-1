local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIOffSeason1QueenOfBloodMain = BaseClass("UIOffSeason1QueenOfBloodMain", base)
local CityItem = require("UI.LWOffSeason1.QueenOfBlood.OffSeason1QueenOfBloodItem")
local Localization = CS.GameEntry.Localization
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")

function UIOffSeason1QueenOfBloodMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1QueenOfBloodMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1QueenOfBloodMain:ComponentDefine()
  self.rawImgPreview = self:AddComponent(UIRawImage, "Bg/rectMask/RawImagePreview")
  self.rawImgMain = self:AddComponent(UIBaseComponent, "Bg/RawImageMain")
  self.btnTips = self:AddComponent(UIButton, "Content/TipsBtn")
  self.btnTips:SetOnClick(function()
    self:OnBtnTipsClick()
  end)
  self.btnReward = self:AddComponent(UIButton, "Content/RewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textRemainTime = self:AddComponent(UITextMeshProUGUIEx, "Content/RemainTimeContent/RemainTimeText")
  self.imgBubbleTipsPreview = self:AddComponent(UIImage, "Content/BubbleTipsPreview")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Content/BubbleTipsPreview/timeTextContent/timeText")
  self.contentMain = self:AddComponent(UIBaseComponent, "Content/contentMain")
  self.btnRank = self:AddComponent(UIButton, "Content/contentMain/RankBtn")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textBubbleMain = self:AddComponent(UITextMeshProUGUIEx, "Content/contentMain/BubbleBg/BubbleMainText")
  self.cityContent = self:AddComponent(UIBaseContainer, "Content/contentMain/ScrollView/Viewport/Content/city")
  self.bossContent = self:AddComponent(UIBaseContainer, "Content/contentMain/ScrollView/Viewport/Content/boss")
  self.queenOfBloodItem = self:AddComponent(UIBaseContainer, "Content/contentMain/ScrollView/Viewport/Content/OffSeason1QueenOfBloodItem")
  self.queenOfBloodItem.gameObject:SetActive(false)
  self.queenOfBloodItemPool = self.queenOfBloodItem.gameObject
  self.queenOfBloodItemPool:GameObjectCreatePool()
  self.queenOfBloodItems = {}
  self.compCalendarAddBtnContent = self:AddComponent(CalendarAddBtnContent, "Content/BubbleTipsPreview/timeTextContent/timeText/CalendarAddBtnContent")
  self.redPoint = self:AddComponent(UICommonRedPoint, "Content/RewardBtn/CommonRedPoint")
  self.redPoint:SetType(CommonRedPointPriority.Level1)
  self.text1Tip = self:AddComponent(UIText, "Content/Tip1Text")
  self.text2Tip = self:AddComponent(UIText, "Content/Tip2Text")
  self.text3Tip = self:AddComponent(UIText, "Content/Tip3Text")
  self.text1Tip:SetActive(false)
  self.text2Tip:SetActive(false)
  self.text3Tip:SetActive(false)
  self.spineMask = self:AddComponent(UIBaseComponent, "Bg/HeroSpineContainer")
  self.spine = self:AddComponent(UISpine, "Bg/HeroSpineContainer/Xueponvwang/New SkeletonGraphic")
  self.spineMask:SetActive(false)
end

function UIOffSeason1QueenOfBloodMain:ComponentDestroy()
  self.rawImgPreview = nil
  self.rawImgMain = nil
  self.btnTips = nil
  self.btnReward = nil
  self.textRemainTime = nil
  self.imgBubbleTipsPreview = nil
  self.textTime = nil
  self.contentMain = nil
  self.btnRank = nil
  self.textBubbleMain = nil
  self.cityContent = nil
  self.bossContent = nil
  self.queenOfBloodItem = nil
  self.compCalendarAddBtnContent = nil
  self.redPoint = nil
  self.text1Tip = nil
  self.text2Tip = nil
  self.text3Tip = nil
  self.spineMask = nil
  self.spine = nil
end

function UIOffSeason1QueenOfBloodMain:DataDefine()
  self.stage = -1
  self.activityStateEndTime = 0
  self.cityInfo = nil
  self.monsterInfo = nil
  self.battleStage = -1
  self.battleStageEndTime = 0
  self.allDefendState = -1
end

function UIOffSeason1QueenOfBloodMain:DataDestroy()
  self.stage = nil
  self.activityStateEndTime = nil
  self.cityInfo = nil
  self.monsterInfo = nil
  self.battleStage = nil
  self.battleStageEndTime = nil
  self.allDefendState = nil
  self:ClearContent()
end

function UIOffSeason1QueenOfBloodMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.QueenOfBloodMainInfoUpdate, self.RefreshData)
  self:AddUIListener(EventId.PushBloodyQueenS1RestActivityInfoUpdateInView, self.OnPushBloodyQueenS1RestActivityInfoUpdateInView)
  self:AddUIListener(EventId.RefreshQueenOfBloodActivityInfoAllMonster, self.RefreshData)
  self:AddUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.RefreshRedDot)
end

function UIOffSeason1QueenOfBloodMain:OnRemoveListener()
  self:RemoveUIListener(EventId.QueenOfBloodMainInfoUpdate, self.RefreshData)
  self:RemoveUIListener(EventId.PushBloodyQueenS1RestActivityInfoUpdateInView, self.OnPushBloodyQueenS1RestActivityInfoUpdateInView)
  self:RemoveUIListener(EventId.RefreshQueenOfBloodActivityInfoAllMonster, self.RefreshData)
  self:RemoveUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.RefreshRedDot)
  base.OnRemoveListener(self)
end

function UIOffSeason1QueenOfBloodMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = tonumber(activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainActivityInfo)
  self:Update1000MS()
end

function UIOffSeason1QueenOfBloodMain:RefreshData()
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.stage = DataCenter.OffSeason1QueenOfBloodManager:GetQueenOfBloodActivityStage()
  self.activityStateEndTime = DataCenter.OffSeason1QueenOfBloodManager:GetActivityStateEndTime()
  if self.stage ~= QueenOfBloodActivityState.preview then
    self.monsterInfo = DataCenter.OffSeason1QueenOfBloodManager:GetMonsterInfosList()
    self.cityInfo = DataCenter.OffSeason1QueenOfBloodManager:GetCityInfoList()
    self.battleStage = DataCenter.OffSeason1QueenOfBloodManager:GetBattleStateNow()
    self.battleStageEndTime = DataCenter.OffSeason1QueenOfBloodManager:GetBattleStageEndTime()
    if self.stage == QueenOfBloodActivityState.postBattleShow or self.stage == QueenOfBloodActivityState.activityEndShow then
      self.allDefendState = DataCenter.OffSeason1QueenOfBloodManager:GetTheBattleResult()
    end
  end
  self:RefreshUIState()
  self:InitScrollView()
  self:RefreshRedDot()
  self:RefreshRankBtnShow()
  self:RefreshDownTip()
  self:Update1000MS()
  self:ShowCalendatBtnContent()
end

function UIOffSeason1QueenOfBloodMain:ShowCalendatBtnContent()
  if self.stage == QueenOfBloodActivityState.preview then
    self.compCalendarAddBtnContent:SetActive(true)
    local startTime = toInt(self.activityStateEndTime / 1000)
    local endTime = toInt(self.activityStateEndTime / 1000)
    self.compCalendarAddBtnContent:SetDataWithDefautValue(13, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.compCalendarAddBtnContent:SetActive(false)
  end
end

function UIOffSeason1QueenOfBloodMain:RefreshUIState()
  local previewStageOpen = self.stage == QueenOfBloodActivityState.preview
  self.rawImgPreview.gameObject:SetActive(previewStageOpen)
  self.rawImgMain.gameObject:SetActive(not previewStageOpen)
  self.contentMain.gameObject:SetActive(not previewStageOpen)
  self.imgBubbleTipsPreview.gameObject:SetActive(previewStageOpen)
  if previewStageOpen then
    self.spineMask:SetActive(true)
    self.spineMask:SetSizeDeltaXY(654, 1030)
    self.spineMask:SetAnchoredPositionXY(0, 120)
    self.spineMask:SetLocalScaleXYZ(1.2, 1.2, 1.2)
    self.spine:SetAnimation(1, "yansu", true)
  else
    self.spineMask:SetActive(true)
    self.spineMask:SetSizeDeltaXY(810, 666)
    self.spineMask:SetAnchoredPositionXY(75, 207)
    self.spineMask:SetLocalScaleXYZ(-0.9, 0.9, 0.9)
    if self.stage == QueenOfBloodActivityState.postBattleShow then
      local haveWin = false
      for k, v in pairs(self.cityInfo) do
        if not v.defendInfo.isDefendSuccess then
          haveWin = true
          break
        end
      end
      if haveWin then
        self.spine:SetAnimation(1, "yansu", true)
      else
        self.spine:SetAnimation(1, "yaoyaqiechi", true)
      end
    elseif self.stage == QueenOfBloodActivityState.activityEndShow then
      self.spine:SetAnimation(1, "yaoyaqiechi", true)
    else
      self.spine:SetAnimation(1, "zixin", true)
    end
  end
end

function UIOffSeason1QueenOfBloodMain:OnBtnTipsClick()
  if self.activityData and not table.IsNullOrEmpty(self.activityData.howtoplay) then
    local param = {}
    param.howToPlayList = self.activityData.howtoplay
    param.story = self.activityData.story
    param.defaultTitle = self.activityData.name
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  end
end

function UIOffSeason1QueenOfBloodMain:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIOffSeason1Task, {anim = true}, OffSeason1TaskGroup.QueenOfBlood)
end

function UIOffSeason1QueenOfBloodMain:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIQueenOfBloodRankList, {anim = true})
end

function UIOffSeason1QueenOfBloodMain:Update1000MS()
  if self.stage == QueenOfBloodActivityState.preview then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diffTime = self.activityStateEndTime - curTime
    if 0 < diffTime then
      local dateTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, diffTime))
      self.textTime:SetLocalText("s1_QueenChallenge_preview_tips_timmer", dateTime)
    else
    end
  elseif self.stage == QueenOfBloodActivityState.battle then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diffTime = 0
    local roundInfo = DataCenter.OffSeason1QueenOfBloodManager:GetRoundInfo()
    local curCount = 0
    local maxCount = 0
    if roundInfo and roundInfo.nextRound and roundInfo.maxRound then
      curCount = roundInfo.nextRound
      maxCount = roundInfo.maxRound
      diffTime = roundInfo.nextRoundTime - curTime
    end
    if diffTime < 0 then
      diffTime = 0
    end
    local dateTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, diffTime))
    self.textBubbleMain:SetLocalText("s1_QueenChallenge_challenging_desc", dateTime, curCount, maxCount)
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local diffTime = self.activityStateEndTime - curTime
    if 0 < diffTime then
      local dateTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, diffTime))
      if self.stage == QueenOfBloodActivityState.preBattleShow then
        local configTime = LuaEntry.DataConfig:TryGetNum("s1_offSeason_rerecapture", "k20", 0) * 60 * 1000
        dateTime = UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, diffTime) + configTime)
        self.textBubbleMain:SetLocalText("s1_QueenChallenge_ready_desc", dateTime)
        if self.text2Tip:GetActive() then
          self.text2Tip:SetLocalText("s1_QueenChallenge_ready_tips_signUpTimer", UITimeManager:GetInstance():MilliSecondToFmtString(math.max(0, diffTime)))
        end
      elseif self.stage == QueenOfBloodActivityState.preBattleShowNoApplication then
        self.textBubbleMain:SetLocalText("s1_QueenChallenge_ready_desc", dateTime)
      elseif self.stage == QueenOfBloodActivityState.postBattleShow then
        if self.allDefendState == QueenOfBloodBattleResult.AllSuccess then
          self.textBubbleMain:SetLocalText("s1_QueenChallenge_result_tips1", dateTime)
        elseif self.allDefendState == QueenOfBloodBattleResult.PartSuccess then
          self.textBubbleMain:SetLocalText("s1_QueenChallenge_result_tips2", dateTime)
        else
          self.textBubbleMain:SetLocalText("s1_QueenChallenge_result_tips3", dateTime)
        end
      elseif self.stage == QueenOfBloodActivityState.activityEndShow then
        self.textBubbleMain:SetLocalText("s1_QueenChallenge_result_tips4")
      end
    end
  end
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
end

function UIOffSeason1QueenOfBloodMain:InitScrollView()
  local count = 0
  if self.monsterInfo and 0 < #self.monsterInfo then
    count = #self.monsterInfo
    for i = 1, count do
      local parent = self.bossContent
      local item = self.queenOfBloodItems[i]
      if item == nil then
        local go = self.queenOfBloodItemPool:GameObjectSpawn(parent.transform)
        go.name = "item" .. i
        item = parent:AddComponent(CityItem, go.name)
        self.queenOfBloodItems[i] = item
      else
        item.gameObject.transform:SetParent(parent.transform)
      end
      item:SetActive(true)
      item:ReInit(0, self.monsterInfo[i])
    end
  end
  if self.cityInfo and 0 < #self.cityInfo then
    local index = 1
    local oldCount = count
    count = oldCount + #self.cityInfo
    for i = oldCount + 1, count do
      local parent = self.cityContent
      local item = self.queenOfBloodItems[i]
      if item == nil then
        local go = self.queenOfBloodItemPool:GameObjectSpawn(parent.transform)
        go.name = "item" .. i
        item = parent:AddComponent(CityItem, go.name)
        self.queenOfBloodItems[i] = item
      else
        item.gameObject.transform:SetParent(parent.transform)
      end
      item:SetActive(true)
      item:ReInit(index, self.cityInfo[index])
      index = index + 1
    end
  end
  for i = count + 1, #self.queenOfBloodItems do
    local item = self.queenOfBloodItems[i]
    if item then
      item:SetActive(false)
    end
  end
end

function UIOffSeason1QueenOfBloodMain:ClearContent()
  self.bossContent:RemoveComponents(CityItem)
  self.cityContent:RemoveComponents(CityItem)
  self.queenOfBloodItemPool:GameObjectRecycleAll()
  self.queenOfBloodItems = nil
end

function UIOffSeason1QueenOfBloodMain:OnPushBloodyQueenS1RestActivityInfoUpdateInView(msg)
  SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainActivityInfo, msg.updateType, msg.extendInfo)
end

function UIOffSeason1QueenOfBloodMain:RefreshRedDot()
  self.redPoint:SetDefaultVisible(DataCenter.OffSeason1TaskDataManager:GetRedDotNum(tonumber(OffSeason1TaskGroup.QueenOfBlood)) > 0)
end

function UIOffSeason1QueenOfBloodMain:RefreshRankBtnShow()
  local activityCount = DataCenter.OffSeason1QueenOfBloodManager.activityCount
  local state = DataCenter.OffSeason1QueenOfBloodManager.activityState
  if 1 < activityCount or state == QueenOfBloodActivityState.postBattleShow or state == QueenOfBloodActivityState.activityEndShow then
    self.btnRank:SetActive(true)
  else
    self.btnRank:SetActive(false)
  end
end

function UIOffSeason1QueenOfBloodMain:RefreshDownTip()
  self.text1Tip:SetActive(false)
  self.text2Tip:SetActive(false)
  self.text3Tip:SetActive(false)
  if self.stage == QueenOfBloodActivityState.preBattleShow then
    self.text1Tip:SetActive(true)
    self.text2Tip:SetActive(true)
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      self.text1Tip:SetLocalText("s1_QueenChallenge_ready_tips_signUpCount", DataCenter.OffSeason1QueenOfBloodManager:GetCanChooseNum())
    else
      self.text1Tip:SetLocalText("s1_QueenChallenge_ready_tips_signUp")
    end
  elseif self.stage == QueenOfBloodActivityState.preBattleShowNoApplication then
    self.text3Tip:SetActive(true)
    self.text3Tip:SetLocalText("s1_QueenChallenge_ready_tips_signUpEnd")
  end
end

return UIOffSeason1QueenOfBloodMain
