local LWBiuBiuManager = BaseClass("LWBiuBiuManager", CEventable)
local Localization = CS.GameEntry.Localization
local FuncUdpLatencySafe = CS.MiniGame.Biubiu.Client.FuncUdpLatencySafe
local ReConnectUI = {
  [UIWindowNames.UIChatNew_v2] = true,
  [UIWindowNames.LWSeason5Main] = true,
  [UIWindowNames.UILWBagMain] = true
}
local NeedPingUI = {
  [UIWindowNames.UILWBiuBiuRoom] = true,
  [UIWindowNames.UILWBiuBiuCreateRoom] = true
}

function LWBiuBiuManager:__init()
  self:RegisterEvent(EventId.OpenUI, self.OpenUIHandle)
  self:RegisterEvent(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self.latencies = nil
  self.loginState = nil
end

function LWBiuBiuManager:__delete()
  self.latencies = nil
  self.loginState = nil
end

function LWBiuBiuManager:InitData()
  if self.loginState == nil then
    self.loginState = 1
    SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPInfo, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPInfo, 3)
  end
end

function LWBiuBiuManager:OpenUIHandle(name)
  if ReConnectUI[name] then
    self:ReConnectPvp()
  end
end

function LWBiuBiuManager:OnApplicationPause(isPaused)
  if not isPaused then
    Logger.Log("[LWBiuBiu]:OnApplicationPause")
    SFSNetwork.SendMessage(MsgDefines.BiuBiuPVPInfo, 3)
  end
end

function LWBiuBiuManager:ReConnectPvp()
  if not DataCenter.LWBiuBiuDataManager:GetResourceLoaded() then
    return
  end
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  if room:GetState() == LittleGameRoomState.FightIng then
    UIUtil.ShowSecondMessage("", Localization:GetString("season_s5_activity_1200045_desc77"), 2, "110006", "110106", function()
      room:Connect(true)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil)
  end
end

local PING_TIMEOUT_SEC = 3.5

function LWBiuBiuManager:GameLiftPing(callback)
  if self.latencies ~= nil then
    if callback ~= nil then
      callback(self.latencies)
    end
    return
  end
  local ids = {}
  LocalController:instance():visitTable(TableName.SEASON_BULLET_SERVER, function(id, lineData)
    local enable = lineData:getValue("Enable") == "true"
    if enable then
      table.insert(ids, id)
    end
  end)
  local called = false
  local timeoutTimer
  
  local function onPingResult(msg, isTimeout)
    if called then
      return
    end
    called = true
    if timeoutTimer ~= nil then
      timeoutTimer:Stop()
      timeoutTimer = nil
    end
    if isTimeout then
      msg = ""
      Logger.LogWarning("[LWBiuBiu] GameLiftPing timeout, fallback with empty latency")
    else
      Logger.LogInfo("[LWBiuBiu] Ping Info " .. tostring(msg))
    end
    self.latencies = msg
    if callback ~= nil then
      callback(msg)
    end
  end
  
  timeoutTimer = TimerManager:GetInstance():DelayInvoke(function()
    timeoutTimer = nil
    onPingResult(nil, true)
  end, PING_TIMEOUT_SEC)
  local startPvpNewPing = DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.BiuBiuNewPing)
  local time = Time.realtimeSinceStartup
  if startPvpNewPing then
    FuncUdpLatencySafe.PingAll(ids, function(msg)
      Logger.LogInfo("[LWBiuBiu] Ping(New) cost " .. Time.realtimeSinceStartup - time .. "s")
      onPingResult(msg, false)
    end)
  else
    FuncUdpLatencySafe.GetGameLiftServerPingValues(ids, function(msg)
      Logger.LogInfo("[LWBiuBiu] Ping(Old) cost " .. Time.realtimeSinceStartup - time .. "s")
      onPingResult(msg, false)
    end)
  end
end

return LWBiuBiuManager
