local LWGGGoManager = BaseClass("LWGGGoManager", CEventable)
local Localization = CS.GameEntry.Localization
local FuncUdpLatencySafe = CS.MiniGame.Biubiu.Client.FuncUdpLatencySafe
local ReConnectUI = {
  [UIWindowNames.UIChatNew_v2] = true,
  [UIWindowNames.LWSeason6Main] = true,
  [UIWindowNames.UILWBagMain] = true
}
local NeedPingUI = {
  [UIWindowNames.UILWGGGoRoom] = true,
  [UIWindowNames.UILWGGGoCreateRoom] = true
}

function LWGGGoManager:__init()
  self:RegisterEvent(EventId.OpenUI, self.OpenUIHandle)
  self:RegisterEvent(EventId.APP_APPLICATION_PAUSE, self.OnApplicationPause)
  self:RegisterEvent(EventId.SeasonGGGoPveStart, self.SeasonGGGoPveStartHandle)
  self.latencies = nil
  self.loginState = nil
  self.gameView = nil
end

function LWGGGoManager:__delete()
  self.latencies = nil
  self.loginState = nil
  self.gameView = nil
end

function LWGGGoManager:InitData()
  if self.loginState == nil then
    self.loginState = 1
    SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpInfo, 1)
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpInfo, 3)
  end
end

function LWGGGoManager:OpenUIHandle(name)
  if ReConnectUI[name] then
    self:ReConnectPvp()
  end
end

function LWGGGoManager:OnApplicationPause(isPaused)
  if not isPaused then
    Logger.Log("[LWGGGo]:OnApplicationPause")
    SFSNetwork.SendMessage(MsgDefines.ActivityLittleGamePvpInfo, 3)
  end
end

function LWGGGoManager:SeasonGGGoPveStartHandle()
  local function openWindow()
    if not self.gameView then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoGame, {
        anim = true,
        
        UIMainAnim = UIMainAnimType.AllHide
      })
      self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWGGGoGame)
    end
    if self.gameView == nil then
      return false
    end
    if self.gameView.View:InitFinish() then
      self.gameView = nil
      return true
    end
    return false
  end
  
  self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWGGGoGame)
  local curOpenCloudTime = Time.realtimeSinceStartup
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWGGGo] LWGGGoManager UILWGGGoCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= 8 then
      if self.gameView ~= nil then
        self.gameView.View.ctrl:CloseSelf()
        self.gameView = nil
      end
      return true
    else
      return openWindow()
    end
  end)
end

function LWGGGoManager:ReConnectPvp()
  if not DataCenter.LWGGGoDataManager:GetResourceLoaded() then
    return
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  if room:GetState() == LittleGameRoomState.FightIng then
    UIUtil.ShowSecondMessage("", Localization:GetString("season_s6_minigame_erro_tips_8"), 2, "110006", "110106", function()
      room:Connect(true)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, nil)
  end
end

local PING_TIMEOUT_SEC = 3.5

function LWGGGoManager:GameLiftPing(callback)
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
      Logger.LogWarning("[LWGGGo] GameLiftPing timeout, fallback with empty latency")
    else
      Logger.LogInfo("[LWGGGo] Ping Info " .. tostring(msg))
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
      Logger.LogInfo("[LWGGGo] Ping(New) cost " .. Time.realtimeSinceStartup - time .. "s")
      onPingResult(msg, false)
    end)
  else
    FuncUdpLatencySafe.GetGameLiftServerPingValues(ids, function(msg)
      Logger.LogInfo("[LWGGGo] Ping(Old) cost " .. Time.realtimeSinceStartup - time .. "s")
      onPingResult(msg, false)
    end)
  end
end

return LWGGGoManager
