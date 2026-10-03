local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local rvoObstaclePath = "Assets/Main/Prefabs/PVELevel/%s/obstacle.bytes"
local PVEResConfigPath = "Assets/Main/Prefabs/PVELevel/%s/res_config.json"
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Const = require("Scene.LWBattle.Const")
local CollectionManager = require("Scene.PVEBattleLevel.CollectionManager")
local BarrageTriggerItem = require("Scene.LWBattle.BarrageBattle.TriggerItem.BarrageTriggerItem")
local TriggerPlot = require("Scene.LWBattle.BarrageBattle.TriggerItem.TriggerPlot")
local LWWayPoint = require("Scene.LWBattle.LWWayPoint")
local PveLevelTemplate = require("DataCenter.PveLevel.PveLevelTemplate")
local Squad = require("Scene.LWBattle.BarrageBattle.Squad")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local Physics = CS.UnityEngine.Physics
local Localization = CS.GameEntry.Localization
local Zombie = require("Scene.LWBattle.BarrageBattle.Unit.Zombie")
local Boss = require("Scene.LWBattle.BarrageBattle.Unit.Boss")
local Pet = require("Scene.LWBattle.BarrageBattle.Unit.Pet")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local FixPointSummonZombieTask = require("Scene.LWBattle.Scene.FixPointSummonZombieTask")
local SummonPetTask = require("Scene.LWBattle.Scene.SummonPetTask")
local ZombiePointManager = require("DataCenter.ZombieBattle.ZombiePointManager")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local TreasureBoxAsset = "Assets/Main/Prefabs/LWBattle/BaoXiang.prefab"
local TreasureBoxOpenEffectAsset = "Assets/Main/Prefabs/LWBattle/BaoXiang_OpenEffect.prefab"
local Time = _ENV.Time
local FPS_SAMPLE_CD = 10
local ZombieBattleManager = BaseClass("ZombieBattleManager")
local LevelState = {
  Init = 0,
  RequestInfo = 1,
  Created = 2,
  Destroying = 3,
  Destroyed = 4
}

local function GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function ZombieBattleManager:__init()
  self.nextObjId = 1
  self.sceneObjs = {}
  self.levelState = LevelState.Init
  
  function self.cameraAfterUpdate()
    self:ClampCamera()
  end
  
  self.collectionMgr = CollectionManager.New()
  self.zombiePointMgr = ZombiePointManager.New()
  self.damageTextMgr = DamageTextManager.New()
  self.followCameraTarget = Vector3.zero
  self.wayPoint = {}
  self.nextWayPoint = nil
  self.nextWayPointOrder = 0
  self.triggerItems = {}
  self.triggerPlots = {}
  self.squad = nil
  self.buff = {}
  self.squadCreateFinish = nil
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.gamePause = false
  self.gameOver = false
  self.timeStopDuration = 0
  self.cacheZoomParam = 0
  self.delayEvents = {}
  self.exitFlag = nil
end

function ZombieBattleManager:__delete()
  self:Destroy()
end

function ZombieBattleManager:Destroy(exceptScene)
  EventManager:GetInstance():Broadcast(EventId.ZombieBattleDestroy)
  self:UnInitCamera()
  self:RemoveListeners()
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  if self.triggerItems then
    for _, items in pairs(self.triggerItems) do
      for _, inner in pairs(items) do
        inner:Destroy()
      end
    end
    self.triggerItems = nil
  end
  if self.triggerPlots then
    for _, triggerPlot in pairs(self.triggerPlots) do
      triggerPlot:Destroy()
    end
    self.triggerPlots = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
  end
  if self.squad then
    self.squad:Delete()
    self.squad = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
  end
  self.cameraAfterUpdate = nil
  self.sceneObjs = nil
  if not exceptScene and self.levelInst then
    self.levelInst:Destroy()
    self.levelInst = nil
  end
  if self.cityPrefabAsset then
    self.cityPrefabAsset:Release()
    self.cityPrefabAsset = nil
  end
  self:RemoveUpdateTimer()
  self:RemoveSceneUpdator()
  if self.collectionMgr ~= nil then
    self.collectionMgr:Delete()
  end
  if self.zombiePointMgr ~= nil then
    self.zombiePointMgr:Destroy()
  end
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Destroy()
  end
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.rvoMgr then
    self.rvoMgr:Destory()
    self.rvoMgr = nil
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
  end
  self.sceneLoadRequest = nil
  self.sceneObjs = nil
  self.pveTemplate = nil
  self.levelState = LevelState.Destroyed
  self.wayPoint = nil
  self.nextWayPoint = nil
  self.buff = nil
  self.squadCreateFinish = nil
  if self.cameraTween then
    self.cameraTween:Kill()
    self.cameraTween = nil
  end
  self.genZombieTask = nil
  if self.waypointTreasureBoxReq then
    self.waypointTreasureBoxReq:Destroy()
    self.waypointTreasureBoxReq = nil
    self.waypointTreasureBoxAnim = nil
  end
  self.monsterRectPosition = nil
  self.monsterRectSize = nil
  self.timeStopDuration = 0
  self.cacheZoomParam = 0
  self.shouldStartBatle = false
  self.heroStatisticalData = nil
  self.weaponStatisticalData = nil
  self.exitFlag = nil
  if self.openEffectTimer then
    self.openEffectTimer:Stop()
    self.openEffectTimer = nil
  end
end

function ZombieBattleManager:AddUpdateTimer()
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

function ZombieBattleManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function ZombieBattleManager:OnUpdate()
  if self.gamePause then
    return
  end
  if self.gameOver then
    self.unitMgr:RemoveAllUnitByType(UnitType.Zombie)
    return
  end
  self.effectObjMgr:OnUpdate()
  self.bulletManager:OnUpdate()
  self.damageTextMgr:OnUpdate()
  if self.camera ~= nil then
    local camTrans = self.camera.transform
    if camTrans ~= nil then
      local cameraRot = camTrans.rotation
      if cameraRot ~= self.cameraRot then
        self.cameraRot = cameraRot
        self:RefreshCameraRotation()
      end
    end
  end
  local tarPos = self.touchCamera:GetCameraTargetPos()
  local viewTile = SceneUtils.WorldToTile(tarPos)
  if self.staticMgr ~= nil then
    self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
  end
  self.collectionMgr:OnUpdate(viewTile.x, viewTile.y)
  self.unitMgr:OnUpdate()
  if self.timeStopDuration > 0 then
    self.timeStopDuration = self.timeStopDuration - Time.deltaTime
    if self.timeStopDuration <= 0 then
      self:EndTimeStop()
    end
  else
    self:TickGenZombieTask()
    if self.isFingerDown and self.squad ~= nil and self.joystick ~= nil then
      local vx, vz = self.joystick:OnUpdate()
      self.squad:OnFingerHold(vx, vz)
    end
    if self.squad then
      local playerPos = self.squad:GetPosition()
      if self.rvoMgr ~= nil then
        self.rvoMgr:Update(playerPos.x, playerPos.z)
      end
      self.squad:OnUpdate()
    end
    if PVE_TEST_MODE then
      if not self.monsterRectPosition or self.monsterRectPosition ~= self.bulletMotionEditor.Rectangle.position or self.monsterRectSize ~= self.bulletMotionEditor.Rectangle.size then
        self.monsterRectPosition = self.bulletMotionEditor.Rectangle.position
        self.monsterRectSize = self.bulletMotionEditor.Rectangle.size
        self.unitMgr:RemoveAllUnitByType(UnitType.Zombie)
        for i = self.monsterRectPosition.x, self.monsterRectPosition.x + self.monsterRectSize.x do
          for j = self.monsterRectPosition.y, self.monsterRectPosition.y + self.monsterRectSize.y do
            self:CreateMonster(100001, Vector3.New(i, 0, j))
          end
        end
      end
    else
      self.zombiePointMgr:OnUpdate(tarPos.x, tarPos.z)
    end
  end
