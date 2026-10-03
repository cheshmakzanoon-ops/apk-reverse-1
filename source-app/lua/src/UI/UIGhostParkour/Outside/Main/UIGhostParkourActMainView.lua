local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIGhostParkourActMainView = BaseClass("UIGhostParkourActMainView", base)
local RewardItem = require("UI.UIGhostParkour.Outside.RewardBox.GhostParkourRewardBox")
local Localization = CS.GameEntry.Localization
local UICommonRedPoint = require("Framework.UI.Component.UICommonRedPoint")

function UIGhostParkourActMainView:OnCreate()
  base.OnCreate(self)
  DataCenter.LWBattleManager:SetBattleExitEndTime(BattleExitTimeLogType.GhostParkour)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGhostParkourActMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourActMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgImgbg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textSubTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnScore = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnScore:SetOnClick(function()
    self:OnBtnScoreClick()
  end)
  self.textScoreTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textScoreNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnGuide = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnGuide:SetOnClick(function()
    self:OnBtnGuideClick()
  end)
  self.textGuide = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.rewardCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 12)
  self.textBox = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.rawImgRankImg = self.viewSkin:AddComponent(self, UIRawImage, 15)
  self.rankCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 16)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textRewardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 19)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 20)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 21)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 22)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textGoBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.textRemainTimes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.textEmptyTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 25)
  self.textTimeCountDownTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.btnChallenge = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnChallenge:SetOnClick(function()
    self:OnBtnChallengeClick()
  end)
  self.textChallenge = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.rectChallenge = self.viewSkin:AddComponent(self, UIBaseContainer, 30)
  self.scoreCommonRedPoint = self.viewSkin:AddComponent(self, UICommonRedPoint, 31)
  self.effect = self.viewSkin:AddComponent(self, UIBaseContainer, 32)
  self.rewardItem = self:AddComponent(UIBaseComponent, "SafeArea/bottom/rectChallenge/progressArea/progress/ScrollView/Viewport/Content/rewardBox")
  self.rewardItem.gameObject:SetActive(false)
  self.rewardItemPool = self.rewardItem.gameObject
  self.rewardItemPool:GameObjectCreatePool()
  self.rewardItems = {}
  self.rewardCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.rewardCommonRedPoint:SetActive(false)
  self.rankCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.rankCommonRedPoint:SetActive(false)
  self.scoreCommonRedPoint:SetType(CommonRedPointPriority.Level1)
  self.scoreCommonRedPoint:SetActive(false)
end

function UIGhostParkourActMainView:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgImgbg = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.textRemainTime = nil
  self.textSubTitle = nil
  self.btnScore = nil
  self.textScoreTitle = nil
  self.textScoreNum = nil
  self.btnGuide = nil
  self.textGuide = nil
  self.btnReward = nil
  self.rewardCommonRedPoint = nil
  self.textBox = nil
  self.btnRank = nil
  self.rawImgRankImg = nil
  self.rankCommonRedPoint = nil
  self.textRank = nil
  self.textRewardTips = nil
  self.slider = nil
  self.scrollRect = nil
  self.content = nil
  self.btnGo = nil
  self.textGoBtn = nil
  self.textRemainTimes = nil
  self.textEmptyTips = nil
  self.textTimeCountDownTips = nil
  self.btnChallenge = nil
  self.textChallenge = nil
  self.btnRecord = nil
  self.rectChallenge = nil
  self.scoreCommonRedPoint = nil
  self.effect = nil
  self.rewardItem = nil
end

function UIGhostParkourActMainView:DataDefine()
end

function UIGhostParkourActMainView:DataDestroy()
  self:ClearContent()
  self.personalBattlePassList = nil
end

function UIGhostParkourActMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourMainUIRefresh, self.InitData)
  self:AddUIListener(EventId.GhostParkourPersonalBPRefresh, self.UpdateRewardBoxList)
  self:AddUIListener(EventId.GhostParkourMainHandArrow, self.ShowArrowHand)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
  self:AddUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdateRedPoint)
  self:AddUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateRedPoint)
end

function UIGhostParkourActMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateRedPoint)
  self:RemoveUIListener(EventId.GhostParkourMainUIRefresh, self.InitData)
  self:RemoveUIListener(EventId.GhostParkourPersonalBPRefresh, self.UpdateRewardBoxList)
  self:RemoveUIListener(EventId.GhostParkourMainHandArrow, self.ShowArrowHand)
  self:RemoveUIListener(EventId.GhostParkourTypeRankPraiseRefresh, self.UpdateRedPoint)
  self:RemoveUIListener(EventId.GhostParkourChallengeBtnRed, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

function UIGhostParkourActMainView:OnEnable()
  base.OnEnable(self)
  DataCenter.LWGhostParkourDataManager:SendGetGhostParkourInfosMessage(true)
end

function UIGhostParkourActMainView:OnBtnInfoClick()
  if self.activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = self.activityData.howtoplay
  param.defaultTitle = self.activityData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UIGhostParkourActMainView:OnBtnScoreClick()
  if LuaEntry.Player:IsInAlliance() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankPanelView, GhostParkourTypeRank.AllianceRank)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankPanelView, GhostParkourTypeRank.ServerRank)
  end
end

function UIGhostParkourActMainView:OnBtnGuideClick()
  local param = {}
  param.type = PVEType.GhostParkour
  param.levelId = 70001
  param.enterType = PVEEnterType.Guide
  DataCenter.LWBattleManager:Enter(param)
end

function UIGhostParkourActMainView:OnBtnRewardClick()
  if not LuaEntry.Player:IsInAlliance() then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
    end
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourAllianceRewardView)
end

function UIGhostParkourActMainView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRankPageView)
end

function UIGhostParkourActMainView:OnBtnGoClick()
  local restDay = self:GetNowIsRestDay()
  if restDay then
    UIUtil.ShowTipsId("ghost_parkour_off_season_desc")
    return
  end
  local guideRewarded = DataCenter.LWGhostParkourDataManager:IsGuideReward()
  if not guideRewarded then
    self:OnBtnGuideClick()
    return
  end
  local curTs = UITimeManager:GetInstance():GetServerTime()
  if self.clickTs == nil then
    self.clickTs = curTs
  elseif curTs - self.clickTs <= 500 then
    return
  end
  self.clickTs = curTs
  DataCenter.LWGhostParkourDataManager:CheckDeviceLevel(function()
    self:HandleEnterGame()
  end)
end

function UIGhostParkourActMainView:UpdateRedPoint()
  local redAlliance = DataCenter.LWGhostParkourDataManager:AllianceRewardRedPoint()
  self.rewardCommonRedPoint:SetDefaultVisible(redAlliance)
  local redTier = DataCenter.LWGhostParkourDataManager:AllTierRewardRedPoint()
  self.rankCommonRedPoint:SetDefaultVisible(redTier)
  local redRankThumbsUp = DataCenter.LWGhostParkourDataManager:GetRankItemThumbsUpRedPoint()
  local redRankChallenge = DataCenter.LWGhostParkourDataManager:GetRankItemChallengeRedPoint()
  self.scoreCommonRedPoint:SetDefaultVisible(redRankThumbsUp or redRankChallenge)
end

function UIGhostParkourActMainView:HandleEnterGame()
  local curTs = UITimeManager:GetInstance():GetServerTime()
  local battleEndTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  local leftTime = battleEndTime - curTs
  local fixTime = DataCenter.LWGhostParkourDataManager:GetDelayTime()
  if leftTime < fixTime and 0 < leftTime then
    local param = {
      contentText = Localization:GetString("ghost_parkour_count_down_minute"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          DataCenter.LWGhostParkourDataManager:ReqFightMatch()
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.Ghost_Parkour_Enter_Button, param)
  else
    DataCenter.LWGhostParkourDataManager:ReqFightMatch()
  end
end

function UIGhostParkourActMainView:OnBtnRecordClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRecordPopView)
end

function UIGhostParkourActMainView:OnBtnChallengeClick()
end

function UIGhostParkourActMainView:SetData(actId)
  base.SetData(self, actId)
  self.activityId = actId
  if not self.activityId then
    return
  end
  DataCenter.LWGhostParkourDataManager:SetActivityId(self.activityId)
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textTitle:SetLocalText(self.activityData.activityName)
  self:InitData()
  self:UpdateRedPoint()
  self:Update1000MS()
