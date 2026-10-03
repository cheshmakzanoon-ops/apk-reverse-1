local Resource = CS.GameEntry.Resource
local Time = _ENV.Time
local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local LastStandData = require("DataCenter.LWBattle.Logic.LastStand.LastStandData")
local Const = require("Scene.LWBattle.Const")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local MonsterManager = require("Scene.LWBattle.ParkourBattle.Monster.LastStandMonsterManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")
local ParkourTeam = require("Scene.LWBattle.ParkourBattle.Team.ParkourTeam")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local BuildingManager = require("DataCenter.LWBattle.Logic.LastStand.LastStandBuilding.LastStandBuildingManager")
local TriggerEventManager = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEventManager")
local rvoObstaclePath = "Assets/Main/Prefabs/PVELevel/%s/obstacle.bytes"
local Localization = CS.GameEntry.Localization
local GuideManager = require("DataCenter.LWBattle.Logic.LastStand.LastStandGuideManager")
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local LastStandLogic = BaseClass("LastStandLogic", base)
local defaultFov = 60
local defaultHeight = 20
local defaultRotation = 45
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local XCenter = Const.ParkourSceneCenter

function LastStandLogic:Enter(param)
  self.battleMgr = DataCenter.LWBattleManager
  self.data = LastStandData.New(param.levelId)
  self.killBossNum = 0
  self.param = param
  self.levelId = param.levelId
  self.detectUuid = param.detectUuid
  self:InitRVO()
  self.__event_handlers = {}
  self.monsterMgr = MonsterManager.New()
  self.unitMgr = UnitManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.damageTextMgr = DamageTextManager.New()
  self.damageTextMgr:Init(self)
  self.buildingMgr = BuildingManager.New(self)
  self.unitGuid = 0
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.sharedHeroInfo = {}
  end
  EffectViewUtil.InitView()
  PveUnitViewUtil.InitView()
  self.triggerEventMgr = TriggerEventManager.New(self)
  self.guideManager = GuideManager.New(self, self.data.start_guide)
  self.coinNum = self.data.start_gold
  self.isBattleFinish = false
  self:AddListeners()
  self.useTime = 0
  self.enterTime = UITimeManager:GetInstance():GetServerSeconds()
  PostEventLog.Track(PostEventLog.Defines.LastStandEnterLevel, {
    levelId = self.levelId
  })
end

function LastStandLogic:AddListeners()
  self:AddListener(EventId.LastStandBuildingUpgrade, self.OnLastStandBuildingUpgrade)
  self:AddListener(EventId.LastStandBuildingFinish, self.OnLastStandBuildingFinish)
end

function LastStandLogic:RemoveListeners()
  self:RemoveListener(EventId.LastStandBuildingUpgrade, self.OnLastStandBuildingUpgrade)
  self:RemoveListener(EventId.LastStandBuildingFinish, self.OnLastStandBuildingFinish)
end

function LastStandLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function LastStandLogic:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function LastStandLogic:__delete()
  self:Destroy()
end

function LastStandLogic:Destroy()
  self:RemoveListeners()
  self:UnInitCamera()
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  if self.team then
    self.team:Destroy()
    self.team = nil
  end
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
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
  if self.buildingMgr ~= nil then
    self.buildingMgr:Destroy()
    self.buildingMgr = nil
  end
  EffectViewUtil.UnInitView()
  PveUnitViewUtil.UnInitView()
  if self.rvoMgr then
    self.rvoMgr:Destory()
    self.rvoMgr = nil
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
  if self.sceneExtReq then
    self.sceneExtReq:Destroy()
    self.sceneExtReq = nil
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.sharedHeroInfo = nil
  end
end

