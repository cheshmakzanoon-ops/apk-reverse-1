local UIParkourBattleLoseView = BaseClass("UIParkourBattleLoseView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGrowthList = require("UI.UIParkour.LoseUI.Component.UIParkourBattleResultGrowthList")
local UIStatisticList = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroList")

function UIParkourBattleLoseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
  self:Show()
  self.waitingForMsg = false
  CommonUtil.PlayerPrefsSetInt("PveLevelLosed", 1)
end

function UIParkourBattleLoseView:OnDestroy()
  base.OnDestroy(self)
  if self.delayCheck then
    self.delayCheck:Stop()
    self.delayCheck = nil
  end
  if self.delayLoseGuideTimer then
    self.delayLoseGuideTimer:Stop()
    self.delayLoseGuideTimer = nil
  end
end

function UIParkourBattleLoseView:ComponentDefine()
  local param = self:GetUserData()
  self.canvasGroup = self.transform:Find("Root").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.tryAgainBtn = self:AddComponent(UIButton, "Root/btnLayout/TryAgainBtn")
  self.tryAgainBtn:SetOnClick(function()
    self:OnTryAgainBtnClick()
  end)
  self.tryAgainBtnText = self:AddComponent(UIText, "Root/btnLayout/TryAgainBtn/TryAgainBtnText")
  self.tryAgainBtnText:SetText(Localization:GetString("134021"))
  self.backBtn = self:AddComponent(UIButton, "BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.helpInfo = self:AddComponent(UIBaseContainer, "Root/helpInfo")
  self.helpInfo:SetActive(false)
  self.helpBtn = self:AddComponent(UIButton, "Root/helpInfo/helpBtn")
  self.helpBtn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.helpBtnText = self:AddComponent(UITextMeshProUGUIEx, "Root/helpInfo/helpBtn/HelpBtnText")
  self.helpCountDownText = self:AddComponent(UITextMeshProUGUIEx, "Root/helpInfo/helpCountDownText")
  self.helpBtnText:SetLocalText("frontline_help_fail_01")
  self.isHideHelpBtn = true
  self.jumpBtn = self:AddComponent(UIButton, "Root/btnLayout/JumpBtn")
  self.jumpBtn:SetOnClick(function()
    self:OnJumpBtnClick()
  end)
  self.jumpBtnText = self:AddComponent(UIText, "Root/btnLayout/JumpBtn/JumpBtnText")
  self.jumpBtnText:SetLocalText("110171")
  self.defeatText = self:AddComponent(UIText, "Root/Top/BattleDefeatPanel_ani/DefeatGo/DefeatText")
  self.defeatText:SetText(Localization:GetString("311106"))
  self.levelText = self:AddComponent(UIText, "Root/Top/LevelText")
  self.timeText = self:AddComponent(UIText, "Root/Top/TimeText")
  self.killNumText = self:AddComponent(UIText, "Root/Top/KillNumText")
  self.space = self:AddComponent(UIBaseContainer, "Root/space")
  self.ActFrontBreakTopRank = self:AddComponent(UIBaseContainer, "Root/TopRank")
  self.ActFrontBreakTopRTitile = self:AddComponent(UIText, "Root/TopRank/TopRTitle")
  self.ActFrontBreakTopRTitile:SetText(Localization:GetString("activity_breakthrough_tips_37"))
  self.ActFrontBreakTopRSrcNum = self:AddComponent(UIText, "Root/TopRank/TopRSrcNum")
  self.ActFrontBreakTopRTargetNum = self:AddComponent(UIText, "Root/TopRank/TopRTargetNum")
  self.ActFrontBreakALRank = self:AddComponent(UIBaseContainer, "Root/ALRank")
  self.ActFrontBreakALRTitile = self:AddComponent(UIText, "Root/ALRank/ALRTitle")
  self.ActFrontBreakALRTitile:SetText(Localization:GetString("activity_breakthrough_tips_13"))
  self.ActFrontBreakALRSrcNum = self:AddComponent(UIText, "Root/ALRank/ALRSrcNum")
  self.ActFrontBreakALRTargetNum = self:AddComponent(UIText, "Root/ALRank/ALRTargetNum")
  self.ActFrontBreakServerRank = self:AddComponent(UIBaseContainer, "Root/ServerRank")
  self.ActFrontBreakServerRTitile = self:AddComponent(UIText, "Root/ServerRank/SRTitle")
  self.ActFrontBreakServerRTitile:SetText(Localization:GetString("activity_breakthrough_tips_14"))
  self.ActFrontBreakServerRSrcNum = self:AddComponent(UIText, "Root/ServerRank/SRSrcNum")
  self.ActFrontBreakServerRTargetNum = self:AddComponent(UIText, "Root/ServerRank/SRTargetNum")
  self.ActFrontBreakRemainSolider = self:AddComponent(UIBaseContainer, "Root/RemainSolider")
  self.ActFrontBreakRemainSoliderTitle = self:AddComponent(UIText, "Root/RemainSolider/RemainTitle")
  self.ActFrontBreakRemainSoliderTitle:SetText(Localization:GetString("activity_breakthrough_tips_25"))
  self.ActFrontBreakRemainSoliderCount = self:AddComponent(UIText, "Root/RemainSolider/RemainCount")
  self.ActFrontBreakTotalRemainSoliderNewRecord = self:AddComponent(UIBaseContainer, "Root/RemainSolider/RemainCount/NewRecord")
  self.ActFrontBreakTotalRemainSoliderNewRecordTitle = self:AddComponent(UIText, "Root/RemainSolider/RemainCount/NewRecord/RecordTitle")
  self.ActFrontBreakTotalRemainSoliderNewRecordTitle:SetLocalText("activity_breakthrough_tips_30")
  self.FrontBreakSundayRankTip = self:AddComponent(UIBaseContainer, "Root/FrontBreakSundayRankTips")
  self.FrontBreakSundayRankCriteriaLabel = self:AddComponent(UIText, "Root/FrontBreakSundayRankTips/RankCriteriaLabel")
  self.FrontBreakSundayRankCriteriaLabel:SetLocalText("activity_breakthrough_tips_38")
  self.FrontBreakSundayRankCriteriaStageLabel = self:AddComponent(UIText, "Root/FrontBreakSundayRankTips/CriteriaStageLabel")
  self.FrontBreakSundayRankCriteriaRemainSoliderLabel = self:AddComponent(UIText, "Root/FrontBreakSundayRankTips/CriteriaRemainSolider")
  self.tabRoot = self:AddComponent(UIBaseContainer, "Root/Tabs")
  self.tabBtns = {
    self:AddComponent(UIButton, "Root/Tabs/GuideBtn"),
    self:AddComponent(UIButton, "Root/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Root/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  self.tabComps = {
    self:AddComponent(UIGrowthList, "Root/GrowGuideScroll", self.ctrl, self),
    self:AddComponent(UIStatisticList, "Root/MakeDmgScroll", "makeDmg"),
    self:AddComponent(UIStatisticList, "Root/TakeDmgScroll", "takeDmg")
  }
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Root/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Root/Tabs/GuideBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/GuideBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800799)
  self.transform:Find("Root/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Root/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Root/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.videoLink = self:AddComponent(UIBaseContainer, "Root/VideoLink")
  self.videoBtn = self:AddComponent(UIButton, "Root/VideoLink/VideoBtn")
  self.videoBtn:SetOnClick(function()
    self:OnVideoBtnClick()
  end)
  self.videoBtnText = self:AddComponent(UIText, "Root/VideoLink/VideoBtn/VideoBtnText")
  self.videoBtnText:SetText(Localization:GetString("breakthough_tips_06"))
  self.shareBtn = self:AddComponent(UIButton, "ShareBtn")
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.emptyGroupContainer = self:AddComponent(UIBaseContainer, "Root/emptyGroup")
  self.btnGroupContainer = self:AddComponent(UIBaseContainer, "Root/btnLayout")
  self.btnGroupLayoutElement = self:AddComponent(UILayoutElement, "Root/btnLayout")
  self.emptyGroupContainer:SetActive(false)
  self.btnGroupLayoutElement:SetIgnoreLayout(false)
end

function UIParkourBattleLoseView:ComponentDestroy()
  self.back_btn = nil
end

function UIParkourBattleLoseView:OnRefreshFirstPay()
  self:RefreshView()
end

function UIParkourBattleLoseView:RefreshView()
  local param = self:GetUserData()
  local time = param.time
  local kill = param.kill
  local stageId = param.stageId
  self.backBtn:SetActive(not (DataCenter.LWGuideManager:GetCurGuideId() < GuideState.CityCopter))
  local fromActFrontBreakSunday = param.fromActFrontBreakSunday
  local levelTitle = ""
  if fromActFrontBreakSunday then
    local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId)
    local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
    levelTitle = Localization:GetString("activity_breakthrough_tips_19", stageIdIndex, stagesCount)
  else
    local levelTitlePrefixKey = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "name")
    local order = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order")
    levelTitle = Localization:GetString(levelTitlePrefixKey, order)
  end
  self.levelText:SetText(levelTitle)
  local showStatistic = param.showStatistic
  if showStatistic then
    for i, tabComp in ipairs(self.tabComps) do
      if i == self.tabIdx then
        tabComp:SetActive(true)
        tabComp:RefreshView()
        tabComp:FadeIn()
      else
        tabComp:SetActive(false)
      end
    end
  end
  local isInAlliance = LuaEntry.Player:IsInAlliance()
  if DataCenter.LWBattleManager:GetPVEEnterType() == PVEEnterType.Radar then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    self.shareBtn:SetActive(false)
  elseif param.fromChapter then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    self.shareBtn:SetActive(false)
    local isEasyStageFeatureSkippedStage = DataCenter.LWEasyStageFeatureChapterManager:IsSkipStage(param.stageId)
    local isStageFeatureSkippedStage = DataCenter.LWStageFeatureChapterManager:IsSkipStage(param.stageId)
    local isStageFeatureResetedStage = DataCenter.LWStageFeatureChapterManager:IsStageReseted(param.stageId)
    if not isEasyStageFeatureSkippedStage and not isStageFeatureSkippedStage and not isStageFeatureResetedStage and not param.isChapterHelp then
      local failSkipNum = param.chapterFailSkipNum or 0
      if 0 < failSkipNum then
        local curStageInNormalModeFailedNum = DataCenter.LWStageFeatureChapterManager:GetFailCount(param.stageId)
        local curStageInEasyModeFailedNum = DataCenter.LWEasyStageFeatureChapterManager:GetFailCount(param.stageId)
        if failSkipNum <= curStageInNormalModeFailedNum or failSkipNum < curStageInEasyModeFailedNum then
          self.jumpBtn:SetActive(true)
        end
      end
    end
    local isHelpShareOn = DataCenter.LWStageFeatureChapterManager:IsHelpShareFunctionOn()
    local currentChapterCfg = DataCenter.LWStageFeatureChapterManager:GetStageBelongsChapterCfgData(stageId)
    if isHelpShareOn and isInAlliance and not param.isChapterHelp and not isStageFeatureResetedStage and currentChapterCfg then
      self.helpInfo:SetActive(true)
      self.isHideHelpBtn = false
    else
      self.helpInfo:SetActive(false)
      self.isHideHelpBtn = true
    end
  elseif showStatistic then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    self.shareBtn:SetActive(false)
  elseif param.fromActFrontBreakSunday then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    local index = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(stageId) or 0
    self.shareBtn:SetActive(1 < index)
  elseif param.enterType == PVEEnterType.DetectCaveExploreEnter or param.enterType == PVEEnterType.DetectAttackCityS0 then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    self.tryAgainBtn:SetActive(false)
    self.shareBtn:SetActive(false)
  elseif param.enterType == PVEEnterType.HeroTryOut then
    self.backBtn:SetActive(true)
    self.jumpBtn:SetActive(false)
    self.tryAgainBtn:SetActive(false)
    self.shareBtn:SetActive(false)
  else
    self.backBtn:SetActive(false)
    self.jumpBtn:SetActive(true)
    self.shareBtn:SetActive(false)
  end
  local toShowVideoBtn = param.loseToShowVideo
  self.videoLink:SetActive(toShowVideoBtn)
  self.loseToShowVideoURL = param.loseToShowVideoURL
  if showStatistic then
    self.tabRoot:SetActive(true)
    self.ActFrontBreakTopRank:SetActive(false)
    self.ActFrontBreakALRank:SetActive(false)
    self.FrontBreakSundayRankTip:SetActive(false)
    self.ActFrontBreakServerRank:SetActive(false)
    self.ActFrontBreakRemainSolider:SetActive(false)
    self.space:SetActive(false)
    self.killNumText:SetText(nil)
    self.timeText:SetText(nil)
  else
    self.tabRoot:SetActive(false)
    for i, tabComp in ipairs(self.tabComps) do
      tabComp:SetActive(false)
    end
    if param.fromActFrontBreakSunday then
      self.space:SetActive(false)
      self.killNumText:SetText(nil)
      self.timeText:SetText(nil)
      local topRankOld = param.topRankOld or 0
      local topRankNew = param.topRankNew or 0
      self.ActFrontBreakTopRank:SetActive(0 < topRankNew and (topRankOld == 0 or topRankOld > topRankNew))
      self.ActFrontBreakTopRSrcNum:SetText(topRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or topRankOld)
      self.ActFrontBreakTopRTargetNum:SetText(topRankNew)
      local alRankOld = param.alRankOld or 0
      local alRankNew = param.alRankNew or 0
      self.ActFrontBreakALRank:SetActive(isInAlliance and 0 < alRankNew and (alRankOld == 0 or alRankOld > alRankNew))
      self.ActFrontBreakALRSrcNum:SetText(alRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or alRankOld)
      self.ActFrontBreakALRTargetNum:SetText(alRankNew)
      local serRankOld = param.serRankOld or 0
      local serRankNew = param.serRankNew or 0
      self.ActFrontBreakServerRank:SetActive(0 < serRankNew and (serRankOld == 0 or serRankOld > serRankNew))
      self.ActFrontBreakServerRSrcNum:SetText(serRankOld == 0 and Localization:GetString("activity_breakthrough_tips_16") or serRankOld)
      self.ActFrontBreakServerRTargetNum:SetText(serRankNew)
      self.ActFrontBreakRemainSolider:SetActive(true)
      self.ActFrontBreakRemainSoliderCount:SetText(string.format("x%d", param.totalLeft or 0))
      local newRecord = param.newRecord and true or false
      self.ActFrontBreakTotalRemainSoliderNewRecord:SetActive(newRecord)
      self.FrontBreakSundayRankTip:SetActive(true)
      local criteriaStage = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaStage(param.frontBreakSundayActId)
      self.FrontBreakSundayRankCriteriaStageLabel:SetLocalText("activity_breakthrough_tips_15", criteriaStage)
      local criteriaRemainSolider = DataCenter.ActFrontBreakSundayDataManager:GetTopRankCriteriaRemainSolider(param.frontBreakSundayActId)
      self.FrontBreakSundayRankCriteriaRemainSoliderLabel:SetText(string.format("x%d", criteriaRemainSolider))
    else
      self.space:SetActive(true)
      self.ActFrontBreakTopRank:SetActive(false)
      self.ActFrontBreakALRank:SetActive(false)
      self.FrontBreakSundayRankTip:SetActive(false)
      self.ActFrontBreakServerRank:SetActive(false)
      self.ActFrontBreakRemainSolider:SetActive(false)
      self.killNumText:SetText(Localization:GetString("800303") .. " " .. kill)
      self.timeText:SetText(Localization:GetString("800304") .. " " .. UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time))
    end
  end
