local NewPeakArenaManager = BaseClass("NewPeakArenaManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.state = NewPeakArenaState.Invalide
  self.info = nil
  self.rankData = nil
  self.showSelfRank = nil
  self.showSelfCount = nil
  self.rankRewards = nil
  self.defLoseTimes = 0
  self.remainPraise = 0
  self.arenaType = 0
  self.arenaMainGotoTab = nil
  self.upStartTime = nil
  self.showChampionDuel = false
  self.switchTimer = 0
  self.build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
end

local function __delete(self)
  self.state = NewPeakArenaState.Invalide
  self.info = nil
  self.rankData = nil
  self.showSelfRank = nil
  self.showSelfCount = nil
  self.upStartTime = nil
  self.showChampionDuel = nil
  self.switchTimer = nil
  self.build = nil
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

local function CheckIsNeedPop(self)
  local pop = CommonUtil.PlayerPrefsGetBool(SettingKeys.POP_NEWPEAKARENA_DIALOG, true)
  local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
  if build == nil or build.level < 1 then
    pop = false
  end
  return pop and self.state ~= NewPeakArenaState.Invalide
end

local function OnGetArenaInfo(self, info)
  if info == nil then
    return
  end
  self.info = info
  if self.info.defLoseTimes then
    self.defLoseTime = self.info.defLoseTimes
  end
  self.arenaType = self.info.arenaType
  self.remainPraise = self.info.remainPraise
  self.state = NewPeakArenaState.Invalide
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if info.showTime == 0 then
    if info.startTime and info.startTime ~= 0 then
      self.state = NewPeakArenaState.FirstPreview
      self.countDown = info.startTime - serverTime
    end
  else
    local a = serverTime >= info.startTime
    local b = serverTime <= info.endTime
    if serverTime >= info.startTime and serverTime <= info.endTime then
      self.state = NewPeakArenaState.Open
      self.countDown = info.endTime - serverTime
    elseif serverTime > info.endTime then
      self.state = NewPeakArenaState.Finshed
    else
      self.state = NewPeakArenaState.Preview
      self.countDown = info.startTime - serverTime
    end
  end
  if self.state == PVPArenaState.Open or self.state == PVPArenaState.FirstPreview then
    local flag = CommonUtil.PlayerPrefsGetInt("__NewPeaakArenaState_Flag", 0)
    self.showNew = flag == 0
  else
    CommonUtil.PlayerPrefsSetInt("__NewPeaakArenaState_Flag", 0)
    self.showNew = nil
  end
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  if self.countDown and 0 < self.countDown then
    self.cdTimer = TimerManager:GetInstance():GetTimer(1, __TickCountDown, self, false, false, false)
  end
  EventManager:GetInstance():Broadcast(EventId.NewPeakArenaInfoRefresh)
end

local function GetRedDotCount(self)
  local redDotCount = 0
  if self.rankData and self.rankData.curRank and 0 < self.rankData.curRank and self.state ~= NewPeakArenaState.Invalide then
    if self.state == NewPeakArenaState.Open and self.rankData.battleTimes and 0 < self.rankData.battleTimes then
      redDotCount = self.rankData.battleTimes
    end
    if 0 < self.defLoseTimes then
      redDotCount = redDotCount + self.defLoseTimes
    end
  end
  return redDotCount
end

local function GetMyPower(self)
  return self.rankData.formationPower
end

local function IsNeedPlayRankAnim(self)
  return self.showLastSelfRank and self.showSelfRank and self.showLastSelfRank ~= self.showSelfRank
end

local function ResetLastSelfRank(self)
  self.showLastSelfRank = self.showSelfRank
end

local function IsNeedShowBoxTip(self)
  return self.showLastSelfCount and self.showSelfCount and self.showLastSelfCount ~= self.showSelfCount
end

local function ResetLastSelfCount(self)
  self.showLastSelfCount = self.showSelfCount
end

local function NewArenaRankListHandler(self, msg)
  self.rankData = msg
  self.showLastSelfRank = self.showSelfRank
  self.showSelfRank = msg.curRank or 0
  if self.showLastSelfRank == nil then
    self.showLastSelfRank = self.showSelfRank
  end
  self.showLastSelfCount = self.showSelfCount
  self.showSelfCount = msg.battleCount or 0
  if self.showLastSelfCount == nil then
    self.showLastSelfCount = self.showSelfCount
  end
  if msg.defLoseTimes then
    self.defLoseTime = msg.defLoseTimes
  end
  self.remainPraise = msg.remainPraise
  self.arenaType = msg.arenaType
  EventManager:GetInstance():Broadcast(EventId.NewPeakArenaGetRankList, msg)
  EventManager:GetInstance():Broadcast(EventId.NewPeakArenaRefreshRedPoint)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

local function SendNewArenaPraise(self, uid)
  if self.remainPraise and self.remainPraise <= 0 then
    local maxPraiseNum = LuaEntry.DataConfig:TryGetNum("new_arena_settings", "k1")
    UIUtil.ShowTips(Localization:GetString(500229, maxPraiseNum))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.NewArenaPraise, uid)