end

function UIGhostParkourActMainView:InitData()
  local restDay = self:GetNowIsRestDay()
  self.textTimeCountDownTips.gameObject:SetActive(restDay)
  self.rectChallenge.gameObject:SetActive(not restDay)
  self.btnReward.gameObject:SetActive(not restDay)
  self.btnScore.gameObject:SetActive(not restDay)
  local endlessModeOpen = DataCenter.LWGhostParkourDataManager:GetEndlessModeSwitch()
  self.btnChallenge.gameObject:SetActive(endlessModeOpen)
  CS.UIGray.SetGray(self.btnGo.transform, restDay, true)
  local index = restDay and 2 or 1
  local infos = DataCenter.LWGhostParkourDataManager:GetMainUIDisplayInfo(self.activityId, index)
  if infos then
    self.rawImgImgbg:LoadSprite(string.format("Assets/Main/TextureEx/UIGhostParkour/MainBanner/%s.png", infos.icon))
  end
  self.effect.gameObject:SetActive(not restDay)
  if not restDay then
    self.textGoBtn:SetLocalText("ghost_parkour_start_match_btn")
    self:UpdateChallengeTimes()
    self:UpdateRewardBoxList()
    self:UpdateHightestScore()
  else
    self.textGoBtn:SetLocalText("ghost_parkour_off_season_btn")
  end
  local newRecord = DataCenter.LWGhostParkourDataManager:GetNewRecordList()
  if newRecord and 0 < #newRecord then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGhostParkourRecordListView)
  end
  self:UpdateRankBtnImage()
  self:CheckLogUpload()
  DataCenter.LWGhostParkourDataManager:CheckRoundFirstEnterAct()
end

function UIGhostParkourActMainView:UpdateRankBtnImage()
  local tier = DataCenter.LWGhostParkourDataManager:GetTier()
  if not string.IsNullOrEmpty(tier) then
    local config = DataCenter.ParkourScoreTierTemplateManager:GetTemplate(tier)
    local path = ""
    if config then
      path = config.icon
    end
    self.rawImgRankImg:LoadSpriteAsyncWithCallback(path, function(sprite)
      if self.rawImgRankImg then
        self.rawImgRankImg:SetNativeSize()
      end
    end)
  end
end

function UIGhostParkourActMainView:GetNowIsRestDay()
  local roundEndTime = DataCenter.LWGhostParkourDataManager:GetRoundEndTime()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  if round then
    self.textSubTitle:SetLocalText("ghost_parkour_round_title", round)
  else
    self.textSubTitle:SetLocalText("ghost_parkour_off_season_title")
  end
  if not roundEndTime and not round then
    return true
  end
  return false
end

function UIGhostParkourActMainView:UpdateHightestScore()
  local personalHightestScore = DataCenter.LWGhostParkourDataManager:GetPersonalHightestScore()
  if personalHightestScore == 0 then
    self.textScoreNum:SetLocalText("ghost_parkour_rank_no_data")
  else
    local time = UITimeManager:GetInstance():GetCompetitionTimeFormat(personalHightestScore)
    self.textScoreNum:SetText(time)
  end
end

function UIGhostParkourActMainView:UpdateChallengeTimes()
  local remainTimes = DataCenter.LWGhostParkourDataManager:GetRemainTimes()
  if remainTimes and 0 < remainTimes then
    self.textEmptyTips.gameObject:SetActive(false)
    self.btnGo.gameObject:SetActive(true)
    self.textRemainTimes.gameObject:SetActive(true)
    self.textRemainTimes:SetLocalText("ghost_parkour_match_count_desc", remainTimes)
  else
    self.textEmptyTips.gameObject:SetActive(true)
    self.btnGo.gameObject:SetActive(false)
    self.textRemainTimes.gameObject:SetActive(false)
  end
end

