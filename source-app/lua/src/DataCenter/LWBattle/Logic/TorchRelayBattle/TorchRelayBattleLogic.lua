local Player = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Player/TorchRelayBattlePlayer")
local Data = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleData")
local Scene = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Scene/TorchRelayBattleScene")
local FSMachine = require("Common.FSMachine")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local Touch = CS.BitBenderGames.TouchWrapper
local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local socket = require("socket")
local TorchRelayBattleStageCheerConfigTemplate = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Config/TorchRelayBattleStageCheerConfigTemplate")
local TorchRelayBattleCheerNormal = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Cheer/TorchRelayBattleCheerNormal")
local TorchRelayBattleCheerAdvance = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Cheer/TorchRelayBattleCheerAdvance")
local TorchRelayScenePropsPool = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelayScenePropsPool")
local TorchRelayBattleRecordLine = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Scene.TorchRelayBattleRecordLine")
local TorchRelayBattleLogic = BaseClass("TorchRelayBattleLogic", base)
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
TorchRelayBattleLogic.State = {
  None = 0,
  Init = 1,
  Load = 2,
  Ready = 3,
  Play = 4,
  Finish = 5
}

function TorchRelayBattleLogic:__init()
end

function TorchRelayBattleLogic:__delete()
  self:Destroy()
end

function TorchRelayBattleLogic:Enter(param)
  self:PrintRealInfoLog("enter battle logic")
  self:AddListener(EventId.ActivityTorchRelayBattleFinishSuccess, self.OnFinishSuccess)
  if self.active then
    self:PrintRealErrorLog("already active")
    return
  end
  self.battleMgr = DataCenter.LWBattleManager
  self.param = param
  self.activityId = nil
  if self.param ~= nil and self.param.userData ~= nil then
    self.activityId = self.param.userData.activityId
  end
  self.curState = self.State.None
  self.totalGamePassedTime = 0
  self.tmpGamePassedTime = 0
  self.tmpGamePassedTimePostEvent = 0
  self.sceneReqs = {}
  self.sceneDataList = {}
  self.scenes = {}
  self.sceneCount = 0
  self.curScene = nil
  self.scenePropsPool = TorchRelayScenePropsPool.New()
  self.data = Data.New(param.levelId, param.userData)
  self.player = nil
  self.stamina = 100
  self.active = true
  self.fingerDown = false
  self:InitCheer()
  self.serverCheckIntervalData = nil
  self.finishIntervalData = nil
  self.mileStoneRewardDataDict = nil
  self.curMileStoneRewardData = nil
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Init, require("DataCenter/LWBattle/Logic/TorchRelayBattle/States/TorchRelayBattleStateInit").Create())
  self.fsm:Add(self.State.Load, require("DataCenter/LWBattle/Logic/TorchRelayBattle/States/TorchRelayBattleStateLoad").Create())
  self.fsm:Add(self.State.Ready, require("DataCenter/LWBattle/Logic/TorchRelayBattle/States/TorchRelayBattleStateReady").Create())
  self.fsm:Add(self.State.Play, require("DataCenter/LWBattle/Logic/TorchRelayBattle/States/TorchRelayBattleStatePlay").Create())
  self.fsm:Add(self.State.Finish, require("DataCenter/LWBattle/Logic/TorchRelayBattle/States/TorchRelayBattleStateFinish").Create())
  self.soundId = DataCenter.LWSoundManager:PlaySound(70012, true)
  self.isFinishAnimationOver = false
  self.finishMessageCache = nil
end

