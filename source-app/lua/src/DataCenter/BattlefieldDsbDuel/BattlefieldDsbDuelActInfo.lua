local BattlefieldDsbDuelActInfo = BaseClass("BattlefieldDsbDuelActInfo")
local BattlefieldDsbDuelActTeamInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActTeamInfo")
local BattlefieldDsbDuelActBattleHistoryInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActBattleHistoryInfo")
local BattlefieldDsbDuelActAllianceRankInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActAllianceRankInfo")
local BattlefieldDsbDuelActPlayerInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActPlayerInfo")
local BattlefieldDsbDuelActOperateLogInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActOperateLogInfo")
local BattlefieldDsbDuelActRewardInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActRewardInfo")
local BattlefieldDsbDuelActAllianceBattleInfo = require("DataCenter.BattlefieldDsbDuel.BattlefieldDsbDuelActAllianceBattleInfo")
local Localization = CS.GameEntry.Localization

function BattlefieldDsbDuelActInfo:__init()
  self.isActInfoInit = false
  self.templateId = 0
  self.signUpBeginTime = 0
  self.signUpEndTime = 0
  self.groupEndTime = 0
  self.battleWeek = 0
  self.teamSignUpStartTime = 0
  self.teamSignUpEndTime = 0
  self.teamMatchStartTime = 0
  self.teamMatchEndTime = 0
  self.teamBattleReadyStartTime = 0
  self.teamBattleReadyEndTime = 0
  self.teamBattleStartTime = 0
  self.teamBattleEndTime = 0
  self.teamResultShowStartTime = 0
  self.teamResultShowEndTime = 0
  self.resultShowTime = 0
  self.resultEndTime = 0
  self.serverList = {}
  self.battleTimes = 0
  self.schedule = {}
  self.lastEnterBattleTime = 0
  self.isRegister = false
  self.teamA = nil
  self.teamB = nil
  self.selfBattleAllianceInfo = nil
  self.myAllianceBattleAllianceInfo = nil
  self.leaveCDTime = 0
  self.teamBCloseCDTime = 0
  self.selfGroup = 0
  self.battleHistoryInfo = {}
  self.groupRankList = {}
  self.selfRank = {}
  self.playerList = {}
  self.logList = {}
  self.rewardList = {}
  self.teamABattleAllianceList = {}
  self.teamBBattleAllianceList = {}
  self.teamAEmptyCount = 0
  self.teamBEmptyCount = 0
  self.winNum = 0
  self.winScore = 0
  self.updateTimer = TimerManager:GetInstance():GetTimer(1, function()
    self:OnUpdateTime()
  end, self, false, false, false)
  self.curPhaseIndex = BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.None
  self.updateTimer:Start()
end

function BattlefieldDsbDuelActInfo:__delete()
  self.isActInfoInit = nil
  self.templateId = nil
  self.signUpBeginTime = nil
  self.signUpEndTime = nil
  self.groupEndTime = nil
  self.battleWeek = nil
  self.teamSignUpStartTime = nil
  self.teamSignUpEndTime = nil
  self.teamMatchStartTime = nil
  self.teamMatchEndTime = nil
  self.teamBattleReadyStartTime = nil
  self.teamBattleReadyEndTime = nil
  self.teamBattleStartTime = nil
  self.teamBattleEndTime = nil
  self.teamResultShowStartTime = nil
  self.teamResultShowEndTime = nil
  self.resultShowTime = nil
  self.resultEndTime = nil
  self.serverList = nil
  self.schedule = nil
  self.isRegister = nil
  self.teamA = nil
  self.teamB = nil
  self.leaveCDTime = nil
  self.teamBCloseCDTime = nil
  self.lastRequestBattleInfoTime = nil
  self.lastEnterBattleTime = nil
  self.selfBattleAllianceInfo = nil
  self.myAllianceBattleAllianceInfo = nil
  self.selfTeamInfo = nil
  self.theGuideList = nil
  self.selfGroup = nil
  self.battleHistoryInfo = nil
  self.groupRankList = nil
  self.selfRank = nil
  self.playerList = nil
  self.battleTimes = nil
  self.battleTimesInfo = nil
  self.logList = nil
  self.rewardList = nil
  self.teamABattleAllianceList = nil
  self.teamBBattleAllianceList = nil
  self.winNum = nil
  self.winScore = nil
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
end

function BattlefieldDsbDuelActInfo:OnUpdateTime()
  if self.isActInfoInit then
    local phaseIndex = self:GetCurrentPhaseIndex()
    if self.curPhaseIndex ~= phaseIndex then
      self:SendActInfoMsg()
      self.curPhaseIndex = phaseIndex
      EventManager:GetInstance():Broadcast(EventId.DsbDuelActTimePhaseChange, phaseIndex)
      if phaseIndex == BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.Result and UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBFDsbDuelActMain) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActMain)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActFinal, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
      end
      EventManager:GetInstance():Broadcast(EventId.BattlefieldActStateChanged)
    elseif self:IsInTeamBattlePhase() then
      self:TrySendBattleInfoMsgAuto()
    end
  end
end

function BattlefieldDsbDuelActInfo:GetCurTemplateId()
  return self.templateId
end

function BattlefieldDsbDuelActInfo:CheckIfActOpen()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.ActDsbDuel.ActId)
  if actInfo == nil then
    return false
  end
  local isValid = actInfo:IsValid()
  if not isValid then
    return false
  end
  return true
end

function BattlefieldDsbDuelActInfo:OpenActWindow()
  local lv = DataCenter.BuildManager:GetMainLevel()
  if lv < self:GetMinLevel() then
    UIUtil.ShowTipsId("yuntieBattle_tips_1033", self:GetMinLevel())
    return
  end
  if self:GetIsActInfoInit() and self:IsInResultShowPhase() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActFinal, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self:GetIsActInfoInit() and not self:IsInSignUpPhase() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, BattlefieldDsbConst.BF_DSB_MAIN_VIEW_TOGGLE_INDEX.EditBattle)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

function BattlefieldDsbDuelActInfo:GetMinLevel()
  if self.activityMinLevel then
    return self.activityMinLevel
  end
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.ActDsbDuel.ActId)
  if tabData then
    self.activityMinLevel = tonumber(tabData.needMainCityLevel) or 1
  else
    self.activityMinLevel = 1
  end
  return self.activityMinLevel
end

function BattlefieldDsbDuelActInfo:IsRegistered()
  return self.isRegister
end

function BattlefieldDsbDuelActInfo:GetSelfGroup()
  return self.selfGroup
end

function BattlefieldDsbDuelActInfo:GetBattleWeek()
  return self.battleWeek
end

function BattlefieldDsbDuelActInfo:GetTotalBattleWeekNum()
  return self.battleTimes
end

