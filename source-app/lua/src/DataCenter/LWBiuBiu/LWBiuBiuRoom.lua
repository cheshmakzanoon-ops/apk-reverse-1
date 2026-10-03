local LWBiuBiuRoom = BaseClass("LWBiuBiuRoom")
local LWBiuBiuResult = require("DataCenter.LWBiuBiu.LWBiuBiuResult")
local UIBootPvpConnect = CS.MiniGame.Biubiu.Client.UIBootPvpConnect
LWBiuBiuRoom.ErrorCode = {
  WAITJOIN_TIMEOUT = 0,
  MANUAL_CANCEL = 1,
  WAITREADY_TIMEOUT = 2,
  FIGHT_END = 3,
  KICK = 4,
  FORCE_CLOSE = 5,
  FIGHT_CREATE_FAIL = 7,
  GM_CLOSE = 10,
  FIGHT_END_ERROR = 31,
  ROOM_PVP_INFO_MISS = -1,
  CREATE_ROOM_FAIRED = -2,
  CREATE_GAME_VIEW_FAILED = -3,
  READY_FAIRED = -4,
  KICK_FAIRED = -5,
  PING_SERVER_FAIRED = -6,
  ENTER_GAME_FAILED = -7,
  ENTER_ROOM_TIME_OUT = -8,
  FIGHT_DESCRIBE_FAILED = -9,
  FIGHT_CREATE_FAILED = -10,
  FIGHT_CONNECT_GAME_LIFT = -11,
  FIGHT_LOAD_MAP_FAIRED = -12,
  FIGHT_WAIT_PLAYER = -13,
  FIGHT_CREATE_PLAYER_FAIR = -14
}

function LWBiuBiuRoom:__init()
  self.data = nil
  self.battleData = LWBiuBiuResult.New()
  self.sessionidgame = nil
  self.sessionidplayer = nil
end

function LWBiuBiuRoom:__delete()
  self.data = nil
  self.battleData = nil
  self.sessionidgame = nil
  self.sessionidplayer = nil
end

function LWBiuBiuRoom:Error(errorCode)
  local sessionidgame = self.sessionidgame or ""
  local sessionidplayer = self.sessionidplayer or ""
  Logger.LogInfo("[LWBiuBiu] Room ErrorCode" .. errorCode .. " sessionidgame is " .. sessionidgame .. " sessionidplayer is " .. sessionidplayer)
end

function LWBiuBiuRoom:Info(msg)
  Logger.LogInfo("[LWBiuBiu] Room Info :" .. msg)
end

function LWBiuBiuRoom:VersionDiff()
  local codeMd5 = ""
  local FuncVersion = CS.MiniGame.Biubiu.Client.FuncVersion
  if FuncVersion then
    codeMd5 = FuncVersion.CSharpCodeMD5
  end
  Logger.LogInfo("[LWBiuBiu]: Version Diff" .. " player uid is " .. LuaEntry.Player.uid .. " version is Release" .. DataCenter.LWBiuBiuDataManager:GetVersion() .. " md5 is " .. codeMd5)
end

function LWBiuBiuRoom:CheckRoom(notTip)
  if not self:HasPvp() then
    if not notTip then
      self:Error(LWBiuBiuRoom.ErrorCode.ROOM_PVP_INFO_MISS)
    end
    return false
  end
  return true
end

function LWBiuBiuRoom:UpdateMsg(data, force)
  local curState = -1
  if self:HasPvp() then
    curState = self:GetState()
  end
  if self.data == nil then
    self.data = {}
  end
  if data.betdate then
    self.data.betdate = data.betdate
  end
  if data.bettimes then
    self.data.bettimes = data.bettimes
  end
  if data.effectAddMax then
    self.data.effectAddMax = data.effectAddMax
  end
  if data.pvp or force then
    self.data.pvp = data.pvp
  end
  if data.user or force then
    self.data.user = data.user
  end
  if data.session or force then
    self.data.session = data.session
  end
  if data.opt ~= nil and data.opt == 3 then
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuReconnection)
    return
  end
  if data.opt ~= nil and data.opt == 1 then
    return
  end
  if self:HasPvp() then
    local newState = self:GetState()
    if curState ~= newState then
      self:Info("RoomStateChange:" .. newState)
      EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpStateChange)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpUpdateInfo)