function UIGhostParkourActMainView:UpdateRewardBoxList()
  self.personalBattlePassList = DataCenter.LWGhostParkourDataManager:GetPersonalBattlePassList()
  local completed = true
  if self.personalBattlePassList then
    local count = #self.personalBattlePassList
    for i = 1, count do
      local item = self.rewardItems[i]
      if item == nil then
        local go = self.rewardItemPool:GameObjectSpawn(self.content.transform)
        go.name = "item" .. i
        item = self.content:AddComponent(RewardItem, go.name)
        self.rewardItems[i] = item
      else
        item.gameObject.transform:SetParent(self.content.transform)
      end
      item:SetActive(true)
      if self.personalBattlePassList[i].state ~= TaskState.Received then
        completed = false
      end
      item:ReInit(self.personalBattlePassList[i], i)
    end
    for i = count + 1, #self.rewardItems do
      local item = self.rewardItems[i]
      if item then
        item:SetActive(false)
      end
    end
  end
  local score = DataCenter.LWGhostParkourDataManager:GetPersonalBattleProgressScore()
  local progress = 0
  if not table.IsNullOrEmpty(self.personalBattlePassList) then
    local firstStep = 0
    local num = #self.personalBattlePassList - 1
    if num == 0 then
      num = 1
    end
    local otherStep = (1 - firstStep) / num
    local lastNeedScore = 0
    for i, v in ipairs(self.personalBattlePassList) do
      local curStageStep = i == 1 and firstStep or otherStep
      local needScore = GetTableData(TableName.lw_parkour_battle_pass, v.id, "score")
      if v.state == 1 or score >= needScore then
        progress = progress + curStageStep
        lastNeedScore = needScore
      else
        progress = progress + curStageStep * (score - lastNeedScore) / (needScore - lastNeedScore)
        break
      end
    end
    progress = 1 < progress and 1 or progress
  end
  self.slider:SetValue(progress)
  if completed then
    self.textRewardTips:SetLocalText("ghost_parkour_today_finish_desc")
  else
    self.textRewardTips:SetLocalText("ghost_parkour_task_desc")
  end
end

function UIGhostParkourActMainView:ClearContent()
  self.content:RemoveComponents(RewardItem)
  self.rewardItemPool:GameObjectRecycleAll()
  self.rewardItems = nil
end

function UIGhostParkourActMainView:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityData.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
  local restDay = self:GetNowIsRestDay()
  local nextRoundTime = DataCenter.LWGhostParkourDataManager:GetNextRoundTime()
  if restDay and nextRoundTime then
    local leftTime2 = nextRoundTime - curTime
    if leftTime2 < 0 then
      leftTime2 = 0
    end
    local countDownTimeStr2 = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime2)
    self.textTimeCountDownTips:SetLocalText("ghost_parkour_countdown_desc", countDownTimeStr2)
  end
end

function UIGhostParkourActMainView:ShowArrowHand()
  local param = {}
  param.positionType = PositionType.Screen
  local targetRoot = self.btnGo
  param.position = targetRoot.transform.position + Vector3.New(50, -50, 0)
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

function UIGhostParkourActMainView:CheckLogUpload()
  if self.isUpload then
    return
  end
  self.isUpload = true
  local notSyncUuidList = DataCenter.LWGhostParkourDataManager:GetNotSyncUuidList()
  if table.IsNullOrEmpty(notSyncUuidList) then
    return
  end
  local GhostParkourLogger = require("Scene.LWBattle.GhostParkour.GhostParkourLogger")
  local ghostParkourLogger = GhostParkourLogger.New(PVELogFuncType.GhostParkour)
  local beginTime = DataCenter.LWGhostParkourDataManager:GetBeginTime()
  local curTs = UITimeManager:GetInstance():GetServerSeconds()
  for _, v in ipairs(notSyncUuidList) do
    if v and not DataCenter.LWGhostParkourDataManager:CheckFileUploading(v) then
      DataCenter.LWGhostParkourDataManager:AddUploadingFile(v, curTs)
      ghostParkourLogger:UploadFile(v, function(uuid, succeed)
        DataCenter.LWGhostParkourDataManager:ReqSyncChallengeInfo(uuid, succeed)
        DataCenter.LWGhostParkourDataManager:RemoveUploadingFile(uuid)
      end, beginTime)
    end
  end
end

return UIGhostParkourActMainView