end

function ZombieBattleManager:OnUpdateSec()
  if self.gameOver or self.gamePause then
    return
  end
  self.useTime = self.useTime + 1
  local winCondition = self.pveTemplate.winCondition
  if winCondition.winType == Const.StageWinType.Time and self.uiPveMain then
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.Time)
    if self.useTime >= self.pveTemplate.winCondition.timeLimit then
      self:OnBattleWin()
    end
  end
  if winCondition.winType == Const.StageWinType.WayPoint and self.uiPveMain then
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.WayPoint)
  end
  self.sampleCd = self.sampleCd - 1
  if self.sampleCd <= 0 then
    self.sampleCd = FPS_SAMPLE_CD
    local fps = (Time.frameCount - self.sampleFrame) / FPS_SAMPLE_CD
    self.sampleFrame = Time.frameCount
    if fps < self.lowestFps then
      self.lowestFps = fps
    end
  end
end

function ZombieBattleManager:Enter(param)
  DataCenter.LWBattleManager:SetCurBattleLogic(self)
  if PVE_TEST_MODE then
    local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
    self.bulletMotionEditor = GameFramework.transform:GetOrAddComponent(typeof(CS.BulletMotionEditor))
  end
  self.buff = {}
  self.squadCreateFinish = false
  self.shouldStartBatle = false
  self.param = param
  self.levelId = param.levelId
  self.levelGroupId = param.levelGroupId
  self.enterTime = UITimeManager:GetInstance():GetServerTime()
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), self.levelId)
  if line ~= nil then
    local template = PveLevelTemplate.New()
    template:InitByLWData(line)
    self.pveTemplate = template
  end
  if self.pveTemplate == nil then
    Logger.LogError("pveLevel is not exist" .. self.levelId)
    return
  end
  
  function self.onCreateComplete()
    self:LoadSceneComplete()
  end
  
  local p = {}
  if param.enterType == PVEEnterType.StageFeatureBuilding then
    local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(param.featureId)
    local index = table.indexof(feature.stages, param.levelId)
    if 1 <= index then
      local levelTitle = ""
      if feature.winType[index] == 1 then
        levelTitle = Localization:GetString("newbies_fuben_title")
        p.rightText = Localization:GetString("newbies_fuben_coin_loading", tostring(feature.winNeedCount[index]))
      elseif feature.winType[index] == 2 then
        local curIdx = table.indexof(feature.stages, param.levelId)
        local content = Localization:GetString("newbies_fuben_title")
        levelTitle = string.format("%s %d/%d", content, curIdx, #feature.stages)
        if #feature.stages == 1 then
          p.rightText = Localization:GetString("newbies_fuben_save_loading", tostring(feature.winNeedCount[index]))
        elseif #feature.stages == 3 then
          p.rightText = Localization:GetString("newbies_fuben_battlefront_loading", tostring(feature.winNeedCount[index]))
        end
      elseif feature.winType[index] == 0 then
        if #feature.winType == 1 then
          local content = Localization:GetString("newbies_fuben_title")
          levelTitle = string.format("%s %d/%d", content, index, #feature.stages)
        elseif #feature.winType == 3 then
          if feature.caty[index] == "0" then
            local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), param.levelId, "desc")
            levelTitle = Localization:GetString(desc)
          else
            local desc = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), param.levelId, "desc")
            levelTitle = Localization:GetString(desc)
          end
        end
        p.leftText = levelTitle
        p.rightText = Localization:GetString("newbies_fuben_attack_loading")
      end
    end
  else
    p.leftText = Localization:GetString(800313, self.pveTemplate.stageMeta.level)
    p.rightText = Localization:GetString(self.pveTemplate.stageMeta.desc)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVELoading, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomHide,
    playEffect = 10004
  }, p)
  self.uiPveLoading = UIManager:GetInstance():GetWindow(UIWindowNames.UIPVELoading).View
  
  local function pveLoadingOnEnter()
    self:LogPassTime("pveLoadingOnEnter")
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
    GoToUtil.CloseAllWindows()
    self:CloseUIWindows()
    self:CreateLevel()
  end
  
  local function pveLoadingOnClosed()
    self:LogPassTime("pveLoadingOnClosed")
    local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
    if mainUIView then
      mainUIView:SetActive(false)
    end
  end
  
  self.uiPveLoading:SetOnEntered(pveLoadingOnEnter)
  self.uiPveLoading:SetOnClosed(pveLoadingOnClosed)
end

function ZombieBattleManager:Exit(ExitAction, exitType)
  DataCenter.LWSoundManager:StopAllSounds()
  if self.winTimer then
    self.winTimer:Stop()
    Time.timeScale = 1
  end
  if self:ExitAsync(ExitAction, exitType) then
    return
  end
  self:Destroy()
  DataCenter.LWBattleManager:SetCurBattleLogic()
  EventManager:GetInstance():Broadcast(EventId.GF_pve_battle_exit, {
    id = self.levelId,
    type = exitType
  })
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    self.levelState = LevelState.Destroying
    local action = ExitAction
    local onSceneCreated
    if exitType == LWStageType.DetectEvent then
      function onSceneCreated()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleMain, {anim = false})
        
        self.uiPveMain = nil
        DataCenter.WarningBallManager:AddTimer()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
        EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
        if action ~= nil then
          action()
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
        DataCenter.GuideManager:DoWaitTriggerAfterBack()
      end
      
      SceneUtils.CreateWorld()
    elseif exitType == LWStageType.TowerupAdvanture then
      function onSceneCreated()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleMain, {anim = false})
        
        self.uiPveMain = nil
        DataCenter.WarningBallManager:AddTimer()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, nil)
        EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
        DataCenter.CityNpcManager:SetNpcVisible(true)
        if action ~= nil then
          action()
        end
        DataCenter.GuideManager:DoWaitTriggerAfterBack()
      end
      
      SceneUtils.CreateCity()
    else
      function onSceneCreated()
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIZombieBattleMain, {anim = false})
        
        self.uiPveMain = nil
        DataCenter.WarningBallManager:AddTimer()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        EventManager:GetInstance():Broadcast(EventId.PveLevelExit, self.levelId)
        EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
        DataCenter.CityNpcManager:SetNpcVisible(true)
        if action ~= nil then
          action()
        end
        DataCenter.GuideManager:DoWaitTriggerAfterBack()
        if self.param and self.param.enterType and self.param.enterType == PVEEnterType.Monopoly then
          DataCenter.MonopolyManager:TryMoveCameraEnterCity()
        end
      end
      
      SceneUtils.CreateCity()
    end
    CS.SceneManager.World:CreateScene(onSceneCreated)
  end
  if self.param and self.param.enterType and self.param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnExitBattle(self.param.buildUuid)
  end
  local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
  if mainUIView then
    mainUIView:SetActive(true)
  end
end

function ZombieBattleManager:ExitAsync(ExitAction, exitType)
  local exitFlag = self.exitFlag
  self.exitFlag = nil
  if exitFlag and self.param.enterType == PVEEnterType.TowerupJeepAdventure and DataCenter.LWJeepAdventureManager:GetBackSwitchOn() and exitType == LWStageType.TowerupAdvanture then
    local action, type = ExitAction, exitType
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.ZombieBattleManager:ExitNewHandler(action, type)
      DataCenter.LWJeepAdventureManager:SetBattleBackMark(true)
      DataCenter.LWHummerSceneManager:Enter()
    end, function()
      return DataCenter.LWHummerSceneManager:CheckLoadingState()
    end)
    return true
  end
  return false
