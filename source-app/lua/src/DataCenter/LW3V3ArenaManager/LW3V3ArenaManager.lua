local LW3V3ArenaManager = BaseClass("LW3V3ArenaManager")
local Localization = CS.GameEntry.Localization

function LW3V3ArenaManager:__init()
  self.selfRank = nil
  self.battleTimes = 0
  self.defLoseTimes = 0
  self.addPraiseNum = 0
  self.remainPraise = 0
  self.maxTimes = nil
  self.rankings = nil
  self.atkTeams = nil
  self.playersDefTeams = nil
  self.rankRewards = nil
  self.recordsMailState = {}
  self.showSelfRank = nil
  self.revengeNum = 0
end

function LW3V3ArenaManager:__delete()
  self.recordsMailState = nil
end

function LW3V3ArenaManager:InitData()
  self.redDotIgnore = nil
end

function LW3V3ArenaManager:Startup()
  self.state = PVPArenaState.Invalide
end

local function __TickCountDown(self)
  if self.countDown then
    self.countDown = self.countDown - 1
    if self.countDown <= 0 then
      if self.cdTimer then
        self.cdTimer:Stop()
        self.cdTimer = nil
      end
      SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
    end
  end
end

function LW3V3ArenaManager:OnGetArenaInfo(info)
  if not info then
    return
  end
  local isInit = false
  if self.state == nil then
    isInit = true
  end
  self.state = PVPArenaState.Invalide
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if info.showTime > 0 then
    if serverTime >= info.showTime then
      if serverTime > info.startTime and serverTime < info.endTime then
        self.state = PVPArenaState.Open
        self.countDown = info.endTime - serverTime
      else
        self.state = PVPArenaState.NotOpen
        self.countDown = info.startTime - serverTime
      end
    else
      self.state = PVPArenaState.NotActive
      self.countDown = info.showTime - serverTime
    end
  end
  if self.state == PVPArenaState.Open then
    local flag = CommonUtil.PlayerPrefsGetInt("__3V3ArenaState_Flag", 0)
    self.showNew = flag == 0
  else
    CommonUtil.PlayerPrefsSetInt("__3V3ArenaState_Flag", 0)
    self.showNew = nil
  end
  self.startTime = info.startTime or 0
  self.endTime = info.endTime or 0
  self.showTime = info.showTime or 0
  self.historyServers = info.historyServers
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  if self.countDown then
    self.cdTimer = TimerManager:GetInstance():GetTimer(1, __TickCountDown, self, false, false, false)
  end
  self.battleTimes = info.battleTimes or 0
  self.defLoseTimes = info.defLoseTimes or 0
  self.addPraiseNum = info.addPraiseNum or 0
  self.remainPraise = info.remainPraise or 0
  self.inRank = info.inRank
  if isInit and self.state == PVPArenaState.Open then
    local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
    if build == nil or 1 > build.level then
      return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local showPopup = false
    local lastOpenTime = Setting:GetString(SettingKeys.LASTTIME_ARENA3V3_OPEN, "")
    if string.IsNullOrEmpty(lastOpenTime) then
      showPopup = true
    else
      local lastOpenTimeNum = tonumber(lastOpenTime)
      if lastOpenTimeNum == nil then
        showPopup = true
      else
        local lastOpenTimeNumber = tonumber(lastOpenTime)
        if lastOpenTimeNumber < self.startTime then
          showPopup = true
        end
      end
    end
    if showPopup then
      local isFunctionOnNewPopupStyle = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
      if not isFunctionOnNewPopupStyle then
        DataCenter.UIPopWindowManager:Push(UIWindowNames.UILWArena3V3Popup, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
        Setting:SetString(SettingKeys.LASTTIME_ARENA3V3_OPEN, tostring(curTime))
      else
        DataCenter.LWPopupManager:TryAddPopupActivity(PopupActivityType.ThreeVThreeArena)
      end
    end
  end
end

function LW3V3ArenaManager:IsNeedPlayRankAnim()
  return self.showLastSelfRank and self.showSelfRank and self.showLastSelfRank ~= self.showSelfRank
end

function LW3V3ArenaManager:ResetLastSelfRank()
  self.showLastSelfRank = self.showSelfRank
end

function LW3V3ArenaManager:ParseOneDefenseTeam(uuid, index, data)
  DataCenter.LW3V3Manager:ParseOneDefenseTeam(Type3v3.Arena, uuid, index, data)
end

function LW3V3ArenaManager:ParseDefenseTeams(msg)
  if not msg then
    return
  end
  if msg.ownerInfo then
    local onwerInfo = msg.ownerInfo
    local uuid = onwerInfo.playerInfo.uid
    if onwerInfo.armyUnit1 then
      self:ParseOneDefenseTeam(uuid, 1, onwerInfo.armyUnit1)
    end
    if onwerInfo.armyUnit2 then
      self:ParseOneDefenseTeam(uuid, 2, onwerInfo.armyUnit2)
    end
    if onwerInfo.armyUnit3 then
      self:ParseOneDefenseTeam(uuid, 3, onwerInfo.armyUnit3)
    end
  end
end

function LW3V3ArenaManager:ParseRankingRewardData(msg)
  if not msg then
    return
  end
  self.rankRewards = {}
  if msg.rankRewards then
    self.rankRewards[PVPArenaRewardType.Rank] = msg.rankRewards
  else
    self.rankRewards[PVPArenaRewardType.Rank] = {}
  end
  if msg.winTimesRewards then
    self.rankRewards[PVPArenaRewardType.Personal] = msg.winTimesRewards
  else
    self.rankRewards[PVPArenaRewardType.Personal] = {}
  end
  if msg.allianceRewards then
    self.rankRewards[PVPArenaRewardType.Alliance] = msg.allianceRewards
  else
    self.rankRewards[PVPArenaRewardType.Alliance] = {}
  end
end

function LW3V3ArenaManager:GetRankRewardData()
  return self.rankRewards
end

function LW3V3ArenaManager:ParseOneAtkTeam(index, data)
  DataCenter.LW3V3Manager:ParseOneAtkTeam(Type3v3.Arena, index, data)
end

function LW3V3ArenaManager:ParseAtkTeams(msg)
  if not msg then
    return
  end
  if msg.armyUnit1 then
    self:ParseOneAtkTeam(1, msg.armyUnit1)
  end
  if msg.armyUnit2 then
    self:ParseOneAtkTeam(2, msg.armyUnit2)
  end
  if msg.armyUnit3 then
    self:ParseOneAtkTeam(3, msg.armyUnit3)
  end
end

function LW3V3ArenaManager:ParseRankingData(msg)
  if not msg then
    return
  end
  self.lastSelfRank = self.selfRank
  self.battleTimes = msg.battleTimes
  self.showTime = msg.showTime
  self.startTime = msg.startTime
  self.endTime = msg.endTime
  self.defLoseTimes = msg.defLoseTimes or 0
  self.addPraiseNum = msg.addPraiseNum or 0
  self.arena_id = msg.arena_id
  self.max_limit = msg.max_limit or 0
  self.remainPraise = msg.remainPraise or 0
  self.selfRank = msg.curRank or 0
  self.showLastSelfRank = self.showSelfRank
  self.showSelfRank = msg.curRank or 0
  self.revengeNum = msg.revengeNum or 0
  if msg.players then
    self.rankings = msg.players
  end
  EventManager:GetInstance():Broadcast(EventId.Arena3V3GetRankList)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

function LW3V3ArenaManager:ParseOpponentData(msg, isRevenge)
  if not msg then
    return
  end
  local opponentData = {}
  opponentData.teams = {}
  opponentData.is3V3Revenge = isRevenge or false
  if msg.otherInfo then
    local otherInfo = msg.otherInfo
    local uuid = otherInfo.playerInfo.uid
    if otherInfo.armyUnit1 then
      local info = ArenaArmyFormationInfo.New()
      info:ParseData(otherInfo.armyUnit1, true)
      opponentData.teams[1] = info
      opponentData.teams[1].equipPower = otherInfo.armyUnit1.equipPower
      opponentData.teams[1].power = otherInfo.armyUnit1.power
      self:ParseOneDefenseTeam(uuid, 1, otherInfo.armyUnit1)
    end
    if otherInfo.armyUnit2 then
      local info = ArenaArmyFormationInfo.New()
      info:ParseData(otherInfo.armyUnit2, true)
      opponentData.teams[2] = info
      opponentData.teams[2].equipPower = otherInfo.armyUnit2.equipPower
      opponentData.teams[2].power = otherInfo.armyUnit2.power
      self:ParseOneDefenseTeam(uuid, 2, otherInfo.armyUnit2)
    end
    if otherInfo.armyUnit3 then
      local info = ArenaArmyFormationInfo.New()
      info:ParseData(otherInfo.armyUnit3, true)
      opponentData.teams[3] = info
      opponentData.teams[3].equipPower = otherInfo.armyUnit3.equipPower
      opponentData.teams[3].power = otherInfo.armyUnit3.power
      self:ParseOneDefenseTeam(uuid, 3, otherInfo.armyUnit3)
    end
    opponentData.playerInfo = otherInfo.playerInfo
    opponentData.playerInfo.power = otherInfo.power or 0
    opponentData.power = otherInfo.power or 0
    opponentData.score = otherInfo.score or 0
    opponentData.enemyFormationSoldier = otherInfo.formationSoldier
    if msg.ownerInfo ~= nil then
      opponentData.myFormationSoldier = msg.ownerInfo.formationSoldier
    end
  end
  if msg.ownerInfo then
    self:ParseAtkTeams(msg.ownerInfo)
  end
  DataCenter.LW3V3Manager:SetOpponentData(opponentData)
  EventManager:GetInstance():Broadcast(EventId.Arena3V3OpponentMatch)
end

function LW3V3ArenaManager:OnBattleFinish(msg)
  if not msg then
    return
  end
  self.lastSelfRank = self.selfRank
  self.selfRank = msg.curRank or 0
  self.battleTimes = msg.battleTimes
  self.winTimes = msg.winTimes
  EventManager:GetInstance():Broadcast(EventId.Arena3V3BattleFinish, msg)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

function LW3V3ArenaManager:ParseRecords(msg)
  if not msg then
    return
  end
  self.records = {}
  self.records = msg.logs
  EventManager:GetInstance():Broadcast(EventId.Arena3V3GetRecords, self.records)
  self.defLoseTimes = 0
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

function LW3V3ArenaManager:GetPlayerScore(uid)
  if not self.rankings then
    return nil
  end
  for i, v in pairs(self.rankings) do
    if v.uid == uid then
      return v.score
    end
  end
end

function LW3V3ArenaManager:SendLike(uid)
  if self.remainPraise <= 0 then
    local maxPraiseNum = LuaEntry.DataConfig:TryGetNum("arena_score_settings", "k5")
    UIUtil.ShowTips(Localization:GetString(500229, maxPraiseNum))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.Arena3V3Like, uid)