function TorchRelayBattleLogic:Destroy()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
  self:RemoveAllListeners()
  CS.SceneManager.ResetNightColor()
  if self.recordLineList then
    for i, v in ipairs(self.recordLineList) do
      if v then
        v:Delete()
      end
    end
  end
  self.recordLineList = nil
  if not self.active then
    self:PrintRealInfoLog("inactive Destroy battle logic")
    return
  end
  self:PrintRealInfoLog("Destroy battle logic")
  self.active = false
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if self.camTween then
    self.camTween:Kill()
  end
  self.camTween = nil
  self.camera = nil
  self.touchCamera = nil
  if self.cheers then
    Logger.Log("\232\183\145\233\133\183 cheer\229\135\160\228\184\170" .. tostring(#self.cheers))
    for i, v in pairs(self.cheers) do
      v:Destroy()
      v:Release()
    end
    self.cheers = nil
  end
  if self.scenes then
    for _, scene in pairs(self.scenes) do
      scene:OnDestroy()
    end
    self.scenes = nil
  end
  self.curScene = nil
  self:DestroyAllProps()
  self:RemoveSceneUpdator()
  if self.player then
    self.player:Destroy()
    self.player = nil
  end
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TorchRelayBattleMain, {anim = false})
  self.mainView = nil
end

function TorchRelayBattleLogic:AddListener(msg_name, callback)
  if not self.__event_handlers then
    self.__event_handlers = {}
  end
  
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function TorchRelayBattleLogic:RemoveAllListeners()
  if not self.__event_handlers then
    return
  end
  for name, bindFunc in pairs(self.__event_handlers) do
    if bindFunc then
      EventManager:GetInstance():RemoveListener(name, bindFunc)
    end
  end
  self.__event_handlers = nil
end

function TorchRelayBattleLogic:OnUpdate()
  local dt = Time.deltaTime
  if self.gamePassedTime then
    self.gamePassedTime = self.gamePassedTime + dt
  end
  if self.tmpGamePassedTime then
    self.tmpGamePassedTime = self.tmpGamePassedTime + dt
    if self.tmpGamePassedTime >= TorchConstant.SERVER_CHECK_DURATION then
      self.tmpGamePassedTime = 0
      self:SendInGameServerCheckMsg()
    end
  end
  if self.tmpGamePassedTimePostEvent then
    self.tmpGamePassedTimePostEvent = self.tmpGamePassedTimePostEvent + dt
    if self.tmpGamePassedTimePostEvent >= TorchConstant.POST_EVENT_DURATION then
      self.tmpGamePassedTimePostEvent = 0
      self:SendInGamePostEvent()
    end
  end
  if self.fsm then
    self.fsm:Update(dt)
  end
  if self.touchCamera then
    local tarPos = self.touchCamera:GetCameraTargetPos()
    local viewTile = SceneUtils.WorldToTile(tarPos)
    if self.staticMgr ~= nil then
      self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
  end
  if self.fingerDown then
    self:OnFingerHold()
  end
  self:UpdateCurScene()
  if self.player then
    self.player:OnUpdate(dt)
  end
  self:UpdateMainUI()
  self:UpdateMilestoneRewardUI()
  self:CheckGameState()
  if self.scenes then
    for _, scene in pairs(self.scenes) do
      scene:OnUpdate(dt)
    end
  end
  if self.cheers then
    for i, v in pairs(self.cheers) do
      v:OnUpdate(dt)
    end
  end
  self:SyncCamera()
end

function TorchRelayBattleLogic:ChangeState(targetState, callback)
  if self.curState == targetState then
    return
  end
  Logger.Log("\232\183\145\233\133\183 ChangeState:" .. tostring(targetState))
  self.fsm:Switch(targetState, callback)
  self.curState = targetState
end

function TorchRelayBattleLogic:LoadScene(callBack)
  self:ChangeState(self.State.Load, function()
    if callBack ~= nil then
      callBack()
    end
    self:AddSceneUpdator()
  end)
end

function TorchRelayBattleLogic:InitCamera()
  self:ChangeState(self.State.Init)
end

function TorchRelayBattleLogic:OnStartGame()
  if self.battleMgr then
    self.battleMgr:SetGameStart(true)
  end
  self:RemoveSceneUpdator()
  self:ChangeState(self.State.Play)
end

function TorchRelayBattleLogic:CheckGameState()
  if self.battleMgr and self.battleMgr.gameStart and self.player and self.data then
    local curStamina = self.player:GetStamina()
    local maxStamina = self.data:GetInitStamina()
    if self.mainView then
      local showRed = 0 < maxStamina and curStamina / maxStamina <= TorchConstant.STAMINA_RED_EFFECT__PERCENT
      self.mainView:UpdateRedEffect(showRed)
    end
    if curStamina <= 0 then
      self:OnStaminaOver()
    end
  end
end

function TorchRelayBattleLogic:OnStaminaOver()
  self:PrintRealInfoLog("Stamina over")
  if not self.battleMgr then
    return
  end
  if not self.player then
    return
  end
  if not self.data then
    return
  end
  if not self.curScene then
    return
  end
  self.battleMgr:SetGameOver(true)
  self.player:RemoveAllBuff()
  self.player:HideHpBar()
  local score = self.player:GetScore()
  local passedSceneCount = self.curScene.sceneData.index
  local contentObj = CS.Sfs2X.Entities.Data.SFSObject()
  contentObj:PutInt("score", math.ceil(score))
  contentObj:PutInt("sceneCount", passedSceneCount)
  local contentArray = CS.Sfs2X.Entities.Data.SFSArray()
  if self.finishIntervalData then
    for i, v in pairs(self.finishIntervalData) do
      local obj = CS.Sfs2X.Entities.Data.SFSObject()
      obj:PutInt("intervalTime", math.floor(v.intervalTime))
      obj:PutInt("intervalScore", math.floor(v.intervalScore))
      contentArray:AddSFSObject(obj)
    end
  end
  contentObj:PutSFSArray("intervals", contentArray)
  self:PrintEditorLog("\231\187\147\231\174\151\229\138\160\229\175\134\229\137\141content", contentObj:ToJson())
  local byteArray = contentObj:ToBinary()
  local encodedStr = CS.System.Convert.ToBase64String(byteArray.Bytes)
  if self.activityId then
    DataCenter.ActivityTorchRelayManager:SendFinishGameMsg(self.activityId, encodedStr)
  end
  self:ChangeState(self.State.Finish)
end

function TorchRelayBattleLogic:AfterExit()
end

function TorchRelayBattleLogic:LoadSceneByCount(loadCount, callback)
  local function GetLastSceneData()
    local z = 0
    
    local res
    if self.scenes ~= nil then
      for i, v in pairs(self.scenes) do
        if v.sceneData ~= nil and z < v.sceneData.endZ then
          res = v.sceneData
        end
      end
    end
    return res
  end
  
  if not self.data then
    return
  end
  if self.sceneCount + 1 > TorchConstant.MAX_LOAD_SCENE_COUNT then
    if self.battleMgr then
      self.battleMgr:Exit(nil, "quit")
    end
    local curStamina = -1
    if self.player then
      curStamina = self.player:GetStamina()
    end
    self:PrintRealInfoLog("wrong!!! over max scene count, stamina: " .. tostring(curStamina))
    return
  end
  local sceneConfigs = self.data:GetSceneConfigs(self.sceneCount + 1, loadCount)
  local finishedScene = 0
  for i, sceneCfg in ipairs(sceneConfigs) do
    local lastData = GetLastSceneData()
    local lastZ = 0
    local lastIndex = 0
    if lastData ~= nil then
      lastZ = lastData.endZ
      lastIndex = lastData.index
    end
    local data = {}
    data.config = sceneCfg
    data.startZ = lastZ
    data.endZ = lastZ + sceneCfg.sizeZ
    data.index = lastIndex + 1
    local scene = Scene.New(data, self)
    scene:OnLoad(function()
      finishedScene = finishedScene + 1
      if finishedScene >= #sceneConfigs and callback then
        callback()
      end
      local evtData = {scene = scene}
      EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayBattleSceneAssetLoaded, evtData)
    end)
    table.insert(self.scenes, scene)
    self.sceneCount = self.sceneCount + 1
  end