end

function UIParkourBattleLoseView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:RefreshView()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 223, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UIParkourBattleLoseView:Show()
  self.delayLoseGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayLoseGuideTimer = nil
    self.canvasGroup:DOFade(1, 0.2)
    local param = self:GetUserData()
    if param and param.showStatistic then
      self.tabComps[1]:FirstTimeLoseGuide()
    end
  end, 1.5)
  self.delayCheck = TimerManager:GetInstance():DelayInvoke(function()
    self.delayCheck = nil
    self:CheckShowFirstPay()
  end, 2)
end

function UIParkourBattleLoseView:OnBackBtnClick()
  if self.waitingForMsg then
    return
  end
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local myStageId = tostring(battleLogic:GetStageId())
  local param = self:GetUserData()
  local isFromActFrontBreakSunday = param.fromActFrontBreakSunday
  if not isFromActFrontBreakSunday then
    PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 2})
  else
    DataCenter.LWBattleManager:SetBattleExitStartTime(BattleExitTimeLogType.ActFrontBreakSunday)
    local preLoadAssets = {
      [UIAssets.ActivityTabGroupItem] = true,
      [UIAssets.UIActivityListItem] = true,
      [UIAssets.FrontBreakSunday] = true
    }
    if param.totalLeft and param.totalLeft > 0 then
      DataCenter.ActFrontBreakSundayDataManager:SetNeedPlaySoliderFlyAnim(true)
    end
    GoToUtil.GotoOpenView_BattleReturnOpt(UIWindowNames.UIActivityCenterTable, preLoadAssets, param.frontBreakSundayActId, preLoadAssets)
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  DataCenter.LWBattleManager:Exit(nil, "lose")
end