function BattlefieldDsbDuelActInfo:GetTeamInfo(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB
  end
  return nil
end

function BattlefieldDsbDuelActInfo:GetLeaveCDTime()
  return self.leaveCDTime
end

function BattlefieldDsbDuelActInfo:GetTeamBCloseCDTime()
  return self.teamBCloseCDTime
end

function BattlefieldDsbDuelActInfo:GetIsActInfoInit()
  return self.isActInfoInit
end

function BattlefieldDsbDuelActInfo:GetWinStreakNum()
  return self.winNum
end

function BattlefieldDsbDuelActInfo:GetWinAddExtraScore()
  return self.winScore
end

function BattlefieldDsbDuelActInfo:GetServerList()
  return self.serverList
end

function BattlefieldDsbDuelActInfo:GetSchedule()
  return self.schedule
end

function BattlefieldDsbDuelActInfo:ParseSchedule(scheduleStr)
  if string.IsNullOrEmpty(scheduleStr) then
    return {}
  end
  local result = {}
  local rounds = string.split(scheduleStr, "|")
  for i, round in ipairs(rounds) do
    if not string.IsNullOrEmpty(round) then
      if string.find(round, ";") then
        local matches = string.split(round, ";")
        local roundData = {}
        for j, match in ipairs(matches) do
          local teams = string.string2array_num_oneSep(match, ",")
          for k, teamId in ipairs(teams) do
            table.insert(roundData, teamId)
          end
        end
        table.insert(result, roundData)
      else
        local roundData = {}
        local teams = string.string2array_num_oneSep(round, ",") or {}
        for k, v in ipairs(teams) do
          table.insert(roundData, v)
        end
        table.insert(result, roundData)
      end
    end
  end
  return result
end

function BattlefieldDsbDuelActInfo:IsInSignUpPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime <= self.signUpEndTime and serverTime >= self.signUpBeginTime
end

function BattlefieldDsbDuelActInfo:GetSignUpBeginTime()
  return self.signUpBeginTime
end

function BattlefieldDsbDuelActInfo:GetSignUpEndTime()
  return self.signUpEndTime
end

function BattlefieldDsbDuelActInfo:IsInGroupPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.signUpEndTime and serverTime < self.groupEndTime
end

function BattlefieldDsbDuelActInfo:GetGroupEndTime()
  return self.groupEndTime
end

function BattlefieldDsbDuelActInfo:IsInBattlePhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.groupEndTime and serverTime < self.resultShowTime
end

function BattlefieldDsbDuelActInfo:IsInResultShowPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.resultShowTime and serverTime <= self.resultEndTime
end

function BattlefieldDsbDuelActInfo:GetResultShowStartTime()
  return self.resultShowTime
end

function BattlefieldDsbDuelActInfo:GetResultShowEndTime()
  return self.resultEndTime
end

function BattlefieldDsbDuelActInfo:IsInTeamWaitSignUpPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime > self.groupEndTime and serverTime < self.teamSignUpStartTime
end

function BattlefieldDsbDuelActInfo:GetTeamWaitSignUpEndTime()
  return self.teamSignUpStartTime
end

function BattlefieldDsbDuelActInfo:IsInTeamSignUpPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamSignUpStartTime and serverTime < self.teamSignUpEndTime
end

function BattlefieldDsbDuelActInfo:GetTeamSignUpEndTime()
  return self.teamSignUpEndTime
end

function BattlefieldDsbDuelActInfo:IsInTeamMatchPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamMatchStartTime and serverTime < self.teamMatchEndTime
end

function BattlefieldDsbDuelActInfo:IsInTeamWaitBattlePhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamMatchEndTime and serverTime < self.teamBattleReadyStartTime
end

function BattlefieldDsbDuelActInfo:GetTeamWaitBattleEndTime()
  return self.teamBattleReadyStartTime
end

function BattlefieldDsbDuelActInfo:IsInTeamBattleReadyPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamBattleReadyStartTime and serverTime < self.teamBattleReadyEndTime
end

function BattlefieldDsbDuelActInfo:IsInTeamBattlePhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamBattleStartTime and serverTime < self.teamBattleEndTime
end

function BattlefieldDsbDuelActInfo:GetBattleTime()
  return self.teamBattleStartTime, self.teamBattleEndTime
end

function BattlefieldDsbDuelActInfo:IsInTeamResultShowPhase()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return serverTime >= self.teamBattleEndTime and serverTime < self.teamResultShowEndTime
end

function BattlefieldDsbDuelActInfo:GetCurrentPhaseStartEndTime()
  if self:IsInSignUpPhase() then
    return self.signUpBeginTime, self.signUpEndTime
  elseif self:IsInGroupPhase() then
    return self.signUpEndTime, self.groupEndTime
  elseif self:IsInBattlePhase() then
    if self:IsInTeamSignUpPhase() then
      return self.teamSignUpStartTime, self.teamSignUpEndTime
    elseif self:IsInTeamMatchPhase() then
      return self.teamMatchStartTime, self.teamMatchEndTime
    elseif self:IsInTeamWaitBattlePhase() then
      return self.teamMatchEndTime, self.teamBattleReadyStartTime
    elseif self:IsInTeamBattleReadyPhase() then
      return self.teamBattleReadyStartTime, self.teamBattleReadyEndTime
    elseif self:IsInTeamBattlePhase() then
      return self.teamBattleStartTime, self.teamBattleEndTime
    elseif self:IsInTeamResultShowPhase() then
      return self.teamBattleEndTime, self.teamResultShowEndTime
    end
  else
    return self.resultShowTime, self.resultEndTime
  end
  return 0, 0
end

function BattlefieldDsbDuelActInfo:GetCurrentPhaseIndex()
  if self:IsInSignUpPhase() then
    return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.SignUp
  elseif self:IsInGroupPhase() then
    return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.Group
  elseif self:IsInBattlePhase() then
    if self:IsInTeamWaitSignUpPhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamWaitSignUp
    elseif self:IsInTeamSignUpPhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamSignUp
    elseif self:IsInTeamMatchPhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamMatch
    elseif self:IsInTeamWaitBattlePhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamWaitBattle
    elseif self:IsInTeamBattleReadyPhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamBattleReady
    elseif self:IsInTeamBattlePhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamBattle
    elseif self:IsInTeamResultShowPhase() then
      return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.TeamResult
    end
  else
    return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.Result
  end
  return BattlefieldDsbConst.BF_DSB_SMALL_PHASE_INDEX.None
end

function BattlefieldDsbDuelActInfo:GetCurrentBigPhaseStartEndTime()
  if self:IsInSignUpPhase() then
    return self.signUpBeginTime, self.signUpEndTime
  elseif self:IsInGroupPhase() then
    return self.signUpEndTime, self.groupEndTime
  elseif self:IsInBattlePhase() then
    return self.groupEndTime, self.resultShowTime
  else
    return self.resultShowTime, self.resultEndTime
  end
  return 0, 0
end

function BattlefieldDsbDuelActInfo:GetBigPhaseStartEndTimeByPhase(phase)
  local oneWeekTime = OneWeekTime * 1000
  if phase == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.SignUp then
    return self.signUpBeginTime, self.signUpEndTime
  elseif phase == BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Group then
    return self.signUpEndTime, self.groupEndTime
  elseif phase >= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin and phase <= BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMax then
    return self.groupEndTime + oneWeekTime * (phase - BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin), self.groupEndTime + oneWeekTime * (phase - BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin + 1)
  else
    return self.resultShowTime, self.resultEndTime
  end
  return 0, 0
end

function BattlefieldDsbDuelActInfo:GetCurrentBigPhaseIndex()
  if self:IsInSignUpPhase() then
    return BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.SignUp
  elseif self:IsInGroupPhase() then
    return BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Group
  elseif self:IsInBattlePhase() then
    return BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.BattleWeekMin + self.battleWeek - 1
  else
    return BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.Result
  end
  return BattlefieldDsbConst.BF_DSB_BIG_PHASE_INDEX.None
end

function BattlefieldDsbDuelActInfo:GetCurrentPhaseRemainTime()
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local _, endTime = self:GetCurrentPhaseStartEndTime()
  if serverTime < endTime then
    return endTime - serverTime
  end
  return 0
end

function BattlefieldDsbDuelActInfo:GetBattleTimeInfo()
  if self.battleTimesInfo then
    return self.battleTimesInfo
  end
  self.battleTimesInfo = {}
  local startTime, endTime = self:GetBattleTime()
  table.insert(self.battleTimesInfo, {
    battlePeriod = 1,
    startTime = startTime,
    endTime = endTime
  })
  return self.battleTimesInfo
end

function BattlefieldDsbDuelActInfo:GetShowLocalTime()
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.DSB_SET_SHOW_LOCAL_TIME, true)
end

