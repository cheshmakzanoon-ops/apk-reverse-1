local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIS0AllianceBossMainView = BaseClass("UIS0AllianceBossMainView", base)
local UIS0AllianceBossSelectLevel = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSelectLevel")
local UIS0AllianceBossSliderAlliance = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderAlliance")
local UIS0AllianceBossSliderPersonal = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSliderPersonal")
local UIS0AllianceLastClearResult = require("UI.UIS0AllianceBoss.Component.UIS0AllianceLastClearResult")
local UILoopScrollDriver = require("UI.UIS0AllianceBoss.Component.UILoopScrollDriver")
local UIS0AllianceBossModelShowCtrl = require("UI.UIS0AllianceBoss.Scene.UIS0AllianceBossModelShowCtrl")
local Localization = CS.GameEntry.Localization
local GOTO_BTN_FLAG = {
  None = 0,
  Appoint = 1,
  Goto = 2,
  Lock = 3,
  LockMember = 4,
  GoBack = 5
}

function UIS0AllianceBossMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.btnIntro = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnIntro:SetOnClick(function()
    self:OnBtnIntroClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textRewardName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.textRecordName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.recordRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compMVPTipBubble = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 12)
  self.compDonateShow = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.btnGoToDonate = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnGoToDonate:SetOnClick(function()
    self:OnBtnGoToDonateClick()
  end)
  self.textTxtGoToDonate = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.donateRedPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.textTxtItem = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.compReservationTimeInfo = self.viewSkin:AddComponent(self, UIBaseContainer, 18)
  self.textTxtReservationTimeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textTxtReservationTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textTxtTimeZone = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.resItem = self.viewSkin:AddComponent(self, UICommonResItem, 22)
  self.textTxtGainsTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.compS0AllianceBossSelectLevel = self.viewSkin:AddComponent(self, UIS0AllianceBossSelectLevel, 24)
  self.compPersonal = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderPersonal, 25)
  self.compAlliance = self.viewSkin:AddComponent(self, UIS0AllianceBossSliderAlliance, 26)
  self.btnGoTo = self.viewSkin:AddComponent(self, UIButton, 27)
  self.btnGoTo:SetOnClick(function()
    self:OnBtnGoToClick()
  end)
  self.textTxtGoTo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 28)
  self.compCompleted = self.viewSkin:AddComponent(self, UIBaseContainer, 29)
  self.textTxtComplete = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 30)
  self.toggleOffline = self.viewSkin:AddComponent(self, UIToggle, 31)
  self.textToggle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.btnNextR = self.viewSkin:AddComponent(self, UIButton, 33)
  self.btnNextR:SetOnClick(function()
    self:OnBtnNextRClick()
  end)
  self.btnPreviousL = self.viewSkin:AddComponent(self, UIButton, 34)
  self.btnPreviousL:SetOnClick(function()
    self:OnBtnPreviousLClick()
  end)
  self.compLastClearResult = self.viewSkin:AddComponent(self, UIS0AllianceLastClearResult, 35)
  self.textNameRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.compDonateCritShow = self.viewSkin:AddComponent(self, UILoopScrollDriver, 37)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 38)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.timeSimpleAnim = self.viewSkin:AddComponent(self, UISimpleAnimation, 39)
  self.animatorRewardBubble = self.viewSkin:AddComponent(self, UIAnimator, 40)
  self.btnRewardBubble = self.viewSkin:AddComponent(self, UIButton, 41)
  self.btnRewardBubble:SetOnClick(function()
    self:OnBtnRewardBubbleClick()
  end)
  self.eventTrigger = self.viewSkin:AddComponent(self, UIEventTrigger, 42)
  self.compUIModel = self.viewSkin:AddComponent(self, UIS0AllianceBossModelShowCtrl, 43)
  self.compUIPlayerHead:SetEnableClickShowInfo(false, true)
  self.toggleOffline:SetOnValueChanged(function(isOn)
    self:OnToggleSelected(isOn)
  end)
  self.eventTrigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.eventTrigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.compDonateShow:SetActive(false)
