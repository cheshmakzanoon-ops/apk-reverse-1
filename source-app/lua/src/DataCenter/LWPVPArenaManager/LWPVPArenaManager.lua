local LWPVPArenaManager = BaseClass("LWPVPArenaManager")

function LWPVPArenaManager:__init()
  self.battleTimes = 0
  self.defLoseTimes = 0
  self.max_limit = 0
end

function LWPVPArenaManager:__delete()
end

function LWPVPArenaManager:InitData()
  self.info = nil
  SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
end

function LWPVPArenaManager:Startup()
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

function LWPVPArenaManager:OnGetArenaInfo(info)
  self.info = info
  self.state = PVPArenaState.Invalide
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if info.showTime > 0 then
    if serverTime >= info.showTime then
      if serverTime < info.startTime then
        self.state = PVPArenaState.NotOpen
        self.countDown = info.startTime - serverTime
      else
        self.state = PVPArenaState.Open
        self.countDown = info.endTime - serverTime
      end
    else
      self.state = PVPArenaState.NotActive
      self.countDown = info.showTime - serverTime
    end
  end
  if self.state == PVPArenaState.Open then
    local flag = CommonUtil.PlayerPrefsGetInt("__PVPArenaState_Flag", 0)
    self.showNew = flag == 0
  else
    CommonUtil.PlayerPrefsSetInt("__PVPArenaState_Flag", 0)
    self.showNew = nil
  end
  if self.cdTimer then
    self.cdTimer:Stop()
  end
  if self.countDown then
    self.cdTimer = TimerManager:GetInstance():GetTimer(1, __TickCountDown, self, false, false, false)
  end
  self.battleTimes = info.battleTimes
  self.defLoseTimes = info.defLoseTimes
  self.max_limit = info.max_limit or 0
  self.inRank = info.inRank
  EventManager:GetInstance():Broadcast(EventId.PVPArenaInfoUpdate, self.state)
end

local function __IsNeedPlayRankAnimFunc(msg)
  return msg.lastSelfRank and msg.selfRank and msg.lastSelfRank ~= msg.selfRank
end

function LWPVPArenaManager:OnGetRankList(msg)
  msg.lastSelfRank = self.selfRank
  self.selfRank = nil
  for _, v in ipairs(msg.players) do
    if v.uid == LuaEntry.Player.uid then
      msg.selfRank = v.rank
      self.selfRank = v.rank
      break
    end
  end
  msg.IsNeedPlayRankAnim = __IsNeedPlayRankAnimFunc
  self.rankData = msg
  self.max_limit = msg.max_limit or 0
  self.battleTimes = msg.battleTimes
  self.defLoseTimes = msg.defLoseTimes
  EventManager:GetInstance():Broadcast(EventId.PeakArenaGetRankList, msg)
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

function LWPVPArenaManager:OnRankChange(msg)
  EventManager:GetInstance():Broadcast(EventId.PeakArenaRankChange, msg)
end

function LWPVPArenaManager:SetDefLoseTimes(num)
  self.defLoseTimes = num
  EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
end

function LWPVPArenaManager:CanChallange()
  if not self.inRank then
    return false
  end
  return self.inRank == 1
end

function LWPVPArenaManager:GetMyPower()
  if self.rankData ~= nil and self.rankData.formationPower ~= nil then
    return self.rankData.formationPower
  end
end

function LWPVPArenaManager:GetChallengeItemId()
  return 710000
end

function LWPVPArenaManager:GetChallengeLimit()
  local limit = 0
  if self.max_limit and self.battleTimes then
    limit = self.max_limit - self.battleTimes
  end
  return limit
end

function LWPVPArenaManager.ShowPVPArenaMain(...)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if mySourceServerId == loginServerId or LuaEntry.DataConfig:CheckServerIn("jjc_cross_server", "k1", mySourceServerId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaMain, {anim = false}, ...)
    return
  end
  EventManager:GetInstance():Broadcast(EventId.ShowCrossServerBubbleTips, 500019)
end

return LWPVPArenaManager