function UIParkourBattleLoseView:OnVideoBtnClick()
  if self.loseToShowVideoURL then
    Logger.LogInfo("OnVideoBtnClick" .. self.loseToShowVideoURL)
    CS.SDKManager.OpenURL(self.loseToShowVideoURL)
  end
end

function UIParkourBattleLoseView:CheckShowFirstPay()
  local monopolyEnter
  local param = self:GetUserData()
  if param and param.enterType and param.enterType == PVEEnterType.Monopoly then
    monopolyEnter = true
  end
  local realShow
  local curMonopoly = DataCenter.MonopolyManager.player.curId
  if monopolyEnter then
    local endCount = LuaEntry.DataConfig:TryGetNum("first_cost_intensifying", "k2", -1)
    if -1 < endCount and curMonopoly > endCount then
      realShow = false
    else
      realShow = true
    end
  end
  local hasFirstPayGift = false
  if realShow then
    local isNewFirstPay = DataCenter.FirstPayManager:IsNewFirstPay()
    if isNewFirstPay then
      local firstPayPack = DataCenter.FirstPayManager:GetFirstPayPack()
      hasFirstPayGift = firstPayPack ~= nil
    else
      local firstPayState = DataCenter.FirstPayManager:GetState()
      hasFirstPayGift = firstPayState >= FirstPayState.Unrepaired and firstPayState < FirstPayState.HasReceivedNormalReward
    end
  end