end

function UIS0AllianceBossMainView:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgBg = nil
  self.btnIntro = nil
  self.textTitle = nil
  self.textTime = nil
  self.textDesc = nil
  self.btnReward = nil
  self.textRewardName = nil
  self.btnRecord = nil
  self.textRecordName = nil
  self.recordRedPoint = nil
  self.compMVPTipBubble = nil
  self.compUIPlayerHead = nil
  self.compDonateShow = nil
  self.btnGoToDonate = nil
  self.textTxtGoToDonate = nil
  self.donateRedPoint = nil
  self.textTxtItem = nil
  self.compReservationTimeInfo = nil
  self.textTxtReservationTimeTitle = nil
  self.textTxtReservationTime = nil
  self.textTxtTimeZone = nil
  self.resItem = nil
  self.textTxtGainsTip = nil
  self.compS0AllianceBossSelectLevel = nil
  self.compPersonal = nil
  self.compAlliance = nil
  self.btnGoTo = nil
  self.textTxtGoTo = nil
  self.compCompleted = nil
  self.textTxtComplete = nil
  self.toggleOffline = nil
  self.textToggle = nil
  self.btnNextR = nil
  self.btnPreviousL = nil
  self.compLastClearResult = nil
  self.textNameRank = nil
  self.compDonateCritShow = nil
  self.btnRank = nil
  self.timeSimpleAnim = nil
  self.animatorRewardBubble = nil
  self.btnRewardBubble = nil
  self.eventTrigger = nil
  self.compUIModel = nil
end

function UIS0AllianceBossMainView:DataDefine()
  self.difficulty = nil
  self.viewDifficulty = nil
  self.bossDifficultyIds = nil
  self.startTime = nil
  self.endTime = nil
  self.isForbid = nil
  self.forbidTime = nil
  self.actStatus = nil
  self.mgr = DataCenter.S0AllianceBossDataManager
  self.activityData = self.mgr:GetActivityData()
  self.bossData = nil
  self.recordList = nil
  self.maxDifficulty = DataCenter.AllianceBossS0TemplateManager.maxDifficulty
  self.deadlineOffset = self.mgr:GetDeadlineOffset()
  self.gotoBtnFlag = nil
  self.curDifficulty = nil
  self.isAutoRally = nil
  self.isInit = nil
  self.memberEnough = nil
end

function UIS0AllianceBossMainView:DataDestroy()
  self:ClearTimer()
  self:ClearRewardTimer()
  self.difficulty = nil
  self.viewDifficulty = nil
  self.bossDifficultyIds = nil
  self.startTime = nil
  self.endTime = nil
  self.isForbid = nil
  self.forbidTime = nil
  self.actStatus = nil
  self.mgr = nil
  self.activityData = nil
  self.bossData = nil
  self.recordList = nil
  self.maxDifficulty = nil
  self.deadlineOffset = nil
  self.gotoBtnFlag = nil
  self.openDifficultyLevel = nil
  self.curDifficulty = nil
  self.isAutoRally = nil
  self.isInit = nil
  self.memberEnough = nil
end

function UIS0AllianceBossMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnActInfoRefreshed)
  self:AddUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnViewIndexChanged)
  self:AddUIListener(EventId.OnS0AllianceBossAppointSuccess, self.OnAppointSuccess)
  self:AddUIListener(EventId.OnS0AllianceBossAutoRallyChanged, self.OnAutoRallyChanged)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRedPointRefreshed)
end

