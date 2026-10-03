local MultipleParkourManager = BaseClass("MultipleParkourManager")
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local rvoObstaclePath = "Assets/Main/Prefabs/PVELevel/%s/obstacle.bytes"
local PVEResConfigPath = "Assets/Main/Prefabs/PVELevel/%s/res_config.json"
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Const = require("Scene.LWBattle.Const")
local Touch = CS.BitBenderGames.TouchWrapper
local Localization = CS.GameEntry.Localization
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local Time = _ENV.Time
local FPS_SAMPLE_CD = 10
local velocity = Vector3.unity_vector3(0, 0, 0)
local smoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 1)
local LookOffset = 5
local cameraOffset = Vector3.New(0, 0, -6)
local XCenter = 36
local ZStart = 30
local ZSpeed = 3
local BossSpeed = 12
local ResultTime = 3
local BossWarningTime = 3
local FixedUpdateTime = 0.033
local FixedUpdateMilliTime = 33
local ChangeSelectTime = 0.2
local touchSize = 10
local ViewDisForward = 140
local ViewDisBack = 30
local DoorResPath = {
  "Assets/Main/Prefabs/LWCountBattle/Doors/DoorBlue.prefab",
  "Assets/Main/Prefabs/LWCountBattle/Doors/DoorRed.prefab",
  "Assets/Main/Prefabs/LWCountBattle/Doors/DoorBlue.prefab",
  "Assets/Main/Prefabs/LWCountBattle/Doors/DoorRed.prefab"
}
local FireworksEffectPath = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_fuben_lihua_01.prefab"
local State = {
  Init = 1,
  Loading = 2,
  Ready = 3,
  March = 4,
  Buff = 5,
  Boss = 6,
  BeforeResult = 7,
  Result = 8,
  PreResult = 9
}
local MarchSubState = {Op = 1, Door = 2}
local Mode = {
  Invalid = 0,
  Normal = 1,
  Team = 2,
  Endless = 3
}
local MultipleParkourDoor = require("DataCenter.MultipleParkour.MultipleParkourDoor")
local MultipleParkourTeam = require("DataCenter.MultipleParkour.Team.MultipleParkourTeam")
local MultipleParkourPlayerData = require("DataCenter.MultipleParkour.Team.MultipleParkourPlayerData")
local MultipleParkourBoss = require("DataCenter.MultipleParkour.Team.MultipleParkourBoss")
local MultipleParkourScene = require("DataCenter.MultipleParkour.MultipleParkourScene")

local function GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function MultipleParkourManager:__init()
  self.nextObjId = 1
  self.followCameraTarget = Vector3.zero
  self.state = State.Init
  self.mode = Mode.Invalid
  self.playerIdMap = nil
  self.teamLayoutPlayerMap = nil
  self.teamLeftEmptyQueue = nil
  self.teamRightEmptyQueue = nil
  self.levelDisableOpMap = nil
  self.serverPlayerScoreMap = nil
  self.serverNextSelectMap = nil
  self.serverPassDoorTimeMap = nil
  self.serverMarchStateTimeArray = nil
  self.newRecordTipPool = StringPool.New("multiply_door_tips_014;multiply_door_tips_015;multiply_door_tips_016;multiply_door_tips_017", ";")
  self.normalResultTipPool = StringPool.New("multiply_door_tips_022;multiply_door_tips_023;multiply_door_tips_024", ";")
end

function MultipleParkourManager:__delete()
  self:Destroy()
end

function MultipleParkourManager:Destroy()
  self:UnInitCamera()
  self:RemoveListener()
  self:RemoveUpdateTimer()
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
  if self.sceneArr then
    for _, scene in ipairs(self.sceneArr) do
      scene:Delete()
    end
    self.sceneArr = nil
  end
  if self.doors then
    for _, v in ipairs(self.doors) do
      v:Delete()
    end
    self.doors = nil
  end
  if self.cameraTween then
    self.cameraTween:Kill()
    self.cameraTween = nil
  end
  if self.team then
    self.team:Destroy()
    self.team = nil
  end
  self:DestroyBoss()
  self:ClearFireworks()
  self.param = nil
  self.doorId = 0
  self.doorTemplate = nil
  self.sceneCfgArrList = nil
  self.playerIdMap = nil
  self.teamLayoutPlayerMap = nil
  self.teamLeftEmptyQueue = nil
  self.teamRightEmptyQueue = nil
  self.levelDisableOpMap = nil
  self.serverPassDoorTimeMap = nil
  self.serverMarchStateTimeArray = nil
  self.enterGameTimeStamp = nil
  self.lastGameTimeStamp = nil
  self.loadingEndTimeStamp = nil
  self.startMoveTimeStamp = nil
  self.marchOpTimeArray = nil
  self.marchOpSpeedArray = nil
  self.marchOpIndex = 0
  self.marchPosAdjustArray = nil
  self.reward = nil
  self.endlessResultData = nil
  self.state = State.Init
  self.emojiPlayers = nil
  self.winPlayers = nil
  self.endTotalLevel = nil
  self.uiLoading = nil
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkourLoading) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourLoading)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkour) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkour)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkourWin) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourWin)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkourLose) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourLose)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMultipleParkourResult) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkourResult)
  end
  if self.syncDirDelay then
    self.syncDirDelay:Stop()
    self.syncDirDelay = nil
  end
end

function MultipleParkourManager:AddListener()
  if self.onOpenUIAction == nil then
    function self.onOpenUIAction(uiName)
      self:OnOpenUI(uiName)
    end
    
    EventManager:GetInstance():AddListener(EventId.OpenUI, self.onOpenUIAction)
  end
end

function MultipleParkourManager:RemoveListener()
  if self.onOpenUIAction ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.onOpenUIAction)
    self.onOpenUIAction = nil
  end
end

function MultipleParkourManager:OnOpenUI(uiName)
  if uiName == UIWindowNames.UIDisconnect and self.state ~= State.Init then
    self:Exit()
  end
end

function MultipleParkourManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function MultipleParkourManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function MultipleParkourManager:OnUpdate()
  if self.touchCamera then
    local tarPos = self.touchCamera:GetCameraTargetPos()
    local viewTile = SceneUtils.WorldToTile(tarPos)
    if self.staticMgr ~= nil then
      self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
  end
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
  if self.state <= State.Loading then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local milliTime = curTime - self.lastGameTimeStamp
  local time = milliTime / 1000
  self.lastGameTimeStamp = curTime
  while 0 < time do
    if time > FixedUpdateTime then
      time = time - FixedUpdateTime
      milliTime = milliTime - FixedUpdateMilliTime
      self:UpdateState(FixedUpdateTime, FixedUpdateMilliTime)
    else
      self:UpdateState(time, milliTime)
      time = 0
    end
  end
end

function MultipleParkourManager:UpdateState(deltaTime, deltaMilliTime)
  if self.state == State.Init then
    return
  end
  if self.state == State.Loading then
    return
  end
  if self.state == State.Ready then
    local old = self.readyTimer
    old = math.ceil(old)
    self.readyTimer = self.readyTimer - deltaTime
    local cur = math.ceil(self.readyTimer)
    if old ~= cur then
      EventManager:GetInstance():Broadcast(EventId.MultipleParkourReadyChanged)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_countdown_start)
    end
    if self.readyTimer <= 0 then
      Logger.Log("MultipleParkour ready go !")
      self:ChangeStage(State.March)
    end
    return
  end
  if self.state < State.BeforeResult then
    self:UpdateCameraFollow()
  end
  if self.state == State.March then
    self:UpdateMarch(deltaTime, deltaMilliTime)
    return
  end
  if self.state == State.Boss then
    self:UpdateBoss(deltaTime)
    return
  end
  if self.state == State.BeforeResult then
    self:UpdateBeforeResult(deltaTime)
    return
  end
end

function MultipleParkourManager:GetReadyTimer()
  if self.readyTimer then
    return math.ceil(self.readyTimer)
  end
  return -1
end