end

function ZombieBattleManager:ExitNewHandler(ExitAction, exitType)
  self:Destroy()
  DataCenter.LWBattleManager:SetCurBattleLogic()
  EventManager:GetInstance():Broadcast(EventId.GF_pve_battle_exit, {
    id = self.levelId,
    type = exitType
  })
  if not CS.SceneManager.IsInCity() and not CS.SceneManager.IsInWorld() then
    self.levelState = LevelState.Destroying
    if ExitAction ~= nil then
      ExitAction()
    end
    self.uiPveMain = nil
    EventManager:GetInstance():Broadcast(EventId.PveLevelExit, nil)
  end
end

function ZombieBattleManager:LoadSceneComplete()
  pcall(function()
    CS.SceneManager.CurrSceneID = SceneManagerSceneID.PVE
    CS.SceneManager.CurrentSceneSubType = GetEnumKey(PVEType, PVEType.Barrage)
  end)
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.PVE)
  self:LogPassTime("LoadSceneComplete")
  if self.uiPveLoading then
    self.uiPveLoading:Quit()
  end
  if self.pveTemplate.sound_id_bgm == 0 then
    Logger.LogError("\230\142\168\229\155\190\229\133\179\229\141\161bgm\228\184\186\231\169\186\239\188\140levelId=" .. self.levelId)
  else
    CommonUtil.ClearGameBgMusicData()
    DataCenter.LWSoundManager:PlayMusicById(self.pveTemplate.sound_id_bgm, true)
  end
  EventManager:GetInstance():Broadcast(EventId.PveLevelEnter, self.levelId)
end

function ZombieBattleManager:CreateLevel()
  self:LogPassTime("CreateLevel")
  DataCenter.BuildBubbleManager:ClearAll()
  DataCenter.WorldBuildBubbleManager:ClearAll()
  DataCenter.RoadBubbleManager:ClearAll()
  DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
  DataCenter.SurpriseBuildingTipManager:RemoveAllSurpriseBuildingTip()
  DataCenter.WarningBallManager:DeleteTimer()
  DataCenter.WorldFavoDataManager:ClearAll()
  self.nextObjId = 1
  self.spawnPos = nil
  self.sceneObjs = {}
  self.wayPoint = {}
  self.genZombieTask = nil
  self.killNum = 0
  self.killTargetNum = 0
  self.killBossNum = 0
  self.boss = nil
  self.startTime = Time.time
  self.useTime = 0
  self.startFrame = Time.frameCount
  self.sampleCd = FPS_SAMPLE_CD
  self.sampleFrame = Time.frameCount
  self.lowestFps = 999
  self.gameOver = false
  self.gamePause = false
  self:ReleaseCity()
  self:LoadScene()
  self:ChangeState(BarrageState.Push)
  self:CreateSquad()
  self:InitCamera()
  self:SetGamePause(true)
  self:AddUpdateTimer()
  self.levelState = LevelState.Created
  self:AddListeners()
end

function ZombieBattleManager:AddListeners()
  if self.onBuffChange == nil then
    function self.onBuffChange(buffId)
      self:OnBuffChange(buffId)
    end
    
    EventManager:GetInstance():AddListener(EventId.LWBattleBuffStart, self.onBuffChange)
    EventManager:GetInstance():AddListener(EventId.LWBattleBuffEnd, self.onBuffChange)
    if self.param.enterType == PVEEnterType.StageFeatureBuilding then
      function self.onPlotGroupDone(id)
        self:OnPlotGroupDone(id)
      end
      
      EventManager:GetInstance():AddListener(EventId.PlotGroupDone, self.onPlotGroupDone)
    end
  end
  if self.onKeyCodeEscape == nil then
    function self.onKeyCodeEscape()
      self:OnKeyCodeEscape()
    end
    
    EventManager:GetInstance():AddListener(EventId.OnKeyCodeEscape, self.onKeyCodeEscape)
  end
end

function ZombieBattleManager:RemoveListeners()
  if self.onBuffChange ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.LWBattleBuffStart, self.onBuffChange)
    EventManager:GetInstance():RemoveListener(EventId.LWBattleBuffEnd, self.onBuffChange)
    if self.param.enterType == PVEEnterType.StageFeatureBuilding then
      EventManager:GetInstance():RemoveListener(EventId.PlotGroupDone, self.onPlotGroupDone)
      self.onPlotGroupDone = nil
    end
    self.onBuffChange = nil
  end
  if self.onKeyCodeEscape ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.OnKeyCodeEscape, self.onKeyCodeEscape)
    self.onKeyCodeEscape = nil
  end
end

function ZombieBattleManager:LoadScene()
  if not self.pveTemplate then
    return
  end
  local sceneCfgArr = self.pveTemplate.sceneCfgArr
  self.sceneLoadRequest = {}
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(2)
  self.collectionMgr:InitLW(self)
  self.zombiePointMgr:Init(self)
  self.rvoMgr = CS.LWBattleRVOManager()
  local timeStep = 0.033
  local neighborDist = 2
  local maxNeighbors = 8
  local timeHorizon = 1
  local timeHorizonObst = 1
  local radius = 1
  local maxSpeed = 20
  self.rvoMgr:InitLW(timeStep, neighborDist, maxNeighbors, timeHorizon, timeHorizonObst, radius, maxSpeed)
  self.damageTextMgr:Init(self)
  self.finishedScene = 0
  self.onLoadCompleteEvent = {}
  for _, sceneCfg in ipairs(sceneCfgArr) do
    local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneCfg.meta.asset), ObjectPoolTag.BattleScene)
    req:completed("+", function()
      local sceneRoot = req.gameObject.transform
      sceneRoot:Set_position(0, 0, sceneCfg.offset)
      self.finishedScene = self.finishedScene + 1
      if self.finishedScene >= #self.pveTemplate.sceneCfgArr and self.onCreateComplete then
        self.onCreateComplete()
        self.onCreateComplete = nil
      end
    end)
    table.insert(self.sceneLoadRequest, req)
    self.staticMgr:Append(string.format(PVEDecorationPath, sceneCfg.meta.asset), sceneCfg.offset)
    if sceneCfg.isDeco == false then
      self.collectionMgr:AppendConfig(string.format(PVEResConfigPath, sceneCfg.meta.asset), sceneCfg.offset, sceneCfg.meta)
      self.rvoMgr:Append(string.format(rvoObstaclePath, sceneCfg.meta.asset), sceneCfg.offset)
      table.insert(self.onLoadCompleteEvent, function()
        self.zombiePointMgr:Append(sceneCfg.meta, sceneCfg.offset)
      end)
    end
  end
end