end

function LWBiuBiuRoom:Join(t)
  self:UpdateMsg(t)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuRoom, {anim = true})
  DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.ShootGameEnterRoom)
  UIUtil.ShowTipsId("season_s5_activity_1200045_desc43")
end

function LWBiuBiuRoom:Ready(data, errorCode)
  if errorCode ~= nil then
    self:Error(LWBiuBiuRoom.ErrorCode.READY_FAIRED)
    return
  end
  if not self:CheckRoom() then
    return
  end
  self.data.pvp.readyuids = data.pvp.readyuids
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpUpdateInfo)
  self:Info("Ready:" .. self.data.pvp.readyuids)
end

function LWBiuBiuRoom:Rem(t)
  if t.reason == LWBiuBiuRoom.ErrorCode.FIGHT_END_ERROR or t.reason == LWBiuBiuRoom.ErrorCode.FIGHT_CREATE_FAIL or t.reason == LWBiuBiuRoom.ErrorCode.FORCE_CLOSE then
    self:Error(t.reason)
  end
  if t.reason == LWBiuBiuRoom.ErrorCode.MANUAL_CANCEL or t.reason == LWBiuBiuRoom.ErrorCode.WAITJOIN_TIMEOUT or t.reason == LWBiuBiuRoom.ErrorCode.WAITREADY_TIMEOUT then
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc50")
  end
  if self.data ~= nil then
    self.data.pvp = nil
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpDestroyRoom, t.code)
  self:Info("Rem:" .. t.reason)
end

function LWBiuBiuRoom:Kick(t, errorCode)
  if errorCode ~= nil then
    self:Error(LWBiuBiuRoom.ErrorCode.KICK_FAIRED)
    return
  end
  local hasMe = false
  if t ~= nil and t.pvp ~= nil then
    for _, user in pairs(t.pvp.userinfos) do
      if user.uid == LuaEntry.Player.uid then
        hasMe = true
        break
      end
    end
  end
  if hasMe then
    self:UpdateMsg(t)
    self:Info("Kick: Other People")
  else
    self:Info("Kick: Self People")
    self:Rem()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc42")
  end
end

function LWBiuBiuRoom:Result(t)
  if not self:CheckRoom() then
    return
  end
  self:UpdateMsg(t)
  local aUser, bUser = self:GetRoomUsers()
  local serverResult = {
    result = t.result,
    aUser = aUser,
    bUser = bUser,
    shareUid = LuaEntry.Player.uid,
    betnum = t.pvp.betnum,
    createitemid = t.pvp.createitemid
  }
  if t.result == 4 then
    local sessionidgame = ""
    local sessionidplayer = ""
    if t.session ~= nil then
      sessionidgame = t.session.sessionidgame or ""
      sessionidplayer = t.session.sessionidplayer or ""
    end
    Logger.Log("[LwBiuBiu]: Pvp Result Error(4) " .. " sessionidgame is " .. sessionidgame .. "sessionidplayer is " .. sessionidplayer)
  end
  self.battleData:BindServerResult(serverResult)
  self:Info("ServerResult:")
end

function LWBiuBiuRoom:GameLiftResult(t)
  self.battleData:BindGameLiftResult(t)
  self:Info("GameLiftResult:")
end

function LWBiuBiuRoom:FightReady()
  if not self:CheckRoom() then
    return
  end
  self.data.pvp.fightDescribeResult = nil
  if self:GetState() ~= LittleGameRoomState.FightReady then
    self.data.pvp.state = LittleGameRoomState.FightReady
    self:Info("RoomStateChange:" .. LittleGameRoomState.FightReady)
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpStateChange)
  end
  self:Info("FightReady:")
end

function LWBiuBiuRoom:CreakBattleFailed()
  if not self:CheckRoom() then
    return
  end
  self.data.pvp.fightDescribeResult = nil
  self.data.pvp.state = LittleGameRoomState.RoomFair
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpStateChange)
  self:Error(LWBiuBiuRoom.ErrorCode.FIGHT_CREATE_FAILED)
end