function LastStandLogic:OnUpdate()
  if self.isBattleFinish then
    return
  end
  local deltaTime = Time.deltaTime
  if self.touchCamera then
    local tarPos = self.touchCamera:GetCameraTargetPos()
    local viewTile = SceneUtils.WorldToTile(tarPos)
    if self.staticMgr ~= nil then
      self.staticMgr:OnUpdate(viewTile.x, viewTile.y)
    end
  end
  if self.fingerDown then
    self:OnFingerHold(deltaTime)
  end
  if self.damageTextMgr then
    self.damageTextMgr:OnUpdate()
  end
  local playerPos = self.team:GetPosition()
  if self.rvoMgr ~= nil then
    self.rvoMgr:Update(playerPos.x, playerPos.z)
  end
  self.bulletManager:OnUpdate()
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
  self.team:Update(deltaTime)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PveUnitViewUtil.CreateUnitViewList()
    PveUnitViewUtil.CreateHpBarList()
  end
  self.monsterMgr:Update(9, deltaTime)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PveUnitViewUtil.CreateUnitViewList()
    PveUnitViewUtil.CreateHpBarList()
  end
  self.buildingMgr:OnUpdate(deltaTime)
  self:UpdateCameraFollow(deltaTime)
  PveUnitViewUtil.UpdateHpBar()
  EffectViewUtil.Update(deltaTime)
  self.guideManager:OnUpdate(deltaTime)
end

function LastStandLogic:InitCamera()
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

function LastStandLogic:UnInitCamera()
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

function LastStandLogic:InitCameraParams(pos)
  local cameraParam = self:GetCameraParam()
  local height = cameraParam.height
  local fov = cameraParam.fov
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = self:GetOffsetZ(height, cameraParam.rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = 20
  self.camera.transform.eulerAngles = Vector3.New(cameraParam.rotation, 0, 0)
end

function LastStandLogic:GetCameraParam(pos)
  local fov = defaultFov
  local height = defaultHeight
  local rotation = defaultRotation
  if self.data and self.data.cameraParams and #self.data.cameraParams > 0 then
    fov = self.data.cameraParams[1]
    height = self.data.cameraParams[2]
    rotation = self.data.cameraParams[3]
    rotation = 60
  end
  local camera = {}
  camera.fov = fov
  camera.height = height
  camera.rotation = rotation
  return camera
end

function LastStandLogic:LoadScene(callBack)
  self.monsterMgr:Init(self)
  self.multipleMonsterInfo = self.monsterMgr:GetMultipleMonsterInfo()
  self.team = ParkourTeam.New(self.data.initPosX, self.data.initPosY, self, self.data.meta.default_hero, self.data:GetAppearanceMap())
  self.team.speedX = self.data.moveSpeedX
  self.team.speedZ = self.data.moveSpeedZ
  self.team:ChangeStage(Const.ParkourBattleState.Boss)
  self.team:SetTeamRadius(1)
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(3)
  local sceneCfgArr = self.data.sceneCfgArr
  self.sceneLoadRequest = {}
  self.finishedScene = 0
  self.sceneAnims = {}
  for _, sceneCfg in ipairs(sceneCfgArr) do
    local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneCfg.meta.asset), ObjectPoolTag.BattleScene)
    req:completed("+", function()
      local sceneRoot = req.gameObject.transform
      sceneRoot:Set_position(0, 0, sceneCfg.offset)
      self.finishedScene = self.finishedScene + 1
      if sceneCfg.hasAnim then
        local anim = sceneRoot:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
        if IsNotNull(anim) then
          table.insert(self.sceneAnims, anim)
        end
      end
      if self.finishedScene >= #self.data.sceneCfgArr then
        if callBack then
          callBack()
        end
        self:LoadSceneComplete()
      end
    end)
    table.insert(self.sceneLoadRequest, req)
    self.staticMgr:Append(string.format(PVEDecorationPath, sceneCfg.meta.asset), sceneCfg.offset)
    if self.data.isBlock then
      self.rvoMgr:Append(string.format(rvoObstaclePath, sceneCfg.meta.asset), sceneCfg.offset)
    end
  end
  local sceneExt = self.data.sceneExt
  if not string.IsNullOrEmpty(sceneExt) then
    self.sceneExtReq = Resource:InstantiateAsync(sceneExt, ObjectPoolTag.BattleScene)
    self.sceneExtReq:completed("+", function()
      if self.sceneExtReq.isError then
        return
      end
      local go = self.sceneExtReq.gameObject
      if go then
        go.transform:Set_localPosition(0, 0, 0)
        go:SetActive(true)
      end
    end)
  end
end