function ZombieBattleManager:OnKeyCodeEscape()
  if self.state == BarrageState.Push and not self.gamePause then
    self:SetGamePause(true)
    UIUtil.ShowMessage(Localization:GetString("400097"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:Exit(nil, nil)
    end, function()
      self:SetGamePause(false)
    end, function()
      self:SetGamePause(false)
    end)
  end
end

function ZombieBattleManager:ReleaseCity()
  if CS.SceneManager.IsInCity() then
    EventManager:GetInstance():Broadcast(EventId.BeforeReleaseCity)
    if self.cityPrefabAsset ~= nil then
      self.cityPrefabAsset:Release()
    end
    self.cityPrefabAsset = Resource:LoadAssetAsync(Const.CityPrefabPath, typeof(CS.UnityEngine.GameObject))
  elseif CS.SceneManager.IsInWorld() then
    EventManager:GetInstance():Broadcast(EventId.BeforeLeaveWorld)
  end
  CS.SceneManager.DestroyCurScene()
  DataCenter.LWSceneStateManager:ChangeScene(SceneType.None)
end

function ZombieBattleManager:InitCamera()
  self.cameraTween = nil
  self.camera = CS.UnityEngine.Camera.main
  self.touchCamera = self.camera:GetComponent(typeof(MobileTouchCamera))
  self.hudCamera = self.camera.transform:Find("HudCamera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.touchCamera.CanMoveing = false
  self.saveCameraParam = {}
  self.saveCameraParam.fieldOfView = self.camera.fieldOfView
  self.touchCamera.AfterUpdate = self.cameraAfterUpdate
  self:InitLevelCameraParams()
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

function ZombieBattleManager:UnInitCamera()
  self.cameraTween = nil
  if self.touchCamera then
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

function ZombieBattleManager:InitLevelCameraParams()
  local cameraParam = self:GetCameraParam()
  local height = cameraParam.height
  local fov = cameraParam.fov
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  self:SetCameraZoomParam()
end

function ZombieBattleManager:SetCameraZoomParam()
  local cameraParam = self:GetCameraParam()
  if cameraParam then
    local height = cameraParam.height
    local offsetZ = GetOffsetZ(height, cameraParam.rotation)
    self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
    self.defaultHeight = height
    self.touchCamera.CamZoomMin = height
  end
end

function ZombieBattleManager:AutoZoom(zoom)
  self.cacheZoomParam = zoom
  if self:IsPlayingShakeCamera() then
    return
  end
  if self.touchCamera ~= nil then
    self.touchCamera:AutoZoom(zoom, 0.5)
  end
end

function ZombieBattleManager:GetCameraParam()
  return self.pveTemplate.camera
end

function ZombieBattleManager:ClampCamera()
end

function ZombieBattleManager:CreateSquad()
  local objId = self:GetNextObjId()
  local squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(1)
  local allHeroes = {}
  self.heroStatisticalData = {
    makeDmg = {},
    takeDmg = {},
    death = {}
  }
  if squadData ~= nil then
    local heroes = squadData:GetAllHeroes()
    for slotIndex, heroUuid in pairs(heroes) do
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        allHeroes[slotIndex] = heroData
        self.heroStatisticalData.makeDmg[heroUuid] = 0
        self.heroStatisticalData.takeDmg[heroUuid] = 0
        self.heroStatisticalData.death[heroUuid] = false
      end
    end
  end
  local tacticalWeaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  local appearance
  if tacticalWeaponInfo then
    appearance = DataCenter.TacticalWeaponManager:GetWeaponAppearance(tacticalWeaponInfo.id)
  end
  local setId = squadData:GetLocalTWSkillChipSetId()
  local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(setId)
  self.weaponStatisticalData = {makeDmg = 0, takeDmg = 0}
  self.squad = Squad.New(self, objId, allHeroes, nil, nil, tacticalWeaponInfo, appearance, skillChips)
  self.squad:OnCreate()
end

function ZombieBattleManager:AddWayPoint(cfg, sceneMeta)
  local wayPoint = LWWayPoint.New(self, cfg, sceneMeta)
  self.wayPoint[#self.wayPoint + 1] = wayPoint
  self.finalTriggerId = self.realyFinalTriggerId
  self.finalTriggerLimit = self.realyFinalTriggerLimit
  self.realyFinalTriggerId = wayPoint.metaId
  self.realyFinalTriggerLimit = wayPoint.limit
end

function ZombieBattleManager:LoadCollectionFinish()
  for _, event in pairs(self.onLoadCompleteEvent) do
    event()
  end
  self.onLoadCompleteEvent = {}
  self.nextWayPointOrder = 1
  self.nextWayPoint = self.wayPoint[self.nextWayPointOrder]
  self.squad:InitPosition(self.nextWayPoint.pos)
  self:InitTriggerItem()
  self:InitTriggerPlot()
  self:OnGameStart()
end

function ZombieBattleManager:InitTriggerItem()
  self.triggerItems = {}
  for _, trigger in ipairs(self.pveTemplate.triggerCfgArr) do
    local wayPoint = self.wayPoint[trigger.wayPointIndex]
    local item = BarrageTriggerItem.New(self, trigger.triggerMetaId, wayPoint.pos)
    item:Load()
    if not self.triggerItems[trigger.wayPointIndex] then
      self.triggerItems[trigger.wayPointIndex] = {}
      table.insert(self.triggerItems[trigger.wayPointIndex], item)
    end
  end
end

function ZombieBattleManager:InitTriggerPlot()
  self.triggerPlots = {}
  for _, plotCfg in ipairs(self.pveTemplate.plotTriggerCfgArr) do
    local wayPoint = self.wayPoint[plotCfg.wayPointIndex]
    local triggerPlot = TriggerPlot.New(self, plotCfg, wayPoint.pos)
    if not self.triggerPlots[plotCfg.wayPointIndex] then
      self.triggerPlots[plotCfg.wayPointIndex] = triggerPlot
    end
  end
end

function ZombieBattleManager:SetSquadCreateFinishFlag(state)
  self.squadCreateFinish = state
end

function ZombieBattleManager:OnSquadCreateFinish()
  self.squadCreateFinish = true
  if self.shouldStartBatle then
    self:StartBattle()
  end
end

function ZombieBattleManager:IsFinalWayPoint()
  return self.wayPoint[self.nextWayPointOrder + 2] == nil, self.wayPoint[self.nextWayPointOrder + 1] == nil
end

function ZombieBattleManager:OnArriveWayPoint()
  if PVE_TEST_MODE then
    return
  end
  if self.nextWayPoint ~= nil then
    local logicFinal, realFinal = self:IsFinalWayPoint()
    if logicFinal and not realFinal then
      EventManager:GetInstance():Broadcast(EventId.BattleZombiesEnter)
      if self.pveTemplate.winCondition.winType == Const.StageWinType.ClearLastTrigger then
        assert(self.finalTriggerLimit > 0, "pve\229\133\179\229\141\161\233\133\141\231\189\174\233\148\153\232\175\175\239\188\154\232\131\156\229\136\169\230\157\161\228\187\1826\239\188\140\228\189\134\230\152\175\230\156\128\229\144\142\228\184\128\228\184\170\232\183\175\231\130\185\229\136\183\230\128\170\230\149\176\233\135\143\228\184\1860")
        EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.ClearLastTrigger)
      end
    end
    self.nextWayPoint:Execute()
  end
  if self.triggerItems[self.nextWayPointOrder] then
    for _, trigger in ipairs(self.triggerItems[self.nextWayPointOrder]) do
      trigger:Trigger()
    end
  end
  if self.triggerPlots[self.nextWayPointOrder] then
    self.triggerPlots[self.nextWayPointOrder]:Trigger()
  end
  self.nextWayPointOrder = self.nextWayPointOrder + 1
  self.nextWayPoint = self.wayPoint[self.nextWayPointOrder]
  self.squad:OnSetDestination(self.nextWayPoint)
  if self.nextWayPoint == nil and self.pveTemplate.winCondition.winType == Const.StageWinType.WayPoint then
    if self.waypointTreasureBoxAnim then
      local req = Resource:InstantiateAsync(TreasureBoxOpenEffectAsset, ObjectPoolTag.Battle)
      req:completed("+", function()
        local trans = req.gameObject.transform
        local finalPoint = self.wayPoint[#self.wayPoint].pos
        trans:Set_position(finalPoint.x, finalPoint.y, finalPoint.z + 5)
      end)
      self.waypointTreasureBoxAnim:Play("quickOpen")
      local destroyTimer = TimerManager:GetInstance():GetTimer(1.5, function()
        req:Destroy()
        self:OnBattleWin()
      end, nil, true, false, false)
      destroyTimer:Start()
      self:SetGamePause(true)
    else
      self:OnBattleWin()
    end
  end
end

function ZombieBattleManager:AddMonsterPoint(cfg, sceneMeta)
  self.zombiePointMgr:ConfigMonsterPoint(cfg, sceneMeta)
end

function ZombieBattleManager:AddBlockPoint(cfg, sceneMeta)
  self.zombiePointMgr:ConfigBlockPoint(cfg, sceneMeta)
end

function ZombieBattleManager:SetJoystick(joystick)
  self.joystick = joystick
end

function ZombieBattleManager:EnableJoystick()
  self.joystick:SetEnabled(true)
end

function ZombieBattleManager:DisableJoystick()
  if self.isFingerDown then
    self.isFingerDown = false
    self.joystick:Clear()
  end
  self.joystick:SetEnabled(false)
end

function ZombieBattleManager:IsFingerOnUI()
  if TouchWrapper.TouchCount > 0 then
    local touches = TouchWrapper.Touches
    local touchCount = touches.Count
    for i = 0, touchCount - 1 do
      local t = touches[i]
      if EventSystem.current:IsPointerOverGameObject(t.FingerId) then
        return true
      end
    end
  end
  return false
end

function ZombieBattleManager:OnFingerDown(pos)
  if not (self.joystick and self.joystick:GetEnabled()) or self:IsFingerOnUI() or self.isBattle or self.freeCamera then
    return
  end
  self.isFingerDown = true
  self:AutoZoom(40)
  
  local function Raycast()
    local ray = self.touchCamera:ScreenPointToRay(pos)
    local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("UIObject3D"))
    local clickOnItem = false
    if hits ~= nil then
      for i = 0, hits.Length - 1 do
        local touchObj = hits[i].collider:GetComponent(typeof(CS.UIEventTrigger))
        if touchObj ~= nil and touchObj.onPointerClick ~= nil then
          touchObj.onPointerClick()
          clickOnItem = true
        end
      end
    end
    if not clickOnItem then
      local hits = Physics.RaycastAll(ray, SceneTouchDistance, LayerMask.GetMask("Default"))
      if hits ~= nil then
        for i = 0, hits.Length - 1 do
          local hitInfo = hits[i]
          local obj = hitInfo.transform.gameObject
          if string.contains(obj.name, "Model") then
            obj = obj.parent.gameObject
          end
          local objIds = string.split(obj.name, "_")
          if objIds ~= nil and table.count(objIds) == 2 and objIds[1] == "Trigger" then
            local triggerId = toInt(objIds[2])
            local trigger = self:GetTriggerByTriggerId(triggerId)
            if trigger ~= nil then
              trigger:DoWhenClickOnTrigger()
              break
            end
          end
          local touchObj = hitInfo.collider:GetComponent(typeof(CS.UIEventTrigger))
          if touchObj ~= nil and touchObj.onPointerClick ~= nil then
            touchObj.onPointerClick()
            break
          end
        end
      end
    end
  end
  
  if pos.y < Screen.height * 0.8 then
    self.touchCamera.CanMoveing = false
    self.joystick:OnFingerDown(pos)
    self.squad:OnFingerDown(pos)
  else
    Raycast()
  end
end

function ZombieBattleManager:OnFingerUp()
  if self.isFingerDown then
    self.isFingerDown = false
    self:AutoZoom(self.defaultHeight)
    self.joystick:OnFingerUp()
    self.squad:OnFingerUp()
  end
end

function ZombieBattleManager:CloseUIWindows()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
end

function ZombieBattleManager:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function ZombieBattleManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function ZombieBattleManager:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function ZombieBattleManager:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function ZombieBattleManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function ZombieBattleManager:GetObj(id)
  return self.sceneObjs[id]
end

function ZombieBattleManager:AddObj(id, obj)
  self.sceneObjs[id] = obj
end

function ZombieBattleManager:RemoveObj(id)
  self.sceneObjs[id] = nil
end

function ZombieBattleManager:IsBeRemove(id)
  return false
end

function ZombieBattleManager:IsCarryType(resType)
  return false
end

function ZombieBattleManager:IsResourceType(resType)
  return false
end

function ZombieBattleManager:CanShowBlood()
  return false
end

function ZombieBattleManager:RemoveOneArrowById()
end

function ZombieBattleManager:RefreshCameraRotation()
  self.collectionMgr:RefreshCameraRotation(self.cameraRot)
  for k, v in pairs(self.sceneObjs) do
    if v.RefreshCameraRotation ~= nil then
      v:RefreshCameraRotation(self.cameraRot)
    end
  end
end

function ZombieBattleManager:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function ZombieBattleManager:IsSkillLevel()
  return false
end

function ZombieBattleManager:GetLevelType()
  return self.pveTemplate and PveLevelType.ZombieBattle or nil
end

local defaultShakeDur = 0.5
local defaultShakeStrength = Vector3.New(0.5, 0.5, 0)
local defaultShakeVibrato = 30
local cameraOffset = Vector3.New(0, 0, 4)

function ZombieBattleManager:ShakeCameraWithParam(param)
  if not self.touchCamera then
    return
  end
  if self.cameraTween then
    self.cameraTween:Kill()
  end
  local duration = defaultShakeDur
  local strength = defaultShakeStrength
  local vibrato = defaultShakeVibrato
  if param then
    if param.duration then
      duration = param.duration
    end
    if param.strength then
      strength = param.strength
    end
    if param.vibrato then
      vibrato = param.vibrato
    end
  end
  self.cameraTween = self.camera:DOShakePosition(duration, strength, vibrato):OnComplete(function()
    self:Lookat(self.followCameraTarget)
    self.cameraTween = nil
    if self.cacheZoomParam > 0 then
      self:AutoZoom(self.cacheZoomParam)
    end
  end)
end

function ZombieBattleManager:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function ZombieBattleManager:GetFollowCameraTarget()
  return self.followCameraTarget
end

function ZombieBattleManager:Lookat(lookWorldPosition)
  self.followCameraTarget = Vector3.New(lookWorldPosition.x, lookWorldPosition.y, lookWorldPosition.z)
  self.touchCamera:LookAt(lookWorldPosition + cameraOffset)
end

function ZombieBattleManager:CameraFollowLookat(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offset = targetPos - self.followCameraTarget
  transform:Set_position(x + offset.x, y + offset.y, z + offset.z)
  self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
end

function ZombieBattleManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function ZombieBattleManager:GetBuffEffectValueByType(buffType)
  local effect = 0
  if self.buff then
    for k, v in pairs(self.buff) do
      if v.type_buff == buffType then
        if v.time_type == PveBuffTimeType.Time then
          return v.effectValue
        end
        effect = v.effectValue
      end
    end
  end
  return effect
end

function ZombieBattleManager:GetSpeedMulti()
  return self.speedMulti or 1
end

function ZombieBattleManager:SetSpeedMulti(speedMulti)
  self.speedMulti = speedMulti
end

function ZombieBattleManager:AddGenZombieTask(task)
  if self.genZombieTask == nil then
    self.genZombieTask = {}
  end
  self.genZombieTask[task.id] = task
end

function ZombieBattleManager:RemoveGenZombieTask(task)
  if self.genZombieTask == nil then
    return
  end
  self.genZombieTask[task.id] = nil
end

function ZombieBattleManager:TickGenZombieTask()
  if self.genZombieTask == nil or table.count(self.genZombieTask) == 0 then
    return
  end
  for k, v in pairs(self.genZombieTask) do
    v:Update()
  end
end

function ZombieBattleManager:SummonMonster(pos, owner, metaId, count, hpPercent)
  if owner then
    local maxBlood = owner.maxBlood
    maxBlood = maxBlood * hpPercent
    local context = {
      maxBlood = maxBlood,
      ownerMeta = owner.meta
    }
    local task = FixPointSummonZombieTask.New(self.battleMgr, 100, pos, metaId, count, context)
    task.id = self:GetNextObjId()
    self:AddGenZombieTask(task)
  end
end

function ZombieBattleManager:CreateMonster(metaId, pos, context, triggerId)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(metaId)
  if not meta then
    Logger.LogError("\231\167\141\230\128\170\231\130\185\230\128\170\231\137\169id\228\184\186\231\169\186\230\136\150\232\128\133\230\151\160\229\174\154\228\185\137\239\188\154pointId=" .. context.pointId)
  end
  local objId = Const.ZombieIdMin + self:GetNextObjId()
  if objId > Const.ZombieIdMax then
    Logger.LogError("objId > Const.ZombieIdMax")
  end
  if meta.monster_type == Const.MonsterType.Boss then
    local boss = ObjectPool:GetInstance():Load(Boss)
    boss:Init(self, objId, meta)
    boss:Create(pos)
    self:AddUnit(boss)
  else
    local zombie = ObjectPool:GetInstance():Load(Zombie)
    zombie:Init(self, objId, meta)
    if context and context.isBlock then
      local bonus = tonumber(self.pveTemplate.stageMeta.block_hp_bonus)
      if 0 < bonus then
        zombie.hpBonus = bonus
      end
    end
    zombie:Create(pos)
    if context and context.maxBlood and context.ownerMeta then
      zombie:OverwriteEffectNum(context.maxBlood, context.ownerMeta)
    end
    zombie.spawnTriggerId = triggerId
    self:AddUnit(zombie)
    if self.pveTemplate.winCondition.winType == Const.StageWinType.ClearLastTrigger and triggerId == self.finalTriggerId then
      local spVfx = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Arms/Ewan/Eff_Ewan_chaofeng.prefab", ObjectPoolTag.Battle)
      spVfx:completed("+", function(handle)
        if handle.isError then
          return
        end
        local gameObject = handle.gameObject
        local transform = gameObject.transform
        transform.position = pos
        TimerManager:GetInstance():DelayInvoke(function()
          spVfx:Destroy()
        end, 3)
      end)
    end
  end
end

function ZombieBattleManager:SummonPet(master, metaId, count, skill)
  if master then
    local task = SummonPetTask.New(self, 100, metaId, count, master)
    task.id = self:GetNextObjId()
    self:AddGenZombieTask(task)
  end
end

function ZombieBattleManager:CreatePet(metaId, master)
  if self.squad then
    self.squad:CreatePet(metaId, master)
  end
end

function ZombieBattleManager:OnMemberDeath()
  if self.gameOver then
    return
  end
  local allDeath = true
  for k, v in pairs(self.squad.members) do
    if v:GetCurBlood() > 0 then
      allDeath = false
    elseif v.hero and v.hero.uuid then
      self.heroStatisticalData.death[v.hero.uuid] = true
    end
  end
  for k, v in pairs(self.squad.pets) do
    if v:IsBattleLostCondition() and not v:IsDead() then
      allDeath = false
    end
  end
  if not allDeath then
    return
  end
  self:OnBattleLose()
  local p = {}
  p.stageId = DataCenter.ZombieBattleManager.pveTemplate.stageMeta.id
  if self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat, {anim = true, playEffect = 10023}, self.param)
  elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
    self.param.stageId = DataCenter.ZombieBattleManager.pveTemplate.stageMeta.id
    self.param.showStatistic = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10023}, self.param)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIZombieBattleLose, {anim = false, playEffect = 10023}, p)
  end