function BattlefieldDsbDuelActInfo:SetShowLocalTime(show)
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DSB_SET_SHOW_LOCAL_TIME, show)
  EventManager:GetInstance():Broadcast(EventId.DsbDuelActChangeTimeType)
end

function BattlefieldDsbDuelActInfo:SendActInfoMsg(bRandomDelay)
  DataCenter.BattlefieldDsbDuelManager:ReqActInfo(bRandomDelay)
end

function BattlefieldDsbDuelActInfo:OnGetActInfoMsg(msg)
  if not msg then
    return
  end
  self.isActInfoInit = true
  self.templateId = msg.templateId or self.templateId
  self.signUpBeginTime = msg.signUpBeginTime and msg.signUpBeginTime * 1000 or self.signUpBeginTime
  self.signUpEndTime = msg.signUpEndTime and msg.signUpEndTime * 1000 or self.signUpEndTime
  self.groupEndTime = msg.groupEndTime and msg.groupEndTime * 1000 or self.groupEndTime
  self.battleWeek = msg.battleWeek or self.battleWeek
  self.teamSignUpStartTime = msg.teamSignUpStartTime and msg.teamSignUpStartTime * 1000 or self.teamSignUpStartTime
  self.teamSignUpEndTime = msg.teamSignUpEndTime and msg.teamSignUpEndTime * 1000 or self.teamSignUpEndTime
  self.teamMatchStartTime = msg.teamMatchStartTime and msg.teamMatchStartTime * 1000 or self.teamMatchStartTime
  self.teamMatchEndTime = msg.teamMatchEndTime and msg.teamMatchEndTime * 1000 or self.teamMatchEndTime
  self.teamBattleReadyStartTime = msg.teamBattleReadyStartTime and msg.teamBattleReadyStartTime * 1000 or self.teamBattleReadyStartTime
  self.teamBattleReadyEndTime = msg.teamBattleReadyEndTime and msg.teamBattleReadyEndTime * 1000 or self.teamBattleReadyEndTime
  self.teamBattleStartTime = msg.teamBattleStartTime and msg.teamBattleStartTime * 1000 or self.teamBattleStartTime
  self.teamBattleEndTime = msg.teamBattleEndTime and msg.teamBattleEndTime * 1000 or self.teamBattleEndTime
  self.teamResultShowStartTime = msg.teamResultShowStartTime and msg.teamResultShowStartTime * 1000 or self.teamResultShowStartTime
  self.teamResultShowEndTime = msg.teamResultShowEndTime and msg.teamResultShowEndTime * 1000 or self.teamResultShowEndTime
  self.resultShowTime = msg.resultShowTime and msg.resultShowTime * 1000 or self.resultShowTime
  self.resultEndTime = msg.resultEndTime and msg.resultEndTime * 1000 or self.resultEndTime
  self.serverList = msg.serverList or self.serverList
  self.battleTimes = msg.battleTimes or self.battleTimes
  if msg.schedule then
    self.schedule = self:ParseSchedule(msg.schedule)
  end
  self.lastEnterBattleTime = msg.lastEnterBattleTime or 0
  self.isRegister = msg.isRegister or self.isRegister
  self.selfTeamInfo = nil
  local selfAssigned
  if msg.teamA then
    self.teamA = BattlefieldDsbDuelActTeamInfo.New(BattlefieldDsbConst.TeamType.A)
    self.teamA:UpdateData(msg.teamA)
    if msg.teamA.group then
      self.selfGroup = msg.teamA.group
    end
    if msg.teamA.winNum then
      self.winNum = msg.teamA.winNum
    end
    if msg.teamA.winScore then
      self.winScore = msg.teamA.winScore
    end
    selfAssigned = self.teamA:GetSelfAssigned()
    if selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main or selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Sub then
      self.selfTeamInfo = self.teamA
    end
  end
  if msg.teamB then
    self.teamB = BattlefieldDsbDuelActTeamInfo.New(BattlefieldDsbConst.TeamType.B)
    self.teamB:UpdateData(msg.teamB)
    selfAssigned = self.teamB:GetSelfAssigned()
    if selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main or selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Sub then
      self.selfTeamInfo = self.teamB
    end
  end
  self.leaveCDTime = msg.leaveCDTime and msg.leaveCDTime * 1000 or self.leaveCDTime
  self.teamBCloseCDTime = msg.teamBCloseCDTime and msg.teamBCloseCDTime * 1000 or self.teamBCloseCDTime
  EventManager:GetInstance():Broadcast(EventId.DsbDuelActInfoUpdate)
  if DataCenter.LoginPopManager.loadComplete then
    self:CheckIsNeedPop()
  end
  self:TrySendBattleInfoMsgAuto()
end

function BattlefieldDsbDuelActInfo:CanEnterBattlefield(group)
  local watchIdx = group or BattleFieldUtil.ObserveIdx()
  if watchIdx == 0 and self.lastEnterBattleTime and 0 > self.lastEnterBattleTime then
    return 458143
  end
  if LuaEntry.Player:IsInAlliance() == false then
    return 390856
  end
  local selfAssigned = self:GetSelfAssigned()
  if watchIdx == 0 and selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None then
    return 458137
  end
  if self:IsInTeamBattleReadyPhase() then
    if watchIdx == 0 and selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Sub then
      return 458145
    end
  elseif not self:IsInTeamBattlePhase() then
    return "YiBianJinQu_event_tips_5"
  end
end

function BattlefieldDsbDuelActInfo:OnEnterBattlefield(watcher)
  if not watcher and self.lastEnterBattleTime == 0 then
    self.lastEnterBattleTime = UITimeManager:GetInstance():GetServerSeconds()
  end
end

function BattlefieldDsbDuelActInfo:OnLeaveBattlefield()
  self:SendActInfoMsg()
end

function BattlefieldDsbDuelActInfo:SendActSignUpMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbActSignUp)
end

function BattlefieldDsbDuelActInfo:OnGetActSignUpMsg(msg)
  if not msg then
    return
  end
  if msg.ret == 1 then
    self.isRegister = true
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActSignUpSuccess)
  end
end

function BattlefieldDsbDuelActInfo:SendActTeamSignUpMsg(data)
  SFSNetwork.SendMessage(MsgDefines.DsbActTeamSignUp, data)
end

function BattlefieldDsbDuelActInfo:OnGetActTeamSignUpMsg(msg)
  if not msg then
    return
  end
  if msg.team then
    local open = BattlefieldDsbConst.TeamType.None
    if msg.team == BattlefieldDsbConst.TeamType.A then
      self.teamA = BattlefieldDsbDuelActTeamInfo.New(BattlefieldDsbConst.TeamType.A)
      self.teamA:SetState(BattlefieldDsbConst.BF_DSB_TEAM_STATE.SignUp)
      open = BattlefieldDsbConst.TeamType.A
    elseif msg.team == BattlefieldDsbConst.TeamType.B then
      self.teamB = BattlefieldDsbDuelActTeamInfo.New(BattlefieldDsbConst.TeamType.B)
      self.teamB:SetState(BattlefieldDsbConst.BF_DSB_TEAM_STATE.SignUp)
      open = BattlefieldDsbConst.TeamType.B
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActTeamSignUpSuccess, msg.team)
    self:SendActInfoMsg(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActSelectUserV2, {anim = true}, {
      group = msg.team
    })
  end
end

function BattlefieldDsbDuelActInfo:SendActApplyMsg(team)
  SFSNetwork.SendMessage(MsgDefines.DsbActApply, {team = team})