function LastStandLogic:LoadSceneComplete()
  self.initComplete = true
  local pos = Vector3.New(XCenter, 0, self.team:GetPositionZ())
  self.battleMgr:LookAt(pos)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILastStandMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, {})
  self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UILastStandMain).View
  self.battleMgr:SetGameStart(true)
  if self.team then
    local heroes = self.team.teamUnits
    for _, hero in pairs(heroes) do
      hero:SetInitUnit()
    end
    self.team:ChangeStage(Const.ParkourBattleState.Boss)
  end
  self.state = Const.ParkourBattleState.Boss
  self.buildingMgr:InitBuilding(self.data.startBuildingList, self.data.allBuildingList)
end

function LastStandLogic:GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function LastStandLogic:SetJoystick(joystick)
  self.joystick = joystick
  self:DisableJoystick()
  self:EnableJoystick()
end

function LastStandLogic:EnableJoystick()
  self.joystick:SetEnabled(true)
end

function LastStandLogic:DisableJoystick()
  if self.fingerDown then
    self.fingerDown = false
    self.joystick:Reset()
  end
  self.joystick:SetEnabled(false)
end

function LastStandLogic:IsFingerOnUI()
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

function LastStandLogic:OnFingerDownJoyStick(pos)
  self.joystick:OnFingerDown(pos)
  self.team:OnFingerDown(pos)
end

function LastStandLogic:OnFingerUpJoyStick()
  if not self.joystick then
    return
  end
  self.joystick:OnFingerUp()
  self.team:OnFingerUp()
end

function LastStandLogic:OnFingerHoldJoyStick(deltaTime)
  local vx, vz = self.joystick:OnUpdate()
  self.team:OnFingerHoldCheckObstacle(vx, vz, deltaTime)
end

function LastStandLogic:OnFingerDown(pos)
  if not (self.joystick and self.joystick:GetEnabled()) or self:IsFingerOnUI() or self:IsBattleFinish() then
    return
  end
  self.fingerDown = true
  self:OnFingerDownJoyStick(pos)
end

function LastStandLogic:OnFingerUp()
  self.fingerDown = false
  self:OnFingerUpJoyStick()
  self.team:StopHorizontalMove()
end

function LastStandLogic:OnFingerHold(deltaTime)
  self:OnFingerHoldJoyStick(deltaTime)
end

function LastStandLogic:GetStageId()
  return self.data.meta.id
end

function LastStandLogic:GetCostTime()
  return 1
end

function LastStandLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function LastStandLogic:RemoveUnit(guid)
  self.unitMgr:RemoveUnitById(guid)
end

function LastStandLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function LastStandLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function LastStandLogic:InitRVO()
  self.rvoMgr = CS.LWBattleRVOManager()
  local timeStep = 0.033
  local neighborDist = 2
  local maxNeighbors = 8
  local timeHorizon = 1
  local timeHorizonObst = 1
  local radius = 1
  local maxSpeed = 20
  local step = 1
  local agentOpt = false
  if self.data.optRvo then
    local params = self.data.meta.rvoOpt
    if params ~= nil and params ~= "" then
      params = string.split(params, "|")
      if #params == 3 then
        maxNeighbors = tonumber(params[1]) or maxNeighbors
        step = tonumber(params[2]) or step
        local value = tonumber(params[3]) or 0
        agentOpt = value == 1
      end
    end
  end
  self.rvoMgr:InitLW(timeStep, neighborDist, maxNeighbors, timeHorizon, timeHorizonObst, radius, maxSpeed, step, agentOpt)
end

function LastStandLogic:ShowEffectObj(path, pos, rot, time, parent, type)
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

local velocity = Vector3.unity_vector3(0, 0, 0)
local bossSmoothTime = 0.3
local immediateSmoothTime = 0
local normalSmoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 1)
local LookOffset = 5
local LookOffsetBoss = 0

function LastStandLogic:UpdateCameraFollow(deltaTime)
  local v1 = self.battleMgr:GetFollowCameraTarget()
  tmpV1:Set(v1.x, v1.y, v1.z)
  local camLeftBordX = self.data.cameraLeftBoderX
  local camRightBordX = self.data.cameraRightBoderX
  local smoothTime = 0
  local teamPos = self.team:GetPosition()
  local teamPosX = teamPos.x
  if camLeftBordX and camRightBordX then
    teamPosX = Mathf.Clamp(teamPosX, camLeftBordX, camRightBordX)
  end
  tmpV2:Set(teamPosX, 0, teamPos.z + LookOffsetBoss)
  smoothTime = bossSmoothTime
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
    self.battleMgr:CameraFollowLookAt(targetPos)
  else
    self.battleMgr:CameraShakeUpdate()
  end