end

function ZombieBattleManager:OnMonsterDeath(monster)
  if self.gameOver then
    return
  end
  local winCondition = self.pveTemplate.winCondition
  self.killNum = self.killNum + 1
  if winCondition.winType == Const.StageWinType.KillMonster then
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.KillMonster)
    if self.killNum >= winCondition.needKillNum then
      self:OnBattleWin()
    end
  end
  if winCondition.winType == Const.StageWinType.KillTargetMonster and monster.meta.id == winCondition.needKillTargetId then
    self.killTargetNum = self.killTargetNum + 1
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.KillTargetMonster)
    if self.killTargetNum >= winCondition.needKillNum then
      self:OnBattleWin()
    end
  end
  if winCondition.winType == Const.StageWinType.ClearLastTrigger and monster.spawnTriggerId == self.finalTriggerId then
    self.killTargetNum = self.killTargetNum + 1
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.ClearLastTrigger)
    if self.killTargetNum >= self.finalTriggerLimit then
      self:OnBattleWin()
    end
  end
  if winCondition.winType == Const.StageWinType.KillBoss and monster.isBoss then
    self.killBossNum = self.killBossNum + 1
    EventManager:GetInstance():Broadcast(EventId.BarrageWinConditionRefresh, Const.StageWinType.KillBoss)
    if self.killBossNum >= winCondition.needKillBossNum then
      self:SetGamePause(true)
      if not self.winTimer then
        Time.timeScale = 0.5
        self.winTimer = TimerManager:GetInstance():GetTimer(1, function()
          Time.timeScale = 1
          self:OnBattleWin()
          self.winTimer:Stop()
          self.winTimer = nil
        end, nil, true, false, true)
      end
      self.winTimer:Start()
    end
  end