function UIS0AllianceBossMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossOnActInfoGot, self.OnActInfoRefreshed)
  self:RemoveUIListener(EventId.OnS0AllianceBossOnLevelSelectChanged, self.OnViewIndexChanged)
  self:RemoveUIListener(EventId.OnS0AllianceBossAppointSuccess, self.OnAppointSuccess)
  self:RemoveUIListener(EventId.OnS0AllianceBossAutoRallyChanged, self.OnAutoRallyChanged)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRedPointRefreshed)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossMainView:InitView()
  self.mgr:ReqActMainMessage()
  self.textTitle:SetLocalText("s0_alliance_boss_activity_name")
  self.textNameRank:SetLocalText("s0_alliance_boss_rank_btn")
  self.textRewardName:SetLocalText("s0_alliance_boss_reward_list_btn")
  self.textRecordName:SetLocalText("s0_alliance_boss_battle_record_btn")
  self.textTxtGoToDonate:SetLocalText("s0_alliance_boss_donate_btn")
  self.textTxtReservationTimeTitle:SetLocalText("s0_alliance_boss_challenge_soon")
  self.textTxtGainsTip:SetLocalText("s0_alliance_boss_first_reward")
  self.textTxtComplete:SetLocalText("s0_alliance_boss_challenge_finish")
  self.textToggle:SetLocalText("s0_alliance_boss_offline_battle")
  self.compS0AllianceBossSelectLevel:InitView(self.maxDifficulty, nil, "Main")
end

function UIS0AllianceBossMainView:SetData(actId)
  self.activityId = actId
end

function UIS0AllianceBossMainView:RefreshView()
  local mgr = self.mgr
  local isAutoRally = mgr.isAutoRally
  self.openDifficultyLevel = mgr.openDifficultyLevel
  self.isAutoRally = isAutoRally
  self.toggleOffline:SetIsOn(isAutoRally == 1)
  local difficulty = mgr.curDifficulty
  self.actStatus = mgr.actStatus
  if self.actStatus >= AllianceBossS0ActStatus.Prepare then
    self.curDifficulty = difficulty
  end
  if difficulty == nil or difficulty == 0 then
    difficulty = mgr.lastDifficultyLevel
  end
  if difficulty == nil or difficulty == 0 then
    difficulty = 1
  end
  self.difficulty = difficulty
  self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  self.recordList = mgr:GetRecordList()
  self.startTime = mgr.actStartTime
  if self.activityData then
    self.endTime = self.activityData.endTime
  end
  self.forbidTime = mgr.actEndTime
  if not self.isForbid then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.forbidTime and now >= self.forbidTime then
      self.isForbid = true
      self.forbidTime = nil
      CS.UIGray.SetGray(self.btnGoTo.transform, true, true)
    end
  end
  self.bossData = mgr.bossData
  local battleStartTime = 0
  local pageEnable = true
  if self.actStatus == AllianceBossS0ActStatus.Prepare then
    battleStartTime = mgr.bossData and mgr.bossData.startTime
    pageEnable = false
  elseif self.actStatus == AllianceBossS0ActStatus.InCombat or self.actStatus == AllianceBossS0ActStatus.Finished then
    pageEnable = false
  end
  self.battleStartTime = battleStartTime or 0
  if self.viewDifficulty == nil then
    self.viewDifficulty = self.difficulty
  end
  self.memberEnough = self.mgr:IsAllyMemberNumEnough()
  self:RefreshCurView(self.viewDifficulty)
  self.compS0AllianceBossSelectLevel:RefreshSelectedItem(self.viewDifficulty)
end

function UIS0AllianceBossMainView:Update1000MS()
  if self.endTime or self.showPrepareTime or not self.isForbid and self.forbidTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.endTime then
      local remainTime = self.endTime - now
      if 0 < remainTime then
        self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        self.textTime:SetText("")
        self.endTime = nil
      end
    end
    if self.showPrepareTime then
      local remainTime = self.battleStartTime - now
      if 0 < remainTime then
        self.textTxtReservationTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
        self.textTxtTimeZone:SetLocalText("s0_alliance_boss_timezone_1", UITimeManager:GetInstance():TimeStampToTimeForLocal(self.battleStartTime))
      else
        self.textTxtReservationTime:SetText("")
        self.showPrepareTime = nil
      end
    end
    if not self.isForbid and self.forbidTime and now >= self.forbidTime then
      self.isForbid = true
      self.forbidTime = nil
      CS.UIGray.SetGray(self.btnGoTo.transform, true, true)
    end
  end