function LWBiuBiuRoom:CreakBattleOk(data)
  if not self:CheckRoom() then
    return
  end
  self.data.session = nil
  local fightDescribeResult = data
  fightDescribeResult.result = true
  fightDescribeResult.sid = self.data.pvp.sid
  fightDescribeResult.playname = LuaEntry.Player.name
  fightDescribeResult.uuid = self.data.pvp.uuid
  fightDescribeResult.p = self:IsMyRoom() == 0 or 1
  fightDescribeResult.logicversion = DataCenter.LWBiuBiuDataManager:GetVersion()
  fightDescribeResult.resversion = fightDescribeResult.logicversion
  fightDescribeResult.time = Time.realtimeSinceStartup
  fightDescribeResult.reconnect = false
  self.data.pvp.fightDescribeResult = fightDescribeResult
  self.sessionidgame = fightDescribeResult.sessionidgame
  self.sessionidplayer = fightDescribeResult.sessionidplayer
  self.data.pvp.state = LittleGameRoomState.FightIng
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpStateChange)
  self:Info("CreakBattleOk:")
end

function LWBiuBiuRoom:ReqCreate(createInfo, errorCallback)
  DataCenter.LWBiuBiuManager:GameLiftPing(function(msg)
    if msg ~= "Error" then
      local version = DataCenter.LWBiuBiuDataManager:GetVersion()
      SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPCreate, createInfo.speak, createInfo.cost, version, msg)
    elseif errorCallback ~= nil then
      errorCallback()
    end
  end)
end

function LWBiuBiuRoom:RespCreate(data, errorCode)
  if errorCode ~= nil then
    self:Error(LWBiuBiuRoom.ErrorCode.CREATE_ROOM_FAIRED)
    EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpCreateRoomError)
    return
  end
  self:UpdateMsg(data)
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpCreateRoomEnd)
  DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.ShootGameEnterRoom)
  PostEventLog.Track(PostEventLog.Defines.MiniGameTrackEvent, {state = 0})
  self:Info("RespCreate:")
end

function LWBiuBiuRoom:ReqReady()
  if not self:CheckRoom() then
    return
  end
  DataCenter.LWBiuBiuManager:GameLiftPing(BindCallback(self, self.ReqPing))
end

function LWBiuBiuRoom:ReqPing(msg)
  if msg == "Error" then
    return
  end
  if not self:HasPvp() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPReady, self.data.pvp.uuid, self.data.pvp.sid, msg)
end

function LWBiuBiuRoom:RespReady(t, errorCode)
  if errorCode ~= nil then
    self:Error(LWBiuBiuRoom.ErrorCode.READY_FAIRED)
    return
  end
  if not self:CheckRoom() then
    return
  end
  self:UpdateMsg(t)
  self:Info("RespReady:")
  PostEventLog.Track(PostEventLog.Defines.MiniGameTrackEvent, {state = 1})
end

function LWBiuBiuRoom:ReqCancel()
  if not self:CheckRoom() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPCancel, self.data.pvp.uuid, self.data.pvp.sid)
end

function LWBiuBiuRoom:RespCancel()
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpDestroyRoom)
  self:Info("RespCancel:")
end

function LWBiuBiuRoom:ReqJoinKick(uid)
  SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPJoinKick, self.data.pvp.uuid, self.data.pvp.sid, uid)
end

function LWBiuBiuRoom:RespJoinKick(t)
  self:UpdateMsg(t)
  self:Info("RespJoinKick:")
end

function LWBiuBiuRoom:UseGoods(data)
  self:UpdateMsg(data)
  EventManager:GetInstance():Broadcast(EventId.SeasonBiuBiuPvpCreateRoomEnd)
  DataCenter.ActWinterStormManager:TryCancelMatch(WinterStormCancelType.ShootGameEnterRoom)
  PostEventLog.Track(PostEventLog.Defines.MiniGameTrackEvent, {state = 0})
  self:Info("UseGoods:")
end

function LWBiuBiuRoom:EnterFail()
  UIUtil.ShowTipsId(129063)
  if self.gameView ~= nil then
    if self.gameView.View ~= nil and self.gameView.View.ctrl ~= nil then
      self.gameView.View.ctrl:CloseSelf()
    end
    self.gameView = nil
  end
  return true