end

function ZombieBattleManager:OnBattleReset(squadIndex, supply, heroes)
  self:OnBattleLose()
  if self.param.enterType == nil or self.param.enterType == PVEEnterType.GM or self.param.enterType == PVEEnterType.Default then
    local curGroup = self.pveTemplate.stageGroupMeta.id
    local curStage = self.pveTemplate.stageMeta.id
    
    local function UseSquadDataEnterBattle(squadIndex, supply, heroes)
      local canEnterBattle = false
      if supply == nil or table.count(supply) <= 0 then
        canEnterBattle = false
      else
        for k, v in pairs(supply) do
          if 0 < v then
            canEnterBattle = true
          end
        end
      end
      if not canEnterBattle then
        if table.count(heroes) > 0 then
          UIUtil.ShowTipsId(430009)
        end
        return
      end
      local slotIndexToSupplyDic = {}
      for heroUuid, supplyCount in pairs(supply) do
        local slotIndex = table.keyof(heroes, heroUuid)
        if slotIndex ~= false then
          if 0 < supplyCount then
            slotIndexToSupplyDic[slotIndex] = supplyCount
          else
            heroes[slotIndex] = nil
          end
        end
      end
      SFSNetwork.SendMessage(MsgDefines.StartPveStage, curGroup, curStage, 1, slotIndexToSupplyDic, heroes)
    end
    
    UseSquadDataEnterBattle(squadIndex, supply, heroes)
  elseif self.param.enterType == PVEEnterType.Radar then
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
  end
end

