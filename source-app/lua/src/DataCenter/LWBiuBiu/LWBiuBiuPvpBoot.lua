local LWBiuBiuPvpBoot = BaseClass("LWBiuBiuPvpBoot")
local LWBiuBiuRoom = require("DataCenter.LWBiuBiu.LWBiuBiuRoom")
local Stage_Path = "Assets/Main/MiniGameRes/BiuBiu/Map/%s.txt"

function LWBiuBiuPvpBoot:__init()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.toEnterFail = nil
  self.room = nil
end

function LWBiuBiuPvpBoot:__delete()
  self.boot = nil
  self.gameView = nil
  self.uiCallback = nil
  self.toEnterFail = nil
  self.room = nil
end

function LWBiuBiuPvpBoot:CreateHandle(view)
  self.room = DataCenter.LWBiuBiuDataManager:GetRoom()
  self.boot = view.gameObject:GetComponent(typeof(CS.MiniGame.Biubiu.Client.UIBiuBiuPvpBoot))
  self.gameView = view
end

function LWBiuBiuPvpBoot:BindCallback(callback)
  self.uiCallback = callback
  self.boot:BindCallback(self.uiCallback)
end

function LWBiuBiuPvpBoot:ConnectGameLift(ConnectFair, ConnectFinish)
  Logger.Log("[BiuBiu]: ConnectGameLift")
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local stageId = room:GetStageCfgId()
  if stageId == nil or stageId == 0 then
    self.room:Error(LWBiuBiuRoom.ErrorCode.ENTER_GAME_FAILED .. " stageId is nil")
    ConnectFair()
    return
  end
  local stageName = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, stageId, "stage_name")
  local fightDescribeResult = room:GetBattleFightDescribeResult()
  if fightDescribeResult == nil then
    self.room:Error(LWBiuBiuRoom.ErrorCode.ENTER_GAME_FAILED .. " fightDescribeResult is nil")
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
  local hybridNetwork = DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.MiniGameUseHybridNetwork)
  local pvpConnect = room:CreatePvpConnect()
  pvpConnect:ConnectGameLift(serverId, fightDescribeResult, 2, string.format(Stage_Path, stageName), function(errorMsg)
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:Error(errorMsg)
    pvpConnect:Dispose()
    ConnectFair()
  end, ConnectFinish, hybridNetwork)
end

function LWBiuBiuPvpBoot:Start(stageId, gameRoot)
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  local pvpConnect = room:GetPvpConnect()
  if pvpConnect ~= nil and not IsNull(pvpConnect.PvpPlayerRuntime) then
    self.boot:StartGameByPvpConnect(pvpConnect, gameRoot)
  else
    self.toEnterFail = false
    if stageId == nil or stageId == 0 then
      self.room:Error(LWBiuBiuRoom.ErrorCode.ENTER_GAME_FAILED .. " stageId is nil")
      self.toEnterFail = true
      return
    end
    local stageName = GetTableData(TableName.SEASON_BULLET_SHOOT_GAME, stageId, "stage_name")
    local fightDescribeResult = room:GetBattleFightDescribeResult()
    if fightDescribeResult == nil then
      self.toEnterFail = true
      self.room:Error(LWBiuBiuRoom.ErrorCode.ENTER_GAME_FAILED .. " fightDescribeResult is nil")
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
    self.boot:StartGame(serverId, string.format(Stage_Path, stageName), fightDescribeResult, gameRoot, BindCallback(self, self.OnError))
  end
end

function LWBiuBiuPvpBoot:OnError(errorMsg)
  self.toEnterFail = true
  local room = DataCenter.LWBiuBiuDataManager:GetRoom()
  room:Error(errorMsg)
end

function LWBiuBiuPvpBoot:Exit()
  self:Dispose()
  if self.gameView and self.gameView.ctrl then
    self.gameView.ctrl:CloseSelf()
    self.gameView = nil
  end
end

function LWBiuBiuPvpBoot:Agent()
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
  
  self.gameView = UIManager:GetInstance():GetWindow(UIWindowNames.UILWBiuBiuPvpGame)
  local curOpenCloudTime = Time.realtimeSinceStartup
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBiuBiuCloud, {anim = true}, nil, function()
    Logger.LogInfo("[LWBiuBiu] UILWBiuBiuActivity UILWBiuBiuCloud Hold Func")
    if Time.realtimeSinceStartup - curOpenCloudTime >= 15 then
      room:Error(LWBiuBiuRoom.ErrorCode.ENTER_ROOM_TIME_OUT)
      return self:EnterFail()
    else
      return openWindow()
    end
  end)
end

function LWBiuBiuPvpBoot:End()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  self.boot:EndGame()
end

function LWBiuBiuPvpBoot:Dispose()
  if self.uiCallback ~= nil then
    self.boot:UnBindCallback(self.uiCallback)
    self.uiCallback = nil
  end
  if self.boot ~= nil then
    self.boot:Dispose()
    self.boot = nil
  end
end

function LWBiuBiuPvpBoot:IsDone()
  if IsNull(self.boot) then
    return false
  end
  return self.boot:IsDone()
end

function LWBiuBiuPvpBoot:CheckEnterFail()
  return self.toEnterFail
end

return LWBiuBiuPvpBoot