end

function UIS0AllianceBossMainView:OnActInfoRefreshed()
  self:RefreshView()
end

function UIS0AllianceBossMainView:OnViewIndexChanged(param)
  if param == nil or param.uiName ~= "Main" then
    return
  end
  local index = param.value
  if self.viewDifficulty == nil then
    return
  end
  if index ~= self.viewDifficulty then
    self.viewDifficulty = index
    self:RefreshCurView(index)
  end
end

function UIS0AllianceBossMainView:ChangeViewIndex(index)
  if index ~= self.viewDifficulty then
    self.viewDifficulty = index
    self:RefreshCurView(index)
  end
end

function UIS0AllianceBossMainView:RefreshCurView(index)
  self:RefreshPageBtnState()
  if self.bossDifficultyIds == nil then
    self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  end
  local bossId = self.bossDifficultyIds and self.bossDifficultyIds[index]
  local personalMaxDmg, allianceMaxDmg = 0, 0
  local allianceDmgData
  self:RefreshFirstReward()
  if bossId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      self.rawImgBg:LoadSpriteAuto(bossTemp.background_image)
      self.compUIModel:SetActive(true)
      self.compUIModel:Init(bossTemp.monster_image)
      personalMaxDmg, allianceMaxDmg = bossTemp.personalMaxDmg, bossTemp.allianceMaxDmg
      allianceDmgData = bossTemp.allianceDmg
      local rewardId = bossTemp.first_reward
      if rewardId then
        local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
        if rewardList then
          local reward = rewardList[1]
          local item = DataCenter.RewardManager:ParseRewardInfo(reward)
          if item then
            if self.firstRewardState == 2 then
              item.isShowReceFlag = true
            end
            self.resItem:ReInit(item)
          end
        end
      end
    end
  end
  local result = AllianceBossS0ClearResult.NoRecord
  if not self.memberEnough then
    result = AllianceBossS0ClearResult.LockMember
  elseif index > self.openDifficultyLevel then
    result = AllianceBossS0ClearResult.Lock
  elseif self.recordList then
    if self.viewDifficulty == self.curDifficulty and self.actStatus == AllianceBossS0ActStatus.InCombat then
      result = AllianceBossS0ClearResult.InCombat
    elseif self.recordList[index] then
      local record = self.recordList[index]
      local passCost = record.passCost
      if passCost then
        result = self.mgr:GetClearResult(passCost)
      end
    end
  end
  self.compLastClearResult:Refresh(result)
  local showPrepareTime = false
  local complete = false
  local contextId = ""
  local showDonate = false
  local gotoBtnFlag = GOTO_BTN_FLAG.Appoint
  self.btnRank:SetActive(index == self.curDifficulty)
  local showDmg = false
  if self.actStatus == AllianceBossS0ActStatus.NoPlan then
    if not self.memberEnough then
      contextId = "s0_alliance_boss_go_lock_btn"
      gotoBtnFlag = GOTO_BTN_FLAG.LockMember
    elseif index > self.openDifficultyLevel then
      contextId = "s0_alliance_boss_go_lock_btn"
      gotoBtnFlag = GOTO_BTN_FLAG.Lock
    else
      contextId = "s0_alliance_boss_challenge_schedule"
    end
  elseif index == self.curDifficulty then
    if self.actStatus == AllianceBossS0ActStatus.Prepare then
      showPrepareTime = true
      contextId = "s0_alliance_boss_go_btn"
      showDonate = true
      gotoBtnFlag = GOTO_BTN_FLAG.Goto
    elseif self.actStatus == AllianceBossS0ActStatus.InCombat then
      contextId = "s0_alliance_boss_go_btn"
      gotoBtnFlag = GOTO_BTN_FLAG.Goto
      showDmg = true
    elseif self.actStatus == AllianceBossS0ActStatus.Finished then
      complete = true
      gotoBtnFlag = GOTO_BTN_FLAG.None
      showDmg = true
    end
  else
    contextId = "s0_alliance_boss_go_back_btn"
    gotoBtnFlag = GOTO_BTN_FLAG.GoBack
  end
  CS.UIGray.SetGray(self.btnGoTo.transform, gotoBtnFlag == GOTO_BTN_FLAG.Lock or gotoBtnFlag == GOTO_BTN_FLAG.LockMember, true)
  self.compDonateCritShow:SetActive(showDonate)
  if showDonate then
    self.compDonateCritShow:InitItem(showDonate)
  else
    self.compDonateCritShow:ClearTextVerTimer()
  end
  if showDmg then
    if self.bossData then
      local personDmg = self.bossData.playerDamage
      local allianceDmg = self.bossData.totalDamage
      self.compPersonal:RefreshView(personDmg, personalMaxDmg, self.viewDifficulty)
      self.compAlliance:RefreshView(allianceDmg, allianceMaxDmg, allianceDmgData, self.viewDifficulty)
    end
  else
    self.compPersonal:RefreshView(0, personalMaxDmg, self.viewDifficulty)
    self.compAlliance:RefreshView(0, allianceMaxDmg, allianceDmgData, self.viewDifficulty)
  end
  self.compDonateShow:SetActive(showDonate)
  if showDonate then
    self.donateRedPoint:SetActive(self.mgr:GetDonateRedPoint())
  end
  self.compCompleted:SetActive(complete)
  self.btnGoTo:SetActive(not complete)
  self.textTxtGoTo:SetLocalText(contextId)
  self.gotoBtnFlag = gotoBtnFlag
  local lastShowPrepareTime = self.showPrepareTime
  self.showPrepareTime = showPrepareTime
  self:ClearTimer()
  if showPrepareTime then
    self.compReservationTimeInfo:SetActive(true)
    local _, duration = self.timeSimpleAnim:PlayAnimationReturnTime("Default")
    if 0 < duration then
      local timer
      timer = TimerManager:GetInstance():DelayInvoke(function()
        if timer then
          timer:Stop()
          timer = nil
        end
      end, duration)
      self.timer = timer
    end
  elseif lastShowPrepareTime then
    local _, duration = self.timeSimpleAnim:PlayAnimationReturnTime("moveout")
    if 0 < duration then
      local timer
      timer = TimerManager:GetInstance():DelayInvoke(function()
        self.compReservationTimeInfo:SetActive(false)
        if timer then
          timer:Stop()
          timer = nil
        end
      end, duration)
      self.timer = timer
    end
  else
    self.compReservationTimeInfo:SetActive(false)
  end
  local mvpActive = false
  if self.recordList then
    local recordInfo = self.recordList[index]
    if recordInfo and recordInfo.mvpInfo then
      mvpActive = true
      local mvpInfo = recordInfo.mvpInfo
      local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(mvpInfo.headSkinId, mvpInfo.headSkinET, false)
      self.compUIPlayerHead:SetData(mvpInfo.uid, mvpInfo.headPic, mvpInfo.headPicVer, nil, headBgImg)
    end
  end
  self.compMVPTipBubble:SetActive(mvpActive)