end

function LW3V3ArenaManager:SetPlayerLikeCount(uid, likeCount)
  if self.rankings then
    for i, v in pairs(self.rankings) do
      if v.uid == uid then
        v.praise = likeCount
        break
      end
    end
  end
end

function LW3V3ArenaManager:GetPlayerData(uid)
  if not self.rankings then
    return nil
  end
  for i, v in pairs(self.rankings) do
    if v.uid == uid then
      return v
    end
  end
end

function LW3V3ArenaManager:RequestPlayerDefenceTeam(uid)
  SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaBattlePreivew, uid)
end

function LW3V3ArenaManager:CanChallange()
  if not self.inRank then
    return false
  end
  return self.inRank == 1
end

function LW3V3ArenaManager:ParseRevengeList(msg)
  if not msg then
    return
  end
  if msg.battleTimes then
    self.battleTimes = msg.battleTimes
  end
  EventManager:GetInstance():Broadcast(EventId.Arena3V3GetRevengeList, msg)
end

function LW3V3ArenaManager:OnRevengeGiveUp(msg)
  if not msg then
    return
  end
  if msg.uid and self.revengeNum then
    self.revengeNum = self.revengeNum - 1
    self.revengeNum = math.max(0, self.revengeNum)
    EventManager:GetInstance():Broadcast(EventId.Arena3V3RevengeNumChanged)
  end
  EventManager:GetInstance():Broadcast(EventId.Arena3V3RevengeGiveUp, msg)
end

function LW3V3ArenaManager:SetRedDotIgnore()
  local last = self.redDotIgnore or false
  self.redDotIgnore = true
  if not last then
    EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
  end
end

function LW3V3ArenaManager:GetRedDotCount()
  if self.redDotIgnore then
    return 0
  end
  local redDotCount = 0
  if 0 < self.remainPraise then
    redDotCount = redDotCount + self.remainPraise
  end
  local canChallange = self:CanChallange()
  if self.state == PVPArenaState.Open and canChallange then
    if 0 < self.battleTimes then
      redDotCount = self.battleTimes
    end
    if 0 < self.defLoseTimes then
      redDotCount = redDotCount + self.defLoseTimes
    end
    if 0 < self.revengeNum then
      redDotCount = redDotCount + self.revengeNum
    end
  end
  return redDotCount
end

return LW3V3ArenaManager