end

function BattlefieldDsbDuelActInfo:OnGetActApplyMsg(msg)
  if not msg then
    return
  end
  if msg.team then
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActTeamSelfApplySuccess, msg.team)
    self:SendActPlayerListMsg()
  end
end

function BattlefieldDsbDuelActInfo:SendActAssignMsg(data)
  SFSNetwork.SendMessage(MsgDefines.DsbActAssign, data)
end

function BattlefieldDsbDuelActInfo:OnGetActAssignMsg(msg)
  if not msg then
    return
  end
  if msg.team then
    local player = self:GetPlayerInfoByUID(msg.targetUid)
    if player then
      player:SetState(msg.state or 0)
      player:SetTeam(msg.team)
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActTeamAssignSuccess, msg.team)
  end
end

function BattlefieldDsbDuelActInfo:SendActTeamModifyMsg(data)
  SFSNetwork.SendMessage(MsgDefines.DsbActTeamModify, data)
end

function BattlefieldDsbDuelActInfo:OnGetActTeamModifyMsg(msg)
  if not msg then
    return
  end
  if msg.team and msg.team == 2 then
    self.teamBCloseCDTime = (msg.teamCloseEndTime or 0) * 1000
    if self.teamB then
      self.teamB:SetState(msg.state)
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActTeamModifySuccess)
  end
end

function BattlefieldDsbDuelActInfo:SendActOperatorLogListMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbOperateLogList)
end

function BattlefieldDsbDuelActInfo:OnGetActOperatorLogListMsg(msg)
  if not msg then
    return
  end
  if msg.data then
    self.logList = {}
    for k, v in ipairs(msg.data) do
      local operateLogInfo = BattlefieldDsbDuelActOperateLogInfo:New()
      operateLogInfo:ParseData(v)
      table.insert(self.logList, operateLogInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActOnGetOperateList)
  end
end

function BattlefieldDsbDuelActInfo:SendActPlayerListMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbActPlayerList)
end

function BattlefieldDsbDuelActInfo:OnGetActPlayerListMsg(msg)
  if not msg then
    return
  end
  if msg.users then
    self.playerList = {}
    for k, v in ipairs(msg.users) do
      local playerInfo = BattlefieldDsbDuelActPlayerInfo:New()
      playerInfo:ParseData(v)
      self.playerList[v.uid] = playerInfo
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActPlayerListUpdate)
  end
end

function BattlefieldDsbDuelActInfo:SendActGroupListMsg(group)
  SFSNetwork.SendMessage(MsgDefines.DsbActGroupList, {group = group})
end

function BattlefieldDsbDuelActInfo:OnGetActGroupListMsg(msg)
  if not msg then
    return
  end
  if msg.data then
    self.groupRankList = {}
    for k, v in ipairs(msg.data) do
      local rankInfo = BattlefieldDsbDuelActAllianceRankInfo.New()
      rankInfo:UpdateData(v)
      rankInfo.rank = k
      table.insert(self.groupRankList, rankInfo)
    end
    if msg.rank ~= -1 then
      self.selfRank = BattlefieldDsbDuelActAllianceRankInfo.New()
      self.selfRank:UpdateData(msg)
      self.selfGroup = msg.group
      local selfAllianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if selfAllianceData then
        self.selfRank.allianceId = selfAllianceData.uid
        self.selfRank.serverId = selfAllianceData.ownerServerId
        self.selfRank.name = selfAllianceData.allianceName
        self.selfRank.abbr = selfAllianceData.abbr
        self.selfRank.icon = selfAllianceData.icon
      end
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActRankInfoUpdate)
  end
end

function BattlefieldDsbDuelActInfo:SendBattleHistoryListMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbBattleHistoryList)
end

function BattlefieldDsbDuelActInfo:OnGetBattleHistoryList(msg)
  if not msg then
    return
  end
  if msg.data then
    self.battleHistoryInfo = {}
    for k, v in ipairs(msg.data) do
      local historyInfo = BattlefieldDsbDuelActBattleHistoryInfo.New()
      historyInfo:UpdateData(v, v.mvp)
      table.insert(self.battleHistoryInfo, historyInfo)
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActHistoryUpdate)
  end
end

function BattlefieldDsbDuelActInfo:SendActRewardInfoMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbActRewardInfo)
end

function BattlefieldDsbDuelActInfo:OnGetActRewardInfoMsg(msg)
  if not msg then
    return
  end
  if msg.data then
    self.rewardList = {}
    for k, v in ipairs(msg.data) do
      local rewardInfo = BattlefieldDsbDuelActRewardInfo.New()
      rewardInfo:ParseData(v)
      self.rewardList[v.id] = rewardInfo
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActOnGetRewardList)
  end
end

function BattlefieldDsbDuelActInfo:SendActGetRewardMsg(rewardId, rewardType)
  SFSNetwork.SendMessage(MsgDefines.DsbActGetReward, {rewardId = rewardId, rewardType = rewardType})
end

function BattlefieldDsbDuelActInfo:OnGetActGetRewardMsg(msg)
  if not msg then
    return
  end
  if msg.reward then
    local info = {}
    local reward = msg.reward
    if reward ~= nil then
      DataCenter.RewardManager:AddRewards(reward)
      info.reward = DataCenter.RewardManager:ReturnRewardParamForView(reward) or {}
    end
    local helpAlliance = msg.alliances
    if helpAlliance ~= nil then
      local allianceInfos = {}
      for i, v in ipairs(helpAlliance) do
        if 20 < i then
          break
        end
        local infoData = {
          abbr = v.abbr,
          icon = v.icon
        }
        table.insert(allianceInfos, infoData)
      end
      info.helpAlliance = allianceInfos
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActGetFinalReward, {anim = true}, info)
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActRewardReceived)
    self:SendActRewardInfoMsg()
  end
end

function BattlefieldDsbDuelActInfo:SendBattleInfoMsg(team)
  if not self:IsInTeamBattlePhase() and not self:IsInTeamBattleReadyPhase() and not self:IsInTeamResultShowPhase() then
    return
  end
  if team == BattlefieldDsbConst.TeamType.B and self:IsTeamBGiveUp() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.DsbBattleInfo, {team = team})
  self.lastRequestBattleInfoTime = UITimeManager:GetInstance():GetServerSeconds()
end

function BattlefieldDsbDuelActInfo:TrySendBattleInfoMsgAuto()
  local myTeam = self:GetSelfTeam()
  if myTeam == BattlefieldDsbConst.TeamType.None then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local nowSec = self.lastRequestBattleInfoTime or 0
  if curSec - nowSec < 10 then
    return
  end
  self:SendBattleInfoMsg(myTeam)
end

local function _SortAllianceBattleInfo(a, b)
  local aRank = a.rank or 0
  local bRank = b.rank or 0
  if aRank ~= bRank then
    return aRank < bRank
  end
  local aScore = a.battleScore or 0
  local bScore = b.battleScore or 0
  if aScore ~= bScore then
    return aScore > bScore
  end
  local aRole = a.role or 0
  local bRole = b.role or 0
  return aRole < bRole
end

