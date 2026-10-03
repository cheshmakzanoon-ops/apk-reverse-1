local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local Const = require("Scene.LWBattle.Const")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local Time = _ENV.Time
local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local SkyBattleTeam = require("Scene.LWBattle.SkyBattle.Team.SkyBattleTeam")
local SkyBattleData = require("DataCenter.LWBattle.Logic.SkyBattle.SkyBattleData")
local MonsterManager = require("Scene.LWBattle.SkyBattle.Monster.SkyBattleMonsterManager")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local TriggerEventManager = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEventManager")
local FSM = require("Framework.Common.FSM")
local TweenSequence = CS.DG.Tweening.DOTween
local Ease = CS.DG.Tweening.Ease
local gameStartFastZMoveSpeed2NormalZSpeedTotalTime = 3
local designedWidthHeightFactor = 0.5625
local SkyBattleLogic = BaseClass("SkyBattleLogic", base)
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local QualitySettingUtil = require("Util.QualitySettingUtil")
local DISPLACE_EPSILON_SCREENSPACE = 1.0E-4
local XCenter = Const.ParkourSceneCenter
local FPS_SAMPLE_CD = 10
local defaultFov = 60
local defaultHeight = 45
local defaultRotation = 90
local SoundDelayTime = 0
local defaultMinMoveX = 31
local defaultMaxMoveX = 41
local scene_cloud_eff_path = "Assets/Main/Prefabs/LWBattle/Plane/Effect/Env/Eff_plane_yun.prefab"
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")
local velocity = Vector3.unity_vector3(0, 0, 0)
local normalSmoothTime = 2
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local SceneGroundY = -105
local SceneLightPath = "Assets/_Art_LastWar/Map/LastWar_PVE/LastWar_Light_PVE.prefab"

function SkyBattleLogic:Enter(param)
  self.__event_handlers = {}
  self.delayEvents = {}
  self.param = param
  self.levelId = param.levelId
  self.battleMgr = DataCenter.LWBattleManager
  self:InitPvePhysicsSetting(param)
  self:InitBattleFsm()
  self.initComplete = false
  self.fingerDown = false
  self.lastFingerPosX = 36
  self.monsterMgr = MonsterManager.New()
  self.bulletManager = BulletManager.New(self)
  EffectViewUtil.InitView()
  PveUnitViewUtil.InitView()
  self.triggerEventMgr = TriggerEventManager.New(self)
  self.startFrame = Time.frameCount
  self.sampleCd = FPS_SAMPLE_CD
  self.sampleFrame = Time.frameCount
  self.lowestFps = 999
  self.unitMgr = UnitManager.New(self)
  self.unitGuid = 0
  self.lastTriggerY = 0
  self.goods = {}
  self.auto = false
  self:AddListener(EventId.OpenUI, self.OnOpenUI)
  self:AddListener(EventId.LWBattleBuffStart, self.OnBuffChange)
  self:AddListener(EventId.LWBattleBuffEnd, self.OnBuffChange)
  self.battleType = Const.ParkourBattleType.Defense
  self.initUnitDeath = false
  self.showGuide = false
  self.winToRemoveEffect = false
  self.remainMember = 0
  self.highQualityMode = QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.High
  self.lowQualityMode = QualitySettingUtil.CurrentGraphicLv < EnumQualityLevel.Middle
  self.movedZDistance = 0
  self.useTime = 0
  self.killNum = 0
  self.sceneMovedZDistance = 0
  self.sceneEffectMovedZDistance = 0
  self.winConditions = {}
  self.data = SkyBattleData.New(param.levelId)
  if param.growthMode then
    local growthSelectPlaneData = DataCenter.LWSkyBattleGrowthChapterManager:GetCurSelectedPlaneData()
    if growthSelectPlaneData and growthSelectPlaneData.heroId then
      self.data.meta.default_hero = string.format("%d", growthSelectPlaneData.heroId)
    end
  end
  self.winCondition = self.data.winCondition
  if self.data.winCondition then
    self.winConditions[self.data.winCondition.winType] = self.data.winCondition
  end
  if not self.data.hideDamage then
    self.damageTextMgr = DamageTextManager.New()
  end
  self.endLine = self.data.endLine or 0
  self.initMoveSpeedZ = self.data.moveSpeedZ or 0
  self.showHeroEnergy = self.data.showEnergy
  self.parkourDoorHeroId = self.data.parkourDoorHeroId
  self.sceneEffectSpeedZ = self.data.sceneSpeedZ or 0
  PostEventLog.Track(PostEventLog.Defines.BattleSkyBattleStart, {
    stageId = tostring(param.levelId)
  })
end

function SkyBattleLogic:__delete()
  self:Destroy()
end

function SkyBattleLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
  local touchInput = self.battleMgr.touchCamera.touchInput
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function SkyBattleLogic:UnInitCamera()
  if self.touchCamera and self.touchCamera.touchInput then
    local touchInput = self.touchCamera.touchInput
    self.touchCamera.CanMoveing = true
    if self.onFingerDown then
      touchInput:OnFingerDown("-", self.onFingerDown)
    end
    if self.onFingerUp then
      touchInput:OnFingerUp("-", self.onFingerUp)
    end
  end
end

function SkyBattleLogic:InitPvePhysicsSetting(param)
  self.userCollider2D = true
  PvePhysicsUtil.EnterBattle(self.userCollider2D)
end