end

function TorchRelayBattleLogic:GetSceneByIndex(sceneIndex)
  if self.scenes then
    for i, v in pairs(self.scenes) do
      if v and v.sceneData and v.sceneData.index == sceneIndex then
        return v
      end
    end
  end
end

function TorchRelayBattleLogic:SceneUpdate()
  if not self.touchCamera then
    return
  end
  if self.battleMgr.gameStart then
    return
  end
  if self.touchCamera then
    local tarPos = self.touchCamera:GetCameraTargetPos()
    local viewTile = SceneUtils.WorldToTile(tarPos)
    if self.staticMgr ~= nil then
      self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
  end
end

function TorchRelayBattleLogic:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function TorchRelayBattleLogic:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function TorchRelayBattleLogic:UpdateCurScene()
  if self.player ~= nil and self.scenes ~= nil and self.data ~= nil then
    local curZ = self.player:GetPosition().z
    if self.curScene ~= nil and self.curScene:IsContainsZ(curZ) then
      return
    end
    local newScene
    for i, v in pairs(self.scenes) do
      if v:IsContainsZ(curZ) then
        newScene = v
      end
    end
    if newScene then
      newScene.startTime = socket.gettime() * 1000
      local preSceneData
      local curSceneData = newScene.sceneData
      if self.curScene then
        local preScene = self.curScene:GetPreviousScene()
        if preScene then
          preScene:OnDestroy()
        end
        preSceneData = self.curScene.sceneData
        self:LoadSceneByCount(1)
        if self.serverCheckIntervalData == nil then
          self.serverCheckIntervalData = {}
        end
        if self.finishIntervalData == nil then
          self.finishIntervalData = {}
        end
        local intervalData = {
          intervalTime = newScene.startTime - self.curScene.startTime,
          intervalScore = self.curScene.sceneData.config.sizeZ
        }
        Logger.Log("\232\183\145\233\133\183\230\151\182\233\151\180\239\188\154" .. tostring(newScene.startTime - self.curScene.startTime))
        table.insert(self.serverCheckIntervalData, intervalData)
        table.insert(self.finishIntervalData, intervalData)
      end
      local evtData = {preSceneData = preSceneData, curSceneData = curSceneData}
      EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayBattleCurSceneChange, evtData)
    end
    self.curScene = newScene
  end