end

local function NewArenaPraiseHandler(self, msg)
  self.remainPraise = msg.remainPraise
  self.info.remainPraise = msg.remainPraise
  self.rankData.remainPraise = msg.remainPraise
  self:SetPlayerLikeCount(msg.uid, msg.praiseNum)
end

local function SetPlayerLikeCount(self, uid, praise)
  for index, value in ipairs(self.rankData.players) do
    if value.uid == uid then
      value.praise = praise
    end
  end
end

local function HavePraiseNum(self)
  return self.rankData.remainPraise and self.rankData.remainPraise > 0 or false
end

local function NewArenaRewardHandler(self, msg)
  if msg.target then
    for k, v in pairs(msg.target) do
      self.rankData.dailyReward[tonumber(v)].rewarded = 1
    end
    EventManager:GetInstance():Broadcast(EventId.NewArenaReward)
  end
end

local function NewArenaRewardPreViewHandler(self, msg)
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

local function GetRankRewardData(self)
  return self.rankRewards
end

local function NewArenaLogRecordHandler(self, msg)
  if not msg then
    return
  end
  self.records = {}
  self.records = msg.logs
  EventManager:GetInstance():Broadcast(EventId.NewArenaLogRecord, self.records)
  self.defLoseTimes = 0
  EventManager:GetInstance():Broadcast(EventId.NewPeakArenaRefreshRedPoint)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

local function GetNeedGetRewardList(self)
  local needGetRewardList
  local dailyReward = DataCenter.NewPeakArenaManager.rankData.dailyReward
  local battleCount = DataCenter.NewPeakArenaManager.rankData.battleCount
  for index, value in ipairs(dailyReward) do
    if battleCount >= value.needCount and value.rewarded == 0 then
      if needGetRewardList == nil then
        needGetRewardList = {}
      end
      table.insert(needGetRewardList, index)
    end
  end
  return needGetRewardList
end

local function NeedShowUpBtn(self)
  return self.info.promoteQualification ~= nil
end

local function GetNewPeakArenaUpStartTime(self)
  if self.upStartTime == nil then
    self.upStartTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.NEWPEAKARENA_UP_STARTTIME, 0)
  end
  return self.upStartTime
end

local function SaveNewPeakArenaUpStartTime(self, startTime)
  if self.info == nil or self.upStartTime ~= startTime then
    self.upStartTime = startTime
    CommonUtil.PlayerPrefsSetLong(SettingKeys.NEWPEAKARENA_UP_STARTTIME, self.upStartTime)
  end
end