function SkyBattleLogic:InitCameraParams(pos)
  local cameraParam = self:GetCameraParam()
  local height = cameraParam.height
  local fov = cameraParam.fov
  local minHeight = 20
  height = math.max(minHeight, height)
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  self.touchCamera:SetZoomParams(1, height, 0, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = minHeight
  self.camera.transform.eulerAngles = Vector3.New(90, 0, 0)
  local halfCameraViewHeight = math.tan(fov * 0.5 * math.pi / 180) * height
  self.battleMgr.cameraOffset:Set(0, 0, halfCameraViewHeight * 0.6)
  self.screen2WorldFactor = halfCameraViewHeight * 2 / Screen.height
  self.safeTeamZMoveDelta = halfCameraViewHeight
  local halfGroundViewHeight = math.tan(fov * 0.5 * math.pi / 180) * (height - SceneGroundY)
  self.safeSceneHideDelta = halfGroundViewHeight * 1.25
  self.deviceWidthHeightFactor = Screen.width / Screen.height
  self.designedHalfWidthView = halfCameraViewHeight * designedWidthHeightFactor
  self.deviceHalfWidthView = halfCameraViewHeight * self.deviceWidthHeightFactor
  self.deviceHalfWidthDeltaToDesign = self.deviceHalfWidthView - self.designedHalfWidthView
  local cameraCfgLeftBorderX = 0
  if self.data and self.data.cameraLeftBoderX then
    cameraCfgLeftBorderX = self.data.cameraLeftBoderX
  end
  local cameraCfgRightBorderX = 0
  if self.data and self.data.cameraRightBoderX then
    cameraCfgRightBorderX = self.data.cameraRightBoderX
  end
  local resetCameraMoveLeftBorder = cameraCfgLeftBorderX + self.deviceHalfWidthDeltaToDesign
  local resetCameraMoveRightBorder = cameraCfgRightBorderX - self.deviceHalfWidthDeltaToDesign
  if resetCameraMoveLeftBorder > resetCameraMoveRightBorder then
    resetCameraMoveLeftBorder = XCenter
    resetCameraMoveRightBorder = XCenter
  end
  self.cameraMoveLeftBorder = resetCameraMoveLeftBorder
  self.cameraMoveRightBorder = resetCameraMoveRightBorder
end

function SkyBattleLogic:InitBattleFsm()
  self.battleFsm = FSM.New()
  self.battleFsm:AddState(Const.ParkourBattleState.Ready, require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleReadyState").New(self))
  self.battleFsm:AddState(Const.ParkourBattleState.Farm, require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleFarmState").New(self))
  self.battleFsm:AddState(Const.ParkourBattleState.PreExit, require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattlePreExitState").New(self))
  self.battleFsm:AddState(Const.ParkourBattleState.Exit, require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleExitState").New(self))
  self.battleFsm:AddState(Const.ParkourBattleState.Lose, require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleLoseState").New(self))
end

function SkyBattleLogic:GetCameraParam(pos)
  local fov = defaultFov
  local height = defaultHeight
  local rotation = defaultRotation
  if self.data and self.data.cameraParams and #self.data.cameraParams > 0 then
    fov = self.data.cameraParams[1]
    height = self.data.cameraParams[2]
    rotation = self.data.cameraParams[3]
  end
  local camera = {}
  camera.fov = fov
  camera.height = height
  camera.rotation = rotation
  return camera
end

function SkyBattleLogic:IsDefenseMode()
  return true
end

function SkyBattleLogic:CanControlMove()
  if not self.battleMgr.gameStart or self.battleMgr.gamePause or self.battleMgr.gameOver then
    return false
  end
  if not self.gameStartShowFinish then
    return false
  end
  return true
end

function SkyBattleLogic:OnFingerDown(pos)
  local canControlMove = self:CanControlMove()
  if not canControlMove then
    return
  end
  self.fingerDown = true
  local firstTouchWrapper = TouchWrapper.GetFirstWrappedTouch()
  self.fingerId = firstTouchWrapper.FingerId
  local hit, hitX, hitZ = CS.CSUtils.GetCameraTouchWorldPos(self.touchCamera)
  if hit then
    self.lastFingerPosX = hitX
    self.lastFingerPosZ = hitZ
  else
    self.lastFingerPosX = nil
    self.lastFingerPosZ = nil
  end
  local curFSMState = self.battleFsm:GetCurState()
  if curFSMState then
    curFSMState:OnFingerDown(pos)
  end
  local finger = string.format("OnFingerDown : %d", self.fingerId)
  Logger.Log(finger)
end

function SkyBattleLogic:OnFingerUp()
  self.fingerDown = false
  if self.team then
    self.team:StopMoveDirection()
  end
  self.fingerId = nil
  self.lastFingerPosX = nil
  self.lastFingerPosZ = nil
  velocity.x, velocity.y, velocity.z = 0, 0, 0
  local curFSMState = self.battleFsm:GetCurState()
  if curFSMState then
    curFSMState:OnFingerUp()
  end
end

function SkyBattleLogic:OnFingerHold(deltaTime)
  local canControlMove = self:CanControlMove()
  if not canControlMove then
    return
  end
  local firstTouchWrapper = TouchWrapper.GetFirstWrappedTouch()
  local fingerId = firstTouchWrapper.FingerId
  if fingerId ~= self.fingerId then
    Logger.Log("OnFingerHold:FingerId Changed, lastFingerId:%d,curFingerId:%d", self.fingerId, fingerId)
    self:OnFingerUp()
    self:OnFingerDown()
    return
  end
  local curFSMState = self.battleFsm:GetCurState()
  if curFSMState then
    curFSMState:OnFingerHold(deltaTime)
  end
end

function SkyBattleLogic:OnFingerHoldHorizonAndVertical(deltaTime)
  local hit, hitX, hitZ = CS.CSUtils.GetCameraTouchWorldPos(self.touchCamera)
  if not hit then
    return
  end
  if not self.team then
    return
  end
  local nowX = self.team:GetPosition().x
  local deltaX = 0
  local absDeltaX = 0
  if self.lastFingerPosX then
    deltaX = hitX - self.lastFingerPosX
    absDeltaX = math.abs(deltaX)
  end
  local nowZ = self.team:GetPosition().z
  local deltaZ = 0
  local absDeltaZ = 0
  if self.lastFingerPosZ then
    deltaZ = hitZ - self.lastFingerPosZ
    absDeltaZ = math.abs(deltaZ)
  end
  local actionType = 0
  local finalXPos = nowX
  if absDeltaX < DISPLACE_EPSILON_SCREENSPACE then
    self.hasHorizonMove = false
  else
    self.hasHorizonMove = true
    finalXPos = self:ClampMoveX(nowX + deltaX)
    self.lastFingerPosX = hitX
    actionType = 1
  end
  local finalZPos = nowZ
  if absDeltaZ < DISPLACE_EPSILON_SCREENSPACE then
    self.hasVerticalMove = false
  else
    self.hasVerticalMove = true
    finalZPos = self:ClampMoveZ(nowZ + deltaZ)
    self.lastFingerPosZ = hitZ
    if not self.hasHorizonMove or absDeltaX < absDeltaZ then
      actionType = 2
    end
  end
  if actionType == 1 then
    self.team:MoveDirectionHorizontal(deltaX)
    self.team:MoveToPos(finalXPos, finalZPos, deltaTime)
  elseif actionType == 2 then
    self.team:MoveDirectionVertical(deltaZ)
    self.team:MoveToPos(finalXPos, finalZPos, deltaTime)
  elseif actionType == 0 then
    self.team:StopMoveDirection()
  end
end

function SkyBattleLogic:HasMove()
  return self.fingerDown and self.hasHorizonMove or self.hasVerticalMove
end

function SkyBattleLogic:ClampMoveX(x)
  local minX = defaultMinMoveX
  local maxX = defaultMaxMoveX
  if self.data.soliderLeftBoderDeltaX and self.data.soliderRightBoderDeltaX then
    minX = self.data.initPosX - self.data.soliderLeftBoderDeltaX
    maxX = self.data.initPosX + self.data.soliderRightBoderDeltaX
  end
  return Mathf.Clamp(x, minX, maxX)
end

function SkyBattleLogic:ClampMoveZ(z)
  local minZ, maxZ = self:GetCameraVisiblePlaneMinZAndMaxZ()
  return Mathf.Clamp(z, minZ, maxZ)
end

function SkyBattleLogic:GetCurScreenWorldPositionWithInitX()
  return self.data.initPosX, 0, self.cameraFollowPosition.z + self.battleMgr.cameraOffset.z
end

function SkyBattleLogic:GetCurScreenCenterWorldPositionXYZ()
  return self.cameraFollowPosition.x, 0, self.cameraFollowPosition.z + self.battleMgr.cameraOffset.z
end

function SkyBattleLogic:LoadScene(callBack)
  if not self.data or self.data.hasError then
    if callBack then
      callBack()
    end
    DataCenter.LWBattleManager:Exit(nil, "win")
    return
  end
  local defaultHeroOverrideProperties, defaultHeroOverrideSkills
  if self.param.growthMode then
    local curPlaneMaxHP = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.HP)
    local curPlaneMaxAttack = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.Attack)
    defaultHeroOverrideProperties = {}
    local propertyHp = {
      key = HeroEffectDefine.HealthPoint,
      value = curPlaneMaxHP
    }
    table.insert(defaultHeroOverrideProperties, propertyHp)
    local propertyAttack = {
      key = HeroEffectDefine.PhysicalAttack,
      value = curPlaneMaxAttack
    }
    table.insert(defaultHeroOverrideProperties, propertyAttack)
    local propertyHpResult = {
      key = HeroEffectDefine.HealPoint_Result,
      value = curPlaneMaxHP
    }
    table.insert(defaultHeroOverrideProperties, propertyHpResult)
    local propertyAttackResult = {
      key = HeroEffectDefine.PhysicalAttack_Result,
      value = curPlaneMaxAttack
    }
    table.insert(defaultHeroOverrideProperties, propertyAttackResult)
    local battleSlotInfo = DataCenter.LWSkyBattleGrowthChapterManager.battleSlotInfo
    if battleSlotInfo then
      for i, slotInfo in pairs(battleSlotInfo) do
        if slotInfo.uuid and slotInfo.skill then
          defaultHeroOverrideSkills = defaultHeroOverrideSkills or {}
          local overrideSkill = {
            skillId = slotInfo.skill,
            slot = slotInfo.slot
          }
          table.insert(defaultHeroOverrideSkills, overrideSkill)
        end
      end
    end
  end
  local intiPosX = self.data.initPosX or 0
  local intiPosY = self.data.initPosY or 0
  local defaultHero = self.data.meta and self.data.meta.default_hero or 0
  self.team = SkyBattleTeam.New(intiPosX, intiPosY - self.safeTeamZMoveDelta, self, defaultHero, defaultHeroOverrideProperties, defaultHeroOverrideSkills, Bind(self, self.OnTeamInited))
  self.team.speedX = self.data.moveSpeedX or 0
  self.team.speedZ = self.data.moveSpeedZ or 0
  if self.damageTextMgr then
    self.damageTextMgr:Init(self)
  end
  self.sceneEffectAssetLoaded = false
  self.sceneAssetLoaded = false
  self.sceneInitedComplete = false
  local sceneCfgArr = self.data.sceneCfgArr or {}
  local sceneCfgCount = #sceneCfgArr
  self.sceneLoadRequest = {}
  self.finishedScene = 0
  self.sceneAnims = {}
  self.monsterMgr:Init(self)
  self.sceneRoots = {}
  self.sceneTotalLength = 0
  self.sceneAssetLoaded = sceneCfgCount == 0
  self.gameStartSceneHeadOffsetZ = 0 < sceneCfgCount and sceneCfgArr[1].offset or 0
  if self.sceneAssetLoaded then
    self:CheckSceneRelatedAssetsLoadComplete(callBack)
  else
    for _, sceneCfg in ipairs(sceneCfgArr) do
      local index = _
      local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneCfg.meta.asset), ObjectPoolTag.BattleScene)
      req:completed("+", function()
        if not req.isError and not IsNull(req.gameObject) then
          local sceneRoot = req.gameObject.transform
          self.sceneRoots[index] = sceneRoot
          sceneRoot:Set_position(0, 0, sceneCfg.offset)
          if sceneCfg.hasAnim then
            local anim = sceneRoot:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
            if IsNotNull(anim) then
              table.insert(self.sceneAnims, anim)
            end
          end
        end
        self.finishedScene = self.finishedScene + 1
        if self.finishedScene >= sceneCfgCount then
          self.sceneAssetLoaded = true
          self:CheckSceneRelatedAssetsLoadComplete(callBack)
        end
      end)
      table.insert(self.sceneLoadRequest, req)
      self.sceneTotalLength = self.sceneTotalLength + sceneCfg.meta.scene_size
      if sceneCfg.offset < self.gameStartSceneHeadOffsetZ then
        self.gameStartSceneHeadOffsetZ = sceneCfg.offset
      end
    end
  end
  local sceneExt = self.data.sceneExt or {}
  if not string.IsNullOrEmpty(sceneExt) then
    self.sceneExtReq = Resource:InstantiateAsync(sceneExt, ObjectPoolTag.BattleScene)
    self.sceneExtReq:completed("+", function()
      if self.sceneExtReq.isError then
        return
      end
      local go = self.sceneExtReq.gameObject
      if not IsNull(go) then
        go.transform:Set_localPosition(0, 0, 0)
        go:SetActive(true)
      end
    end)
  end
  self.sceneLightReq = Resource:InstantiateAsync(SceneLightPath, ObjectPoolTag.BattleScene)
  self.sceneLightReq:completed("+", function()
    if self.sceneLightReq.isError then
      return
    end
    local go = self.sceneLightReq.gameObject
    if not IsNull(go) then
      go.transform:Set_localPosition(0, 0, 0)
      go:SetActive(true)
    end
  end)
  local sceneEffectCfgArr = self.data.sceneEffectCfgArr or {}
  local sceneEffectCfgCount = #sceneEffectCfgArr
  self.sceneEffectAssetLoaded = sceneEffectCfgCount == 0
  self.sceneEffectLoadRequest = {}
  self.recycleSceneEffectRoots = {}
  self.recycleEffectSceneTotalLength = 0
  self.sceneEffectHeadSize = 0
  self.sceneEffectHeadOffsetZ = 0
  self.finishedSceneEffect = 0
  if self.sceneEffectAssetLoaded then
    self:CheckSceneRelatedAssetsLoadComplete(callBack)
  else
    for sceneEffectIndex, sceneEffectCfg in ipairs(sceneEffectCfgArr) do
      local index = sceneEffectIndex
      local req = Resource:InstantiateAsync(sceneEffectCfg.meta.asset, ObjectPoolTag.BattleScene)
      req:completed("+", function()
        if not req.isError and not IsNull(req.gameObject) then
          local sceneEffectRoot = req.gameObject.transform
          if index == 1 then
            self.sceneEffectFirstRoot = sceneEffectRoot
          else
            self.recycleSceneEffectRoots[index] = sceneEffectRoot
          end
          sceneEffectRoot:Set_position(0, 0, sceneEffectCfg.offset)
        end
        self.finishedSceneEffect = self.finishedSceneEffect + 1
        if self.finishedSceneEffect >= sceneEffectCfgCount then
          self.sceneEffectAssetLoaded = true
          self:CheckSceneRelatedAssetsLoadComplete(callBack)
        end
      end)
      table.insert(self.sceneEffectLoadRequest, req)
      if sceneEffectIndex == 1 then
        self.sceneEffectHeadSize = sceneEffectCfg.meta.scene_size
        self.sceneEffectHeadOffsetZ = sceneEffectCfg.offset
      else
        self.recycleEffectSceneTotalLength = self.recycleEffectSceneTotalLength + sceneEffectCfg.meta.scene_size
      end
    end
  end
end

function SkyBattleLogic:CheckSceneRelatedAssetsLoadComplete(callBack)
  if self.sceneInitedComplete then
    return
  end
  if self.sceneAssetLoaded and self.sceneEffectAssetLoaded then
    if callBack then
      callBack()
    end
    self:LoadSceneComplete()
  end
end

function SkyBattleLogic:UpdateSceneMove()
  if self.sceneTotalLength <= 0 then
    return
  end
  local sceneHeadOffset = self.gameStartSceneHeadOffsetZ or 0
  local totalSceneMovedDistance = self.sceneMovedZDistance - sceneHeadOffset
  local cycleMoveSpan = self.safeSceneHideDelta + self.sceneTotalLength
  if totalSceneMovedDistance >= cycleMoveSpan then
    self.sceneMovedZDistance = self.safeSceneHideDelta + sceneHeadOffset
    totalSceneMovedDistance = self.safeSceneHideDelta
  end
  local curTrailEndOffsetZ = self.sceneTotalLength - totalSceneMovedDistance
  local minCameraVisibleZ, maxCameraVisibleZ = self:GetCameraVisibleGroundMinZAndMaxZ()
  local sceneCfgArr = self.data.sceneCfgArr
  for i, sceneRoot in pairs(self.sceneRoots) do
    local sceneCfg = sceneCfgArr[i]
    local sceneInitOffset = sceneCfg.offset - sceneHeadOffset
    local curOffsetZ = sceneInitOffset - totalSceneMovedDistance
    local halfSize = sceneCfg.meta.scene_size * 0.5
    if minCameraVisibleZ > curOffsetZ + halfSize then
      curOffsetZ = curTrailEndOffsetZ + sceneInitOffset
    end
    local inVisible = maxCameraVisibleZ < curOffsetZ - halfSize or minCameraVisibleZ > curOffsetZ + halfSize
    local activeSelf = sceneRoot.gameObject.activeSelf
    if activeSelf and inVisible then
      sceneRoot.gameObject:SetActive(false)
    elseif not activeSelf and not inVisible then
      sceneRoot.gameObject:SetActive(true)
    end
    if not inVisible then
      sceneRoot:Set_position(0, 0, curOffsetZ)
    end
  end
end

function SkyBattleLogic:UpdateSceneEffectMove()
  local sceneEffectHeadOffset = self.sceneEffectHeadOffsetZ or 0
  local sceneEffectHeadSize = self.sceneEffectHeadSize or 0
  local minCameraVisibleZ, maxCameraVisibleZ = self:GetCameraVisibleGroundMinZAndMaxZ()
  if 0 < self.recycleEffectSceneTotalLength then
    local totalSceneEffectRecycleMovedDistance = self.sceneEffectMovedZDistance - sceneEffectHeadOffset - sceneEffectHeadSize
    local cycleMoveSpan = self.safeSceneHideDelta + self.recycleEffectSceneTotalLength
    if totalSceneEffectRecycleMovedDistance >= cycleMoveSpan then
      totalSceneEffectRecycleMovedDistance = self.safeSceneHideDelta
      self.sceneEffectMovedZDistance = self.safeSceneHideDelta + sceneEffectHeadOffset + sceneEffectHeadSize
    end
    local curTrailEndOffsetZ = self.recycleEffectSceneTotalLength - totalSceneEffectRecycleMovedDistance
    local sceneEffectCfgArr = self.data.sceneEffectCfgArr
    for i, sceneEffectRecycleRoot in pairs(self.recycleSceneEffectRoots) do
      local sceneEffectCfg = sceneEffectCfgArr[i]
      local sceneInitOffset = sceneEffectCfg.offset - sceneEffectHeadOffset - sceneEffectHeadSize
      local curOffsetZ = sceneInitOffset - totalSceneEffectRecycleMovedDistance
      if minCameraVisibleZ > curOffsetZ + sceneEffectCfg.meta.scene_size then
        curOffsetZ = curTrailEndOffsetZ + sceneInitOffset
      end
      local inVisible = maxCameraVisibleZ < curOffsetZ - sceneEffectCfg.meta.scene_size or minCameraVisibleZ > curOffsetZ + sceneEffectCfg.meta.scene_size
      local activeSelf = sceneEffectRecycleRoot.gameObject.activeSelf
      if activeSelf and inVisible then
        sceneEffectRecycleRoot.gameObject:SetActive(false)
      elseif not activeSelf and not inVisible then
        sceneEffectRecycleRoot.gameObject:SetActive(true)
      end
      if not inVisible then
        sceneEffectRecycleRoot:Set_position(0, 0, curOffsetZ)
      end
    end
  end
  if self.firstSceneEffectShow and not IsNull(self.sceneEffectFirstRoot) then
    local sceneFirstEffectCfg = self.data.sceneEffectCfgArr[1]
    local sceneFirstEffectOffsetZ = sceneFirstEffectCfg.offset - self.sceneEffectMovedZDistance
    local activeSelf = self.sceneEffectFirstRoot.gameObject.activeSelf
    if minCameraVisibleZ > sceneFirstEffectOffsetZ + sceneFirstEffectCfg.meta.scene_size * 0.5 then
      self.firstSceneEffectShow = false
      if activeSelf then
        self.sceneEffectFirstRoot.gameObject:SetActive(false)
      end
    else
      if not activeSelf then
        self.sceneEffectFirstRoot.gameObject:SetActive(true)
      end
      self.sceneEffectFirstRoot:Set_position(0, 0, sceneFirstEffectOffsetZ)
    end
  end
end

function SkyBattleLogic:GetCameraVisibleGroundMinZAndMaxZ()
  local screenCenterX, screenCenterY, screenCenterZ = self:GetCurScreenCenterWorldPositionXYZ()
  local minVisibleZ = screenCenterZ - self.safeSceneHideDelta
  local maxVisibleZ = screenCenterZ + self.safeSceneHideDelta
  return minVisibleZ, maxVisibleZ
end

function SkyBattleLogic:GetCameraVisiblePlaneMinZAndMaxZ()
  local screenCenterX, screenCenterY, screenCenterZ = self:GetCurScreenCenterWorldPositionXYZ()
  local minVisibleZ = screenCenterZ - self.safeTeamZMoveDelta
  local maxVisibleZ = screenCenterZ + self.safeTeamZMoveDelta
  return minVisibleZ, maxVisibleZ
end

function SkyBattleLogic:OnTeamInited()
  self.teamInited = true
  if self.sceneInitedComplete and not self.initComplete then
    self.initComplete = true
    self:DelayParkourBattleStart()
  end
end

function SkyBattleLogic:LoadSceneComplete()
  self.sceneInitedComplete = true
  local pos = Vector3.New(XCenter, 0, self.team:GetPositionZ())
  self.battleMgr:LookAt(pos)
  self.cameraFollowPosition = pos
  if self.teamInited and not self.initComplete then
    self.initComplete = true
    self:DelayParkourBattleStart()
  end
  local preloadType = self.data.preloadType
  if self.bulletManager ~= nil then
    self.bulletManager:PreloadStraight(preloadType)
  end
  self:PreloadEffect(preloadType)
  self:PreloadUnitView(preloadType)
end

function SkyBattleLogic:PlaySceneAnim(animName)
  if self.sceneAnims then
    for _, anim in ipairs(self.sceneAnims) do
      if IsNotNull(anim) then
        anim:Play(animName)
      end
    end
  end
end

function SkyBattleLogic:PreloadEffect(preloadType)
  if preloadType == 3 then
  else
    if preloadType == 2 then
    else
    end
  end
end

function SkyBattleLogic:PreloadUnitView(preloadType)
  if preloadType == 3 then
    PveUnitViewUtil.PreloadHpBar(100)
  elseif preloadType == 2 then
    PveUnitViewUtil.PreloadHpBar(50)
  else
    PveUnitViewUtil.PreloadHpBar(10)
  end
end

function SkyBattleLogic:TryCheatCheck()
  if self.data and self.param and self.param.cheatCheck then
    self.toCheatExit = true
  end
end

function SkyBattleLogic:TryMonsterCheatCheck(monsterId, initHp)
  if self.data and self.param and self.param.cheatCheck then
    SFSNetwork.SendMessage(MsgDefines.CheckActivityFeatureMonster, monsterId, initHp)
  end
end

function SkyBattleLogic:DelayParkourBattleStart()
  if self.delayBattleStartTimer then
    self.delayBattleStartTimer:Stop()
  end
  self.delayBattleStartTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.delayBattleStartTimer = nil
    self:OnParkourBattleStart()
  end, 0.4)
end

function SkyBattleLogic:OnParkourBattleStart()
  self.heroStatisticalData = {
    makeDmg = {},
    takeDmg = {},
    death = {}
  }
  if self.team then
    self.team:OnStartBattle(not self.auto)
    local heroes = self.team.teamUnits
    for _, hero in pairs(heroes) do
      local uuId = hero.hero.uuid
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuId)
      if heroData ~= nil or hero.hero.fromTemplate then
        self.heroStatisticalData.makeDmg[uuId] = 0
        self.heroStatisticalData.takeDmg[uuId] = 0
        self.heroStatisticalData.death[uuId] = false
      end
      hero:SetInitUnit()
    end
  end
  self.weaponStatisticalData = {makeDmg = 0, takeDmg = 0}
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.SkyBattleMain) then
    local param = {}
    
    local function onOpen()
      if self.mainUI then
        self.mainUI:ShowWinCondition(function()
        end, self.data.hideTitle)
        self:ReadyGo()
      end
    end
    
    param.onOpen = onOpen
    UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
    self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.SkyBattleMain).View
  else
    self:ReadyGo()
  end
  self.delaySound = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWSoundManager:PlaySound(10036)
  end, SoundDelayTime)
