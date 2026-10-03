local LWGGGoPvpBoot = BaseClass("LWGGGoPvpBoot")
local LWGGGoRoom = require("DataCenter.LWGGGo.LWGGGoRoom")
local Stage_Path = "Assets/Main/MiniGameRes/GGGo/Map/%s.txt"

function LWGGGoPvpBoot:__init()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.toEnterFail = nil
  self.room = nil
end

function LWGGGoPvpBoot:__delete()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.toEnterFail = nil
  self.room = nil
end

function LWGGGoPvpBoot:CreateHandle(view)
  self.room = DataCenter.LWGGGoDataManager:GetRoom()
  self.boot = view.gameObject:GetComponent(typeof(CS.MiniGame.GGGo.Client.UIGGGoMain))
  self.gameView = view
end

function LWGGGoPvpBoot:BindCallback(callback)
  self.uiCallback = callback
  self.boot:BindCallback(self.uiCallback)
end

function LWGGGoPvpBoot:ConnectGameLift(ConnectFair, ConnectFinish)
  Logger.Log("[GGGo]: ConnectGameLift")
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  local stageId = room:GetStageCfgId()
  if stageId == nil or stageId == 0 then
    self.room:Error(LWGGGoRoom.ErrorCode.ENTER_GAME_FAILED .. " stageId is nil")
    ConnectFair()
    return
  end
  local stageName = GetTableData(TableName.SEASON_CAVE_EXPLORATION, stageId, "game_level")
  local fightDescribeResult = room:GetBattleFightDescribeResult()
  if fightDescribeResult == nil then
    self.room:Error(LWGGGoRoom.ErrorCode.ENTER_GAME_FAILED .. " fightDescribeResult is nil")
    ConnectFair()
    return
  end
  room.battleData:Clear()
  local serverId = -1
  xpcall(function()
    local sessionidgame = fightDescribeResult.sessionidgame
    local lastIndex = -1
    LocalController:instance():visitTable(TableName.SEASON_BULLET_SERVER, function(id, lineData)
      local localName = lineData:getValue("LocationName")
      local startIndex, _ = string.find(sessionidgame, localName, 1, true)
      if startIndex ~= nil and (lastIndex == -1 or startIndex > lastIndex) then
        lastIndex = startIndex
        serverId = id
      end
    end)
  end, debug.traceback)
  
  local function onDisconnected()
    Logger.Log("[GGGo]: OnServerDisconnected")
    local r = DataCenter.LWGGGoDataManager:GetRoom()
    r:Error(LWGGGoRoom.ErrorCode.FIGHT_CONNECT_GAME_LIFT .. " disconnected")
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpDisconnected)
  end
  
  local function onConnected()
    Logger.Log("[GGGo]: OnServerConnected")
    if ConnectFinish then
      ConnectFinish()
    end
  end
  
  local function onTryReconnect()
    Logger.Log("[GGGo]: OnServerTryReconnect")
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpTryReconnect)
  end
  
  local function onReconnected()
    Logger.Log("[GGGo]: OnServerReconnected")
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpReconnected)
  end
  
  self.boot:ConnectGameLift(serverId, string.format(Stage_Path, stageName), fightDescribeResult, onDisconnected, onConnected, onTryReconnect, onReconnected)
end

function LWGGGoPvpBoot:OnError(errorMsg)
  self.toEnterFail = true
  local room = DataCenter.LWGGGoDataManager:GetRoom()
  room:Error(errorMsg)
end

function LWGGGoPvpBoot:Exit()
  self:Dispose()
  if self.gameView and self.gameView.ctrl then
    self.gameView.ctrl:CloseSelf()
    self.gameView = nil
  end
end

function LWGGGoPvpBoot:Agent()
  local toDoNext = false
  
  local function openWindow()
    if not toDoNext then
      self.gameView:Agent()
      toDoNext = true
    end
    if self.gameView.View:CheckEnterFail() then
      return self:EnterFail()
    end
    if self.gameView.View:InitFinish() then
      return true
    end
    return false
  end
  
  self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWGGGoPvpGame)
  local curOpenCloudTime = Time.realtimeSinceStartup
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGGGoCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWGGGo] UILWGGGoActivity UILWGGGoCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= 15 then
      room:Error(LWGGGoRoom.ErrorCode.ENTER_ROOM_TIME_OUT)
      return self:EnterFail()
    else
      return openWindow()
    end
  end)
end

function LWGGGoPvpBoot:End()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  self.boot:EndGame()
end

function LWGGGoPvpBoot:Dispose()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  if self.boot ~= nil then
    self.boot:Dispose()
    self.boot = nil
  end
end

function LWGGGoPvpBoot:IsDone()
  if IsNull(self.boot) then
    return false
  end
  return self.boot:IsDone()
end

function LWGGGoPvpBoot:CheckEnterFail()
  return self.toEnterFail
end

return LWGGGoPvpBoot