function MultipleParkourManager:UpdateFingerHold()
  if not self.isFingerDown then
    return
  end
  local pos
  if Touch.TouchCount > 0 then
    local touch = Touch.Touches[0]
    pos = touch.Position
  end
  if not pos then
    return
  end
  local delta = pos.x - self.lastTouchPosX
  if 0 < delta then
    if self.lastFingerDir == Const.MultipleParkourDoorLayout.Right then
      delta = pos.x - self.lastFingerPosX
      if delta > touchSize then
        self:ChangeDir(Const.MultipleParkourDoorLayout.Right)
        self.lastFingerPosX = pos.x
      end
    elseif self.lastFingerDir == Const.MultipleParkourDoorLayout.Left then
      self.lastFingerDir = Const.MultipleParkourDoorLayout.Right
      self.lastFingerPosX = pos.x
    else
      self.lastFingerDir = Const.MultipleParkourDoorLayout.Right
    end
  elseif delta < 0 then
    if self.lastFingerDir == Const.MultipleParkourDoorLayout.Left then
      delta = pos.x - self.lastFingerPosX
      if math.abs(delta) > touchSize then
        self:ChangeDir(Const.MultipleParkourDoorLayout.Left)
        self.lastFingerPosX = pos.x
      end
    elseif self.lastFingerDir == Const.MultipleParkourDoorLayout.Right then
      self.lastFingerDir = Const.MultipleParkourDoorLayout.Left
      self.lastFingerPosX = pos.x
    else
      self.lastFingerDir = Const.MultipleParkourDoorLayout.Left
    end
  end
  self.lastTouchPosX = pos.x
end

function MultipleParkourManager:ChangeDir(dir)
  if self.marchSubState == MarchSubState.Door then
    local time = Time.realtimeSinceStartup
    if time - self.lastDisableOpTime > 0.3 then
      self.lastDisableOpTime = time
      UIUtil.ShowTips(Localization:GetString("dev_multiple_stage_01"))
    end
    return
  end
  if dir ~= self.mySelected and self.roomId then
    local myId = LuaEntry.Player:GetUid()
    local myData = self.playerIdMap[myId]
    if myData then
      self:ChangeSelect(myData, myData.select, dir, true)
      myData:UpdateSelect(dir)
      self.team:UpdateSinglePlayer(myData, false, true)
      self.mySelected = dir
    end
    SFSNetwork.SendMessage(MsgDefines.MultipleParkourDoorSelect, self.roomId, dir, self.passedDoorLevel)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    Logger.LogInfo("MultipleParkour ChangeDir : " .. dir .. " my :" .. self.mySelected .. "passedDoorLevel : " .. self.passedDoorLevel .. " Time : " .. curTime)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_slip)
    if self.syncDirDelay == nil then
      self.syncDirDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.syncDirDelay = nil
        self:OnSyncDirDelay()
      end, 1)
    else
      self.syncDirDelay:Reset()
    end
  end
end

function MultipleParkourManager:OnSyncDirDelay()
  if self.state == State.March and self.roomId then
    SFSNetwork.SendMessage(MsgDefines.MultipleParkourDoorSelect, self.roomId, self.mySelected, self.passedDoorLevel)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    Logger.LogInfo("MultipleParkour SyncDir : " .. self.mySelected .. "passedDoorLevel : " .. self.passedDoorLevel .. " Time : " .. curTime)
  end
end

function MultipleParkourManager:UpdateMarch(deltaTime, deltaMilliTime)
  if self.startMoveTimeStamp then
    self.startMoveTimeStamp = self.startMoveTimeStamp + deltaMilliTime
  end
  self:UpdateFingerHold()
  local teamZ = self.team:GetPositionZ()
  self:CheckDoors(teamZ)
  self:UpdateSceneLoad(teamZ)
  if teamZ >= self.endLine then
    if self.mode == Mode.Normal then
      self:ChangeStage(State.Boss)
      return
    else
      self:ChangeStage(State.Result)
      return
    end
  end
  self:UpdateChangeSelect(deltaTime)
  self:UpdateTeamPosition(deltaTime)
end

function MultipleParkourManager:UpdateSceneLoad(teamZ)
  if self.sceneArr then
    local count = #self.sceneArr
    for i = count, 1, -1 do
      local scene = self.sceneArr[i]
      local pos = scene.offset
      if scene.loaded == false and scene.offset - teamZ < ViewDisForward then
        scene:Load()
      end
      pos = scene.endPos
      if teamZ - pos > ViewDisBack then
        scene:Delete()
        table.remove(self.sceneArr, i)
      end
    end
  end
end

function MultipleParkourManager:UpdateTeamPosition(deltaTime)
  self:UpdateTeamPositionImp2(deltaTime)
end

function MultipleParkourManager:UpdateTeamPositionImp1(deltaTime)
  local newState = MarchSubState.Door
  local speed = self.curMarchSpeed
  local anoSpeed = self.nextMarchSpeed
  if self.marchSubState == MarchSubState.Door then
    newState = MarchSubState.Op
  end
  local pos = self.team:GetPosition()
  self.lastTeamZ = pos.z
  local add = 0
  local z = pos.z
  local index = self.marchOpIndex
  local anoTime = 0
  if deltaTime < self.marchSubStateTimer then
    self.marchSubStateTimer = self.marchSubStateTimer - deltaTime
    anoTime = 0
  else
    anoTime = deltaTime - self.marchSubStateTimer
    deltaTime = self.marchSubStateTimer
    self.marchSubStateTimer = 0
    self:ChangeMarchSubState(newState)
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourMarchSubStageChanged)
  add = speed * deltaTime
  z = z + add
  if index and self.marchPosAdjustArray and 0 < index and index <= #self.marchPosAdjustArray then
    local max = self.marchPosAdjustArray[index]
    z = Mathf.Min(z, max)
  end
  add = anoTime * anoSpeed
  z = z + add
  self.team:SetPosition(pos.x, z)
end

function MultipleParkourManager:UpdateTeamPositionImp2(deltaTime)
  local newState = MarchSubState.Door
  if self.marchSubState == MarchSubState.Door then
    newState = MarchSubState.Op
  end
  local pos = self.team:GetPosition()
  self.lastTeamZ = pos.z
  local z = pos.z
  local index = self.marchOpIndex
  local serverEndTime = self.serverMarchStateTimeArray[index]
  if serverEndTime == nil then
    return
  end
  local endPos = self.marchPosAdjustArray[index]
  local startPos = ZStart
  local startTime = self.loadingEndTimeStamp
  if 1 < index then
    startPos = self.marchPosAdjustArray[index - 1]
    startTime = self.serverMarchStateTimeArray[index - 1]
  end
  local cur = self.startMoveTimeStamp
  local t = (cur - startTime) / (serverEndTime - startTime)
  z = Mathf.Lerp(startPos, endPos, t)
  if serverEndTime < cur then
    self:ChangeMarchSubState(newState)
  end
  self.marchSubStateTimer = (serverEndTime - cur) / 1000
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourMarchSubStageChanged)
  self.team:SetPosition(pos.x, z)
end