end

function SkyBattleLogic:ReadyGo()
  self.movedZDistance = 0
  self.sceneMovedZDistance = 0
  self.sceneEffectMovedZDistance = 0
  self.firstSceneEffectShow = true
  self.gameStartShowFastZMoveSpeed = self.data.sceneSpeedZ * 20
  self.gameStartShowFastZMoveTotalTime = (self.sceneEffectHeadOffsetZ + self.sceneEffectHeadSize) * 0.5 / math.max(0.1, self.gameStartShowFastZMoveSpeed)
  self.gameStartFastZMoveSpeed2NormalZSpeedFactor = (self.data.sceneSpeedZ - self.gameStartShowFastZMoveSpeed) / gameStartFastZMoveSpeed2NormalZSpeedTotalTime
  self.useTime = 0
  self.killNum = 0
  self.gameStartShowFinish = false
  self:ChangeStage(Const.ParkourBattleState.Ready)
  self.battleMgr:SetGameStart(true)
  local soundBgm = tonumber(self.data.meta.sound_id_bgm) or 0
  if not soundBgm or soundBgm <= 0 then
    Logger.LogError("\232\183\145\233\133\183\229\133\179\229\141\161bgm\228\184\186\231\169\186\239\188\140levelId=" .. self.data.meta.id)
  else
    CommonUtil.ClearGameBgMusicData()
    DataCenter.LWSoundManager:PlayMusicById(self.data.meta.sound_id_bgm, true)
    if not string.IsNullOrEmpty(self.data.meta.bgm_1) then
      self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(tonumber(self.data.meta.bgm_1), true, true)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_start, {
    self.data.battleType,
    self.data.metaId
  })