end

function TorchRelayBattleLogic:OnFingerDown(pos)
  if not self.fsm.currState or not self.fsm.currState.canInput then
    return
  end
  if not self.battleMgr.gameStart or self.battleMgr.gamePause or self.battleMgr.gameOver then
    return
  end
  self.fingerDown = true
  local ray = self.touchCamera:ScreenPointToRay(pos)
  local plane = Plane.New(Vector3.up, 0)
  local hit, dis = plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  self.lastFingerPosX = hitPoint.x
end

function TorchRelayBattleLogic:OnFingerUp()
  self.fingerDown = false
end

function TorchRelayBattleLogic:OnFingerHold()
  if not self.fingerDown then
    return
  end
  if not self.fsm or not self.battleMgr then
    return
  end
  if not self.fsm.currState or not self.fsm.currState.canInput then
    return
  end
  if not self.battleMgr.gameStart or self.battleMgr.gamePause or self.battleMgr.gameOver then
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
  local curPos = self.player:GetPosition()
  local nowX = curPos.x
  local ray = self.touchCamera:ScreenPointToRay(pos)
  local plane = Plane.New(Vector3.up, 0)
  local hit, dis = plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  local delta = hitPoint.x - self.lastFingerPosX
  if math.abs(delta) < TorchConstant.DISPLACE_EPSILON then
    if self.hasHorizonMove then
      self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Idle)
    end
    self.hasHorizonMove = false
    return
  end
  self.hasHorizonMove = true
  local clamp = self:ClampMoveX(nowX + delta * TorchConstant.PLAYER_HORIZONTAL_MOVE_DISTANCE_PER_SECOND)
  self.lastFingerPosX = hitPoint.x
  self.player:SetPosition(clamp, curPos.z)
  if self.inGamePostEventDataCache == nil then
    self.inGamePostEventDataCache = {toRight = 0, toLeft = 0}
  end
  if 0 < delta then
    self.inGamePostEventDataCache.toRight = self.inGamePostEventDataCache.toRight + 1
    self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Right)
  else
    self.inGamePostEventDataCache.toLeft = self.inGamePostEventDataCache.toLeft + 1
    self.player:ChangeHorizontalMoveState(self.player.HorizontalMoveState.Left)
  end
end