function MultipleParkourManager:CheckDoors(teamZ)
  local doorCount = #self.doors
  for i = doorCount, 1, -1 do
    local door = self.doors[i]
    if door:TryParse(teamZ, self.lastTeamZ) then
      local calc = true
      self.lastPassDoorLevel = door.totalLevel
      if door.lastIndex then
        self.passedDoorLevel = door.totalLevel
        if self.serverPlayerScoreMap[door.totalLevel] ~= nil then
          calc = false
        end
      end
      door:OnPassed()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_multiplication)
      if calc then
        self:CalcDoorScore(door.layout, door.totalLevel, door.option, door.value)
      else
        self:SyncDoorScore(door.layout, door.totalLevel)
      end
    end
    if door.passed then
      door:Delete()
      table.remove(self.doors, i)
      local tmpMyScore = -1
      local endResult = self.endTotalLevel ~= nil and self.endTotalLevel == self.passedDoorLevel
      if not endResult and self.mode == Mode.Endless then
        local myId = LuaEntry.Player.uid
        if self.playerIdMap then
          local my = self.playerIdMap[myId]
          if my then
            local myScore = my.score
            tmpMyScore = myScore
            if myScore <= 0 then
              endResult = true
            end
          end
        end
      end
      if door.last and not endResult and door.layout == self.mySelected then
        local newLevel = door.mapIndex + 1
        if self.runningTotalLevel ~= newLevel then
          self.runningTotalLevel = newLevel
          EventManager:GetInstance():Broadcast(EventId.MultipleParkourLevelChanged)
          Logger.LogInfo("MultipleParkour PassDoor newLevel : " .. self.runningTotalLevel .. "myScore : " .. tmpMyScore)
        end
      end
      if CS.CommonUtils.IsDebug() then
        EventManager:GetInstance():Broadcast(EventId.MultipleParkourDoorPassed)
      end
    else
      if door.handle == nil and door.posZ - teamZ < ViewDisForward then
        door:Load()
      end
      if teamZ - door.posZ > ViewDisBack then
        door:Delete()
        table.remove(self.doors, i)
      end
    end
    if self.endTotalLevel ~= nil and self.endTotalLevel == self.passedDoorLevel then
      local remainCount = 1
      if self.team then
        remainCount = self.team:GetPlayerCount()
        remainCount = Mathf.Max(1, remainCount)
      end
      if self.endlessResultData then
        self.endlessResultData.curRank = remainCount
      end
      self:ChangeStage(State.Result)
      return
    end
  end
end

function MultipleParkourManager:UpdateCameraFollow()
  local v1 = self.followCameraTarget
  tmpV1:Set(v1.x, v1.y, v1.z)
  local teamPos = self.team:GetPosition()
  tmpV2:Set(XCenter, 0, teamPos.z + LookOffset)
  tmpV2.x = tmpV2.x + tmpV3.x * 0.3
  tmpV2.y = tmpV2.y + tmpV3.y * 0.3
  tmpV2.z = tmpV2.z + tmpV3.z * 0.3
  local distance = true
  if math.abs(tmpV1.x - tmpV2.x) < 0.01 and math.abs(tmpV1.y - tmpV2.y) < 0.01 and math.abs(tmpV1.z - tmpV2.z) < 0.01 then
    distance = false
    velocity.x, velocity.y, velocity.z = 0, 0, 0
  end
  if distance then
    local targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
    velocity = v
    self:CameraFollowLookAt(targetPos)
  end
end

function MultipleParkourManager:UpdateChangeSelect(deltaTime)
  if self.changeSelectFinialTimer <= 0 then
    return
  end
  self.changeSelectFinialTimer = self.changeSelectFinialTimer - deltaTime
  if self.changeSelectFinialTimer <= 0 then
    local curLevel = self.passedDoorLevel
    local nextSelectMap = self.serverNextSelectMap[curLevel]
    if nextSelectMap then
      for playerId, select in pairs(nextSelectMap) do
        local playerData = self.playerIdMap[playerId]
        if playerData and playerData.select ~= select then
          self:ChangeSelect(playerData, playerData.select, select)
          playerData:UpdateSelect(select)
          self.team:UpdateSinglePlayer(playerData, false, true)
        end
      end
    end
    return
  end
  if 0 < self.changeSelectDelayTimer then
    self.changeSelectDelayTimer = self.changeSelectDelayTimer - deltaTime
    return
  end
  if 0 < self.changeSelectTimer then
    self.changeSelectTimer = self.changeSelectTimer - deltaTime
    if 0 >= self.changeSelectTimer then
      self.changeSelectTimer = ChangeSelectTime
      local curLevel = self.passedDoorLevel
      local nextSelectMap = self.serverNextSelectMap[curLevel]
      if nextSelectMap then
        local playerId
        for i, v in pairs(nextSelectMap) do
          playerId = i
          local select = v
          local playerData = self.playerIdMap[playerId]
          if playerData and playerData.select ~= select then
            self:ChangeSelect(playerData, playerData.select, select)
            playerData:UpdateSelect(select)
            self.team:UpdateSinglePlayer(playerData, false, true)
          end
          break
        end
        if playerId then
          nextSelectMap[playerId] = nil
        end
      end
    end
  end
end

function MultipleParkourManager:OnUpdateSec()
end

function MultipleParkourManager:Enter(param)
  if param.roomId == nil then
    return
  end
  if self.state ~= State.Init then
    self:ClearForAgain()
  end
  self.effectObjMgr = EffectObjManager.New(self)
  self.param = param
  self.doorId = param.doorId
  local type = param.type
  if type == Mode.Normal then
    self.mode = Mode.Normal
  elseif type == Mode.Endless then
    self.mode = Mode.Endless
  else
    Logger.LogError("MultipleParkourManager.Enter type error id:" .. self.doorId .. " type : " .. type)
    self:Exit()
    return
  end
  self.roomId = param.roomId
  if self.mode == Mode.Endless then
    self.doorIdList = param.doorIdList
    self.totalDoorIdCount = #self.doorIdList
    self.doorIdIndex = 1
    if self.totalDoorIdCount < 1 then
      Logger.LogError("MultipleParkourManager.Enter endless model totalDoorIdCount invalid !")
      self:Exit()
      return
    end
    self.doorId = self.doorIdList[self.doorIdIndex]
  end
  local template = DataCenter.MultipleParkourDoorTemplateManager:GetTemplate(self.doorId)
  if template == nil then
    Logger.LogError("MultipleParkourManager.Enter cfg error id:" .. self.doorId)
    return
  end
  self.endLine = ZStart
  self:ChangeStage(State.Loading)
  self.doorTemplate = template
  self.passedDoorLevel = 0
  self.lastPassDoorLevel = 0
  self.mySelected = 0
  self.marchSubState = 0
  self.marchSubStateTimer = 0
  self.lastDisableOpTime = 0
  self.changeSelectDelayTimer = 0
  self.changeSelectTimer = 0
  self.changeSelectFinialTimer = 0
  self.isEnd = false
  self.remainTimes = 0
  self.startMoveTimeStamp = nil
  DataCenter.LWBattleManager:SetCurBattleLogic(self)
  
  function self.onCreateSceneComplete()
    self:LoadSceneComplete()
  end
  
  local p = {}
  p.leftText = Localization:GetString("dev_multiple_stage_04")
  p.rightText = Localization:GetString("dev_multiple_stage_06")
  p.marchCount = self.doorTemplate.total_limit
  p.marchTime = self.doorTemplate.match_time
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkourLoading, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 10004
  }, p)
  self.uiLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIMultipleParkourLoading).View
  
  local function onLoadingEnter()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
    GoToUtil.CloseAllWindows()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
    UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
    self:CreateLevel()
  end
  
  local function onLoadingClosed()
    local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
    if mainUIView then
      mainUIView:SetActive(false)
    end
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      local desertUI = UIManager:GetInstance():GetWindow(uiStr)
      if desertUI and desertUI.View then
        desertUI.View:SetActive(false)
      end
    end
  end
  
  self.uiLoading:SetOnEntered(onLoadingEnter)
  self.uiLoading:SetOnClosed(onLoadingClosed)
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourEnter, {
    doorId = self.doorId
  })
end

function MultipleParkourManager:SendExit()
  if self.roomId then
    SFSNetwork.SendMessage(MsgDefines.MultipleParkourDoorExit, self.roomId)
  end
end

function MultipleParkourManager:TryExit()
  self:SendExit()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMultipleParkour, {anim = false})
  self:Exit()
end

function MultipleParkourManager:ClearForAgain()
  DataCenter.LWSoundManager:StopAllSounds()
  self:Destroy()
  DataCenter.LWBattleManager:SetCurBattleLogic()
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourExit)
end