function ZombieBattleManager:ShowDamageText(damage, position, style, damageType, isCrit, time)
  local param = self.damageTextMgr:GetParam()
  param.style = style
  param.damage = damage
  param.position = position
  param.damageType = damageType
  param.isCrit = isCrit
  param.time = time
  self.damageTextMgr:GenText(param)
end

function ZombieBattleManager:ShowBuffText(txt, position, isDebuff, iconPath, time)
  local param = self.damageTextMgr:GetParam()
  param.txt = txt
  param.position = position
  param.style = DamageTextType.GetBuff
  param.isDebuff = isDebuff
  param.iconPath = iconPath
  param.time = time
  param.damage = 0
  self.damageTextMgr:GenText(param)
end

function ZombieBattleManager:SetGameOver(v)
  self.gameOver = v
end

function ZombieBattleManager:SetGamePause(v)
  self.gamePause = v
end

local TreasureBoxAsset_Anim = "A_vehicle_baoxiang_skin"

function ZombieBattleManager:OnGameStart()
  local winCondition = self.pveTemplate.winCondition
  if winCondition.winType == Const.StageWinType.WayPoint then
    local req = Resource:InstantiateAsync(TreasureBoxAsset, ObjectPoolTag.BattleScene)
    req:completed("+", function()
      local trans = req.gameObject.transform
      local finalPoint = self.wayPoint[#self.wayPoint].pos
      trans:Set_position(finalPoint.x, finalPoint.y, finalPoint.z + 5)
      local treasureBox = trans:Find(TreasureBoxAsset_Anim)
      if treasureBox then
        self.waypointTreasureBoxAnim = treasureBox:GetComponent(typeof(CS.SimpleAnimation))
        self.waypointTreasureBoxAnim:Play("show")
      end
    end)
    self.waypointTreasureBoxReq = req
  end
  if self.param.enterType == PVEEnterType.Radar and self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVEFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.DetectEventPVE, self.param.extraData.uuid)
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure and self.param.extraData ~= nil and self.param.extraData.cfgId ~= nil then
    local isAuto = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    if isAuto then
      DataCenter.ZombieBattleManager:StartBattle()
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVEFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, EnterHeroSquadPanelWay.TowerupJeepAdventure, self.param.extraData.cfgId, self.levelId)
    end
  elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVEFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.StageFeatureBattle, nil, self.levelId, self.param.enterType)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVEFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.PveEnterBattle, self.levelGroupId, self.levelId, self.param.enterType)
  end
  self:AddSceneUpdator()
end

function ZombieBattleManager:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function ZombieBattleManager:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function ZombieBattleManager:SceneUpdate()
  if not self.touchCamera then
    return
  end
  if not self.gamePause then
    return
  end
  local tarPos = self.touchCamera:GetCameraTargetPos()
  local viewTile = SceneUtils.WorldToTile(tarPos)
  if self.staticMgr ~= nil then
    self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
  end
  if self.collectionMgr then
    self.collectionMgr:OnUpdate(viewTile.x, viewTile.y)
  end
end

function ZombieBattleManager:OnBossEnterBattle(boss)
  local winCondition = self.pveTemplate.winCondition
  if winCondition.winType == Const.StageWinType.KillBoss and boss.meta.id == winCondition.needKillBossNum then
    self.genZombieTask = {}
    self.boss = boss
  end
end

function ZombieBattleManager:DealDamage(params)
  local attacker = params.attacker
  local defender = params.defender
  local bulletMeta = params.bulletMeta
  local damageMultiplier = params.damageMultiplier
  local hitPoint = params.hitPoint
  local hitDir = params.hitDir
  local whiteTime = params.whiteTime
  local stiffTime = params.stiffTime
  local hitBackDistance = params.hitBackDistance
  local hitEff = params.hitEff
  local skill = params.skill
  local isCritical = params.isCritical
  local isSplash = params.isSplash
  local hurt, isCritical, isMiss, nakedDmg = PveUtil.CalculateDamage(attacker, defender, bulletMeta.damage_type, damageMultiplier, isCritical)
  hurt = hurt or 0
  if isMiss then
    self:ShowDamageText(hurt, hitPoint, DamageTextType.Miss, bulletMeta.damage_type, isCritical)
    return
  end
  if hurt <= 0 then
    return
  end
  defender:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  defender:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
  local rootAttacker, rootDefender
  if attacker.unitType == UnitType.Pet and attacker.owner then
    rootAttacker = attacker.owner.hero
  else
    rootAttacker = attacker.hero
  end
  if defender.unitType == UnitType.Pet and defender.owner then
    rootDefender = defender.owner.hero
  else
    rootDefender = defender.hero
  end
  if rootAttacker and 0 < hurt then
    if self.heroStatisticalData.makeDmg[rootAttacker.uuid] == nil then
      self.heroStatisticalData.makeDmg[rootAttacker.uuid] = 0
    end
    self.heroStatisticalData.makeDmg[rootAttacker.uuid] = self.heroStatisticalData.makeDmg[rootAttacker.uuid] + hurt
  end
  if rootDefender and 0 < nakedDmg then
    if self.heroStatisticalData.takeDmg[rootDefender.uuid] == nil then
      self.heroStatisticalData.takeDmg[rootDefender.uuid] = 0
    end
    self.heroStatisticalData.takeDmg[rootDefender.uuid] = self.heroStatisticalData.takeDmg[rootDefender.uuid] + nakedDmg
  end
  if attacker.weaponData and 0 < hurt then
    if self.weaponStatisticalData.makeDmg == nil then
      self.weaponStatisticalData.makeDmg = 0
    end
    self.weaponStatisticalData.makeDmg = self.weaponStatisticalData.makeDmg + hurt
  end
  local damageTextType
  if attacker.unitType == UnitType.Member then
    if skill and skill:IsUltimate() then
      damageTextType = DamageTextType.HeroUltimate
    elseif isSplash then
      damageTextType = DamageTextType.Splash
    else
      damageTextType = DamageTextType.HeroNormalAttack
    end
  elseif attacker.unitType == UnitType.Zombie then
    if 0 < defender:GetSubTypeBuffCount(BuffSubType.ReduceDamage) then
      damageTextType = DamageTextType.ReduceDamageBuff
    elseif skill and skill:IsNormalAttack() then
      damageTextType = DamageTextType.ZombieNormalAttack
    else
      damageTextType = DamageTextType.ZombieUltimate
    end
  elseif attacker.unitType == UnitType.TacticalWeapon then
    damageTextType = DamageTextType.Drone
  else
    damageTextType = DamageTextType.HeroNormalAttack
  end
  self:ShowDamageText(hurt, hitPoint, damageTextType, bulletMeta.damage_type, isCritical)
end

function ZombieBattleManager:OnBuffChange(buffId)
  self.squad.moveSpeedDirty = true
  self.squad.superArmorDirty = true
end

function ZombieBattleManager:OnPlotGroupDone(id)
end

function ZombieBattleManager:GetTotalKill()
  return self.killNum
end

function ZombieBattleManager:GetCostTime()
  return self.useTime
end

function ZombieBattleManager:GetAvgFPS()
  if self.useTime == 0 then
    return -1
  end
  return (Time.frameCount - self.startFrame) / self.useTime
end

function ZombieBattleManager:GetLowestFPS()
  return math.min(self.lowestFps, self:GetAvgFPS())
end

function ZombieBattleManager:GetStageId()
  return self.pveTemplate.id
end

function ZombieBattleManager:LogPassTime(title)
  local now = UITimeManager:GetInstance():GetServerTime()
  local pass = (now - self.enterTime) / 1000