function TorchRelayBattleLogic:SendInGamePostEvent()
  local postEventData = {toRight = 0, toLeft = 0}
  if self.inGamePostEventDataCache ~= nil then
    postEventData = {
      toRight = self.inGamePostEventDataCache.toRight,
      toLeft = self.inGamePostEventDataCache.toLeft
    }
  end
  PostEventLog.Track(PostEventLog.Defines.ActivityTorchRelayInGameControl, postEventData)
  self.inGamePostEventDataCache = nil
end

function TorchRelayBattleLogic:ClampMoveX(x)
  return Mathf.Clamp(x, 31, 41)
end

TorchRelayBattleLogic.velocity = Vector3.unity_vector3(0, 0, 0)
TorchRelayBattleLogic.smoothTime = 0.3
TorchRelayBattleLogic.tmpV1 = Vector3.New(0, 0, 0)
TorchRelayBattleLogic.tmpV2 = Vector3.New(0, 0, 0)
TorchRelayBattleLogic.tmpV3 = Vector3.New(0, 0, 1)

function TorchRelayBattleLogic:SyncCamera()
  if not self.staticMgr or not self.player then
    return
  end
  local v1 = self.battleMgr:GetFollowCameraTarget()
  self.tmpV1:Set(v1.x, v1.y, v1.z)
  self.tmpV2:Set(TorchConstant.SCENE_CENTER_X + TorchConstant.CAMERA_OFFSET.x, 0 + TorchConstant.CAMERA_OFFSET.y, self.player:GetPosition().z + TorchConstant.CAMERA_OFFSET.z)
  self.tmpV2.x = self.tmpV2.x + self.tmpV3.x * 0.3
  self.tmpV2.y = self.tmpV2.y + self.tmpV3.y * 0.3
  self.tmpV2.z = self.tmpV2.z + self.tmpV3.z * 0.3
  local distance = true
  if math.abs(self.tmpV1.x - self.tmpV2.x) < 0.01 and math.abs(self.tmpV1.y - self.tmpV2.y) < 0.01 and math.abs(self.tmpV1.z - self.tmpV2.z) < 0.01 then
    distance = false
    self.velocity.x, self.velocity.y, self.velocity.z = 0, 0, 0
  end
  if distance then
    local targetPos, v = Vector3.SmoothDamp(v1, self.tmpV2, self.velocity, self.smoothTime)
    self.velocity = v
    self.battleMgr:CameraFollowLookAt(targetPos)
  end
end

function TorchRelayBattleLogic:UpdateMainUI()
  if self.player and self.data then
    local curStamina = self.player:GetStamina()
    local totalStamina = self.data:GetInitStamina()
    if self.mainView == nil then
      local window = UIManager:GetInstance():GetWindow(UIWindowNames.TorchRelayBattleMain)
      if window then
        self.mainView = window.View
      end
    end
    if self.mainView == nil then
      return
    end
    local score = self.player:GetScore()
    local scoreDisplay = math.ceil(score * self.data:GetScoreCoefficient())
    self.mainView:SetStaminaSliderValue(curStamina, totalStamina)
    self.mainView:SetScoreText(scoreDisplay)
    self.player:WalkBuffStateData(function(state, buffData)
      if buffData.durationEnd and buffData.durationEnd >= Time.time then
        local residueTime = buffData.durationEnd - Time.time
        self.mainView:UpdateBuffResidueTime(state, residueTime, buffData.duration)
      end
    end)
  end
end

function TorchRelayBattleLogic:UpdateMainUI_SpeedPower(curPower, addSpeedShowValue)
  if not self.player or not self.data then
    return
  end
  if self.mainView == nil then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.TorchRelayBattleMain)
    if window then
      self.mainView = window.View
    end
  end
  if self.mainView then
    local totalPower = self.data.stage.speed_power_max
    self.mainView:SetSpeedPower(curPower, totalPower, addSpeedShowValue)
  end
end

function TorchRelayBattleLogic:OnStrengthAddTrigger(propsData)
  self.player:OnStrengthAddTrigger(propsData)
  self:UpdateMainUI()
end