function MultipleParkourManager:Exit(ExitAction)
  DataCenter.LWSoundManager:StopAllSounds()
  self:Destroy()
  DataCenter.LWBattleManager:SetCurBattleLogic()
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    local action = ExitAction
    local onSceneCreated
    
    function onSceneCreated()
      DataCenter.WarningBallManager:AddTimer()
      EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
      EventManager:GetInstance():Broadcast(EventId.PveLevelExit)
      EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
      DataCenter.CityNpcManager:SetNpcVisible(true)
      if action ~= nil then
        action()
      end
      DataCenter.GuideManager:DoWaitTriggerAfterBack()
    end
    
    SceneUtils.CreateCity()
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(true)
  end
  if BattleFieldUtil.InBattleField() then
    local uiStr = BattleFieldUtil.GetMainUIName()
    if not string.IsNullOrEmpty(uiStr) then
      local desertUI = UIManager:GetInstance():GetWindow(uiStr)
      if desertUI and desertUI.View then
        desertUI.View:SetActive(true)
      end
    end
  end
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourExit)
end

function MultipleParkourManager:CreateLevel()
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  self.nextObjId = 1
  if CS.SceneManager.IsInCity() then
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
  elseif CS.SceneManager.IsInWorld() then
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
  end
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
  self:LoadScene()
  self:InitCamera()
  self:AddUpdateTimer()
  self:AddListener()
end

function MultipleParkourManager:LoadScene()
  if self.mode == Mode.Normal then
    self.sceneCfgArrList = {}
    local sceneGroupCfg = self.doorTemplate.sceneGroupCfg
    local sceneCfgArr
    local groupCount = #sceneGroupCfg
    if groupCount == 1 then
      sceneCfgArr = sceneGroupCfg[1]
    else
      local index = math.random(1, groupCount)
      sceneCfgArr = sceneGroupCfg[index]
    end
    table.insert(self.sceneCfgArrList, sceneCfgArr)
  elseif self.mode == Mode.Endless then
    self.sceneCfgArrList = {}
    for _, doorId in ipairs(self.doorIdList) do
      local template = DataCenter.MultipleParkourDoorTemplateManager:GetTemplate(doorId)
      if template then
        local sceneGroupCfg = template.sceneGroupCfg
        local sceneCfgArr
        local groupCount = #sceneGroupCfg
        if groupCount == 1 then
          sceneCfgArr = sceneGroupCfg[1]
        else
          local index = math.random(1, groupCount)
          sceneCfgArr = sceneGroupCfg[index]
        end
        table.insert(self.sceneCfgArrList, sceneCfgArr)
      end
    end
  end
  self.sceneArr = {}
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(2)
  local sceneOffset = 0
  for i, sceneCfg in ipairs(self.sceneCfgArrList) do
    sceneCfg.offset = sceneOffset
    sceneOffset = sceneOffset + sceneCfg.totalSize
  end
  local count = #self.sceneCfgArrList
  for i = count, 1, -1 do
    local sceneCfg = self.sceneCfgArrList[i]
    local callback
    if i == 1 then
      callback = self.onCreateSceneComplete
    end
    local scene = MultipleParkourScene.New(self, i, sceneCfg, callback)
    table.insert(self.sceneArr, scene)
  end
  self:LoadTeam()
end

function MultipleParkourManager:LoadTeam()
  self.teamPosCount = self.doorTemplate.total_limit
  if self.team == nil then
    self.team = MultipleParkourTeam.New(XCenter, ZStart, self, self.doorTemplate.total_limit)
    self.team:InitData()
    self.lastTeamZ = ZStart
  end
end

function MultipleParkourManager:InitCamera()
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  self.hudCamera = self.camera.transform:Find("HudCamera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.touchCamera.CanMoveing = false
  self.saveCameraParam = {}
  self.saveCameraParam.fieldOfView = self.camera.fieldOfView
  self:InitCameraParams()
  local touchInput = self.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function MultipleParkourManager:UnInitCamera()
  if self.touchCamera then
    self.touchCamera:StopMove()
    self.touchCamera.CanMoveing = true
    local touchInput = self.touchCamera.touchInput
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
    self.camera.fieldOfView = self.saveCameraParam.fieldOfView
    self.hudCamera.fieldOfView = self.saveCameraParam.fieldOfView
    for i, p in pairs(Const.CameraParam.World) do
      self.touchCamera:SetZoomParams(i, p.height, GetOffsetZ(p.height, p.rotation), p.sen)
    end
    self.touchCamera.AfterUpdate = nil
    self.touchCamera = nil
  end
end

function MultipleParkourManager:InitCameraParams()
  local cameraParam = self:GetCameraParams()
  local height = cameraParam.height
  local fov = cameraParam.fov
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = GetOffsetZ(height, cameraParam.rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = 8
  self.camera.transform.eulerAngles = Vector3.New(cameraParam.rotation, 0, 0)
end

function MultipleParkourManager:GetCameraParams()
  local camera = {}
  camera.fov = 60
  camera.height = 20
  camera.rotation = 50
  return camera
end

function MultipleParkourManager:LoadSceneComplete()
  if self.state == State.Init then
    return
  end
  pcall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.PVE
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.PVE)
end

function MultipleParkourManager:TryReady(roomInfo)
  local roomId = roomInfo.roomId
  if roomId == nil then
    return
  end
  if self.roomId == nil then
    return
  end
  if self.roomId ~= roomId then
    return
  end
  local stage = roomInfo.stage or 0
  if stage ~= 3 then
    Logger.LogError("MultipleParkourManager.TryReady stage invalid : " .. stage)
    self:Exit()
    return
  end
  if roomInfo.roomId then
    local type = roomInfo.type
    if type == nil or self.mode == nil or type ~= self.mode then
      Logger.LogError("MultipleParkourManager.TryReady type invalid : " .. tostring(type) .. " curType : " .. tostring(self.mode))
      self:Exit()
      return
    end
    self.mapId = roomInfo.mapId
    self.mapIdList = roomInfo.mapIdList
    self.remainTimes = roomInfo.remainTimes or 0
    self.playerIdMap = {}
    self.teamLayoutPlayerMap = {}
    self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Left] = {}
    self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Right] = {}
    self.teamLeftEmptyQueue = {}
    self.teamRightEmptyQueue = {}
    self.levelDisableOpMap = {}
    self.serverPlayerScoreMap = {}
    self.serverNextSelectMap = {}
    self.serverPassDoorTimeMap = {}
    self.serverMarchStateTimeArray = {}
    self.enterGameTimeStamp = roomInfo.enterGameTime
    self.lastGameTimeStamp = self.enterGameTimeStamp
    self.loadingEndTimeStamp = roomInfo.loadingEndTime
    self.startMoveTimeStamp = self.loadingEndTimeStamp
    if 0 < self.loadingEndTimeStamp then
      self.readyTimer = (self.loadingEndTimeStamp - self.enterGameTimeStamp) / 1000
    else
      self.readyTimer = self.doorTemplate.loading_time
    end
    local leftIndex = 0
    local rightIndex = 0
    local players = roomInfo.players
    if players then
      for _, v in pairs(players) do
        local playerData = MultipleParkourPlayerData.New()
        playerData:Update(v)
        local mySelf = playerData.mySelf
        if mySelf then
          self.team:SetMyTeamId(playerData.teamId)
        end
        local id = playerData.playerId
        self.playerIdMap[id] = playerData
        local select = playerData.select
        if select == Const.MultipleParkourDoorLayout.Left then
          if mySelf then
            playerData:UpdateTeamIndex(0)
            self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Left][0] = id
          else
            leftIndex = leftIndex + 1
            playerData:UpdateTeamIndex(leftIndex)
            self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Left][leftIndex] = id
          end
        elseif select == Const.MultipleParkourDoorLayout.Right then
          if mySelf then
            playerData:UpdateTeamIndex(0)
            self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Right][0] = id
          else
            rightIndex = rightIndex + 1
            playerData:UpdateTeamIndex(rightIndex)
            self.teamLayoutPlayerMap[Const.MultipleParkourDoorLayout.Right][rightIndex] = id
          end
        end
        if id == LuaEntry.Player:GetUid() then
          self.mySelected = select
        end
      end
      for i = self.teamPosCount, leftIndex + 1, -1 do
        table.insert(self.teamLeftEmptyQueue, i)
      end
      for i = self.teamPosCount, rightIndex + 1, -1 do
        table.insert(self.teamRightEmptyQueue, i)
      end
      self.team:Load(self.playerIdMap)
    else
      Logger.LogError("MultipleParkourManager.TryReady roomInfo no playerData !")
      return
    end
    self:StartReady()
  else
    Logger.LogError("MultipleParkourManager:TryReady invalid roomId ! ")
  end