end

function SkyBattleLogic:OnUpdatePause(deltaTime)
  if not self.initComplete then
    return
  end
  EffectViewUtil.Update(deltaTime)
  ProfilerUtil.BeginSample("UnitViewLoaded")
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded()
      end
    end
  end
  ProfilerUtil.EndSample()
end

function SkyBattleLogic:OnUpdate()
  local deltaTime = Time.deltaTime
  if self.battleFsm and self.battleFsm:GetCurState() then
    self.battleFsm:GetCurState():OnUpdate(deltaTime)
  end
  self:UpdateSceneMove()
  self:UpdateSceneEffectMove()
  local screenCenterX, screenCenterY, screenCenterZ = self:GetCurScreenCenterWorldPositionXYZ()
  local movedScreenCenterZ = screenCenterZ + self:GetMovedZDistance()
  EffectViewUtil.Update(deltaTime)
  ProfilerUtil.BeginSample("UnitViewLoaded")
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded()
      end
    end
  end
  ProfilerUtil.EndSample()
  if self.userCollider2D then
    PvePhysicsUtil.UpdateCollider()
  end
  ProfilerUtil.BeginSample("BulletManagerUpdate")
  if not self:IsBattleFinish() then
    self.bulletManager:OnUpdate()
  end
  ProfilerUtil.EndSample()
  if self.damageTextMgr then
    self.damageTextMgr:OnUpdate()
  end
  if self.battleFsm then
    self.battleFsm:OnUpdate(deltaTime)
  end
  if self.fingerDown then
    self:OnFingerHold(deltaTime)
  end
  ProfilerUtil.BeginSample("MonsterManagerUpdate")
  if self.monsterMgr ~= nil and not self:IsBattleFinish() then
    self.monsterMgr:Update(movedScreenCenterZ, screenCenterZ, deltaTime)
  end
  ProfilerUtil.EndSample()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PveUnitViewUtil.CreateUnitViewList()
    PveUnitViewUtil.CreateHpBarList()
  end
  ProfilerUtil.BeginSample("TeamUpdate")
  self.team:Update(deltaTime)
  ProfilerUtil.EndSample()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PveUnitViewUtil.CreateUnitViewList()
    PveUnitViewUtil.CreateHpBarList()
  end
  if not self.battleMgr:IsPlayingShakeCamera() then
    self:UpdateCameraFollow(deltaTime)
  end
  self.tmpStraightBulletTarget = nil
  if self.winToRemoveEffect then
    self.winToRemoveEffect = false
    if self.bulletManager then
      self.bulletManager:ResetData()
    end
    if self.monsterMgr then
      self.monsterMgr:HideAllMonsterHpBar()
    end
    EffectViewUtil.ClearAll()
  end
  PveUnitViewUtil.UpdateHpBar()
  if self.toCheatExit then
    self.toCheatExit = nil
    self:NoticeLose()
    self.battleMgr:Exit(nil, "lose")
    UIUtil.ShowTipsId("activity_breakthrough_tips_54")
  end
end

function SkyBattleLogic:GetMovedZDistance()
  return self.movedZDistance
end

function SkyBattleLogic:UpdateGameStartShow(deltaTime)
  self.sceneEffectSpeedZ = self.data.sceneSpeedZ
  if self.gameStartKeepFastZRemainTime > 0 then
    self.gameStartKeepFastZRemainTime = self.gameStartKeepFastZRemainTime - deltaTime
    self.sceneEffectSpeedZ = self.gameStartShowFastZMoveSpeed
  end
  if self.gameStartKeepFastZRemainTime <= 0 and 0 < self.gameStartFastZ2NormalZRemainTime then
    self.gameStartFastZ2NormalZRemainTime = self.gameStartFastZ2NormalZRemainTime - deltaTime
    if 0 < self.gameStartFastZ2NormalZRemainTime then
      self.sceneEffectSpeedZ = self.data.sceneSpeedZ - self.gameStartFastZMoveSpeed2NormalZSpeedFactor * self.gameStartFastZ2NormalZRemainTime
    end
  end
  if self.gameStartKeepFastZRemainTime <= 0 and 0 >= self.gameStartFastZ2NormalZRemainTime then
    self.gameStartShowFinish = true
  end
  return self.gameStartShowFinish
end

function SkyBattleLogic:MoveZDistanceFrame(deltaTime)
  self.movedZDistance = self.movedZDistance + self.data.moveSpeedZ * deltaTime
  self.sceneEffectMovedZDistance = self.sceneEffectMovedZDistance + self.sceneEffectSpeedZ * deltaTime
  self.sceneMovedZDistance = self.sceneMovedZDistance + self.sceneEffectSpeedZ * deltaTime
  self:TriggerCondition(Const.ParkourWinType.FinishPoint)