function BattlefieldDsbDuelActInfo:OnGetBattleInfoMsg(msg)
  if not msg then
    return
  end
  local myTeam = self:GetSelfTeam()
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if msg.data then
    local list = msg.team == 1 and self.teamABattleAllianceList or self.teamBBattleAllianceList
    local sortList = {}
    local memberCount = #msg.data
    if msg.team == 1 then
      self.teamAEmptyCount = BattlefieldDsbConst.RoleType.MAX - memberCount
    elseif msg.team == 2 then
      self.teamBEmptyCount = BattlefieldDsbConst.RoleType.MAX - memberCount
    end
    if table.IsNullOrEmpty(list) then
      for k, v in ipairs(msg.data) do
        local allianceInfo = BattlefieldDsbDuelActAllianceBattleInfo.New()
        allianceInfo:ParseData(v, msg.team)
        if not allianceInfo.rank or allianceInfo.rank == 0 then
          table.insert(sortList, allianceInfo)
        end
        list[v.allianceId] = allianceInfo
        if allianceInfo.allianceId == myAllianceId then
          self.myAllianceBattleAllianceInfo = allianceInfo
          if msg.team == myTeam then
            self.selfBattleAllianceInfo = allianceInfo
          end
        end
        allianceInfo.emptyRoles = BattlefieldDsbConst.RoleType.MAX - #msg.data
      end
    else
      for k, v in ipairs(msg.data) do
        local _info = list[v.allianceId]
        if _info then
          _info:ParseData(v, msg.team)
          if not _info.rank or _info.rank == 0 then
            table.insert(sortList, _info)
          end
          _info.emptyRoles = BattlefieldDsbConst.RoleType.MAX - #msg.data
        end
      end
    end
    table.sort(sortList, _SortAllianceBattleInfo)
    for k, v in ipairs(sortList) do
      v:UpdateRank(k)
    end
    EventManager:GetInstance():Broadcast(EventId.DsbDuelActBattleInfoUpdate)
  end
end

function BattlefieldDsbDuelActInfo:IsSelfInTeam(teamId)
  local selfData = self:GetPlayerInfoByUID(LuaEntry.Player.uid)
  if selfData then
    return selfData.team == teamId and selfData.state ~= BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None
  end
  return false
end

function BattlefieldDsbDuelActInfo:GetSelfTeam()
  if not self.selfTeamInfo then
    return BattlefieldDsbConst.TeamType.None
  end
  return self.selfTeamInfo:GetTeamId()
end

function BattlefieldDsbDuelActInfo:GetSelfTeamInfo()
  return self.selfTeamInfo
end

function BattlefieldDsbDuelActInfo:GetSelfAllianceInfo()
  return self.selfBattleAllianceInfo
end

function BattlefieldDsbDuelActInfo:GetMyAllianceBattleInfo()
  return self.myAllianceBattleAllianceInfo
end

function BattlefieldDsbDuelActInfo:GetSelfAssigned()
  if not self.selfTeamInfo then
    return BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None
  end
  return self.selfTeamInfo:GetSelfAssigned()
end

function BattlefieldDsbDuelActInfo:GetSelfTeamState()
  if not self.selfTeamInfo then
    return BattlefieldDsbConst.BF_DSB_TEAM_STATE.NotSignUp
  end
  return self.selfTeamInfo:GetState()
end