end

function MultipleParkourManager:StartReady()
  if self.uiLoading then
    self.uiLoading:Quit()
    self.uiLoading = nil
  end
  if self.doorTemplate.sound_id_bgm == 0 then
    Logger.LogError("\233\155\134\228\189\147\232\183\145\233\133\183\229\133\179\229\141\161bgm\228\184\186\231\169\186\239\188\140levelId=" .. (self.doorId or 0))
  else
    CommonUtil.ClearGameBgMusicData()
    DataCenter.LWSoundManager:PlayMusicById(self.doorTemplate.sound_id_bgm, true)
  end
  EventManager:GetInstance():Broadcast(EventId.PveLevelEnter)
  local pos = Vector3.New(XCenter, 0, ZStart)
  self:LookAt(pos)
  self:OnGameStart()
  self:LoadDoor()
  self:ChangeStage(State.Ready)
end

function MultipleParkourManager:LoadDoor()
  self.doors = {}
  self.bossLeftDamage = 0
  self.bossRightDamage = 0
  self.bossLevel = 0
  self.marchOpTimeArray = {}
  self.marchOpSpeedArray = {}
  self.marchOpIndex = 0
  self.marchPosAdjustArray = {}
  self.runningTotalLevel = 1
  local mapTemplateArrList = {}
  if self.mode == Mode.Normal then
    local map_Type = self.mapId
    local mapTemplateArr = DataCenter.MultipleParkourMapTemplateManager:GetMapLevelList(map_Type)
    if mapTemplateArr == nil then
      Logger.LogError("MultipleParkourManager.LoadDoor mapTemplateArr nil id:" .. map_Type)
      return
    end
    table.insert(mapTemplateArrList, mapTemplateArr)
  elseif self.mode == Mode.Endless then
    local mapIdList = self.mapIdList
    for i, mapId in ipairs(mapIdList) do
      local mapTemplateArr = DataCenter.MultipleParkourMapTemplateManager:GetMapLevelList(mapId)
      if mapTemplateArr ~= nil then
        table.insert(mapTemplateArrList, mapTemplateArr)
      else
        Logger.LogError("MultipleParkourManager.LoadDoor mapTemplateArr nil id:" .. mapId)
      end
    end
  end
  local lastLevel = 0
  local lastIndex = 0
  local lastTotalLevel = 0
  local levelMaxMap = {}
  local mapLevelCount = 0
  local baseStart = ZStart
  local allMapCount = #mapTemplateArrList
  for i, mapTemplateArr in ipairs(mapTemplateArrList) do
    lastLevel = 0
    lastIndex = 0
    mapLevelCount = #mapTemplateArr
    for j, v in ipairs(mapTemplateArr) do
      local level = v.level
      local mapId = v.map_type
      if level ~= lastLevel then
        lastLevel = level
        lastIndex = 1
        lastTotalLevel = lastTotalLevel + 1
        local levelOffset = v.op_time * v.choose_speed
        baseStart = baseStart + levelOffset
        table.insert(self.marchPosAdjustArray, baseStart + 1)
        levelOffset = v.sprint_time * v.choose_over_speed
        baseStart = baseStart + levelOffset
        table.insert(self.marchPosAdjustArray, baseStart + 1)
        table.insert(self.marchOpTimeArray, v.op_time)
        table.insert(self.marchOpTimeArray, v.sprint_time)
        table.insert(self.marchOpSpeedArray, v.choose_speed)
        table.insert(self.marchOpSpeedArray, v.choose_over_speed)
      else
        lastIndex = lastIndex + 1
      end
      levelMaxMap[lastTotalLevel] = lastIndex
      local z = baseStart
      local pos = Vector3.New(XCenter, 0, z)
      local option1 = v.option1
      local option1Type = option1[1]
      if 0 < option1Type and option1Type < Const.MultipleParkourOptionType.Boss then
        local door = MultipleParkourDoor.New(pos, lastLevel, lastIndex, option1Type, option1[2], Const.MultipleParkourDoorLayout.Left, DoorResPath[option1Type], levelMaxMap, self, mapId, lastTotalLevel, i, j == mapLevelCount and i ~= allMapCount, v.right_option)
        table.insert(self.doors, door)
        self.endLine = z
      elseif option1Type == Const.MultipleParkourOptionType.Boss then
        self.bossLeftDamage = option1[2]
        if self.bossLevel == 0 then
          self.bossLevel = lastTotalLevel
        end
      end
      local option3 = v.option3
      local option3Type = option3[1]
      if 0 < option3Type and option3Type < Const.MultipleParkourOptionType.Boss then
        local door = MultipleParkourDoor.New(pos, lastLevel, lastIndex, option3Type, option3[2], Const.MultipleParkourDoorLayout.Right, DoorResPath[option3Type], levelMaxMap, self, mapId, lastTotalLevel, i, j == mapLevelCount and i ~= allMapCount, v.right_option)
        table.insert(self.doors, door)
      elseif option3Type == Const.MultipleParkourOptionType.Boss then
        self.bossRightDamage = option3[2]
        if self.bossLevel == 0 then
          self.bossLevel = lastTotalLevel
        end
      end
    end
  end
  self.totalLevel = lastTotalLevel
  self.doors = table.reverse(self.doors)
  for _, v in ipairs(self.doors) do
    v:InitData()
  end
end

function MultipleParkourManager:CalcDoorScore(layout, level, optionType, optionValue)
  local players = self.teamLayoutPlayerMap[layout]
  for _, playerId in pairs(players) do
    local playerData = self.playerIdMap[playerId]
    if playerData then
      local baseScore = playerData.score
      playerData:UpdateClientScore(self:CalcScore(baseScore, optionType, optionValue))
    end
  end
  self.team:UpdateScore(players)
end

function MultipleParkourManager:CalcScore(score, optionType, optionValue)
  local baseScore = score
  if optionType == Const.MultipleParkourOptionType.Add then
    baseScore = baseScore + optionValue
  elseif optionType == Const.MultipleParkourOptionType.Sub or optionType == Const.MultipleParkourOptionType.Boss then
    baseScore = baseScore - optionValue
    baseScore = math.max(baseScore, 0)
  elseif optionType == Const.MultipleParkourOptionType.Mul then
    baseScore = baseScore * optionValue
  elseif optionType == Const.MultipleParkourOptionType.Div and 0 < optionValue then
    baseScore = baseScore / optionValue
  end
  return math.ceil(baseScore)
end

function MultipleParkourManager:SyncDoorScore(layout, level)
  local playerScoreMap = self.serverPlayerScoreMap[level]
  if playerScoreMap ~= nil then
    local players = self.teamLayoutPlayerMap[layout]
    for _, playerId in pairs(players) do
      local playerData = self.playerIdMap[playerId]
      local serverScore = playerScoreMap[playerId]
      if playerData and serverScore then
        playerData:UpdateServerScore(serverScore)
      end
    end
    self.team:UpdateScore(players)
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourRankChanged)
end

function MultipleParkourManager:OnGameStart()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkour, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.doorId)
end

function MultipleParkourManager:OnFingerDown(pos)
  self.isFingerDown = true
  self.lastFingerPosX = pos.x
  self.lastTouchPosX = pos.x
  self.lastFingerDir = 0
end

function MultipleParkourManager:OnFingerUp()
  self.isFingerDown = false
end

function MultipleParkourManager:ChangeStage(newState)
  if self.state == newState then
    return
  end
  if newState == State.Loading and self.state == State.Init then
    self.state = newState
    return
  end
  if newState == State.Ready and self.state == State.Loading then
    self.state = newState
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_countdown_start)
    return
  end
  if newState == State.March and self.state == State.Ready then
    self.state = newState
    self:EnterMarch()
    return
  end
  if newState == State.Boss and self.state == State.March then
    self.state = newState
    self:EnterBoss()
    return
  end
  if newState == State.BeforeResult and self.state == State.Boss then
    self.state = newState
    self:DestroyBoss()
    self:EnterBeforeResult()
    return
  end
  if newState == State.Result and self.state ~= State.Result then
    self.state = newState
    if self.mode == Mode.Normal then
      self:EnterResult()
    elseif self.mode == Mode.Endless then
      if self.endlessResultData then
        self:EnterEndlessResult()
      else
        self.state = State.PreResult
        self:EnterEndlessPreResult()
      end
    end
    return
  end
  Logger.LogError("MultipleParkourManager.ChangeState invalid " .. self.state .. " -> " .. newState)