local function GetBuildBuildingType(self)
  local bubbleType = ArenaBubbleType.None
  local bubbleArenaType = {
    PVPArenaType.NewPeakArena,
    PVPArenaType.NewGaleArena,
    PVPArenaType.PeakArena,
    PVPArenaType.Arena3V3,
    PVPArenaType.NewbieArenaV2
  }
  local arenaBubbleInfo = {
    [PVPArenaType.NewPeakArena] = {
      showNew = DataCenter.NewPeakArenaManager.showNew,
      showVs = DataCenter.NewPeakArenaManager.state == NewPeakArenaState.Open or DataCenter.NewPeakArenaManager.state == NewPeakArenaState.FirstPreview,
      firstInfo = DataCenter.NewPeakArenaManager.info and DataCenter.NewPeakArenaManager.info.firstPlayerInfo or nil
    },
    [PVPArenaType.NewGaleArena] = {
      showNew = DataCenter.NewGaleArenaManager.showNew,
      showVs = DataCenter.NewGaleArenaManager.state == NewPeakArenaState.Open or DataCenter.NewGaleArenaManager.state == NewPeakArenaState.FirstPreview,
      firstInfo = DataCenter.NewGaleArenaManager.info and DataCenter.NewGaleArenaManager.info.firstPlayerInfo or nil
    },
    [PVPArenaType.PeakArena] = {
      showNew = DataCenter.LWPVPArenaManager.showNew,
      showVs = DataCenter.LWPVPArenaManager.state == PVPArenaState.Open,
      firstInfo = DataCenter.LWPVPArenaManager.info and DataCenter.LWPVPArenaManager.info.firstPlayerInfo or nil
    },
    [PVPArenaType.Arena3V3] = {
      showNew = DataCenter.LW3V3ArenaManager.showNew,
      showVs = DataCenter.LW3V3ArenaManager.state == PVPArenaState.Open,
      firstInfo = DataCenter.LW3V3ArenaManager.info and DataCenter.LW3V3ArenaManager.info.firstPlayerInfo or nil
    },
    [PVPArenaType.NewbieArenaV2] = {
      showNew = false,
      showVs = DataCenter.LWNewbieArenaManager:GetState() == ActivityArenaState.Fight,
      firstInfo = nil
    }
  }
  local showNewArenaType, showVsArenaType, showFirstArenaType, firstInfo
  for index, value in ipairs(bubbleArenaType) do
    local info = arenaBubbleInfo[value]
    if showNewArenaType == nil and info.showNew then
      showNewArenaType = value
    end
    if showVsArenaType == nil and info.showVs then
      showVsArenaType = value
    end
    if showFirstArenaType == nil and info.firstInfo then
      showFirstArenaType = value
      firstInfo = info.firstInfo
    end
  end
  local arenaType
  if showNewArenaType then
    bubbleType = ArenaBubbleType.New
    arenaType = showNewArenaType
  elseif showVsArenaType then
    bubbleType = ArenaBubbleType.VS
    arenaType = showVsArenaType
  elseif showFirstArenaType and firstInfo then
    bubbleType = ArenaBubbleType.ShowFirst
    arenaType = showFirstArenaType
  end
  local targetTime
  if arenaType == PVPArenaType.NewPeakArena then
    local info = DataCenter.NewPeakArenaManager.info
    local state = DataCenter.NewPeakArenaManager.state
    if info then
      if state == NewPeakArenaState.FirstPreview then
        targetTime = info.startTime
      elseif state == NewPeakArenaState.Preview then
        targetTime = info.startTime
      elseif state == NewPeakArenaState.Open then
        targetTime = info.endTime
      end
    end
  elseif arenaType == PVPArenaType.NewGaleArena then
    local info = DataCenter.NewGaleArenaManager.info
    local state = DataCenter.NewGaleArenaManager.state
    if info then
      if state == NewPeakArenaState.FirstPreview then
        targetTime = info.startTime
      elseif state == NewPeakArenaState.Preview then
        targetTime = info.startTime
      elseif state == NewPeakArenaState.Open then
        targetTime = info.endTime
      end
    end
  elseif arenaType == PVPArenaType.PeakArena then
    local info = DataCenter.LWPVPArenaManager.info
    local state = DataCenter.LWPVPArenaManager.state
    if info then
      if state == PVPArenaState.NotActive then
        targetTime = info.showTime
      elseif state == PVPArenaState.NotOpen then
        targetTime = info.startTime
      elseif state == PVPArenaState.Open then
        targetTime = info.endTime
      end
    end
  elseif arenaType == PVPArenaType.Arena3V3 then
    local info = DataCenter.LW3V3ArenaManager.info
    local state = DataCenter.LW3V3ArenaManager.state
    if info then
      if state == PVPArenaState.NotActive then
        targetTime = info.showTime
      elseif state == PVPArenaState.NotOpen then
        targetTime = info.startTime
      elseif state == PVPArenaState.Open then
        targetTime = info.endTime
      end
    end
  end
  return bubbleType, arenaType, firstInfo, targetTime