end

function UIParkourBattleLoseView:OnTryAgainBtnClick()
  if self.waitingForMsg then
    return
  end
  self.ctrl:CloseSelf()
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
  local param = self:GetUserData()
  local isFromActFrontBreakSunday = param.fromActFrontBreakSunday
  if isFromActFrontBreakSunday then
    DataCenter.LWBattleManager:Destroy()
    local actId = param.frontBreakSundayActId
    local stageId = DataCenter.ActFrontBreakSundayDataManager:GetNextStageId(actId)
    DataCenter.ActFrontBreakSundayDataManager:RequestToEnterStage(stageId)
  else
    DataCenter.LWBattleManager:Restart()
    local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
    local myStageId = tostring(battleLogic:GetStageId())
    PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 1})
  end
end

function UIParkourBattleLoseView:OnJumpBtnClick()
  if self.waitingForMsg then
    return
  end
  local param = self:GetUserData()
  if param and param.fromChapter then
    if param.stageId then
      DataCenter.LWStageFeatureChapterManager:SendSkipMessage(param.stageId)
      PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {
        stageId = param.stageId,
        isSkip = 0
      })
      return
    end
    self:OnBackBtnClick()
    return
  end
  self.waitingForMsg = true
  self:AddUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
  DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()
  local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
  local myStageId = tostring(battleLogic:GetStageId())
  PostEventLog.Track(PostEventLog.Defines.BattleParkourSkip, {stageId = myStageId, isSkip = 0})