end

function MultipleParkourManager:EnterMarch()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_countdown_end)
  self:ChangeMarchSubState(MarchSubState.Op)
  if self.team then
    self.team:EnterMarch()
  end
end

function MultipleParkourManager:ChangeMarchSubState(state)
  if self.marchSubState == state then
    return
  end
  self.marchSubState = state
  self.marchOpIndex = self.marchOpIndex + 1
  local length = table.length(self.marchOpTimeArray)
  if length < self.marchOpIndex then
    self.marchSubStateTimer = self.marchOpTimeArray[length]
  else
    self.marchSubStateTimer = self.marchOpTimeArray[self.marchOpIndex]
    if state == MarchSubState.Op then
      self.changeSelectFinialTimer = self.marchSubStateTimer - 0.5
      self.changeSelectDelayTimer = self.changeSelectFinialTimer / 2
      self.changeSelectTimer = ChangeSelectTime
    end
  end
  length = table.length(self.marchOpSpeedArray)
  if length < self.marchOpIndex then
    self.curMarchSpeed = self.marchOpSpeedArray[length]
  else
    self.curMarchSpeed = self.marchOpSpeedArray[self.marchOpIndex]
  end
  local nextIndex = self.marchOpIndex + 1
  if length < nextIndex then
    self.nextMarchSpeed = self.marchOpSpeedArray[length]
  else
    self.nextMarchSpeed = self.marchOpSpeedArray[nextIndex]
  end
  if state == MarchSubState.Door then
    local rand = math.random(1, 2)
    if rand == 1 then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_sound_countmaster_pace1)
    else
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_sound_countmaster_pace2)
    end
  end
end

function MultipleParkourManager:GetMarchSubStateTimer()
  if self.state == State.March and self.marchSubState == MarchSubState.Op then
    return math.ceil(self.marchSubStateTimer)
  end
  return 0
end

function MultipleParkourManager:EnterBoss()
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourBossEnter)
  self.bossWarningTimer = self.marchOpTimeArray[#self.marchOpTimeArray - 1]
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourMarchSubStageChanged)
  if self.team then
    self.team:EnterBoss()
  end
end

function MultipleParkourManager:LoadBoss()
  if not self.bosses then
    self.bosses = {}
    self.bossSprintTime = self.marchOpTimeArray[#self.marchOpTimeArray]
    self.bossSprintSpeed = self.marchOpSpeedArray[#self.marchOpSpeedArray]
    if self.bossLeftDamage > 0 then
      local pos = Vector3.New(XCenter - 3, 0, self.endLine + self.bossSprintTime * self.bossSprintSpeed)
      local boss = MultipleParkourBoss.New(self, pos, self.bossSprintSpeed, self.bossLeftDamage, Const.MultipleParkourDoorLayout.Left)
      table.insert(self.bosses, boss)
    end
    if 0 < self.bossRightDamage then
      local pos = Vector3.New(XCenter + 3, 0, self.endLine + self.bossSprintTime * self.bossSprintSpeed)
      local boss = MultipleParkourBoss.New(self, pos, self.bossSprintSpeed, self.bossRightDamage, Const.MultipleParkourDoorLayout.Right)
      table.insert(self.bosses, boss)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_bus_run)
  end
end

function MultipleParkourManager:DestroyBoss()
  if self.bosses then
    for _, v in ipairs(self.bosses) do
      v:Delete()
    end
    self.bosses = nil
  end
end

function MultipleParkourManager:UpdateBoss(deltaTime)
  if self.bossWarningTimer > 0 then
    self.bossWarningTimer = self.bossWarningTimer - deltaTime
    if self.bossWarningTimer <= 0 then
      self:LoadBoss()
    end
    return
  end
  local bossEnd = false
  local maxZ = self.bossSprintSpeed * 5
  if self.team then
    maxZ = self.team:GetMaxZ() + 1
  end
  for _, v in ipairs(self.bosses) do
    local bossZ = v:GetPositionZ()
    if maxZ < self.endLine - bossZ then
      bossEnd = true
      break
    end
  end
  if bossEnd then
    self:ChangeStage(State.BeforeResult)
    return
  end
  self:UpdateBossPosition(deltaTime)
end

function MultipleParkourManager:UpdateBossPosition(deltaTime)
  local syncScore = false
  for _, v in ipairs(self.bosses) do
    local pos = v:GetPosition()
    local add = self.bossSprintSpeed * deltaTime
    local posZ = pos.z
    local z = posZ - add
    v:UpdatePos(pos.x, z)
    local layout = v.layout
    syncScore = self:UpdateBossPlayer(layout, posZ, z, v.damage)
  end
  if syncScore then
    EventManager:GetInstance():Broadcast(EventId.MultipleParkourRankChanged)
  end
end

function MultipleParkourManager:UpdateBossPlayer(layout, lastZ, curZ, damage)
  local syncScore = false
  if self.passedDoorLevel ~= self.bossLevel and lastZ > self.endLine and curZ <= self.endLine then
    self.passedDoorLevel = self.bossLevel
    self.lastPassDoorLevel = self.bossLevel
  end
  local map = self.teamLayoutPlayerMap[layout]
  for _, v in pairs(map) do
    local hit = self.team:UpdateBossPos(v, lastZ, curZ)
    if hit then
      local playerData = self.playerIdMap[v]
      if playerData then
        local serverScore = self.serverPlayerScoreMap[self.bossLevel]
        if serverScore and serverScore[v] then
          playerData:UpdateServerScore(serverScore[v])
          syncScore = true
        else
          local baseScore = playerData.score
          playerData:UpdateClientScore(self:CalcScore(baseScore, Const.MultipleParkourOptionType.Boss, damage))
        end
        self.team:UpdatePlayerScore(v)
      end
      self.team:EnterBossResult(v)
    end
  end
  return syncScore
end

function MultipleParkourManager:EnterBeforeResult()
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourRankChanged)
  self.resultTimer = self.doorTemplate.boss_over_time
  local per = self.doorTemplate.emoji_percentage
  per = per / 100
  local allPlayer = table.count(self.playerIdMap)
  local emojiCount = math.floor(allPlayer * per)
  self.emojiCount = emojiCount
  self.emojiCountTimer = 0.05
  self.emojiPlayers = {}
  local hasSelf = false
  for playerId, playerData in pairs(self.playerIdMap) do
    emojiCount = emojiCount - 1
    if emojiCount < 0 then
      break
    end
    table.insert(self.emojiPlayers, playerId)
    if playerData.mySelf then
      hasSelf = true
    end
  end
  if not hasSelf then
    local myId = LuaEntry.Player:GetUid()
    if self.playerIdMap[myId] then
      table.insert(self.emojiPlayers, myId)
      self.emojiCount = self.emojiCount + 1
    end
  end
  local hasWin = false
  self.winPlayers = {}
  local players = self:GetAllPlayers()
  if self.team then
    for i = 1, 5 do
      local player = players[i]
      if player and 0 < player.score then
        self.team:MoveToRewardPos(player.playerId, i, 2)
        table.insert(self.winPlayers, player.playerId)
        hasWin = true
      end
    end
  end
  if hasWin then
    self.moveToRewardTimer = 2
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_run_03)
  else
    self.moveToRewardTimer = 0
  end
  if self.playerIdMap then
    for playerId, playerData in pairs(self.playerIdMap) do
      if not table.hasvalue(self.winPlayers, playerId) and playerData and 0 < playerData.score then
        self.team:PlayWin(playerId)
      end
    end
  end
  DataCenter.LWSoundManager:StopBGMusic()