function TorchRelayBattleLogic:OnSpeedAddTrigger(propsData)
  self.player:OnSpeedAddTrigger(propsData)
end

function TorchRelayBattleLogic:OnDefendTrigger(propsData)
  self.player:OnDefendTrigger(propsData)
  self:ShowBuffStateUI(TorchRelayBuffState.Defend, propsData)
end

function TorchRelayBattleLogic:OnAutoCollectTrigger(propsData)
  self.player:OnAutoCollectTrigger(propsData)
  self:ShowBuffStateUI(TorchRelayBuffState.AutoCollect, propsData)
end

function TorchRelayBattleLogic:OnInvincibleTrigger(propsData)
  self.player:OnInvincibleTrigger(propsData)
  self:ShowBuffStateUI(TorchRelayBuffState.Invincible, propsData)
  self:ShowInvincibleSpecialBar()
  local autoCollectPropsData = {}
  autoCollectPropsData.instanceId = TorchConstant.VIRTUAL_AUTO_COLLECT_PROPS_INSTANCE_ID
  autoCollectPropsData.configId = TorchConstant.VIRTUAL_AUTO_COLLECT_PROPS_CONFIG_ID
  autoCollectPropsData.config = DataCenter.TorchRelayTemplateManager:GetStageItemTemplate(autoCollectPropsData.configId)
  autoCollectPropsData.duration = autoCollectPropsData.config.para1
  autoCollectPropsData.bound = {
    minX = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MIN_X,
    maxX = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MAX_X,
    minZ = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MIN_Z,
    maxY = TorchConstant.PROPS_AUTO_COLLECT_BOUND_MAX_Y,
    maxZ = autoCollectPropsData.config.para2
  }
  self:OnAutoCollectTrigger(autoCollectPropsData)
end

function TorchRelayBattleLogic:OnObstaclesTrigger(propsData)
  if self.player:OnObstaclesTrigger(propsData) then
    self:UpdateMainUI()
  end
  if self.battleMgr then
    self.battleMgr:DoVibration(TorchConstant.RUNNING_MAN_OBSTACLES_VIBRATION_INTENSITY, TorchConstant.RUNNING_MAN_OBSTACLES_VIBRATION_SHARPNESS, TorchConstant.RUNNING_MAN_OBSTACLES_VIBRATION_DURATION)
  end
end

function TorchRelayBattleLogic:ShowBuffStateUI(buffState, propsData)
  self.resConfig = DataCenter.TorchRelayTemplateManager:GetStageResourceTemplate(propsData.config.resource_id)
  local buffData = {}
  buffData.state = buffState
  buffData.iconPath = self.resConfig.buff_pic
  if self.mainView then
    self.mainView:ShowBuff(buffData)
  end
end

function TorchRelayBattleLogic:ShowInvincibleSpecialBar()
  if self.mainView then
    self.mainView:ShowInvincibleSpecialBar()
  end
end

function TorchRelayBattleLogic:HideBuffStateUI(buffState)
  self.mainView:HideBuff(buffState)
end

function TorchRelayBattleLogic:SendInGameServerCheckMsg()
  if not self.player then
    return
  end
  if not self.data then
    return
  end
  if not self.curScene then
    return
  end
  local score = self.player:GetScore()
  local passedSceneCount = self.curScene.sceneData.index
  local contentObj = CS.Sfs2X.Entities.Data.SFSObject()
  contentObj:PutInt("score", math.floor(score))
  contentObj:PutInt("sceneCount", passedSceneCount)
  local contentArray = CS.Sfs2X.Entities.Data.SFSArray()
  if self.serverCheckIntervalData then
    for i, v in pairs(self.serverCheckIntervalData) do
      local obj = CS.Sfs2X.Entities.Data.SFSObject()
      obj:PutInt("intervalTime", math.floor(v.intervalTime))
      obj:PutInt("intervalScore", math.floor(v.intervalScore))
      contentArray:AddSFSObject(obj)
    end
  end
  contentObj:PutSFSArray("intervals", contentArray)
  local byteArray = contentObj:ToBinary()
  if CS.SDKManager.IS_UNITY_EDITOR() then
    Logger.Log("TorchRelay Log: " .. tostring(contentObj:ToJson()))
  end
  local encodedStr = CS.System.Convert.ToBase64String(byteArray.Bytes)
  if self.activityId then
    DataCenter.ActivityTorchRelayManager:SendInGameServerCheckMsg(self.activityId, encodedStr)
  end
  self.serverCheckIntervalData = nil