end

function UIParkourBattleLoseView:OnJumpConfirmed(pveType)
  if pveType == PVEType.Parkour then
    self:RemoveUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit(nil, "win")
  end
end

function UIParkourBattleLoseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnRefreshFirstPay)
  self:AddUIListener(EventId.StageFeatureChapterSkip, self.OnStageFeatureChapterSkip)
end

function UIParkourBattleLoseView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnRefreshFirstPay)
  self:RemoveUIListener(EventId.StageFeatureChapterSkip, self.OnStageFeatureChapterSkip)
  base.OnRemoveListener(self)
end

function UIParkourBattleLoseView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIParkourBattleLoseView:OnShareBtnClick()
  local stage_share_time = CommonUtil.PlayerPrefsGetLong(SettingKeys.STAGE_FEATURE_SHARE_TIME, 0)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaMinTime = LuaEntry.DataConfig:TryGetNum("Breakthrough_config", "k3", 0) * 1000
  if curTime <= stage_share_time + deltaMinTime then
    UIUtil.ShowTips(Localization:GetString("breakthough_tips_03"))
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.param = {}
  local stageId = param.stageId or 0
  shareParam.param.stageId = stageId
  if param.fromChapter then
    shareParam.post = PostType.STAGE_FEATURE_CHAPTER
    local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order") or 0
    shareParam.param.stageOrder = stageOrder
    shareParam.param.fromChapter = true
    shareParam.param.score = param.score or 0
    shareParam.param.rank = param.rank or 0
  elseif param.fromActFrontBreakSunday then
    shareParam.post = PostType.FrontBreakSunday
    shareParam.param.fromActFrontBreakSunday = true
    shareParam.param.win = false
    shareParam.param.totalLeft = param.totalLeft or 0
    shareParam.param.frontBreakSundayActId = param.frontBreakSundayActId
    shareParam.param.ActFrontBreakTopRankOld = param.topRankOld or 0
    shareParam.param.ActFrontBreakTopRankNew = param.topRankNew or 0
    shareParam.param.ActFrontBreakAlRankOld = param.alRankOld or 0
    shareParam.param.ActFrontBreakAlRankNew = param.alRankNew or 0
    shareParam.param.ActFrontBreakSerRankOld = param.serRankOld or 0
    shareParam.param.ActFrontBreakSerRankNew = param.serRankNew or 0
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
end