end

function LWBiuBiuRoom:Connect(reconnect, callback)
  local cloud = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuCloud)
  if cloud ~= nil then
    return
  end
  local enter = false
  local buildData = false
  
  local function openWindow()
    if not self.gameView then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuPvpGame, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
      self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuPvpGame)
    end
    if self.gameView == nil then
      self:Error(LWBiuBiuRoom.ErrorCode.CREATE_GAME_VIEW_FAILED)
      return false
    end
    if not self.gameView.View.createFinish then
      return false
    end
    if not self:HasPvp() then
      UIUtil.ShowTips("season_s5_activity_1200045_desc69")
      return self:EnterFail()
    end
    if reconnect == true then
      if not buildData then
        self:BuildReConnectData()
        buildData = true
      end
      local fightDescribeResult = self:GetBattleFightDescribeResult()
      if fightDescribeResult == nil then
        self:Error(LWBiuBiuRoom.ErrorCode.FIGHT_DESCRIBE_FAILED)
        return self:EnterFail()
      end
    else
      local fightDescribeResult = self:GetBattleFightDescribeResult()
      if fightDescribeResult == nil then
        return false
      end
      if fightDescribeResult ~= nil and not fightDescribeResult.result then
        self:Error(LWBiuBiuRoom.ErrorCode.FIGHT_DESCRIBE_FAILED)
        return self:EnterFail()
      end
    end
    if not enter then
      enter = true
      self.gameView.View:EnterGame()
    end
    if self.gameView.View:CheckEnterFail() then
      return self:EnterFail()
    end
    if self.gameView.View:InitFinish() then
      return true
    end
    return false
  end
  
  self.gameView = nil
  local waitTime = DataCenter.LWBiuBiuDataManager:GetTimeOut()
  local curOpenCloudTime = Time.realtimeSinceStartup
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWBiuBiu] UILWBiuBiuActivity UILWBiuBiuCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= waitTime then
      self:Error(LWBiuBiuRoom.ErrorCode.ENTER_ROOM_TIME_OUT)
      return self:EnterFail()
    else
      if callback ~= nil then
        callback()
        callback = nil
      end
      return openWindow()
    end
  end, true)
end

function LWBiuBiuRoom:GetUserInfo()
  if not self:CheckRoom() then
    return
  end
  return self.data.pvp.userinfos
end

function LWBiuBiuRoom:GetRoomUid()
  if not self:CheckRoom() then
    return
  end
  return self.data.pvp.uid
end

function LWBiuBiuRoom:GetRoomUUid()
  if not self:CheckRoom() then
    return
  end
  return self.data.pvp.uuid
end

function LWBiuBiuRoom:GetSid()
  if not self:CheckRoom() then
    return -1
  end
  return self.data.pvp.sid
end

function LWBiuBiuRoom:GetSpeak()
  if not self:CheckRoom() then
    return ""
  end
  return self.data.pvp.speak
end

function LWBiuBiuRoom:GetBetNum()
  if not self:CheckRoom() then
    return -1
  end
  return self.data.pvp.betnum
end

function LWBiuBiuRoom:GetRoomUsers()
  if not self:CheckRoom() then
    return nil, nil
  end
  local uid = self:GetRoomUid()
  local roomUser, otherUser
  for _, user in pairs(self.data.pvp.userinfos) do
    if user.uid == uid then
      roomUser = user
    end
    if user.uid ~= uid then
      otherUser = user
    end
  end
  return roomUser, otherUser
end

function LWBiuBiuRoom:GetRoomWaitPlayerTime()
  local activityData = DataCenter.LWBiuBiuDataManager:GetActivityData()
  if activityData == nil then
    return -1
  end
  if not self:CheckRoom() then
    return -1
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  return (self.data.pvp.statestarttime + toInt(activityData.para_7) * 1000 - serverTime) / 1000
end

function LWBiuBiuRoom:GetRoomWaitReadyTime()
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.BiuBiu.ActId)
  return toInt(tabData.para_3)
end