end

local function GetBuildBuildingTypeWithChampionDuel(self)
  if self.showChampionDuel then
    return ArenaBubbleType.ChampionDuel
  else
    return self:GetBuildBuildingType()
  end
end

local function OnClickBubble(self)
  local bubbleType, arenaType = self:GetBuildBuildingType()
  if self.arenaMainGotoTab == nil then
    self.arenaMainGotoTab = arenaType
  end
  if bubbleType == ArenaBubbleType.New then
    CommonUtil.PlayerPrefsSetInt("__NewPeaakArenaState_Flag", 1)
    DataCenter.NewPeakArenaManager.showNew = nil
    CommonUtil.PlayerPrefsSetInt("__NewGaleArenaState_Flag", 1)
    DataCenter.NewGaleArenaManager.showNew = nil
    CommonUtil.PlayerPrefsSetInt("__PVPArenaState_Flag", 1)
    DataCenter.LWPVPArenaManager.showNew = nil
    CommonUtil.PlayerPrefsSetInt("__3V3ArenaState_Flag", 1)
    DataCenter.LW3V3ArenaManager.showNew = nil
  end
end

local function UseKofBattle(self)
  return self.info.kofOpen and self.info.kofOpen == 1
end

local function ParseOpponentData(self, msg, isChallange)
  if not msg then
    return
  end
  local opponentData = {}
  opponentData.teams = {}
  if msg.otherInfo then
    local otherInfo = msg.otherInfo
    if isChallange then
      for i, v in ipairs(otherInfo.formationArr) do
        local info = ArenaArmyFormationInfo.New()
        info:ParseData(v)
        info.equipPower = v.equipPower
        info.power = v.power
        table.insert(opponentData.teams, info)
      end
      opponentData.playerInfo = otherInfo.playerInfo
      opponentData.playerInfo.power = otherInfo.formationPower or 0
      opponentData.power = otherInfo.formationPower or 0
      opponentData.score = otherInfo.score or 0
      if msg.ownerInfo ~= nil then
        opponentData.myPower = msg.ownerInfo.formationPower
        local ownerInfo = msg.ownerInfo
        for i, v in ipairs(ownerInfo.formationArr) do
          DataCenter.LWKOFBattleManager:ParseOneAtkTeam(TypeKOF.NewPeakArena, i, v)
        end
      end
      DataCenter.LWKOFBattleManager:SetOpponentData(opponentData)
    else
      for i, v in ipairs(otherInfo.formationArr) do
        DataCenter.LWKOFBattleManager:ParseOneDefenseTeam(TypeKOF.NewPeakArena, otherInfo.playerInfo.uid, i, v)
      end
    end
  elseif msg.ownerInfo then
    local ownerInfo = msg.ownerInfo
    for i, v in ipairs(ownerInfo.formationArr) do
      DataCenter.LWKOFBattleManager:ParseOneDefenseTeam(TypeKOF.NewPeakArena, LuaEntry.Player.uid, i, v)
    end
  end
end

local function SendNewArenaBattlePreView(self, uid, isChallange)
  if self:UseKofBattle() then
    SFSNetwork.SendMessage(MsgDefines.NewArenaKofBattlePreviewMessage, uid, isChallange)
  else
    SFSNetwork.SendMessage(MsgDefines.NewArenaBattlePreView, uid)
  end
end