end

function LastStandLogic:DealDamage(params)
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
  ProfilerUtil.EndSample()
  if isMiss then
    self:ShowDamageText(hurt, hitPoint, DamageTextType.Miss, bulletMeta.damage_type, critical)
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
  self:ShowDamageText(hurt, hitPoint, damageTextType, bulletMeta.damage_type, critical)
end

function LastStandLogic:ShowDamageText(damage, position, style, damageType, isCritical, time)
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

function LastStandLogic:OnMonsterDeath(monster)
  if not self.deathNum then
    self.deathNum = 0
  end
  self.deathNum = self.deathNum + 1
  if not self.multipleKillInfo then
    self.multipleKillInfo = {}
  end
  if not self.multipleKillInfo[self.curRound] then
    self.multipleKillInfo[self.curRound] = 0
  end
  self.multipleKillInfo[self.curRound] = self.multipleKillInfo[self.curRound] + 1
  self:RefreshKillNum()
end

function LastStandLogic:GetKillMonsterNum()
  return self.deathNum or 0
end

function LastStandLogic:AddCoin(num)
  if not self.buildingMgr then
    return
  end
  self.coinNum = self.coinNum + num
  self.buildingMgr:CheckNeedShowUpgradeUI(self.coinNum)
end

function LastStandLogic:ReduceCoin()
  if self.coinNum > 0 then
    self.coinNum = self.coinNum - 1
    self.mainUI:ReduceRes(2, 1)
  end
  self.buildingMgr:CheckNeedShowUpgradeUI(self.coinNum)
end

function LastStandLogic:GetCoin()
  return self.coinNum
end

function LastStandLogic:AddMember(heroId, heroLevel, showBornTween)
  if self.team then
    self.team:AddMember(heroId, heroLevel, showBornTween)
    local teamCount = self.team:GetMemberCount()
    local radius = self.data:GetTeamRadius(teamCount)
    self.team:SetTeamRadius(radius)
  end
end

function LastStandLogic:AddSoliderToArmyYard(sourceBuildingUid)
  if self.buildingMgr then
    self.buildingMgr:AddSoliderToArmyYard(sourceBuildingUid)
  end
end

function LastStandLogic:AddSoldierToHospital()
  if self.buildingMgr then
    self.buildingMgr:AddSoldierToHospital()
  end
end

function LastStandLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function LastStandLogic:OnMemberDeath(unit)
  self:AddSoldierToHospital()
  local teamCount = self.team:GetMemberCount()
  if teamCount < 1 then
    self:OnGameEnd(false)
  end
  local radius = self.data:GetTeamRadius(teamCount)
  self.team:SetTeamRadius(radius)
end