end

function MultipleParkourManager:UpdateBeforeResult(deltaTime)
  if self.emojiCount > 0 and self.playerIdMap then
    self.emojiCountTimer = self.emojiCountTimer - deltaTime
    if 0 >= self.emojiCountTimer then
      self.emojiCountTimer = 0.05
      local playerId = self.emojiPlayers[self.emojiCount]
      self.emojiCount = self.emojiCount - 1
      if not table.hasvalue(self.winPlayers, playerId) then
        local playerData = self.playerIdMap[playerId]
        if playerData then
          local win = 0 < playerData.score
          local emojiList = self.doorTemplate.lose_emoji
          if win then
            emojiList = self.doorTemplate.win_emoji
          end
          local count = #emojiList
          local rand = math.random(1, count)
          local emojiId = emojiList[rand]
          self.team:ShowEmoji(playerId, emojiId)
        end
      end
    end
  end
  if 0 < self.resultTimer then
    self.resultTimer = self.resultTimer - deltaTime
    if 0 >= self.resultTimer then
      self:ChangeStage(State.Result)
    end
  end
  if 0 < self.moveToRewardTimer then
    self.moveToRewardTimer = self.moveToRewardTimer - deltaTime
    if 0 >= self.moveToRewardTimer then
      if self.touchCamera then
        self.touchCamera:AutoLookat(Vector3.New(self.followCameraTarget.x, self.followCameraTarget.y, self.followCameraTarget.z + 2), 17, 1, function()
          self:OnCameraZoomFinish()
        end)
      end
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_multiply_door_win_bgm)
    end
  end
end

function MultipleParkourManager:OnCameraZoomFinish()
  if (self.state == State.BeforeResult or self.state == State.Result) and self.team and self.winPlayers then
    for i, v in ipairs(self.winPlayers) do
      self.team:PlayWin(v)
      local emojiList = self.doorTemplate.win_emoji
      local count = #emojiList
      local rand = math.random(1, count)
      local emojiId = emojiList[rand]
      self.team:ShowEmoji(v, emojiId, 3)
      self.team:ShowNameAndUpdateHeight(v, 3)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_multiply_door_win)
    self:ShowFireworks(Vector3.New(self.followCameraTarget.x, self.followCameraTarget.y, self.followCameraTarget.z + 9))
  end
end

function MultipleParkourManager:ShowFireworks(pos)
  self:ClearFireworks()
  self.fireworksReq = Resource:InstantiateAsync(FireworksEffectPath)
  self.fireworksReq:completed("+", function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local tf = go.transform
    tf:SetParent(nil)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf:Set_localPosition(pos.x, pos.y, pos.z)
    go:SetActive(true)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_fireworks)
  end)
end

function MultipleParkourManager:ClearFireworks()
  if self.fireworksReq then
    self.fireworksReq:Destroy()
    self.fireworksReq = nil
  end
end

function MultipleParkourManager:EnterResult()
  local myScore = self:GetResultShowData()
  local result = 0
  if 0 < myScore then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkourWin, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide,
      playEffect = 10004
    })
    result = 1
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkourLose, {
      anim = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide,
      playEffect = 10004
    })
  end
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourResult, {
    type = tonumber(self.mode),
    multipleParkourResult = result
  })
end

function MultipleParkourManager:EnterEndlessResult()
  local curRank = 1
  if self.endlessResultData then
    curRank = self.endlessResultData.curRank
  end
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourMarchSubStageChanged)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultipleParkourResult, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 10004
  })
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourResult, {
    type = tonumber(self.mode),
    multipleParkourResult = curRank
  })
end

function MultipleParkourManager:EnterEndlessPreResult()
  EventManager:GetInstance():Broadcast(EventId.MultipleParkourMarchSubStageChanged)
end

function MultipleParkourManager:LookAt(lookWorldPosition)
  self.followCameraTarget = Vector3.New(lookWorldPosition.x, lookWorldPosition.y, lookWorldPosition.z)
  self.touchCamera:LookAt(lookWorldPosition + cameraOffset)
end

function MultipleParkourManager:CameraFollowLookAt(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offset = targetPos - self.followCameraTarget
  transform:Set_position(x + offset.x, y + offset.y, z + offset.z)
  self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
end

function MultipleParkourManager:IsEndless()
  return self.mode and self.mode == Mode.Endless
end

function MultipleParkourManager:HandleRoomInfo(roomInfo)
  if self.state == State.Init then
    return
  end
  local stage = roomInfo.stage or 0
  if stage ~= 4 then
    Logger.LogError("MultipleParkourManager.HandleRoomInfo stage invalid : " .. stage)
    return
  end
  local roomId = roomInfo.roomId
  if roomId ~= self.roomId then
    Logger.LogError("MultipleParkourManager.HandleRoomInfo diff room : " .. roomId .. " - " .. self.roomId)
    return
  end
  local level = roomInfo.level
  if self.mode == Mode.Endless then
    level = roomInfo.curTotalLevel
  end
  local nextLevelTime = roomInfo.nextLevelTime
  if 0 < nextLevelTime then
    if level == 0 then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      Logger.LogInfo("MultipleParkour HandleRoomInfo level 0. Time : " .. curTime)
      self.serverMarchStateTimeArray[1] = nextLevelTime - self.marchOpTimeArray[2] * 1000
      self.serverMarchStateTimeArray[2] = nextLevelTime
      local count = #self.marchOpTimeArray
      local timeStamp = nextLevelTime
      for i = 3, count do
        timeStamp = timeStamp + self.marchOpTimeArray[i] * 1000
        self.serverMarchStateTimeArray[i] = timeStamp
      end
      self.serverPassDoorTimeMap[level + 1] = nextLevelTime
    end
    if level == 0 then
      local totalCount = #self.marchOpTimeArray
      totalCount = totalCount / 2
      local time = nextLevelTime
      for i = 1, totalCount - 1 do
        local marchOp1 = self.marchOpTimeArray[i * 2 + 1] * 1000
        time = time + marchOp1
        local marchOp2 = self.marchOpTimeArray[i * 2 + 2] * 1000
        time = time + marchOp2
        self.serverPassDoorTimeMap[i + 1] = time
      end
    end
  end
  local syncScore = self.passedDoorLevel == level and self.lastPassDoorLevel == level
  local players = roomInfo.players
  local playerScores = self.serverPlayerScoreMap[level]
  if playerScores == nil then
    playerScores = {}
    self.serverPlayerScoreMap[level] = playerScores
  end
  local selectMap = self.serverNextSelectMap[level]
  if selectMap == nil then
    selectMap = {}
    self.serverNextSelectMap[level] = selectMap
  end
  for _, v in pairs(players) do
    local playerId = v.playerId
    local data = self.playerIdMap[playerId]
    if data then
      local lastSelect = data.select
      local newSelect = v.select
      if newSelect ~= lastSelect then
        self:ChangeSelect(data, lastSelect, newSelect, true)
        if playerId == LuaEntry.Player:GetUid() then
          self.mySelected = newSelect
        end
      end
      local nextSelect = v.nextSelect
      if 0 < nextSelect and newSelect ~= nextSelect then
        selectMap[playerId] = nextSelect
      end
      data:UpdateLevel(v, level)
      if syncScore then
        data:UpdateServerScore(v.score)
      end
      data:UpdateSelectTimes(v.operationNum)
      playerScores[playerId] = v.score
    end
  end
  self.team:UpdatePlayer(self.playerIdMap, syncScore, self.passedDoorLevel ~= self.bossLevel)
  self.isEnd = roomInfo.isEnd == 1
  if syncScore then
    EventManager:GetInstance():Broadcast(EventId.MultipleParkourRankChanged)
  end
end

function MultipleParkourManager:ChangeSelect(playerData, fromSelect, toSelect, force)
  if not force and playerData.mySelf then
    return
  end
  local curSelect = playerData.select
  if curSelect == toSelect then
    return
  end
  local index = playerData.teamIndex
  local playerId = playerData.playerId
  local players = self.teamLayoutPlayerMap[fromSelect]
  players[index] = nil
  if playerData.mySelf then
    self.teamLayoutPlayerMap[toSelect][0] = playerId
    playerData:UpdateTeamIndex(0)
    return
  end
  if fromSelect == Const.MultipleParkourDoorLayout.Left then
    table.insert(self.teamLeftEmptyQueue, index)
  elseif fromSelect == Const.MultipleParkourDoorLayout.Right then
    table.insert(self.teamRightEmptyQueue, index)
  end
  local newIndex = -1
  if toSelect == Const.MultipleParkourDoorLayout.Left then
    local emptyCount = #self.teamLeftEmptyQueue
    if 0 < emptyCount then
      newIndex = self.teamLeftEmptyQueue[emptyCount]
      table.remove(self.teamLeftEmptyQueue, emptyCount)
      self.teamLayoutPlayerMap[toSelect][newIndex] = playerId
      playerData:UpdateTeamIndex(newIndex)
    end
  elseif toSelect == Const.MultipleParkourDoorLayout.Right then
    local emptyCount = #self.teamRightEmptyQueue
    if 0 < emptyCount then
      newIndex = self.teamRightEmptyQueue[emptyCount]
      table.remove(self.teamRightEmptyQueue, emptyCount)
      self.teamLayoutPlayerMap[toSelect][newIndex] = playerId
      playerData:UpdateTeamIndex(newIndex)
    end
  end
end

function MultipleParkourManager:GetTopScore()
  if self.doorTemplate then
    return self.doorTemplate.top_score
  end
  return 0
end

function MultipleParkourManager:IsResult()
  return self.isEnd, self.remainTimes
end

function MultipleParkourManager:GetResultShowData()
  local myScore = 0
  local elimination = 0
  local full = 0
  local fullScore = self:GetTopScore()
  if self.playerIdMap then
    for _, playerData in pairs(self.playerIdMap) do
      local playerScore = playerData.score
      if playerData.mySelf then
        myScore = playerScore
      end
      if fullScore <= playerScore then
        full = full + 1
      end
      if playerScore <= 0 then
        elimination = elimination + 1
      end
    end
  end
  return myScore, elimination, full
end

function MultipleParkourManager:GetAllPlayers()
  local players = {}
  if self.playerIdMap then
    for _, v in pairs(self.playerIdMap) do
      table.insert(players, v)
    end
  end
  table.sort(players, function(a, b)
    local scoreA = a.score
    local scoreB = b.score
    if scoreA ~= scoreB then
      return scoreA > scoreB
    end
    local selectA = a.selectTimes
    local selectB = b.selectTimes
    if selectA ~= selectB then
      return selectA < selectB
    end
    local indexA = a.numberId
    local indexB = b.numberId
    return indexA < indexB
  end)
  return players
end

function MultipleParkourManager:SimulatorSingleMatch()
  SFSNetwork.SendMessage(MsgDefines.MultipleParkourSingleMatch, Mode.Normal)
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourMarch, {
    type = Mode.Normal
  })