function BattlefieldDsbDuelActInfo:GetTeamPlayerNum(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and self.teamA == nil or teamId == BattlefieldDsbConst.TeamType.B and self.teamB == nil then
    return 0
  end
  return self:GetCurNumByTeam(teamId)
end

function BattlefieldDsbDuelActInfo:GetTeamMainPlayerNum(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and self.teamA == nil or teamId == BattlefieldDsbConst.TeamType.B and self.teamB == nil then
    return 0
  end
  return self:GetCurNumByStateAndTeam(BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main, teamId)
end

function BattlefieldDsbDuelActInfo:GetCurGroup()
  return self:GetSelfGroup()
end

function BattlefieldDsbDuelActInfo:GetTeamMatchAllianceInfoByRole(teamId, role)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:GetMatchAllianceInfoByRole(role) or BattlefieldDsbConst.EmptyRole
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:GetMatchAllianceInfoByRole(role) or BattlefieldDsbConst.EmptyRole
  end
  return BattlefieldDsbConst.EmptyRole
end

function BattlefieldDsbDuelActInfo:GetTeamBattleAllianceInfo(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and table.IsNullOrEmpty(self.teamABattleAllianceList) or teamId == BattlefieldDsbConst.TeamType.B and table.IsNullOrEmpty(self.teamBBattleAllianceList) then
    return {}
  end
  local list
  if teamId == BattlefieldDsbConst.TeamType.A then
    list = table.values(self.teamABattleAllianceList)
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    list = table.values(self.teamBBattleAllianceList)
  else
    return {}
  end
  table.sort(list, _SortAllianceBattleInfo)
  local emptyCount = BattlefieldDsbDuelUtils.GetEmptyRoles(teamId)
  if 0 < emptyCount then
    for i = 1, emptyCount do
      table.insert(list, BattlefieldDsbConst.EmptyRole)
    end
  end
  return list
end

function BattlefieldDsbDuelActInfo:GetTeamGroup(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and self.teamA == nil or teamId == BattlefieldDsbConst.TeamType.B and self.teamB == nil then
    return 0
  end
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA:GetGroup()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB:GetGroup()
  end
  return 0
end

function BattlefieldDsbDuelActInfo:GetTeamGroupRank(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and self.teamA == nil or teamId == BattlefieldDsbConst.TeamType.B and self.teamB == nil then
    return 0
  end
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA:GetGroupRank()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB:GetGroupRank()
  end
  return 0
end

function BattlefieldDsbDuelActInfo:GetTeamState(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A and self.teamA == nil or teamId == BattlefieldDsbConst.TeamType.B and self.teamB == nil then
    return 0
  end
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA:GetState()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB:GetState()
  end
  return 0
end

function BattlefieldDsbDuelActInfo:IsTeamSignUp(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:IsSignUp()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:IsSignUp()
  end
  return false
end

function BattlefieldDsbDuelActInfo:IsTeamMatched(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:IsMatched()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:IsMatched()
  end
  return false
end

function BattlefieldDsbDuelActInfo:IsTeamBye(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:IsBye()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:IsBye()
  end
  return false
end

function BattlefieldDsbDuelActInfo:IsTeamGiveUp(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:IsGiveUp()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:IsGiveUp()
  end
  return false
end

function BattlefieldDsbDuelActInfo:IsTeamBGiveUp()
  return self:GetTeamState(BattlefieldDsbConst.TeamType.B) == BattlefieldDsbConst.BF_DSB_TEAM_STATE.GiveUp
end

function BattlefieldDsbDuelActInfo:GetSelfTeamRole(teamId)
  if teamId == BattlefieldDsbConst.TeamType.A then
    return self.teamA and self.teamA:GetSelfTeamRole()
  elseif teamId == BattlefieldDsbConst.TeamType.B then
    return self.teamB and self.teamB:GetSelfTeamRole()
  end
end

function BattlefieldDsbDuelActInfo:GetAllianceRankList()
  return self.groupRankList
end

function BattlefieldDsbDuelActInfo:GetSelfAllianceRank()
  return self.selfRank
end

function BattlefieldDsbDuelActInfo:GetCurNumByStateAndTeam(state, team)
  local num = 0
  for _, v in pairs(self.playerList) do
    if (team == 0 or v.team == team) and v.state == state then
      num = num + 1
    end
  end
  return num
end

function BattlefieldDsbDuelActInfo:GetCurNumByTeam(team)
  local num = 0
  for _, v in pairs(self.playerList) do
    if v.team == team then
      num = num + 1
    end
  end
  return num
end

function BattlefieldDsbDuelActInfo:GetCurCommanderNum(team)
  local num = 0
  for _, v in pairs(self.playerList) do
    if v.team == team and v.commander then
      num = num + 1
    end
  end
  return num
end

function BattlefieldDsbDuelActInfo:GetPlayerList()
  return self.playerList
end

function BattlefieldDsbDuelActInfo:GetPlayerInfoByUID(uid)
  return self.playerList[uid]
end

function BattlefieldDsbDuelActInfo:SelectPlayer(uid, state, group)
  if self.playerList[uid] ~= nil then
    if self.playerList[uid].state == state then
      return
    end
    if state == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main then
      local maxNum = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
      local curNum = self:GetCurNumByStateAndTeam(state, group)
      if maxNum <= curNum then
        UIUtil.ShowTipsId("458148")
        EventManager:GetInstance():Broadcast(EventId.DsbDuelActPlayerListUpdate)
        return
      else
        self:AssignPlayer(uid, state, group)
      end
    elseif state == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Sub then
      local maxNum = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k5", 10)
      local curNum = self:GetCurNumByStateAndTeam(state, group)
      if maxNum <= curNum then
        UIUtil.ShowTipsId("458149")
        EventManager:GetInstance():Broadcast(EventId.DsbDuelActPlayerListUpdate)
        return
      else
        self:AssignPlayer(uid, state, group)
      end
    end
    self.playerList[uid].state = state
  end
end

function BattlefieldDsbDuelActInfo:AssignPlayer(uid, state, group)
  local data = {
    team = group,
    targetUid = uid,
    state = state
  }
  self:SendActAssignMsg(data)
end

function BattlefieldDsbDuelActInfo:CancelPlayer(uid, group)
  local playerInfo = self.playerList[uid]
  if playerInfo ~= nil then
    local data = {
      team = group,
      targetUid = uid,
      state = 0
    }
    self:SendActAssignMsg(data)
  end
end

function BattlefieldDsbDuelActInfo:RefreshAutoRequestTimer()
end

function BattlefieldDsbDuelActInfo:GetLogList()
  return self.logList
end

function BattlefieldDsbDuelActInfo:GetBattleHistoryList()
  return self.battleHistoryInfo
end

function BattlefieldDsbDuelActInfo:GetReceiveState(rewardId, isAllianceReward)
  if self.rewardList[rewardId] then
    return self.rewardList[rewardId]:GetReceiveState(isAllianceReward)
  end
end

function BattlefieldDsbDuelActInfo:GetZoneRewardCount(rewardId)
  if self.rewardList[rewardId] then
    return self.rewardList[rewardId]:GetZoneRewardCount()
  end
end

function BattlefieldDsbDuelActInfo:GetCurrentRankRewards(type)
  local ret = {}
  if self.rewardList then
    for k, v in pairs(self.rewardList) do
      local template = BattlefieldDsbDuelUtils.ActTemplateInfo:GetLWDsbLeagueRankRewardTemplate(v.id)
      if template and template.type == type then
        table.insert(ret, template)
      end
    end
  end
  table.sort(ret, function(a, b)
    return a.id < b.id
  end)
  return ret
end

function BattlefieldDsbDuelActInfo:GetCanReceiveRewardNum(rankRewardId, isAllianceReward)
  local ret = 0
  if rankRewardId then
    if self:GetReceiveState(rankRewardId, isAllianceReward) == BattlefieldDsbConst.BF_DSB_REWARD_STATE.CanReceive then
      ret = 1
    end
  else
    for k, v in pairs(self.rewardList) do
      if v:HasRewardToReceive(isAllianceReward) then
        ret = ret + 1
      end
    end
  end
  return ret
end

function BattlefieldDsbDuelActInfo:GetCanReceiveRewardNumByToggle(rewardGroupType)
  local ret = 0
  for k, v in pairs(self.rewardList) do
    local template = BattlefieldDsbDuelUtils.ActTemplateInfo:GetLWDsbLeagueRankRewardTemplate(v.id)
    if template and template.type == rewardGroupType then
      ret = ret + (v:HasRewardToReceive(true) and 1 or 0) + (v:HasRewardToReceive(false) and 1 or 0)
    end
  end
  return ret
end

function BattlefieldDsbDuelActInfo:GetGuideList()
  if self.theGuideList == nil then
    self.theGuideList = BattleFieldUtil.GetGuideList(BattleFieldType.DsbDuel)
  end
  return self.theGuideList
end

function BattlefieldDsbDuelActInfo:GetIsShownPopUp()
  if not self.signUpEndTime then
    return false
  end
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.DSB_IS_SHOWN_POP_UP_WINDOW .. self.signUpEndTime, false)
end

function BattlefieldDsbDuelActInfo:SetIsShownPopUp(show)
  if not self.signUpEndTime then
    return
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DSB_IS_SHOWN_POP_UP_WINDOW .. self.signUpEndTime, show)
end

function BattlefieldDsbDuelActInfo:GetIsShownTopItemFinger()
  if not self.signUpEndTime then
    return false
  end
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.DSB_IS_SHOWN_ACT_TOP_ITEM_FINGER .. self.signUpEndTime, false)
end

function BattlefieldDsbDuelActInfo:SetIsShownTopItemFinger(show)
  if not self.signUpEndTime then
    return
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DSB_IS_SHOWN_ACT_TOP_ITEM_FINGER .. self.signUpEndTime, show)
end

function BattlefieldDsbDuelActInfo:CheckIsNeedPop()
  if not self:CheckIfActOpen() or self.signUpEndTime == 0 or self:GetMinLevel() > DataCenter.BuildManager:GetMainLevel() then
    return false
  end
  if self:GetIsShownPopUp() then
    return false
  end
  local isFunctionOn = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
  if not isFunctionOn then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UIBFDsbDuelActFirstPopUpView, {anim = true})
  else
    DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.ActDsbDuel)
  end
end

function BattlefieldDsbDuelActInfo:GetIsShownWeekEndPopUp()
  if not self.signUpEndTime then
    return false
  end
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.DSB_IS_SHOWN_WEEK_END_POP_UP_WINDOW .. self.signUpEndTime .. self.battleWeek, false)
end

function BattlefieldDsbDuelActInfo:SetIsShownWeekEndPopUp(show)
  if not self.signUpEndTime then
    return
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DSB_IS_SHOWN_WEEK_END_POP_UP_WINDOW .. self.signUpEndTime .. self.battleWeek, show)
end

function BattlefieldDsbDuelActInfo:CheckIsWeekEndNeedPop()
  if not self:CheckIfActOpen() or self.signUpEndTime == 0 or not self:IsInTeamResultShowPhase() then
    return false
  end
  if self:GetIsShownWeekEndPopUp() then
    return false
  end
  local teamA = BattlefieldDsbDuelUtils.ActInfo:GetTeamInfo(BattlefieldDsbConst.TeamType.A)
  if teamA == nil or teamA:GetState() == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.NotSignUp then
    return false
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelActWeekEndPopUpView, {anim = true})
end

function BattlefieldDsbDuelActInfo:GetIsOpenEntranceInThisTeamSignUpPhase()
  if not self.teamSignUpEndTime then
    return false
  end
  return CommonUtil.PlayerPrefsGetBool(SettingKeys.DSB_IS_OPEN_ENTRANCE_IN_TEAM_SIGN_UP .. self.teamSignUpEndTime, false)
end

function BattlefieldDsbDuelActInfo:SetIsOpenEntranceInThisTeamSignUpPhase(show)
  if not self.teamSignUpEndTime then
    return
  end
  CommonUtil.PlayerPrefsSetBool(SettingKeys.DSB_IS_OPEN_ENTRANCE_IN_TEAM_SIGN_UP .. self.teamSignUpEndTime, show)
end

function BattlefieldDsbDuelActInfo:TryEnterBattle()
  if self:GetSelfTeam() == BattlefieldDsbConst.TeamType.None then
    return
  end
  local selfTeamId = self:GetSelfTeam()
  local isInTeamBattleReadyPhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattleReadyPhase()
  local isTeamMatched = BattlefieldDsbDuelUtils.ActInfo:IsTeamMatched(selfTeamId)
  local isInTeamBattlePhase = BattlefieldDsbDuelUtils.ActInfo:IsInTeamBattlePhase()
  local canEnterBattle = false
  if isInTeamBattleReadyPhase then
    local selfAssigned = BattlefieldDsbDuelUtils.ActInfo:GetSelfAssigned()
    canEnterBattle = isTeamMatched and selfAssigned == BattlefieldDsbConst.BF_DSB_PLAYER_STATE.Main
  else
    canEnterBattle = isTeamMatched and isInTeamBattlePhase
  end
  if canEnterBattle then
    DataCenter.BattlefieldDsbDuelManager:TryEnterBattlefield()
  end
end

local rewardType2prop = {
  [EpidemicRankRewardType.BattleScore] = "battle_score_ranking_reward",
  [EpidemicRankRewardType.Cooperation] = "cooperation_score_ranking_reward",
  [EpidemicRankRewardType.Tactics] = "tactics_score_ranking_reward"
}
local roleReward2prop = {
  [BattlefieldDsbConst.BF_DSB_REWARD_RANK.Rank1] = 1,
  [BattlefieldDsbConst.BF_DSB_REWARD_RANK.Rank2] = 2,
  [BattlefieldDsbConst.BF_DSB_REWARD_RANK.Rank3] = 3,
  [BattlefieldDsbConst.BF_DSB_REWARD_RANK.Rank4] = 4
}

function BattlefieldDsbDuelActInfo:GetRankBattleReward(role, rewardType)
  local id = roleReward2prop[role]
  local name = rewardType2prop[rewardType]
  if not id or not name then
    BattlefieldDsbDuelUtils.LogError("Get rank battle reward failed. rewardType:%s", rewardType)
    return {}
  end
  if not self.rankRewardCache then
    self.rankRewardCache = {}
  end
  local _targetKey = role * 1000 + rewardType
  if not self.rankRewardCache[_targetKey] then
    local _ = {}
    local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.REWARD)
    local line = LocalController:instance():getLine(tbName, id)
    if not line then
      BattlefieldDsbDuelUtils.LogError("Get rank battle reward line failed. Role:%s, rewardType:%s", role, rewardType)
      self.rankRewardCache[_targetKey] = _
      return _
    end
    local _key
    for k, v in pairs(rewardType2prop) do
      _key = role * 1000 + k
      local ranks = {}
      self.rankRewardCache[_key] = ranks
      local _str = line[v]
      local _line1 = string.split_ss_array(_str, "|")
      for _, rankAndReward in ipairs(_line1) do
        local rankItem = {}
        local rankAndRewardArray = string.split_ss_array(rankAndReward, ";")
        if 2 <= #rankAndRewardArray then
          rankItem.rewardId = tonumber(rankAndRewardArray[2])
          local _lvs = string.split_ii_array(rankAndRewardArray[1], "-")
          rankItem.from = _lvs and _lvs[1] or 0
          rankItem.to = _lvs and _lvs[2] or rankItem.from
        end
        table.insert(ranks, rankItem)
      end
    end
  end
  if not self.rankRewardCache[_targetKey] then
    self.rankRewardCache[_targetKey] = {}
    BattlefieldDsbDuelUtils.LogError("Get rank battle reward data failed. Role:%s, rewardType:%s", role, rewardType)
  end
  return self.rankRewardCache[_targetKey]