function LastStandLogic:OnGameEnd(isWin)
  if self.isBattleFinish then
    return
  end
  self.isBattleFinish = true
  self:CalcUseTime()
  if isWin then
    if self.detectUuid then
      DataCenter.LastStandManager:SendWinLevel(self.detectUuid, self.levelId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILastStandWin)
    elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingSaveSpecialStage, {
        uuid = self.param.buildUuid,
        stageId = self.param.levelId
      })
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingFinishSpecialStage, self.param.buildUuid)
      local param = {}
      param.featureId = self.param.featureId
      param.rewardTitle = "newbies_fuben_award_desc"
      param.enterType = PVEEnterType.LastStand
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
    elseif self.param.enterType == PVEEnterType.GM then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILastStandWin)
    end
    PostEventLog.Track(PostEventLog.Defines.LastStandWinLevel, {
      levelId = self.levelId,
      useTime = self.useTime
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILastStandLose)
    PostEventLog.Track(PostEventLog.Defines.LastStandLoseLevel, {
      levelId = self.levelId,
      useTime = self.useTime
    })
  end
end

function LastStandLogic:SummonTriggerItem(pos, owner, triggerItemId, count, castType)
  if owner then
    self.monsterMgr:SummonTriggerItem(pos, triggerItemId, count, owner.meta, castType)
  end
end

function LastStandLogic:RangeSummonTriggerItem(owner, triggerItemId, count, distanceZ, r1, r2, castType)
  if owner then
    local pos = owner:GetPosition()
    local targetPos = pos + Vector3(0, 0, distanceZ)
    self.monsterMgr:RangeSummonTriggerItem(targetPos, r1, r2, triggerItemId, count, owner.meta, castType)
  end
end

function LastStandLogic:RecordGoods(goodsId, goodsCount)
end

function LastStandLogic:GetPVEType()
  return PVEType.LastStand
end

function LastStandLogic:IsPointInWallArea(center)
  return self.data:IsPointInWallArea(center.x, center.z)
end

function LastStandLogic:GetNearestDoor(center)
  return self.buildingMgr:GetNearestDoor(center)
end

function LastStandLogic:SetMaxMonsterRound(roundNum)
  self.maxRound = roundNum
  if self.mainUI then
    self.mainUI:SetMaxRound(self.maxRound)
  end
end

function LastStandLogic:SetCurMonsterRound(roundNum)
  self.curRound = roundNum
  if self.mainUI then
    self.mainUI:SetCurRound(self.curRound)
  end
  self:RefreshKillNum()
end

function LastStandLogic:GetMaxMonsterRound()
  return self.maxRound or 0
end

function LastStandLogic:RefreshKillNum()
  if not (self.mainUI and self.curRound) or not self.multipleKillInfo then
    return
  end
  local curKillNum = self.multipleKillInfo[self.curRound] or 0
  local maxNum = self.multipleMonsterInfo[self.curRound] or 0
  self.mainUI:SetCurKillMonsterNum(curKillNum, maxNum)
end

function LastStandLogic:GetCurRoundMaxMonsterNum(round)
  return self.multipleMonsterInfo[round] or 0
end

function LastStandLogic:OpenDoor(doorType, direction)
  self.buildingMgr:OpenDoor(doorType, direction)
end

function LastStandLogic:CloseDoor(doorType)
  self.buildingMgr:CloseDoor(doorType)
end

function LastStandLogic:IsHomeBuildingDone()
  return self.buildingMgr:IsHomeBuildingDone()
end

function LastStandLogic:GetDoorInfo()
  return self.data:GetDoorInfo()
end

function LastStandLogic:ShowGuideArrow(targetPos)
  self.team:ShowGuideArrow(targetPos)
end

function LastStandLogic:HideGuideArrow()
  self.team:HideGuideArrow()
end

function LastStandLogic:IsBattleFinish()
  return self.isBattleFinish
end

function LastStandLogic:AfterExit()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILastStandMain, {anim = false})
  self.mainUI = nil
end

function LastStandLogic:OnLastStandBuildingUpgrade(param)
  local buildingCfg = param.buildingCfg
  self.buildingMgr:CheckNeedShowUpgradeUI(self.coinNum)
  self.buildingMgr:CheckCanShowBuilding()
  self.data:SetBuildingExist(buildingCfg, param.x, param.z)
end

function LastStandLogic:OnLastStandBuildingFinish(buildingCfg)
  if buildingCfg.type == LastStandBuildType.Gate or buildingCfg.type == LastStandBuildType.ArmyYard then
    return
  end
  local pos = self.team:GetPosition()
  local x, z, isFind = self.data:FindNearbyEmptyPosition(pos.x, pos.z, 3, 10)
  if isFind then
    self.team:SetPosition(x, z)
  end
end

function LastStandLogic:ShowGuideText(id)
  self.mainUI:ShowGuideText(id)
end

function LastStandLogic:HideGuideText()
  self.mainUI:HideGuideText()
end

function LastStandLogic:ShakeCameraWithParam(param)
end

function LastStandLogic:SetNextMonsterRoundTime(time)
  self.mainUI:SetNextCountDownTime(time)
end

function LastStandLogic:CalcUseTime()
  local nowTime = UITimeManager:GetInstance():GetServerSeconds()
  self.useTime = nowTime - self.enterTime
  return self.useTime
end

function LastStandLogic:GetSharedHeroInfo(heroId)
  local heroInfo = self.sharedHeroInfo[heroId]
  local needInit = false
  if nil == heroInfo then
    heroInfo = HeroInfo.New()
    self.sharedHeroInfo[heroId] = heroInfo
    needInit = true
  end
  return heroInfo, needInit
end

return LastStandLogic