function LWBiuBiuRoom:GetStageCfgId()
  if not self:CheckRoom() then
    return nil
  end
  if self.data.pvp.fightDescribeResult == nil then
    return
  end
  return self.data.pvp.fightDescribeResult.stagecfgid
end

function LWBiuBiuRoom:IsMyRoom()
  if not self:CheckRoom() then
    return false
  end
  return self:GetRoomUid() == LuaEntry.Player.uid
end

function LWBiuBiuRoom:IsGoodsPvp()
  if not self:CheckRoom() then
    return false
  end
  return self.data.pvp.createitemid ~= nil
end

function LWBiuBiuRoom:GetReady(uuid)
  if not self:CheckRoom() then
    return false
  end
  if self.data.pvp.readyuids == nil or string.IsNullOrEmpty(self.data.pvp.readyuids) then
    return false
  end
  local uids = string.split(self.data.pvp.readyuids, ",")
  for _, uid in pairs(uids) do
    if uid == uuid then
      return true
    end
  end
  return false
end

function LWBiuBiuRoom:GetState()
  if not self:CheckRoom(true) then
    return -1
  end
  return self.data.pvp.state
end

function LWBiuBiuRoom:GetBetCount()
  if self.data ~= nil and self.data.bettimes ~= nil and self.data.betdate ~= nil then
    if self.data.betdate == 0 then
      return self.data.bettimes or 0
    end
    local countData = UITimeManager:GetInstance():TimeStampToServerDate(self.data.betdate)
    local serverData = UITimeManager:GetInstance():TimeStampToServerDate(UITimeManager:GetInstance():GetServerTime())
    if countData.yday == serverData.yday and countData.year == serverData.year then
      return self.data.bettimes or 0
    end
    return 0
  end
  return -1
end

function LWBiuBiuRoom:GetBetMaxCount()
  if SeasonUtil.IsInSeasonSettleTime() then
    return 999999
  end
  local tabData = LocalController:instance():getLine(TableName.Activity, EnumActivity.BiuBiu.ActId)
  return tonumber(tabData.para_4)
end

function LWBiuBiuRoom:GetBetExtraNum()
  if self.data ~= nil then
    return self.data.effectAddMax
  end
  return 0
end

function LWBiuBiuRoom:GetBattleFightDescribeResult()
  if not self:CheckRoom() then
    return
  end
  return self.data.pvp.fightDescribeResult
end

function LWBiuBiuRoom:GetBattleResult()
  return self.battleData
end

function LWBiuBiuRoom:HasPvp()
  if self.data == nil then
    return false
  end
  return self.data.pvp ~= nil
end

function LWBiuBiuRoom:BuildReConnectData()
  if self.data.session ~= nil then
    local fightDescribeResult = self.data.session
    fightDescribeResult.result = true
    fightDescribeResult.playname = LuaEntry.Player.name
    fightDescribeResult.p = self:IsMyRoom() == 0 or 1
    fightDescribeResult.logicversion = DataCenter.LWBiuBiuDataManager:GetVersion()
    fightDescribeResult.resversion = fightDescribeResult.logicversion
    fightDescribeResult.time = Time.realtimeSinceStartup
    fightDescribeResult.reconnect = true
    fightDescribeResult.sid = self:GetSid()
    fightDescribeResult.uuid = self:GetRoomUUid()
    self.data.pvp.fightDescribeResult = fightDescribeResult
    self.sessionidgame = fightDescribeResult.sessionidgame
    self.sessionidplayer = fightDescribeResult.sessionidplayer
  else
    local fightDescribeResult = self:GetBattleFightDescribeResult()
    if fightDescribeResult ~= nil then
      fightDescribeResult.reconnect = true
      self.sessionidgame = fightDescribeResult.sessionidgame
      self.sessionidplayer = fightDescribeResult.sessionidplayer
    end
  end
end

function LWBiuBiuRoom:GetPvpConnect()
  if not IsNull(self.pvpConnect) then
    return self.pvpConnect
  end
end

function LWBiuBiuRoom:CreatePvpConnect()
  if not IsNull(self.pvpConnect) then
    self.pvpConnect:Dispose()
  end
  self.pvpConnect = UIBootPvpConnect()
  return self.pvpConnect
end

return LWBiuBiuRoom