end

function BattlefieldDsbDuelActInfo:GetScoreRewards(allianceRank)
  if not self.scoreRewardsCache then
    self.scoreRewardsCache = {}
  end
  if not self.scoreRewardsCache[allianceRank] then
    local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.REWARD)
    local line = LocalController:instance():getLine(tbName, allianceRank)
    if line then
      self.scoreRewardsCache[allianceRank] = string.string2table_ii_toList(line.score_reward, ",", ";")
    end
  end
  if not self.scoreRewardsCache[allianceRank] then
    self.scoreRewardsCache[allianceRank] = {}
  end
  return self.scoreRewardsCache[allianceRank]
end

function BattlefieldDsbDuelActInfo:GetWinnerRewardIdByTeamType(teamType)
  if not self.winnerRewardCache then
    self.winnerRewardCache = {}
    self.winnerRewardCache[EpidemicTeamRewardType.AB] = {}
    self.winnerRewardCache[EpidemicTeamRewardType.A] = {}
  end
  for id = BattlefieldDsbConst.GroupRewardType.Min, BattlefieldDsbConst.GroupRewardType.Max do
    local _id = roleReward2prop[id]
    if not self.winnerRewardCache[EpidemicTeamRewardType.AB][_id] or not self.winnerRewardCache[EpidemicTeamRewardType.A][_id] then
      local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.REWARD)
      local line = LocalController:instance():getLine(tbName, _id)
      if line then
        self.winnerRewardCache[EpidemicTeamRewardType.AB][_id] = {
          rewardId = line.win_alliance_reward
        }
        self.winnerRewardCache[EpidemicTeamRewardType.A][_id] = {
          rewardId = line.win_alliance_reward_abandonB
        }
      end
    end
  end
  return self.winnerRewardCache[teamType]
end

function BattlefieldDsbDuelActInfo:GetPersonalRewardId()
  if not self.personalRewardCache then
    self.personalRewardCache = {}
  end
  for id = BattlefieldDsbConst.GroupRewardType.Min, BattlefieldDsbConst.GroupRewardType.Max do
    local _id = roleReward2prop[id]
    if not self.personalRewardCache[_id] then
      local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.REWARD)
      local line = LocalController:instance():getLine(tbName, _id)
      if line then
        self.personalRewardCache[_id] = {
          rewardId = line.participants_reward
        }
      end
    end
  end
  return self.personalRewardCache
end

function BattlefieldDsbDuelActInfo:GetBuffDesc(template)
  if template == nil then
    return
  end
  local buffShowMap = template.buffShowMap
  if table.IsNullOrEmpty(buffShowMap) then
    return Localization:GetString(template.desc)
  end
  local effects = template.effects or {}
  local values = {}
  for _, v in ipairs(buffShowMap) do
    if v == 99 then
      table.insert(values, template.duration_time)
    else
      local eff = effects[v]
      local effVal = eff ~= nil and eff.lordEffectVal or 0
      local effId = eff.lordEffectId
      local type = toInt(GetTableData(TableName.LW_Effect_Number, tonumber(effId), "type"))
      if type ~= 0 then
        effVal = effVal * 1.0E-4
      end
      local value = UIUtil.ParseEffectValue(effId, effVal)
      table.insert(values, value)
    end
  end
  return Localization:GetString(template.desc, table.unpack(values))
end

function BattlefieldDsbDuelActInfo:GetTemplateBuffById(id)
  if self.templateBuffs == nil then
    self.templateBuffs = {}
  end
  local template = self.templateBuffs[id]
  if self.templateBuffs[id] == nil then
    local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.PARAM)
    local lineData = LocalController.instance():getLine(tbName, id)
    if lineData ~= nil then
      template = {}
      template.id = id
      template.name = lineData:getValue("name")
      template.desc = lineData:getValue("desc")
      template.icon = string.format(LoadPath.LWBattleFieldPath, lineData:getValue("map_icon"))
      template.probability = lineData:getIntValue("probability")
      template.duration_time = lineData:getIntValue("duration_time")
      template.active_effect = lineData:getValue("active_effect")
      local effects = {}
      local mySplit = string.split
      local list = mySplit(lineData:getValue("effect_number"), "|")
      if 0 < #list then
        for _, v in ipairs(list) do
          local tmp = mySplit(v, ";")
          table.insert(effects, {
            lordEffectId = tmp[1] or 0,
            lordEffectVal = tmp[2] or 0
          })
        end
      end
      template.effects = effects
      template.buffShowMap = string.string2array_num_oneSep(lineData:getValue("buff_para_show_map"), ",")
      
      function template.getDesc()
        return self:GetBuffDesc(template)
      end
      
      self.templateBuffs[id] = template
    end
  end
  return template