local function GetChampionDuelIsOpen()
  local open = LuaEntry.DataConfig:CheckSwitch("new_activity_test2_migration")
  if not open then
    return false, nil
  end
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv >= SEASON_MIN_LEVEL then
    local list = DataCenter.ActivityListDataManager:GetNowActivityList(nil, true)
    for _, value in pairs(list) do
      if value.type == EnumActivity.ChampionDuelMain.Type then
        return true, value.startTime
      end
    end
  end
  return false, nil
end

local function GoToChampionDuelMain(self)
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ChampionDuelMain.Type)
  if actData and actData:GetValidType() == ActivityValidType.Now then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelMain, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllHide
    }, actData)
  else
    local beginTime = DataCenter.ChampionDuelManager:GetChampionDuelBeginTime()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelDetail, {anim = true}, 0, beginTime, true)
  end
end

local function OnUpdateBubbleState(self)
  if self.build then
    if self:GetChampionDuelIsOpen() then
      self.switchTimer = (self.switchTimer or 0) + 1
      if self.switchTimer >= 10 then
        self.switchTimer = 0
        self.showChampionDuel = not self.showChampionDuel
        DataCenter.BuildBubbleManager:CheckShowBubble(self.build.uuid)
      end
    else
      self.showChampionDuel = false
      DataCenter.BuildBubbleManager:CheckShowBubble(self.build.uuid)
    end
  else
    self.build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PVP_ARENA)
  end
end

NewPeakArenaManager.__init = __init
NewPeakArenaManager.__delete = __delete
NewPeakArenaManager.CheckIsNeedPop = CheckIsNeedPop
NewPeakArenaManager.OnGetArenaInfo = OnGetArenaInfo
NewPeakArenaManager.GetRedDotCount = GetRedDotCount
NewPeakArenaManager.GetMyPower = GetMyPower
NewPeakArenaManager.NewArenaRankListHandler = NewArenaRankListHandler
NewPeakArenaManager.NewArenaPraiseHandler = NewArenaPraiseHandler
NewPeakArenaManager.SetPlayerLikeCount = SetPlayerLikeCount
NewPeakArenaManager.IsNeedPlayRankAnim = IsNeedPlayRankAnim
NewPeakArenaManager.ResetLastSelfRank = ResetLastSelfRank
NewPeakArenaManager.IsNeedShowBoxTip = IsNeedShowBoxTip
NewPeakArenaManager.ResetLastSelfCount = ResetLastSelfCount
NewPeakArenaManager.SendNewArenaPraise = SendNewArenaPraise
NewPeakArenaManager.HavePraiseNum = HavePraiseNum
NewPeakArenaManager.NewArenaRewardHandler = NewArenaRewardHandler
NewPeakArenaManager.NewArenaRewardPreViewHandler = NewArenaRewardPreViewHandler
NewPeakArenaManager.GetRankRewardData = GetRankRewardData
NewPeakArenaManager.NewArenaLogRecordHandler = NewArenaLogRecordHandler
NewPeakArenaManager.GetNeedGetRewardList = GetNeedGetRewardList
NewPeakArenaManager.NeedShowUpBtn = NeedShowUpBtn
NewPeakArenaManager.GetNewPeakArenaUpStartTime = GetNewPeakArenaUpStartTime
NewPeakArenaManager.SaveNewPeakArenaUpStartTime = SaveNewPeakArenaUpStartTime
NewPeakArenaManager.GetBuildBuildingType = GetBuildBuildingType
NewPeakArenaManager.OnClickBubble = OnClickBubble
NewPeakArenaManager.UseKofBattle = UseKofBattle
NewPeakArenaManager.ParseOpponentData = ParseOpponentData
NewPeakArenaManager.SendNewArenaBattlePreView = SendNewArenaBattlePreView
NewPeakArenaManager.GetBuildBuildingTypeWithChampionDuel = GetBuildBuildingTypeWithChampionDuel
NewPeakArenaManager.GetChampionDuelIsOpen = GetChampionDuelIsOpen
NewPeakArenaManager.OnUpdateBubbleState = OnUpdateBubbleState
NewPeakArenaManager.GoToChampionDuelMain = GoToChampionDuelMain
return NewPeakArenaManager