end

function SkyBattleLogic:OverEndLine()
  return self.movedZDistance > self.endLine
end

function SkyBattleLogic:GetMoveSpeedZ()
  return self.initMoveSpeedZ
end

function SkyBattleLogic:OnUpdateSec()
  if self.gameStartShowFinish then
    self.useTime = self.useTime + 1
    self:TriggerCondition(Const.ParkourWinType.Time)
    self:BroadcastStarConditionRefresh(BattleStarCondition.StageSuccessTime)
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

local cameraLerpFactor = 0.05

function SkyBattleLogic:UpdateCameraFollow(deltaTime)
  if self.state == Const.ParkourBattleState.Exit then
    return
  end
  local v1 = self.battleMgr:GetFollowCameraTarget()
  tmpV1:Set(v1.x, v1.y, v1.z)
  local camLeftBordX = self.cameraMoveLeftBorder
  local camRightBordX = self.cameraMoveRightBorder
  local smoothTime = 0
  local cameraFollowPosX = self.cameraFollowPosition.x
  local cameraFollowPosZ = self.cameraFollowPosition.z
  if camLeftBordX and camRightBordX then
    local teamPos = self.team:GetPosition()
    local teamPosX = teamPos.x
    cameraFollowPosX = Mathf.Clamp(teamPosX, camLeftBordX, camRightBordX)
  end
  tmpV2:Set(cameraFollowPosX, 0, v1.z)
  local hasHorDistance = true
  if math.abs(tmpV1.x - tmpV2.x) < 0.01 then
    hasHorDistance = false
    velocity.x, velocity.y, velocity.z = 0, 0, 0
  end
  local hasVerticalDistance = true
  if math.abs(tmpV1.z - cameraFollowPosZ) < 0.01 then
    hasVerticalDistance = false
  end
  if hasHorDistance or hasVerticalDistance then
    local targetPos = tmpV2
    if hasHorDistance then
      if self.battleMgr.cameraMoveType == 1 then
        smoothTime = self.battleMgr.cameraMoveFactor or normalSmoothTime
        local v
        targetPos, v = Vector3.SmoothDamp(v1, tmpV2, velocity, smoothTime)
        velocity = v
      elseif self.battleMgr.cameraMoveType == 2 then
        targetPos.x = (1 - self.battleMgr.cameraMoveFactor) * tmpV1.x + self.battleMgr.cameraMoveFactor * tmpV2.x
      end
    end
    if hasVerticalDistance then
      targetPos.z = cameraFollowPosZ
    end
    self.battleMgr:CameraFollowLookAt(targetPos)
  else
    self.battleMgr:CameraShakeUpdate()
  end
end

function SkyBattleLogic:TeamObjectActive(isShow)
  if self.team then
    self.team:SetActive(isShow)
  end
end

function SkyBattleLogic:GetGuideTimelineOffset()
  return Vector3.New(-0.4, 0, 4.7)
end

function SkyBattleLogic:OnGuideTimelineStart(timelineGO)
  local camInTimeline = timelineGO:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
  self.srcCamPos = camInTimeline.transform.position
  self.srcCamAngle = camInTimeline.transform.eulerAngles.x
  self.srcCamFov = camInTimeline.fieldOfView
  camInTimeline.enabled = false
  if self.camera then
    self.camera.transform.position = self.srcCamPos
    self.camera.transform.eulerAngles = Vector3.New(self.srcCamAngle, 0, 0)
    self.camera.fieldOfView = self.srcCamFov
  end
end

function SkyBattleLogic:OnBattleWin()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.monsterMgr then
    self.monsterMgr:SetGamePause(true)
  end
  self:ChangeStage(Const.ParkourBattleState.PreExit)
end

function SkyBattleLogic:OnBattleLose()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  self.loseToShowVideo = false
  self.loseToShowVideoURL = nil
  if self.param.levelId then
    local failTimesKey = string.format("%s%d", SettingKeys.STAGE_FEATURE_FAIL_PREFIX, self.param.levelId)
    local recordedFailTimes = CommonUtil.PlayerPrefsGetInt(failTimesKey, 0)
    recordedFailTimes = recordedFailTimes + 1
    CommonUtil.PlayerPrefsSetInt(failTimesKey, recordedFailTimes)
    if self.data.videoRaiseUpFailTimes and recordedFailTimes >= self.data.videoRaiseUpFailTimes and self.data.youtubeLinkURL then
      self.loseToShowVideo = true
      self.loseToShowVideoURL = self.data.youtubeLinkURL
    end
    self.suggest_herolv = self.data.suggest_herolv
  end
  if self.monsterMgr then
    self.monsterMgr:SetGamePause(true)
  end
  self:ChangeStage(Const.ParkourBattleState.Lose)
end

function SkyBattleLogic:GetPlayerPosZ()
  if not self.initComplete then
    return self.data.initPosY
  end
  return self.team:GetPositionZ()
end

function SkyBattleLogic:ShakeCameraWithParam(param)
  self.battleMgr:ShakeCameraWithParam(param)
end

function SkyBattleLogic:DoVibration(intensity, sharpness, duration)
  if self.highQualityMode then
    self.battleMgr:DoVibration(intensity, sharpness, duration)
  end
end

function SkyBattleLogic:DealDamage(params)
  ProfilerUtil.BeginSample("BulletCalculateDamage")
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
  local exType = params.exType
  local exValue = params.exValue
  local isCritical = params.isCritical
  local isSplash = params.isSplash
  local hurt = 0
  local critical = false
  local isMiss = false
  local nakedDmg = 0
  if defender.ignoreDamage then
    hurt = 1
  else
    hurt, critical, isMiss, nakedDmg = PveUtil.CalculateDamage(attacker, defender, bulletMeta.damage_type, damageMultiplier, exType, exValue, isCritical, bulletMeta.percent_damage)
  end
  local isReach, limitHurt = self:CheckIsReachSkillDamageLimit(defender, skill, hurt)
  if isReach then
    hurt = limitHurt
  end
  ProfilerUtil.EndSample()
  if isMiss then
    self:ShowDamageText(hurt, hitPoint, DamageTextType.Miss, bulletMeta.damage_type, isCritical)
    return
  end
  if hurt <= 0 then
    return
  end
  ProfilerUtil.BeginSample("BulletDefenderBeAttack")
  defender:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("BulletDefenderAfterBeAttack")
  defender:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
  ProfilerUtil.EndSample()
  if defender.ignoreDamage then
    return
  end
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
  if rootAttacker and 0 < hurt and self.heroStatisticalData.makeDmg[rootAttacker.uuid] then
    self.heroStatisticalData.makeDmg[rootAttacker.uuid] = self.heroStatisticalData.makeDmg[rootAttacker.uuid] + hurt
  end
  if rootDefender and 0 < nakedDmg and self.heroStatisticalData.takeDmg[rootDefender.uuid] then
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
    if skill and not skill:IsNormalAttack() then
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

function SkyBattleLogic:DealMemberDie(hero)
  self.team:RemoveMember(hero)
  if self.team:GetMemberCount() < 1 and self.battleFsm and self.battleFsm:GetCurState() then
    self.battleFsm:GetCurState():OnMemberAllDied()
  end
end

function SkyBattleLogic:OnMemberDeath(unit)
  if unit and unit.initUnit then
    self.initUnitDeath = true
    if unit.hero and unit.hero.uuid then
      self.heroStatisticalData.death[unit.hero.uuid] = true
    end
  end
  if self.team:GetMemberCount() < 1 and self.battleFsm and self.battleFsm:GetCurState() then
    self.battleFsm:GetCurState():OnMemberAllDied()
  end
end

function SkyBattleLogic:ShowDamageText(damage, position, style, damageType, isCritical, time)
  if not self.damageTextMgr then
    return
  end
  local param = self.damageTextMgr:GetParam()
  param.damage = damage
  param.position = position
  param.style = style
  param.damageType = damageType
  param.isCritical = isCritical
  param.time = time
  self.damageTextMgr:GenText(param)
end

function SkyBattleLogic:ShowBuffText(txt, position, isDebuff, iconPath, time)
  if not self.damageTextMgr then
    return
  end
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