end

function TorchRelayBattleLogic:InitCheer()
  self.cheers = {}
  if self.param == nil or self.param.userData == nil or self.param.userData.cheerData == nil then
    return
  end
  if self.activityId then
    local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if actData then
      local growUpSpeedLevel = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed)
      local growUpSpeedTemplate = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed, growUpSpeedLevel)
      if growUpSpeedTemplate then
        local sceneIndexList = growUpSpeedTemplate:GetCheerIndexList()
        local sceneIndexes = {}
        
        local function GetSceneIndex(isRare)
          local res = sceneIndexList[1]
          if isRare then
            res = sceneIndexList[2]
          end
          if res then
            local isAlreadyContains = false
            for i, v in pairs(sceneIndexes) do
              if v == res then
                isAlreadyContains = true
                break
              end
            end
            if isAlreadyContains then
              if isRare then
                res = sceneIndexList[1]
              else
                res = sceneIndexList[2]
              end
            end
          end
          return res
        end
        
        for i, v in pairs(self.param.userData.cheerData) do
          if v.cheerId ~= nil then
            local line = LocalController:instance():getLine(TableName.Activity_Torch_Relay_Stage_Cheer, tonumber(v.cheerId))
            if line then
              local template = TorchRelayBattleStageCheerConfigTemplate.New()
              template:InitData(line)
              if template.cheer_rare == 0 then
                local sceneIndex = GetSceneIndex(false)
                if sceneIndex then
                  local cheer = TorchRelayBattleCheerNormal.New(template, sceneIndex, self, v)
                  cheer:Init()
                  table.insert(self.cheers, cheer)
                  self:PrintEditorLog("\230\153\174\233\128\154\229\138\169\229\168\129\229\135\186\231\142\176\229\156\168\231\172\172\229\135\160\228\184\170\229\156\186\230\153\175", sceneIndex)
                  table.insert(sceneIndexes, sceneIndex)
                else
                  self:PrintRealErrorLog(string.format("normal cheer init failed, line:%s", growUpSpeedTemplate.cheer_scene_position))
                end
              else
                local sceneIndex = GetSceneIndex(true)
                if sceneIndex then
                  local cheer = TorchRelayBattleCheerAdvance.New(template, sceneIndex, self, v)
                  cheer:Init()
                  table.insert(self.cheers, cheer)
                  self:PrintEditorLog("\233\171\152\231\186\167\229\138\169\229\168\129\229\135\186\231\142\176\229\156\168\231\172\172\229\135\160\228\184\170\229\156\186\230\153\175", sceneIndex)
                  table.insert(sceneIndexes, sceneIndex)
                else
                  self:PrintRealErrorLog(string.format("advance cheer init failed, line:%s", growUpSpeedTemplate.cheer_scene_position))
                end
              end
            end
          end
        end
      end
    end
  end
end

function TorchRelayBattleLogic:InitRecordLine()
  local function _bornLine(score, effectRes, effectDescKey)
    if effectRes == nil or effectDescKey == nil then
      return nil
    end
    if not score or score <= 0 then
      return nil
    end
    local bornPos = self.data:GetPlayerBirthPos()
    local posZ = score / self.data:GetScoreCoefficient() + bornPos.z
    local pos = Vector3.New(TorchConstant.SCENE_CENTER_X, 0.1, posZ)
    local line = TorchRelayBattleRecordLine.New()
    local serverRecordDesc = CS.GameEntry.Localization:GetString(effectDescKey, score)
    line:Load(pos, effectRes, serverRecordDesc)
    return line
  end
  
  local actData = self.data:GetActivityData()
  self.recordLineList = {}
  table.insert(self.recordLineList, _bornLine(actData.serverScoreRecord, self.data.stage.effectLine_server_res, self.data.stage.effectLine_server_key))
  table.insert(self.recordLineList, _bornLine(actData.selfScoreRecord, self.data.stage.effectLine_self_res, self.data.stage.effectLine_self_key))
  if self.data.stage.lineScoreList then
    for i, v in ipairs(self.data.stage.lineScoreList) do
      table.insert(self.recordLineList, _bornLine(v, self.data.stage.effectLine_m_res, self.data.stage.effectLine_m_key))
    end
  end