end

function UIS0AllianceBossMainView:RefreshFirstReward()
  self:ClearRewardTimer()
  local firstRewardList = DataCenter.S0AllianceBossDataManager.firstRewardList
  local firstRewardState = 0
  if firstRewardList then
    local info = firstRewardList[self.viewDifficulty]
    if info then
      firstRewardState = info.state
      if firstRewardState == 1 and not self.isInit then
        self.isInit = true
        local _, duration = self.animatorRewardBubble:PlayAnimationReturnTime("V_ui_S0_Reward_Bubble_shake")
        if 0 < duration then
          local timer
          timer = TimerManager:GetInstance():DelayInvoke(function()
            self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_glow")
            if timer then
              timer:Stop()
              timer = nil
            end
          end, duration)
          self.rewardTimer = timer
        else
          self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_glow")
        end
      elseif firstRewardState == 1 then
        self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_glow")
      else
        self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_idle")
      end
    else
      self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_idle")
    end
  else
    self.animatorRewardBubble:Play("V_ui_S0_Reward_Bubble_idle")
  end
  self.firstRewardState = firstRewardState
end

function UIS0AllianceBossMainView:ClearTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIS0AllianceBossMainView:ClearRewardTimer()
  if self.rewardTimer then
    self.rewardTimer:Stop()
    self.rewardTimer = nil
  end