function SkyBattleLogic:Destroy()
  PostEventLog.Track(PostEventLog.Defines.BattleSkyBattleExit, {
    stageId = tostring(self.param.levelId)
  })
  self:RemoveListener(EventId.OpenUI)
  self:RemoveListener(EventId.LWBattleBuffStart)
  self:RemoveListener(EventId.LWBattleBuffEnd)
  if self.delayBattleStartTimer then
    self.delayBattleStartTimer:Stop()
    self.delayBattleStartTimer = nil
  end
  if self.teamGameStartShowSeq then
    self.teamGameStartShowSeq:Kill()
    self.teamGameStartShowSeq = nil
  end
  self.teamInited = false
  self.sceneInitedComplete = false
  self.gameStartShowFinish = false
  self.userCollider2D = false
  PvePhysicsUtil.ExitBattle()
  if self.battleFsm then
    self.battleFsm:Delete()
    self.battleFsm = nil
  end
  if self.delayEvents then
    for _, v in pairs(self.delayEvents) do
      v:Stop()
    end
    self.delayEvents = {}
  end
  self:UnInitCamera()
  self.touchCamera = nil
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  if self.team then
    self.team:Destroy()
    self.team = nil
  end
  if self.monsterMgr then
    self.monsterMgr:Destroy()
    self.monsterMgr = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Destroy()
    self.damageTextMgr = nil
  end
  EffectViewUtil.UnInitView()
  PveUnitViewUtil.UnInitView()
  self.sceneAnims = nil
  self.sceneAssetLoaded = false
  self.sceneTotalLength = 0
  self.sceneRoots = nil
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
  self.sceneEffectFirstRoot = nil
  self.recycleSceneEffectRoots = nil
  self.recycleEffectSceneTotalLength = 0
  self.sceneEffectHeadSize = 0
  self.finishedSceneEffect = 0
  self.sceneEffectAssetLoaded = false
  if self.sceneEffectLoadRequest then
    for _, sceneEffectReq in pairs(self.sceneEffectLoadRequest) do
      sceneEffectReq:Destroy()
    end
    self.sceneEffectLoadRequest = nil
  end
  if self.sceneExtReq then
    self.sceneExtReq:Destroy()
    self.sceneExtReq = nil
  end
  if self.sceneLightReq then
    self.sceneLightReq:Destroy()
    self.sceneLightReq = nil
  end
  self.heroStatisticalData = nil
  self.weaponStatisticalData = nil
  self.heroIdReplaceSkillMap = nil
  self.heroIdReplaceAppearanceMap = nil
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
  self:ClearFlyNodeData()
  self.hitWhiteMPB = nil
  self.MPB = nil
  self.toCheatExit = nil
  if self.battleEffectTimer then
    self.battleEffectTimer:Stop()
    self.battleEffectTimer = nil
  end
end

function SkyBattleLogic:AfterExit()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SkyBattleMain, {anim = false})
  self.mainUI = nil
end

function SkyBattleLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function SkyBattleLogic:RemoveUnit(guid)
  self.unitMgr:RemoveUnitById(guid)
end

function SkyBattleLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function SkyBattleLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function SkyBattleLogic:ShowEffectObj(path, pos, rot, time, parent, type)
  if string.IsNullOrEmpty(path) then
    return
  end
  type = type == EffectObjType.Sprite and 1 or 0
  time = time or 1
  if pos == nil and rot == nil then
    return EffectViewUtil.ShowEffectOnlyParent(path, time, type, parent)
  elseif pos == nil then
    return EffectViewUtil.ShowEffectZeroPos(path, time, type, rot, parent)
  elseif rot == nil then
    return EffectViewUtil.ShowEffectZeroRot(path, time, type, pos, parent)
  else
    return EffectViewUtil.ShowEffect(path, time, type, pos, rot, parent)
  end
end

function SkyBattleLogic:ShowHitEffectForViewTarget(path, worldPos, worldHitDir, hitDirType, time, parentViewHandle)
  local type = 0
  time = time or 1
  hitDirType = hitDirType or 1
  EffectViewUtil.ShowHitEffectForViewTarget(path, worldPos, worldHitDir, hitDirType, time, parentViewHandle, type)
end

function SkyBattleLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function SkyBattleLogic:OnMonsterDeath(monster)
  if self.battleMgr.gameOver then
    return
  end
  if monster.isCmpMonster then
    return
  end
  if monster:GetIsCountKillNum() then
    self.killNum = self.killNum + 1
    self:TriggerCondition(Const.ParkourWinType.KillMonster, monster)
  end
end

function SkyBattleLogic:OnOpenUI(name)
end

function SkyBattleLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function SkyBattleLogic:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function SkyBattleLogic:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function SkyBattleLogic:OnBuffChange()
  if not self.team then
    return
  end
  self.team.moveSpeedDirty = true
  self.team.moveSpeedZDirty = true
  self.team.superArmorDirty = true
end

function SkyBattleLogic:GetStageId()
  return self.data.meta.id
end

function SkyBattleLogic:GetTotalKill()
  return self.killNum
end

function SkyBattleLogic:GetCostTime()
  return self.useTime
end

function SkyBattleLogic:GetAvgFPS()
  if self.useTime == 0 then
    return -1
  end
  return (Time.frameCount - self.startFrame) / self.useTime
end

function SkyBattleLogic:GetLowestFPS()
  return math.min(self.lowestFps, self:GetAvgFPS())
end

function SkyBattleLogic:GetRemainUnitCount()
  if self.team then
    return self.team:GetRemainUnitCount()
  end
  return -1
end

function SkyBattleLogic:RecordGoods(goodsId, goodsCount)
  if not self.goods[goodsId] then
    self.goods[goodsId] = 0
  end
  self.goods[goodsId] = self.goods[goodsId] + goodsCount
end

function SkyBattleLogic:GetGoods()
  return self.goods
end

function SkyBattleLogic:CheckToShowWinResult()
  self:NoticeWin()
  self:AddDelayEvent(function()
    if self.battleMgr then
      self.battleMgr:SetGameOver(true)
    end
  end, 4)
end

function SkyBattleLogic:CheckToShowLoseResult()
  local param = {}
  param.time = self.useTime
  param.kill = self.killNum
  param.stageId = self.data.meta.id
  param.extraData = self.param.extraData
  param.enterType = self.param.enterType
  param.fromChapter = self.param.fromChapter
  param.growthMode = self.param.growthMode
  param.loseToShowVideo = self.loseToShowVideo
  param.loseToShowVideoURL = self.loseToShowVideoURL
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISkyBattleLose, {anim = false, playEffect = 10023}, param)
  PostEventLog.Track(PostEventLog.Defines.BattleSkyBattleFailed, {
    stageId = tostring(self.param.levelId)
  })
end

function SkyBattleLogic:ChangeStage(newStage)
  local changeSuccess = self.battleFsm:ChangeState(newStage, newStage)
  if changeSuccess then
    self.state = newStage
  end
end

function SkyBattleLogic:GetGoldCount()
  local goods = self:GetGoods()
  if goods and goods[2] then
    return goods[2]
  end
end

function SkyBattleLogic:IsBattleFinish()
  return self.state >= Const.ParkourBattleState.PreExit
end

function SkyBattleLogic:NoticeWin()
  EventManager:GetInstance():Broadcast(EventId.SkyBattleWin, self.data.meta.id)
  EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_win, self.data.meta.id)
  local param = {}
  param.stageId = self.data.meta.id
  param.enterType = self.param.enterType
  param.kill = self.killNum
  param.time = self.useTime
  param.fromChapter = self.param.fromChapter
  param.growthMode = self.param.growthMode
  if self.param.fromChapter then
    param.stageStarConditionMeet = {}
    local starConditions = self:GetStarCondition()
    local defaultStar = 3
    if starConditions then
      local checkMatchCount = 0
      for i, condition in ipairs(starConditions) do
        if self:CheckStarConditionMatch(condition.type, condition.value) then
          checkMatchCount = checkMatchCount + 1
          param.stageStarConditionMeet[i] = true
        end
      end
      defaultStar = checkMatchCount
    end
    param.stageStarCounts = defaultStar
    if self.param.growthMode then
      SFSNetwork.SendMessage(MsgDefines.LwSaveSkyBattleUpgradeStage, self.data.meta.id, true, defaultStar)
    else
      SFSNetwork.SendMessage(MsgDefines.LwSaveSkyBattleStage, self.data.meta.id, true, defaultStar)
    end
  elseif self.param.enterType == PVEEnterType.Radar then
    SFSNetwork.SendMessage(MsgDefines.LwSaveDetectPlaneStage, self.data.meta.id, true, self.param.detectUuid)
  elseif self.param.enterType == PVEEnterType.Monopoly then
    SFSNetwork.SendMessage(MsgDefines.LwSavePlaneStage, self.data.meta.id, true)
  elseif self.param.enterType == PVEEnterType.CityBuilding then
    SFSNetwork.SendMessage(MsgDefines.LwSavePlaneStage, self.data.meta.id, true)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISkyBattleWin, {anim = false, playEffect = 10024}, param)
  PostEventLog.Track(PostEventLog.Defines.BattleSkyBattleSuccess, {
    stageId = tostring(self.param.levelId)
  })
end

function SkyBattleLogic:NoticeLose()
  EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_lose, self.data.meta.id)
end

function SkyBattleLogic:GetInitPos()
  return Vector3(self.data.initPosX, 0, self.data.initPosY)
end

function SkyBattleLogic:GetPVEType()
  return PVEType.SkyBattle
end

function SkyBattleLogic:GetSquadMemberPosition()
  if self.team then
    return self.team:ReturnMemberPositions()
  end
  return {}
end

function SkyBattleLogic:ResetHeroPos()
  if self.team then
    self.team:ResetHeroPosition()
  end
end

function SkyBattleLogic:SetHeroers(heroes)
  if self.team then
    self.team:ChangeHeroes(heroes)
  end
end

function SkyBattleLogic:SetHeroPos(index, worldPos)
  if self.team then
    self.team:SetHeroPosition(index, worldPos)
  end
end

function SkyBattleLogic:HeroMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.5
  if self.team then
    self.team:MoveHeroToIndex(index, dstIndex, animTime)
  end
end

function SkyBattleLogic:SummonMonster(pos, owner, monsterId, count, hpPercent)
  if owner then
    local maxBlood = owner.maxBlood
    maxBlood = maxBlood * hpPercent
    self.monsterMgr:Summon(pos, monsterId, count, maxBlood, owner.meta)
  end
end