end

function BattlefieldDsbDuelActInfo:CheckAllianceIsValid()
  return self:GetSelfTeamState() == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess
end

function BattlefieldDsbDuelActInfo:CheckSelfAssigned()
  return self:GetSelfAssigned() ~= BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None
end

function BattlefieldDsbDuelActInfo:CheckCanEnterBattlefield(checkType)
  if checkType == BattlefieldEnterCheckType.AllianceIsValid then
    return true, self:GetSelfTeamState() == BattlefieldDsbConst.BF_DSB_TEAM_STATE.MatchSuccess, {"458135", ""}
  elseif checkType == BattlefieldEnterCheckType.YouAreLowBeMember then
    return true, self:GetSelfAssigned() ~= BattlefieldDsbConst.BF_DSB_PLAYER_STATE.None, {"458137"}
  elseif checkType == BattlefieldEnterCheckType.InBlackRect then
    return true, not LuaEntry.Player:IsInBlackRange(true) and not LuaEntry.Player:IsInCityField(true), {"458138"}
  end
  return nil
end

function BattlefieldDsbDuelActInfo:GetTemplateScoreTypes()
  if self.templateScoreTypes == nil then
    local dic = {}
    local mySplitI = string.string2array_i_oneSep
    local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.P_POINT_TYPE)
    LocalController.instance():visitTable(tbName, function(id, lineData)
      local data = {}
      data.id = id
      data.name = lineData:getValue("name")
      data.icon = lineData:getValue("icon")
      data.types = mySplitI(lineData:getValue("sub_type"), ",")
      data.showIds = mySplitI(lineData:getValue("show_id"), ",")
      dic[id] = data
    end)
    self.templateScoreTypes = dic
  end
  local list = {}
  for k, v in pairs(self.templateScoreTypes) do
    table.insert(list, v)
  end
  return list
end

function BattlefieldDsbDuelActInfo:GetEnterBattleState()
  if self.lastEnterBattleTime == 0 then
    return BattlefieldDsbConst.EnterBattleState.None
  elseif self.lastEnterBattleTime > 0 then
    return BattlefieldDsbConst.EnterBattleState.InBattle
  else
    return BattlefieldDsbConst.EnterBattleState.LeaveBattle
  end
end

function BattlefieldDsbDuelActInfo:Description()
  local sb = StringBuilder.New()
  
  local function add(k, v)
    sb:AppendFormat("%s=%s\n", k, tostring(v))
  end
  
  add("\230\168\161\230\157\191ID", self.templateId)
  add("\230\180\187\229\138\168\228\191\161\230\129\175\229\183\178\229\136\157\229\167\139\229\140\150", self.isActInfoInit)
  add("\230\136\152\230\150\151\229\145\168", self.battleWeek)
  add("\230\137\128\229\156\168\231\187\132\229\136\171", self.selfGroup)
  add("\229\183\178\230\138\165\229\144\141", self.isRegister)
  add("\229\189\147\229\137\141\229\176\143\233\152\182\230\174\181", self:GetCurrentPhaseIndex())
  add("\229\189\147\229\137\141\229\164\167\233\152\182\230\174\181", self:GetCurrentBigPhaseIndex())
  local tm = UITimeManager:GetInstance()
  
  local function fmt_ms_to_time(ms)
    if not ms or ms == 0 then
      return "0"
    end
    return tm:TimeStampToTimeForServer(ms)
  end
  
  local serverTime = tm:GetServerTime()
  
  local function _checkTime(cur, startTime, endTime)
    if startTime <= cur and cur < endTime then
      return " [\226\136\154]"
    end
    return ""
  end
  
  add("\230\138\165\229\144\141\231\187\147\230\157\159", fmt_ms_to_time(self.signUpEndTime))
  add("\229\136\134\231\187\132\231\187\147\230\157\159", fmt_ms_to_time(self.groupEndTime))
  add("\231\187\147\230\158\156\229\177\149\231\164\186\229\188\128\229\167\139", fmt_ms_to_time(self.resultShowTime))
  add("\230\136\152\233\152\159\230\138\165\229\144\141\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamSignUpStartTime), fmt_ms_to_time(self.teamSignUpEndTime), _checkTime(serverTime, self.teamSignUpStartTime, self.teamSignUpEndTime)))
  add("\230\136\152\233\152\159\229\140\185\233\133\141\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamMatchStartTime), fmt_ms_to_time(self.teamMatchEndTime), _checkTime(serverTime, self.teamMatchStartTime, self.teamMatchEndTime)))
  add("\230\136\152\233\152\159\229\164\135\230\136\152\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamMatchEndTime), fmt_ms_to_time(self.teamBattleReadyStartTime), _checkTime(serverTime, self.teamMatchEndTime, self.teamBattleReadyStartTime)))
  add("\230\136\152\233\152\159\229\135\134\229\164\135\230\136\152\230\150\151\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamBattleReadyStartTime), fmt_ms_to_time(self.teamBattleReadyEndTime), _checkTime(serverTime, self.teamBattleReadyStartTime, self.teamBattleReadyEndTime)))
  add("\230\136\152\233\152\159\230\136\152\230\150\151\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamBattleStartTime), fmt_ms_to_time(self.teamBattleEndTime), _checkTime(serverTime, self.teamBattleStartTime, self.teamBattleEndTime)))
  add("\230\136\152\233\152\159\231\187\147\231\174\151\233\152\182\230\174\181", string.format("%s~%s%s", fmt_ms_to_time(self.teamResultShowStartTime), fmt_ms_to_time(self.teamResultShowEndTime), _checkTime(serverTime, self.teamResultShowStartTime, self.teamResultShowEndTime)))
  add("\230\136\145\232\135\170\229\183\177\231\154\132\230\136\152\230\150\151\228\191\161\230\129\175(\233\152\159\228\188\141-\232\129\148\231\155\159)", self.selfBattleAllianceInfo and "\230\156\137" or "\230\151\160")
  add("\230\136\145\232\135\170\229\183\177\231\154\132\233\152\159\228\188\141", self:GetSelfTeam() or "\230\151\160")
  add("\230\136\145\232\135\170\229\183\177\231\154\132\233\152\159\228\188\141\231\154\132\229\140\185\233\133\141\231\138\182\230\128\129", self:GetSelfTeamState() or "\230\151\160")
  add("\230\136\145\232\135\170\229\183\177\231\154\132\228\184\187\232\190\133\232\186\171\228\187\189", self:GetSelfAssigned() or "\230\151\160")
  add("\232\189\174\231\169\186: A\233\152\159:", self.teamAEmptyCount)
  add("\232\189\174\231\169\186: B\233\152\159:", self.teamBEmptyCount)
  add("\230\156\141\229\138\161\229\153\168\230\151\182\233\151\180", fmt_ms_to_time(serverTime))
  if self.lastEnterBattleTime == 0 then
    add("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180", "\230\178\161\230\156\137\239\188\129")
  elseif self.lastEnterBattleTime < 0 then
    add("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180", "\229\183\178\231\166\187\229\188\128\230\136\152\229\156\186")
  else
    add("\228\184\138\230\172\161\232\191\155\229\133\165\230\136\152\229\156\186\231\154\132\230\151\182\233\151\180", fmt_ms_to_time(self.lastEnterBattleTime * 1000))
  end
  return sb:ToString()
end

return BattlefieldDsbDuelActInfo