end

function MultipleParkourManager:SimulatorSingleMatchEndless(again)
  SFSNetwork.SendMessage(MsgDefines.MultipleParkourSingleMatch, Mode.Endless, again)
  PostEventLog.Track(PostEventLog.Defines.MultipleParkourMarch, {
    type = Mode.Endless
  })
end

function MultipleParkourManager:HandlePushMultipleMatch(message)
  local param = {}
  param.doorId = message.doorId
  param.type = message.type
  param.doorIdList = message.doorIdList
  param.roomId = message.roomId
  self:Enter(param)
end

function MultipleParkourManager:HandlePushMultipleRoom(message)
  if self.state == State.Init then
    return
  end
  local roomInfo = message.roomInfo
  if self.state == State.Loading then
    if message.roomInfo then
      self:TryReady(message.roomInfo)
    else
      Logger.LogError("MultipleParkourManager:HandlePushMultipleRoom invalid roomInfo !")
    end
    return
  end
  if message.roomInfo then
    self:HandleRoomInfo(message.roomInfo)
  else
    Logger.LogError("MultipleParkourManager:HandlePushMultipleRoom HandleRoomInfo invalid roomInfo !")
  end
  if message.reward then
    self.reward = message.reward
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
end

function MultipleParkourManager:HandlePushMultipleRoomPlayer(message)
  if self.state == State.Init then
    return
  end
  local action = message.action or 0
  local playerInfos = message.playerInfos
  if playerInfos == nil then
    return
  end
  if self.playerIdMap == nil then
    return
  end
  if action == 3 then
    for _, v in pairs(playerInfos) do
      local playerId = v.playerId
      local data = self.playerIdMap[playerId]
      if data then
        local lastSelect = data.select
        local newSelect = v.select
        if newSelect ~= lastSelect and playerId ~= LuaEntry.Player:GetUid() then
          self:ChangeSelect(data, lastSelect, newSelect)
          data:UpdateSelect(newSelect)
        end
      end
    end
    self.team:UpdatePlayer(self.playerIdMap, false, true)
  elseif action == 2 then
    for _, v in pairs(playerInfos) do
      local playerId = v.playerId
      self:RemovePlayer(playerId)
    end
  end
end

function MultipleParkourManager:PlayerDead(playerId)
  if self.playerIdMap == nil then
    return
  end
  local playerData = self.playerIdMap[playerId]
  if playerData then
    local index = playerData.teamIndex
    local select = playerData.select
    local players = self.teamLayoutPlayerMap[select]
    players[index] = nil
    if select == Const.MultipleParkourDoorLayout.Left then
      table.insert(self.teamLeftEmptyQueue, index)
    elseif select == Const.MultipleParkourDoorLayout.Right then
      table.insert(self.teamRightEmptyQueue, index)
    end
  end
end

function MultipleParkourManager:RemovePlayer(playerId)
  if self.playerIdMap == nil then
    return
  end
  local playerData = self.playerIdMap[playerId]
  if playerData then
    local index = playerData.teamIndex
    local select = playerData.select
    local players = self.teamLayoutPlayerMap[select]
    players[index] = nil
    if select == Const.MultipleParkourDoorLayout.Left then
      table.insert(self.teamLeftEmptyQueue, index)
    elseif select == Const.MultipleParkourDoorLayout.Right then
      table.insert(self.teamRightEmptyQueue, index)
    end
    if self.team then
      self.team:RemovePlayer(playerId)
    end
    self.playerIdMap[playerId] = nil
  end
end

function MultipleParkourManager:HandlePushMultiplePlayerEnd(message)
  if self.state == State.Init then
    return
  end
  if self.mode ~= Mode.Endless then
    Logger.LogError("MultipleParkourManager.HandlePushMultiplePlayerEnd not endless mode !")
    return
  end
  local endTotalLevel = message.curTotalLevel
  self.endTotalLevel = endTotalLevel
  self.endlessResultData = message
  if endTotalLevel <= self.lastPassDoorLevel and endTotalLevel <= self.passedDoorLevel then
    local remainCount = 1
    if self.team then
      remainCount = self.team:GetPlayerCount()
      remainCount = Mathf.Max(1, remainCount)
    end
    self.endlessResultData.curRank = remainCount
    self:ChangeStage(State.Result)
  else
  end
end

function MultipleParkourManager:GetPVEType()
  return PVEType.MultipleParkour
end

function MultipleParkourManager:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function MultipleParkourManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function MultipleParkourManager:GetNewRecordTip()
  return self.newRecordTipPool:GetRandom()
end

function MultipleParkourManager:GetNormalResultTip()
  return self.normalResultTipPool:GetRandom()
end

function MultipleParkourManager:IsEndDoor()
  if self.totalLevel then
    return self.totalLevel == self.passedDoorLevel
  end
  return false
end

function MultipleParkourManager:GetPassedLevel()
  if self:IsEndDoor() then
    return self.runningTotalLevel
  end
  return self.runningTotalLevel - 1
end

function MultipleParkourManager:GetRightOption()
  if self.doors and #self.doors > 0 then
    local door = self.doors[#self.doors]
    return door.rightOption
  end
  return 0
end

return MultipleParkourManager