function SkyBattleLogic:SummonMonsterBatch(startPos, monsterId, count, posOffset, hp, monsterMeta)
  self.monsterMgr:SummonBatch(startPos, monsterId, count, posOffset, hp, monsterMeta)
end

function SkyBattleLogic:RangeSummonMonster(owner, monsterId, count, hpPercent, distanceZ, r1, r2)
  if owner then
    local pos = owner:GetPosition()
    local targetPos = pos + Vector3(0, 0, distanceZ)
    local maxBlood = owner.maxBlood
    maxBlood = maxBlood * hpPercent
    self.monsterMgr:RangeSummon(targetPos, r1, r2, monsterId, count, maxBlood, owner.meta)
  end
end

function SkyBattleLogic:SummonTriggerItem(pos, owner, triggerItemId, count, castType)
  if owner then
    self.monsterMgr:SummonTriggerItem(pos, triggerItemId, count, owner.meta, castType)
  end
end

function SkyBattleLogic:RangeSummonTriggerItem(owner, triggerItemId, count, distanceZ, r1, r2, castType)
  if owner then
    local pos = owner:GetPosition()
    local targetPos = pos + Vector3(0, 0, distanceZ)
    self.monsterMgr:RangeSummonTriggerItem(targetPos, r1, r2, triggerItemId, count, owner.meta, castType)
  end
end

function SkyBattleLogic:GetRandomInitUuid()
  if self.team then
    return self.team:GetRandomInitUuid()
  end
  return 0
end

function SkyBattleLogic:GetInitUuidAuto(index)
  if self.team then
    return self.team:GetInitUuidAuto(index)
  end
  return 0
end

function SkyBattleLogic:GetHitWhiteMPB()
  if IsNull(self.hitWhiteMPB) then
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    mpb:Clear()
    mpb:SetFloat("_OnHit", 1)
    self.hitWhiteMPB = mpb
  end
  return self.hitWhiteMPB
end

function SkyBattleLogic:AddMember(heroId, heroLevel, showBornTween)
  if self.team then
    if self.param.growthMode and heroId == self.parkourDoorHeroId then
      local teamMemberUnitCount = self.team.teamUnitCount - 1
      local curPlaneMemberMaxCount = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.MemberNum)
      if teamMemberUnitCount >= curPlaneMemberMaxCount then
        return
      end
      local curPlaneMaxHP = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.HP)
      local curPlaneMaxAttack = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.Attack)
      local curPlaneMemberPropertyPercent = DataCenter.LWSkyBattleGrowthChapterManager:GetPropertyValue(SkyBattleEquipType.MemberPropPercent)
      local finalHp = curPlaneMaxHP * curPlaneMemberPropertyPercent / 10000
      local finalAttack = curPlaneMaxAttack * curPlaneMemberPropertyPercent / 10000
      local properties = {}
      local propertyHp = {
        key = HeroEffectDefine.HealthPoint,
        value = finalHp
      }
      table.insert(properties, propertyHp)
      local propertyAttack = {
        key = HeroEffectDefine.PhysicalAttack,
        value = finalAttack
      }
      table.insert(properties, propertyAttack)
      local propertyHpResult = {
        key = HeroEffectDefine.HealPoint_Result,
        value = finalHp
      }
      table.insert(properties, propertyHpResult)
      local propertyAttackResult = {
        key = HeroEffectDefine.PhysicalAttack_Result,
        value = finalAttack
      }
      table.insert(properties, propertyAttackResult)
      self.team:AddMember(heroId, heroLevel, properties, nil, showBornTween)
    else
      self.team:AddMember(heroId, heroLevel, nil, nil, showBornTween)
    end
  end
end

function SkyBattleLogic:GetReplaceNormalSkill(heroId)
  if self.heroIdReplaceSkillMap and self.heroIdReplaceSkillMap[heroId] then
    return self.heroIdReplaceSkillMap[heroId]
  end
  return 0
end

function SkyBattleLogic:GetReplaceAppearance(heroId)
  if self.heroIdReplaceAppearanceMap and self.heroIdReplaceAppearanceMap[heroId] then
    return self.heroIdReplaceAppearanceMap[heroId]
  end
  return 0
end