end

function UIS0AllianceBossMainView:OnBtnIntroClick()
  if self.activityData == nil then
    self.activityData = self.mgr:GetActivityData()
  end
  if self.activityData == nil then
    return
  end
  local param = {}
  param.howToPlayList = self.activityData.howtoplay
  param.defaultTitle = self.activityData.name
  param.story = self.activityData.story
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UIS0AllianceBossMainView:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRewardPreview, {anim = true}, {
    viewDifficulty = self.viewDifficulty
  })
end

function UIS0AllianceBossMainView:OnBtnGoToDonateClick()
  if self.difficulty == self.viewDifficulty and self.actStatus == AllianceBossS0ActStatus.Prepare then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossBuild)
  else
    Logger.LogError("S0AllianceBoss -- donate cannot show")
  end
end

function UIS0AllianceBossMainView:OnBtnNextRClick()
  if self.viewDifficulty == self.maxDifficulty then
    return
  end
  self:ChangeViewIndex(self.viewDifficulty + 1)
  self.compS0AllianceBossSelectLevel:RefreshSelectedItem(self.viewDifficulty)
end

function UIS0AllianceBossMainView:OnBtnPreviousLClick()
  if self.viewDifficulty == 1 then
    return
  end
  self:ChangeViewIndex(self.viewDifficulty - 1)
  self.compS0AllianceBossSelectLevel:RefreshSelectedItem(self.viewDifficulty)
end

function UIS0AllianceBossMainView:OnBtnGoToClick()
  if self.gotoBtnFlag == GOTO_BTN_FLAG.GoBack then
    if self.viewDifficulty ~= self.difficulty then
      self:ChangeViewIndex(self.difficulty)
      self.compS0AllianceBossSelectLevel:RefreshSelectedItem(self.difficulty)
    end
  elseif self.gotoBtnFlag == GOTO_BTN_FLAG.Goto then
    if self.bossData then
      local bossPointId = self.bossData.bossPointId
      local bossServerId = self.bossData.bossServerId
      self.mgr:GotoWorldPointOpen(bossPointId, bossServerId)
    end
  else
    if self.isForbid then
      local context = Localization:GetString("s0_alliance_boss_count_down_hour", self.deadlineOffset)
      UIUtil.ShowTips(context)
      return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.forbidTime and now >= self.forbidTime then
      self.isForbid = true
      self.forbidTime = nil
      CS.UIGray.SetGray(self.btnGoTo.transform, true, true)
      local context = Localization:GetString("s0_alliance_boss_count_down_hour", self.deadlineOffset)
      UIUtil.ShowTips(context)
      return
    end
    if self.gotoBtnFlag == GOTO_BTN_FLAG.Appoint then
      if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
        UIUtil.ShowTipsId("s0_alliance_boss_start_person_tips")
        return
      end
      local param = {
        viewDifficulty = self.viewDifficulty,
        curDifficulty = self.curDifficulty
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossSelect, {anim = true}, param)
    elseif self.gotoBtnFlag == GOTO_BTN_FLAG.Lock then
      UIUtil.ShowTipsId("s0_alliance_boss_go_lock_tips")
    elseif self.gotoBtnFlag == GOTO_BTN_FLAG.LockMember then
      UIUtil.ShowTipsId("s0_alliance_boss_go_lock_tips_1")
    end
  end