end

function ZombieBattleManager:StartBattle()
  self.shouldStartBatle = true
  if not self.squadCreateFinish then
    return
  end
  self:RemoveSceneUpdator()
  
  local function ReadyGO()
    if self.nextWayPointOrder == 1 then
      self:OnArriveWayPoint()
    end
    if self.squad then
      self.squad:OnStartBattle()
      self:ResetHeroPos()
    end
    self:SetGamePause(false)
    EventManager:GetInstance():Broadcast(EventId.GF_zombie_battle_start, self.levelId)
  end
  
  EventManager:GetInstance():Broadcast(EventId.HidePVEFormationPanel)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIZombieBattleMain) then
    local param = {}
    param.levelId = self.levelId
    
    local function onOpen()
      if self.uiPveMain and self.squadCreateFinish then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPVEFormation)
        self.uiPveMain:ShowWinCondition(function()
        end)
        ReadyGO()
      end
    end
    
    param.onOpen = onOpen
    param.enterType = self.param.enterType
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIZombieBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
    self.uiPveMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIZombieBattleMain).View
  else
    ReadyGO()
  end
  if self.param.enterType == PVEEnterType.StageFeatureBuilding then
  end
end

function ZombieBattleManager:SetHeroers(heroes)
  if self.squad then
    self.squad:ChangeHeroes(heroes)
  end
end

function ZombieBattleManager:SetHeroPos(index, pos)
  if self.squad then
    self.squad:SetHeroPosition(index, pos)
  end
end

function ZombieBattleManager:ResetHeroPos()
  if self.squad then
    self.squad:ResetHeroPosition()
  end
end

function ZombieBattleManager:HeroMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.5
  if self.squad then
    self.squad:MoveHeroToIndex(index, dstIndex, animTime)
  end
end

function ZombieBattleManager:GetSquadMemberPosition()
  if self.squad then
    return self.squad:ReturnMemberPositions()
  else
    return {}
  end
end

function ZombieBattleManager:ChangeState(newState)
  local oldState = self.state
  if newState == BarrageState.Push then
    self.state = newState
  elseif newState == BarrageState.PreExit then
    if oldState ~= BarrageState.Push then
      return
    end
    self.state = newState
    self:SetGamePause(false)
    self.squad:ChangeStage(newState)
    EventManager:GetInstance():Broadcast(EventId.PVEWin)
    self:AddDelayEvent(function()
      self:ChangeState(BarrageState.Exit)
    end, 0.7)
  elseif newState == BarrageState.Exit then
    if oldState ~= BarrageState.PreExit then
      return
    end
    self.state = newState
    self:AddDelayEvent(function()
      self:SetGameOver(true)
    end, 4)
    if self.waypointTreasureBoxReq then
      self.waypointTreasureBoxReq:Destroy()
      self.waypointTreasureBoxReq = nil
      self.waypointTreasureBoxAnim = nil
    end
    if self.squad then
      self.squad:ChangeStage(newState)
      local members = self.squad.members
      local heroes = {}
      local remainSupply = {}
      for k, v in pairs(members) do
        local index = v.index
        local heroUuid = v.heroUuid
        heroes[index] = heroUuid
        remainSupply[index] = v:GetCurBlood()
      end
      local p = {}
      p.stageId = self.pveTemplate.id
      if self.param.enterType == PVEEnterType.TowerupJeepAdventure then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureVictory, {anim = true, playEffect = 10024}, self.param)
      elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
        self.param.stageId = self.pveTemplate.id
        self.param.kill = self.killNum
        self.param.time = self.useTime
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, self.param)
        local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.param.featureId)
        local idx = table.indexof(template.stages, self.pveTemplate.id)
        if #template.winType == 1 then
          if idx == #template.stages then
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingSaveSpecialStage, {
              uuid = self.param.buildUuid,
              stageId = self.param.levelId
            })
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingFinishSpecialStage, self.param.buildUuid)
          end
          return
        else
          SFSNetwork.SendMessage(MsgDefines.FreeBuildingSaveSpecialStage, {
            uuid = self.param.buildUuid,
            stageId = self.param.levelId
          })
          if idx == #template.stages then
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingFinishSpecialStage, self.param.buildUuid)
          end
          return
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIZombieBattleWin, {anim = false, playEffect = 10024}, p, self.param)
      end
      if self.param.enterType == PVEEnterType.Radar then
        local uuid = -1
        if self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
          uuid = self.param.extraData.uuid
        end
        SFSNetwork.SendMessage(MsgDefines.EndDetectEventPve, uuid, true)
      elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
        local cfgId = -1
        if self.param.extraData ~= nil and self.param.extraData.cfgId ~= nil then
          cfgId = self.param.extraData.cfgId
        end
        SFSNetwork.SendMessage(MsgDefines.LWSaveTowerupRecord, cfgId)
      else
        local curGroup = self.pveTemplate.stageGroupMeta.id
        local curStage = self.pveTemplate.stageMeta.id
        SFSNetwork.SendMessage(MsgDefines.PlayerStageInfoMessage, curGroup, curStage, true, 1, remainSupply, heroes)
        PostEventLog.BattleResultLog(PVEType.Barrage, 1)
      end
    end
  elseif newState == BarrageState.Lose then
    if oldState ~= BarrageState.Push then
      return
    end
    self.state = newState
    self:SetGameOver(true)
    EventManager:GetInstance():Broadcast(EventId.PVELose)
    self.squad:ChangeStage(BarrageState.Lose)
    if self.param.enterType == nil or self.param.enterType == PVEEnterType.Default or self.param.enterType == PVEEnterType.GM or self.param.enterType == PVEEnterType.Monopoly then
      local curGroup = self.pveTemplate.stageGroupMeta.id
      local curStage = self.pveTemplate.stageMeta.id
      local allDie = true
      if self.squad ~= nil then
        local members = self.squad.members
        local heroes = {}
        local remainSupply = {}
        for k, v in pairs(members) do
          local index = v.index
          local heroUuid = v.hero.uuid
          heroes[index] = heroUuid
          remainSupply[index] = v:GetCurBlood()
          if v:GetCurBlood() > 0 then
            allDie = false
          end
        end
        SFSNetwork.SendMessage(MsgDefines.PlayerStageInfoMessage, curGroup, curStage, false, 1, remainSupply, heroes)
      else
        SFSNetwork.SendMessage(MsgDefines.PlayerStageInfoMessage, curGroup, curStage, false, 1, {}, {})
      end
      if allDie then
        PostEventLog.BattleResultLog(PVEType.Barrage, 0)
      end
    elseif self.param.enterType == PVEEnterType.Radar then
      local uuid = -1
      if self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
        uuid = self.param.extraData.uuid
      end
      SFSNetwork.SendMessage(MsgDefines.EndDetectEventPve, uuid, false)
    elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    end
  end
end

function ZombieBattleManager:OnBattleWin()
  self:ChangeState(BarrageState.PreExit)
end

function ZombieBattleManager:OnBattleLose()
  self:ChangeState(BarrageState.Lose)
end

function ZombieBattleManager:GetPVEType()
  return PVEType.Barrage
end

function ZombieBattleManager:AddDelayEvent(event, delay)
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function ZombieBattleManager:ChangeTWSkillChipSetId(setId)
  if self.squad then
    local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(setId)
    self.squad:ChangeWeaponSkillChips(skillChips)
  end
end

function ZombieBattleManager:SetBattleExitFlag(flag)
  self.exitFlag = flag
end

return ZombieBattleManager