function SkyBattleLogic:ReplaceHeroUuidNormalAttack(param, heroUuid, skillId)
  if self.team then
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta == nil then
      Logger.LogError("[ReplaceHeroUuidNormalAttack]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
    end
    local heroes = self.team.teamUnits
    local gain_effect = param.gain_effect
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.uuid and hero.hero.uuid == heroUuid then
          local succeed = hero.skillManager:ReplaceNormalAttack(skillMeta)
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
          break
        end
      end
    end
  end
end

function SkyBattleLogic:ReplaceHeroIdNormalAttack(param, heroId, skillId, init)
  if self.team then
    if not init then
      if self.heroIdReplaceSkillMap == nil then
        self.heroIdReplaceSkillMap = {}
      end
      self.heroIdReplaceSkillMap[heroId] = skillId
    end
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta == nil then
      Logger.LogError("[ReplaceHeroIdNormalAttack]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
    end
    local addSuccess = false
    local gain_effect = param.gain_effect
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceNormalAttack(skillMeta)
          addSuccess = succeed
          if succeed and not init and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
    if addSuccess then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleWeaponUpgradeNotice)
    end
  end
end

function SkyBattleLogic:ReplaceHeroIdAppearance(param, heroId, newHeroId)
  if self.team then
    if self.heroIdReplaceAppearanceMap == nil then
      self.heroIdReplaceAppearanceMap = {}
    end
    self.heroIdReplaceAppearanceMap[heroId] = newHeroId
    local gain_effect = param.gain_effect
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          hero:ReplaceAppearance(newHeroId)
          if not string.IsNullOrEmpty(gain_effect) and hero.transform then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
  end
end

function SkyBattleLogic:AddHeroUuidEnergy(param, extra)
  local heroUuid, fromPos
  if type(extra) == "table" then
    heroUuid = extra.extra
    fromPos = extra.fromPos
  else
    heroUuid = extra
  end
  local gain_effect = param.gain_effect
  if self.team then
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.uuid and hero.hero.uuid == heroUuid then
          hero:AddEnergy(fromPos)
          if not string.IsNullOrEmpty(gain_effect) and hero.transform then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
  end
end

function SkyBattleLogic:AddHeroUuidSkill(param, heroUuid, skillId)
  local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if skillMeta == nil then
    Logger.LogError("[AddHeroUuidSkill]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
  end
  local gain_effect = param.gain_effect
  local heroes = self.team.teamUnits
  if heroes then
    for _, hero in pairs(heroes) do
      if hero.hero and hero.hero.uuid and hero.hero.uuid == heroUuid then
        hero.skillManager:AddSkill(skillMeta)
        if not string.IsNullOrEmpty(gain_effect) then
          DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
        end
      end
    end
  end
end

function SkyBattleLogic:AddHeroIdSkill(param, heroId, skillId)
  local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if skillMeta == nil then
    Logger.LogError("[AddHeroIdSkill]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
  end
  local gain_effect = param.gain_effect
  local heroes = self.team.teamUnits
  local addSuccess = false
  if heroes then
    for _, hero in pairs(heroes) do
      if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
        hero.skillManager:AddSkill(skillMeta)
        addSuccess = true
        if not string.IsNullOrEmpty(gain_effect) then
          DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
        end
      end
    end
  end
  if addSuccess then
    UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleWeaponUpgradeNotice, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

function SkyBattleLogic:ReplaceHeroIdNormalBullet(param, heroId, bulletId)
  if self.team then
    local heroes = self.team.teamUnits
    local gain_effect = param.gain_effect
    local addSuccess = false
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceNormalBullet(bulletId)
          addSuccess = succeed
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
    if addSuccess then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleWeaponUpgradeNotice, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    end
  end
end

function SkyBattleLogic:ReplaceHeroIdActiveBullet(param, heroId, bulletId)
  if self.team then
    local heroes = self.team.teamUnits
    local gain_effect = param.gain_effect
    local addSuccess = false
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceActiveBullet(bulletId)
          addSuccess = succeed
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            self:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
    if addSuccess then
      UIManager:GetInstance():OpenWindow(UIWindowNames.SkyBattleWeaponUpgradeNotice, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
    end
  end
end

function SkyBattleLogic:FlyNodeToTeam(request, eventId, extra)
  if not self.team then
    self:TriggerFlyNode(eventId, extra)
    return
  end
  local teamTrans = self.team.transform
  if not teamTrans then
    self:TriggerFlyNode(eventId, extra)
    return
  end
  local go = request.gameObject
  if IsNull(go) then
    self:TriggerFlyNode(eventId, extra)
    return
  end
  local transform = go.transform
  transform:SetParent(teamTrans)
  local from = Vector3.New()
  from.x, from.y, from.z = transform:Get_localPosition()
  local to = Vector3.New(0, 2, 0)
  local renders = {}
  local skinnedMeshRenderer = go:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local meshRenderer = go:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
  if skinnedMeshRenderer then
    local length = skinnedMeshRenderer.Length
    for i = 0, length - 1 do
      table.insert(renders, skinnedMeshRenderer[i])
    end
  end
  if meshRenderer then
    local length = meshRenderer.Length
    for i = 0, length - 1 do
      table.insert(renders, meshRenderer[i])
    end
  end
  if IsNull(self.MPBColor) then
    local intensity = 0
    intensity = Mathf.Pow(2, intensity)
    local color = CS.UnityEngine.Color(1.0 * intensity, 0.7215686274509804 * intensity, 0 / 255 * intensity, 0)
    self.MPBColor = color
  end
  if IsNull(self.MPB) then
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    mpb:Clear()
    mpb:SetFloat("_OnOutlineRim", 1)
    mpb:SetFloat("_OutlineRimPower", 2)
    mpb:SetFloat("_OutlineRimRange", 0.5)
    mpb:SetColor("_OutlineRimeColor", self.MPBColor)
    self.MPB = mpb
  end
  for _, v in ipairs(renders) do
    v:SetPropertyBlock(self.MPB)
  end
  if self.flyNodeDataList == nil then
    self.flyNodeDataList = {}
    self.flyNodeDataIndex = 0
  end
  self.flyNodeDataIndex = self.flyNodeDataIndex + 1
  local curIndex = self.flyNodeDataIndex
  local control = Vector3.New(from.x / 2, from.y + 7, from.z / 2)
  local path = {
    to,
    control,
    control
  }
  local tween = transform:DOLocalPath(path, 0.5, CS.DG.Tweening.PathType.CubicBezier, CS.DG.Tweening.PathMode.Ignore, 10, Color.cyan)
  local delay = TimerManager:GetInstance():DelayInvoke(function()
    self:OnTweenFinish(curIndex)
  end, 0.5)
  local scaleX, scaleY, scaleZ = transform:Get_localScale()
  local scaleTo = Vector3.New(scaleX * 1.2, scaleY * 1.2, scaleZ * 1.2)
  local scaleEnd = Vector3.New(scaleX * 0.8, scaleY * 0.8, scaleZ * 0.8)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Append(transform:DOScale(scaleTo, 0.25))
  sequence:Append(transform:DOScale(scaleEnd, 0.25))
  local data = {}
  data.request = request
  data.tween = tween
  data.sequence = sequence
  data.delay = delay
  data.eventId = eventId
  data.extra = extra
  data.index = curIndex
  data.renders = renders
  table.insert(self.flyNodeDataList, data)
end

function SkyBattleLogic:TriggerFlyNode(eventId, extra)
  if not self.team then
    return
  end
  if not self.triggerEventMgr then
    return
  end
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta and meta.isUnAddEnergyType then
      self.triggerEventMgr:Trigger(meta.type, meta, extra)
    end
  end
end

function SkyBattleLogic:GetParkourRushX()
  local rushX = Const.ParkourSceneCenter
  if self.data.soliderRushValue then
    rushX = self.data.soliderRushValue
  end
  return rushX
end

function SkyBattleLogic:OnTweenFinish(index)
  if self.flyNodeDataList then
    local findIndex = 0
    for i, data in ipairs(self.flyNodeDataList) do
      if data and data.index == index then
        findIndex = i
        self:ClearOneFlyNodeData(data)
        self:TriggerFlyNode(data.eventId, data.extra)
        break
      end
    end
    if 0 < findIndex then
      table.remove(self.flyNodeDataList, findIndex)
    end
  end
end

function SkyBattleLogic:ClearOneFlyNodeData(data)
  if data then
    if data.tween then
      data.tween:Kill()
      data.tween = nil
    end
    if data.sequence then
      data.sequence:Kill()
      data.sequence = nil
    end
    if data.delay then
      data.delay:Stop()
      data.delay = nil
    end
    if data.renders then
      for _, v in ipairs(data.renders) do
        v:SetPropertyBlock(nil)
      end
      data.renders = nil
    end
    if data.request then
      data.request:Destroy()
      data.request = nil
    end
  end
end

function SkyBattleLogic:ClearFlyNodeData()
  if self.flyNodeDataList then
    for _, data in ipairs(self.flyNodeDataList) do
      self:ClearOneFlyNodeData(data)
    end
    self.flyNodeDataList = nil
  end
end

function SkyBattleLogic:GetFreezeXAxisMoveMinDistance()
  return self.data.monsterAttackRange
end

function SkyBattleLogic:GetFreezeXAxisMoveMinDistanceSquare()
  return self.data.monsterAttackRangeSquare
end

function SkyBattleLogic:TriggerCondition(conditionType, param)
  if self.battleFsm and self.battleFsm:GetCurState() then
    self.battleFsm:GetCurState():TriggerCondition(conditionType, param)
  end
end

function SkyBattleLogic:CheckWinConditionsMet(conditionType, param)
  if not conditionType then
    return false
  end
  local curTypeCondition = self:GetWinConditionDataByWinType(conditionType)
  if not curTypeCondition then
    return false
  end
  if conditionType == Const.ParkourWinType.FinishPoint then
    self:BroadcastParkourWinConditionRefresh(conditionType)
    if self.movedZDistance > self.endLine then
      return true
    end
  elseif conditionType == Const.ParkourWinType.Time then
    self:BroadcastParkourWinConditionRefresh(conditionType)
    if self.useTime >= curTypeCondition.needTime then
      return true
    end
  elseif conditionType == Const.ParkourWinType.KillMonster then
    self:BroadcastParkourWinConditionRefresh(conditionType)
    if self.killNum >= curTypeCondition.needKillNum then
      return true
    end
  end
  return false
end

function SkyBattleLogic:GetCheckWinConditions()
  return self.winConditions
end

function SkyBattleLogic:GetWinConditionDataByWinType(winType)
  return self.winConditions[winType]
end

function SkyBattleLogic:SetJoystick(joystick)
  joystick:SetActive(false)
end

function SkyBattleLogic:BroadcastParkourWinConditionRefresh(winType)
  EventManager:GetInstance():Broadcast(EventId.ParkourWinConditionRefresh, winType)
end

function SkyBattleLogic:BroadcastStarConditionRefresh(starConditionType)
  local conditions = self:GetStarCondition()
  for i, condition in ipairs(conditions) do
    if condition.type == starConditionType then
      EventManager:GetInstance():Broadcast(EventId.ParkourMainStarConditionRefresh, condition)
    end
  end
end

function SkyBattleLogic:CheckIsReachSkillDamageLimit(defender, skill, hurt)
  if not (defender and defender.singleDamageLimitPercent) or defender.singleDamageLimitPercent <= 0 or not skill then
    return false
  end
  local maxDamage = defender:GetMaxBlood() * defender.singleDamageLimitPercent
  if skill and 0 < maxDamage then
    skill:SetDamageLimit(maxDamage)
  end
  local isReach, limitHurt = skill:CheckIsReachDamageLimit(hurt)
  return isReach, limitHurt
end

function SkyBattleLogic:SetGamePause(pause)
  if self.flyNodeDataList then
    for _, data in ipairs(self.flyNodeDataList) do
      if data then
        if data.tween then
          if pause then
            data.tween:Pause()
          else
            data.tween:Play()
          end
        end
        if data.sequence then
          if pause then
            data.sequence:Pause()
          else
            data.sequence:Play()
          end
        end
        if data.delay then
          if pause then
            data.delay:Pause()
          else
            data.delay:Resume()
          end
        end
      end
    end
  end
  if self.monsterMgr then
    self.monsterMgr:SetGamePause(pause)
  end
end

function SkyBattleLogic:CheckStarConditionMatch(conditionType, value)
  if conditionType == BattleStarCondition.Success then
    return true
  elseif conditionType == BattleStarCondition.HPPercent then
    local defaultHero = self.team:GetDefaultHero()
    if not defaultHero then
      return false
    end
    local percent = defaultHero.curBlood * 10000 / defaultHero.maxBlood
    return percent > tonumber(value)
  elseif conditionType == BattleStarCondition.StageSuccessTime then
    return self.useTime <= tonumber(value)
  elseif conditionType == BattleStarCondition.MemberNum then
    return self.team.teamUnitCount >= tonumber(value) + 1
  else
    return true
  end
end

function SkyBattleLogic:PlayGameStartShow()
  self.gameStartShowFinish = false
  self:PlayGameStartTeamShow()
  self.gameStartFastZ2NormalZRemainTime = gameStartFastZMoveSpeed2NormalZSpeedTotalTime
  self.gameStartKeepFastZRemainTime = self.gameStartShowFastZMoveTotalTime
end

function SkyBattleLogic:PlayGameStartTeamShow()
  if self.teamGameStartShowSeq then
    self.teamGameStartShowSeq:Kill()
  end
  local curScreenX, curScreenY, curScreenZ = self:GetCurScreenWorldPositionWithInitX()
  self.team.transform.position = Vector3.New(self.cameraFollowPosition.x, 0, curScreenZ - self.safeTeamZMoveDelta * 1.5)
  local sequence = TweenSequence.Sequence()
  sequence:Append(self.team.transform:DOMove(self.cameraFollowPosition, self.gameStartShowFastZMoveTotalTime):SetEase(Ease.OutQuad))
  self.teamGameStartShowSeq = sequence
  self.teamGameStartShowSeq:Play()
end

function SkyBattleLogic:GetStarCondition()
  local mgr = self.param.growthMode and DataCenter.LWSkyBattleGrowthChapterManager or DataCenter.LWSkyBattleChapterManager
  return mgr:GetStageStarCondition(self.data.meta.id)
end

function SkyBattleLogic:CheckIsShowedStarCondition(type)
  if type == BattleStarCondition.StageSuccessTime then
    return true
  end
  return false
end

return SkyBattleLogic