end

function TorchRelayBattleLogic:TryConvertSceneIndexToCheerTemplate(sceneIndex)
  if self.cheers then
    for i, v in pairs(self.cheers) do
      if v:GetRare() == 1 and v:GetSceneIndex() == sceneIndex then
        return v:GetTemplate()
      end
    end
  end
end

function TorchRelayBattleLogic:UpdateMilestoneRewardUI()
  local function GetNext(curScore, dict)
    for i, v in pairs(dict) do
      if curScore >= v.startScore and curScore < v.endScore then
        return v
      end
    end
  end
  
  if self.mileStoneRewardDataDict == nil then
    self.mileStoneRewardDataDict = {}
    if self.activityId then
      local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
      if data and data.config then
        self.mileStoneRewardDataDict = data.config:GetInGameMileStoneRewardDict()
      end
    end
  end
  if self.player and self.data then
    local curScore = self.player:GetScore()
    local curData = GetNext(curScore, self.mileStoneRewardDataDict)
    if curData ~= nil then
      local fillAmount = (curScore - curData.startScore) / (curData.endScore - curData.startScore)
      if self.mainView then
        self.mainView:UpdateRewardBoxProgress(fillAmount)
        self.mainView:UpdateRewardBoxNextValue(math.ceil(curData.endScore * self.data:GetScoreCoefficient()))
      end
    elseif self.mainView then
      self.mainView:UpdateRewardBoxMaxed()
    end
    if self.curMileStoneRewardData ~= nil and (curData == nil or self.curMileStoneRewardData.endScore ~= curData.endScore) and self.mainView then
      self.mainView:ShowRewardBoxClaimed()
    end
    self.curMileStoneRewardData = curData
  end
end

function TorchRelayBattleLogic:DestroyAllProps()
  if self.scenePropsPool then
    self.scenePropsPool:Delete()
    self.scenePropsPool = nil
  end
end

function TorchRelayBattleLogic:ShowMainUIWin()
  if self.mainView then
    self.mainView:OnWinGame()
  end
end

function TorchRelayBattleLogic:OnFinishSuccess(msg)
  self:PrintRealInfoLog("finish msg callback")
  if msg then
    self.finishMessageCache = msg
    self:TryShowFinalResult()
  end
end

function TorchRelayBattleLogic:TryShowFinalResult()
  if self.finishMessageCache and self.isFinishAnimationOver then
    if self.mainView then
      self.mainView:OnShowFinalResult()
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.TorchRelayBattleWin, {anim = false, playEffect = 10024}, self.finishMessageCache)
  end
end

function TorchRelayBattleLogic:PrintEditorLog(key, value)
  if not CS.SDKManager.IS_UNITY_EDITOR() then
    return
  end
  if string.IsNullOrEmpty(key) then
    CS.UnityEngine.Debug.LogError(string.format("\232\183\145\233\133\183Log\230\151\165\229\191\151: [%s]", tostring(value)))
  else
    CS.UnityEngine.Debug.LogError(string.format("\232\183\145\233\133\183Log\230\151\165\229\191\151: [%s], [%s]", tostring(key), tostring(value)))
  end
end

function TorchRelayBattleLogic:PrintRealErrorLog(msg)
  local str = tostring(msg)
  if not string.IsNullOrEmpty(str) then
    Logger.LogError(string.format("Torch Relay Battle Log Error: %s", str))
  end
end

function TorchRelayBattleLogic:PrintRealInfoLog(msg)
  local str = tostring(msg)
  if not string.IsNullOrEmpty(str) then
    Logger.LogInfo(string.format("Torch Relay Battle Log Info: %s", str))
  end
end

return TorchRelayBattleLogic
