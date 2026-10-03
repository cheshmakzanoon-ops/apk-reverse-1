local NewGaleArenaManager = BaseClass("NewGaleArenaManager")
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
  local pop = CommonUtil.PlayerPrefsGetBool(SettingKeys.POP_NEWGALEARENA_DIALOG, true)
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
    self.defLoseTimes = self.info.defLoseTimes
  end
  self.arenaType = self.info.arenaType
  self.remainPraise = self.info.remainPraise
  self.state = NewPeakArenaState.Invalide
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if info.showTime == 0 then
    if info.startTime and info.startTime ~= 0 then
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
  if self.state == NewPeakArenaState.Open then
    local flag = CommonUtil.PlayerPrefsGetInt("__NewGaleArenaState_Flag", 0)
    self.showNew = flag == 0
  else
    CommonUtil.PlayerPrefsSetInt("__NewGaleArenaState_Flag", 0)
    self.showNew = nil
  end
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  if self.countDown and 0 < self.countDown then
    self.cdTimer = TimerManager:GetInstance():GetTimer(1, __TickCountDown, self, false, false, false)
  end
  EventManager:GetInstance():Broadcast(EventId.NewGaleArenaInfoRefresh)
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
    self.defLoseTimes = msg.defLoseTimes
  end
  self.remainPraise = msg.remainPraise
  self.arenaType = msg.arenaType
  EventManager:GetInstance():Broadcast(EventId.NewGaleArenaGetRankList, msg)
  EventManager:GetInstance():Broadcast(EventId.NewGaleArenaRefreshRedPoint)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

local function SendNewArenaPraise(self, uid)
  if self.remainPraise and self.remainPraise <= 0 then
    local maxPraiseNum = LuaEntry.DataConfig:TryGetNum("new_arena_settings", "k1")
    UIUtil.ShowTips(Localization:GetString(500229, maxPraiseNum))
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GaleArenaPraise, uid)
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
    EventManager:GetInstance():Broadcast(EventId.NewGaleArenaReward)
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
  EventManager:GetInstance():Broadcast(EventId.NewGaleArenaLogRecord, self.records)
  self.defLoseTimes = 0
  EventManager:GetInstance():Broadcast(EventId.NewGaleArenaRefreshRedPoint)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

local function GetNeedGetRewardList(self)
  local needGetRewardList
  local dailyReward = DataCenter.NewGaleArenaManager.rankData.dailyReward
  local battleCount = DataCenter.NewGaleArenaManager.rankData.battleCount
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
  return self.info.promoteQualification ~= nil or self.info.lowPromoteQualification ~= nil
end

local function GetNewPeakArenaUpStartTime(self)
  if self.upStartTime == nil then
    self.upStartTime = CommonUtil.PlayerPrefsGetLong(SettingKeys.NEWGALEARENA_UP_STARTTIME, 0)
  end
  return self.upStartTime
end

local function SaveNewPeakArenaUpStartTime(self, startTime)
  if self.info == nil or self.upStartTime ~= startTime then
    self.upStartTime = startTime
    CommonUtil.PlayerPrefsSetLong(SettingKeys.NEWGALEARENA_UP_STARTTIME, self.upStartTime)
  end
end

local function GetBuildBuildingType(self)
  return DataCenter.NewPeakArenaManager:GetBuildBuildingType()
end

local function GetBuildBuildingTypeWithChampionDuel(self)
  if self.showChampionDuel then
    return ArenaBubbleType.ChampionDuel
  else
    return self:GetBuildBuildingType()
  end
end

local function UseKofBattle(self)
  return self.info.kofOpen and self.info.kofOpen == 1
end

local function ParseOpponentData(self, msg, isChallange)
  return DataCenter.NewPeakArenaManager:ParseOpponentData(msg, isChallange)
end

local function SendNewArenaBattlePreView(self, uid)
  SFSNetwork.SendMessage(MsgDefines.GaleArenaBattlePreView, uid)
end

local function GetChampionDuelIsOpen()
  return DataCenter.NewPeakArenaManager:GetChampionDuelIsOpen()
end

local function GoToChampionDuelMain(self)
  return DataCenter.NewPeakArenaManager:GoToChampionDuelMain()
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

NewGaleArenaManager.__init = __init
NewGaleArenaManager.__delete = __delete
NewGaleArenaManager.CheckIsNeedPop = CheckIsNeedPop
NewGaleArenaManager.OnGetArenaInfo = OnGetArenaInfo
NewGaleArenaManager.GetRedDotCount = GetRedDotCount
NewGaleArenaManager.GetMyPower = GetMyPower
NewGaleArenaManager.NewArenaRankListHandler = NewArenaRankListHandler
NewGaleArenaManager.NewArenaPraiseHandler = NewArenaPraiseHandler
NewGaleArenaManager.SetPlayerLikeCount = SetPlayerLikeCount
NewGaleArenaManager.IsNeedPlayRankAnim = IsNeedPlayRankAnim
NewGaleArenaManager.ResetLastSelfRank = ResetLastSelfRank
NewGaleArenaManager.IsNeedShowBoxTip = IsNeedShowBoxTip
NewGaleArenaManager.ResetLastSelfCount = ResetLastSelfCount
NewGaleArenaManager.SendNewArenaPraise = SendNewArenaPraise
NewGaleArenaManager.HavePraiseNum = HavePraiseNum
NewGaleArenaManager.NewArenaRewardHandler = NewArenaRewardHandler
NewGaleArenaManager.NewArenaRewardPreViewHandler = NewArenaRewardPreViewHandler
NewGaleArenaManager.GetRankRewardData = GetRankRewardData
NewGaleArenaManager.NewArenaLogRecordHandler = NewArenaLogRecordHandler
NewGaleArenaManager.GetNeedGetRewardList = GetNeedGetRewardList
NewGaleArenaManager.NeedShowUpBtn = NeedShowUpBtn
NewGaleArenaManager.GetNewPeakArenaUpStartTime = GetNewPeakArenaUpStartTime
NewGaleArenaManager.SaveNewPeakArenaUpStartTime = SaveNewPeakArenaUpStartTime
NewGaleArenaManager.GetBuildBuildingType = GetBuildBuildingType
NewGaleArenaManager.UseKofBattle = UseKofBattle
NewGaleArenaManager.ParseOpponentData = ParseOpponentData
NewGaleArenaManager.SendNewArenaBattlePreView = SendNewArenaBattlePreView
NewGaleArenaManager.GetBuildBuildingTypeWithChampionDuel = GetBuildBuildingTypeWithChampionDuel
NewGaleArenaManager.GetChampionDuelIsOpen = GetChampionDuelIsOpen
NewGaleArenaManager.OnUpdateBubbleState = OnUpdateBubbleState
NewGaleArenaManager.GoToChampionDuelMain = GoToChampionDuelMain
return NewGaleArenaManager