function UIParkourBattleLoseView:OnStageFeatureChapterSkip()
  local param = self:GetUserData()
  if param and param.fromChapter and param.stageId then
    local isStageFeatureChapterSkippedStage = DataCenter.LWStageFeatureChapterManager:IsSkipStage(param.stageId)
    local isEasyStageFeatureChapterSkippedStage = DataCenter.LWEasyStageFeatureChapterManager:IsSkipStage(param.stageId)
    if isStageFeatureChapterSkippedStage or isEasyStageFeatureChapterSkippedStage then
      self.ctrl:CloseSelf()
      DataCenter.LWBattleManager:Exit(nil, "quit")
      return
    end
  end
  self:OnBackBtnClick()
end

function UIParkourBattleLoseView:OnHelpBtnClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId("city_war_tips_02")
    return
  end
  local param = self:GetUserData()
  local shareParam = {}
  shareParam.post = PostType.StageFeatureHelpInvite
  shareParam.param = {}
  local stageId = param.stageId or 0
  shareParam.param.stageId = stageId
  if param.fromChapter then
    local stageOrder = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), stageId, "order") or 0
    shareParam.param.stageOrder = stageOrder
    shareParam.param.fromChapter = true
    shareParam.param.score = param.score or 0
    shareParam.param.rank = param.rank or 0
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
  PostEventLog.Track(PostEventLog.Defines.C_clickLoseShareBtn)
end

function UIParkourBattleLoseView:Update1000MS()
  if self.isHideHelpBtn then
    return
  end
  local isMeetHelpShareCd, leftTime = DataCenter.LWStageFeatureChapterManager:IsMeetShareCd()
  if isMeetHelpShareCd then
    UIGray.SetGray(self.helpBtn.transform, false, true)
    self.helpCountDownText:SetText("")
  else
    UIGray.SetGray(self.helpBtn.transform, true, false)
    local str = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(leftTime / 1000)
    self.helpCountDownText:SetLocalText("frontline_help_fail_02", str)
  end
end

return UIParkourBattleLoseView