end

function UIS0AllianceBossMainView:RefreshPageBtnState()
  if self.viewDifficulty == 1 then
    self.btnPreviousL:SetActive(false)
    self.btnNextR:SetActive(true)
  elseif self.viewDifficulty == self.maxDifficulty then
    self.btnPreviousL:SetActive(true)
    self.btnNextR:SetActive(false)
  else
    self.btnPreviousL:SetActive(true)
    self.btnNextR:SetActive(true)
  end
end

function UIS0AllianceBossMainView:OnBtnRecordClick()
  if self.recordList and self.recordList[self.viewDifficulty] then
    local mvpInfo = self.recordList[self.viewDifficulty].mvpInfo
    if mvpInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossChallengeRecord, {anim = true}, self.viewDifficulty)
      return
    end
  end
  UIUtil.ShowTipsId("s0_alliance_boss_battle_no_record_tips")
end

function UIS0AllianceBossMainView:OnBtnRankClick()
  if self.curDifficulty == self.viewDifficulty then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossRank)
  else
    UIUtil.ShowTipsId("")
  end
end

function UIS0AllianceBossMainView:OnBtnRewardBubbleClick()
  if self.firstRewardState == 0 then
    UIUtil.ShowTipsId("s0_alliance_boss_first_reward_tips_1")
  elseif self.firstRewardState == 1 then
    if self.mgr then
      self.mgr:ReqReceiveFirstReward(self.viewDifficulty)
    end
  elseif self.firstRewardState == 2 then
    UIUtil.ShowTipsId("s0_alliance_boss_first_reward_tips_2")
  end
end

function UIS0AllianceBossMainView:OnToggleSelected(isOn)
  local isAutoRally = isOn and 1 or 0
  if self.isAutoRally == isAutoRally then
    return
  end
  DataCenter.S0AllianceBossDataManager:ReqChangeOffline(isOn)
end

function UIS0AllianceBossMainView:OnBeginDrag(eventData)
  self.dragPosX = eventData.position.x
end

function UIS0AllianceBossMainView:OnEndDrag(eventData)
  local lastDragPosX = self.dragPosX
  self.dragPosY = nil
  if lastDragPosX then
    local dragPosX = eventData.position.x
    if 20 <= dragPosX - lastDragPosX then
      self:OnBtnPreviousLClick()
    elseif dragPosX - lastDragPosX <= -20 then
      self:OnBtnNextRClick()
    end
  end
end

function UIS0AllianceBossMainView:OnDrag(eventData)
end

function UIS0AllianceBossMainView:OnAppointSuccess(message)
  if message then
    self.mgr:GotoWorldPointOpen(message.bossPointId, message.bossServerId)
  end
end

function UIS0AllianceBossMainView:OnAutoRallyChanged(isAutoRally)
  if self.isAutoRally == isAutoRally then
    self.toggleOffline:SetIsOnWithoutNotify(isAutoRally == 1)
  else
    self.isAutoRally = isAutoRally
    if isAutoRally == 1 then
      UIUtil.ShowTipsId("s0_alliance_boss_offline_battle_tips_1")
    else
      UIUtil.ShowTipsId("s0_alliance_boss_offline_battle_tips_2")
    end
  end
end

function UIS0AllianceBossMainView:OnRedPointRefreshed()
  if self.donateRedPoint then
    self.donateRedPoint:SetActive(self.mgr:GetDonateRedPoint())
  end
end

return UIS0AllianceBossMainView
