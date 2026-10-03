local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local rvoObstaclePath = "Assets/Main/Prefabs/PVELevel/%s/obstacle.bytes"
local Const = require("Scene.LWBattle.Const")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local Time = _ENV.Time
local Plane = _ENV.Plane
local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local ParkourTeam = require("Scene.LWBattle.ParkourBattle.Team.ParkourTeam")
local ParkourBattleData = require("DataCenter.LWBattle.Logic.ParkourBattle.ParkourBattleData")
local MonsterManager = require("Scene.LWBattle.ParkourBattle.Monster.MonsterManager")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local TriggerEventManager = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEventManager")
local BattleStartTriggerTask = require("Scene.LWBattle.ParkourBattle.TriggerEvent.BattleStartTriggerTask")
local FSM = require("Framework.Common.FSM")
local ParkourBattleLogic = BaseClass("ParkourBattleLogic", base)
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local GameQualitySettings = require("Util.GameQualitySettings")
local DISPLACE_EPSILON = 0.01
local XCenter = Const.ParkourSceneCenter
local FPS_SAMPLE_CD = 10
local Localization = CS.GameEntry.Localization
local defaultFov = 60
local defaultHeight = 20
local defaultRotation = 45
local LookOffset = 5
local LookOffsetBoss = 0
local SoundDelayTime = 0
local defaultMinMoveX = 31
local defaultMaxMoveX = 41
local PveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local EffectViewUtil = require("Scene.LWBattle.EffectObj.EffectViewUtil")

function ParkourBattleLogic:Enter(param)
  self:InitPvePhysicsSetting(param)
  self.battleMgr = DataCenter.LWBattleManager
  self.data = ParkourBattleData.New(param.levelId)
  if Setting:GetPrivateBool("PARKOUR_OPENING_PLOT" .. param.levelId, true) then
    self.opening_plot = tonumber(self.data.meta.opening_plot) or 0
  else
    self.opening_plot = 0
  end
  self.param = param
  self.levelId = param.levelId
  self.tryHeroes = param.tryHeroes or {}
  self.winCondition = self.data.winCondition
  self.monsterBornTriggerPlotId = 0
  self.winConditions = {}
  if self.data.winCondition then
    for k, v in ipairs(self.data.winCondition) do
      v.finish = false
      self.winConditions[v.winType] = v
    end
    self:ClearPreWinConditionCheck()
  end
  self.bonusType = self.data.bonusType or Const.ParkourBattleBonusType.None
  if self.bonusType ~= Const.ParkourBattleBonusType.None then
    self:InitExtendFsm()
    if self.bonusType == Const.ParkourBattleBonusType.Dash then
      self.stopFireZ = self.data.bonusExtendData.stopFireZ
    end
  else
    self.extendFsm = nil
  end
  self.dashBonusSpeed = 0
  self.tmpBonusSpeed = 0
  self.bonusDashDamageCoefficient = 1
  self.lastBonusDashSolider = nil
  self.bonusDashMonsterCounter = nil
  self.battleMgr.cameraOffset:Set(0, 0, 4)
  self.initComplete = false
  self.fingerDown = false
  self.lastFingerPosX = 36
  self:ChangeStage(Const.ParkourBattleState.Ready)
  self.monsterMgr = MonsterManager.New()
  self.bulletManager = BulletManager.New(self)
  local optMaxDmgNum = true
  self.damageTextMgr = DamageTextManager.New(4, 0.5, optMaxDmgNum)
  EffectViewUtil.InitView()
  PveUnitViewUtil.InitView()
  self.triggerEventMgr = TriggerEventManager.New(self)
  self:InitRVO()
  self.useTime = 0
  self.frames = 0
  self.frameTimer = 0
  self.sampleCd = FPS_SAMPLE_CD
  self.sampleFrame = Time.frameCount
  self.lowestFps = 999
  self.killNum = 0
  self.saveNum = 0
  self.killBossNum = 0
  self.blastStandingWaterBottleNum = 0
  self.unitMgr = UnitManager.New(self)
  self.unitGuid = 0
  self.boss = {}
  self.delayEvents = {}
  self.lastTriggerY = 0
  self.summonPetSlotOrder = 0
  self.trigger130SlotOccupy = {}
  self.trigger130PetToSlot = {}
  self.trigger130SlotReserve = {}
  self.__event_handlers = {}
  self.goods = {}
  self.auto = false
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.sharedHeroInfo = {}
  end
  self:AddListener(EventId.OpenUI, self.OnOpenUI)
  self:AddListener(EventId.LWBattleBuffStart, self.OnBuffChange)
  self:AddListener(EventId.LWBattleBuffEnd, self.OnBuffChange)
  self:AddListener(EventId.ParkourBattleStart, self.OnParkourBattleStart)
  self:AddListener(EventId.FrontBreakSundayChallengeSaveResult, self.OnFrontBreakSundayChallengeResult)
  self:AddListener(EventId.ParkourBonusDashStart, self.OnParkourBonusDashStart)
  self:AddListener(EventId.ParkourBonusDashProgressChange, self.OnParkourBonusDashProgressChange)
  self:AddListener(EventId.PlotGroupDone, self.OnPlotEnd)
  self:AddListener(EventId.PlotViewClosedAbnormally, self.OnPlotViewClosedAbnormally)
  self.defenseFakeTeamPosZ = self.data.initPosY
  self.endLine = self.data.endLine
  self.defenseOffsetZ = 0
  self.initMoveSpeedZ = self.data.moveSpeedZ
  self.battleType = self.data.battleType
  self.initUnitDeath = false
  self.heroIdReplaceNormalSkillMap = nil
  self.heroIdReplaceSkillTriggerMap = nil
  self.heroIdReplaceAppearanceMap = nil
  self.heroIdGlobalBuffMap = nil
  self.heroIdReplaceActiveSkillMap = nil
  self.showHeroEnergy = self.data.showEnergy
  self.useViewBossHpBar = self.data.useViewBossHpBar
  self.showGuide = false
  self.winToRemoveEffect = false
  self.remainMember = 0
  self.highQualityMode = GameQualitySettings.IsHighGearQuality()
  self.lowQualityMode = GameQualitySettings.IsLowGearQuality()
  self.toCheatExit = nil
  self.parkourDoorHeroId = self.data.parkourDoorHeroId
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.needUpdateWinCondition = false
  end
  local isShowShadow = GameQualitySettings.IsShowShadow()
  if isShowShadow then
    self:SetSceneShadow()
  end
  self.detailLog = false
  if self.param and self.param.fromActFrontBreakSunday then
    local deviceId = CS.GameEntry.Device:GetDeviceUid_Transcoding()
    if deviceId == "lwDid_NGE0NWRkYWExYzZkMmUwZDQ3ZDk3ODcxYWRmMDJjMGUxZTZjOGZkNl9uM2Q=" or deviceId == "lwDid_MzZiMzkyZTMtN2M3Yi00ZmZhLTkxNjItNGRjM2U5NGYzZmI5X24zZA==" or deviceId == "lwDid_NDcxNzRiNzMtZWNkNC00ZGExLWE1NTItM2ViNzBmNzkyOGE4XzNk" or deviceId == "lwDid_NDcxNzRiNzMtZWNkNC00ZGExLWE1NTItM2ViNzBmNzkyOGE4X24zZA==" or deviceId == "lwDid_MGMwNDUxMTgtYWFkZi00MzE2LWExN2MtNmMxMzVjZDI4NDg4X24zZA==" or deviceId == "lwDid_OTc3MTI0OWItM2RhNS00NjU3LThkYjAtZGU5NWQ2NTU2MTM3X24zZA==" or deviceId == "lwDid_ODlkNTE0YWItYjRiOC00YzJhLWI3YzItMDMzYzk0MzIzMTk1X24zZA==" or deviceId == "lwDid_OTNhMWFkNzAtMGJmMC00M2NiLWJlMmQtNWRjMjlkNzYyYzgxX24zZA==" or deviceId == "lwDid_OGI2YTA5ODI2NzQyMmU5NTU5MmM5NDE2MmJhN2FlNTQyODYwM2M0Ml9uM2Q=" then
      self.detailLog = true
    end
    self.isDebug = CS.CommonUtils.IsDebug()
    if self.isDebug and not self.detailLog and GMUtils.GetBool(GMConst.ParkourDetailLog, false) then
      self.detailLog = true
    end
  end
  if self.data.cameraParams and 0 < #self.data.cameraParams then
    self.cameraFollowOffsetZ = self.data.cameraParams[4] or LookOffset
  else
    self.cameraFollowOffsetZ = LookOffset
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.attackPropertyCache = {}
  end
  self.captureTimer = 0
  self.captureTime = 10
  self.tauntVersion = 0
end

function ParkourBattleLogic:__delete()
  self:Destroy()
end

function ParkourBattleLogic:InitPvePhysicsSetting(param)
  self.userCollider2D = DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveCollider2D) and (tonumber(param.levelId) == 50001 or tonumber(param.levelId) == 50002)
  PvePhysicsUtil.EnterBattle(self.userCollider2D)
end

function ParkourBattleLogic:InitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:InitCameraParams()
  local touchInput = self.battleMgr.touchCamera.touchInput
  if self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    touchInput.enabled = true
  end
  
  function self.onFingerDown(pos)
    self:OnFingerDown(pos)
  end
  
  function self.onFingerUp()
    self:OnFingerUp()
  end
  
  touchInput:OnFingerDown("+", self.onFingerDown)
  touchInput:OnFingerUp("+", self.onFingerUp)
end

function ParkourBattleLogic:UnInitCamera()
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

function ParkourBattleLogic:InitCameraParams(pos)
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

function ParkourBattleLogic:InitRVO()
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
  self.rvoSyncMode = self.data.rvoSyncMode == 1
end

function ParkourBattleLogic:GetCameraParam(pos)
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

function ParkourBattleLogic:IsDefenseMode()
  return self.battleType == Const.ParkourBattleType.Defense
end

function ParkourBattleLogic:OnFingerDown(pos)
  if self.state == Const.ParkourBattleState.Ready then
    return
  end
  if not self.battleMgr.gameStart or self.battleMgr.gamePause or self.battleMgr.gameOver then
    return
  end
  self.fingerDown = true
  if self.state == Const.ParkourBattleState.Farm then
    self:OnFingerDownLeftRight(pos)
  elseif self.state == Const.ParkourBattleState.Boss then
    self:OnFingerDownJoyStick(pos)
  else
    self:TryCallExtendFsmStateFuc("OnFingerDown", pos)
  end
end

function ParkourBattleLogic:OnFingerUp()
  self.fingerDown = false
  if self.state == Const.ParkourBattleState.Boss then
    self:OnFingerUpJoyStick()
  end
  self.team:StopHorizontalMove()
end

function ParkourBattleLogic:OnFingerHold(deltaTime)
  if self.state == Const.ParkourBattleState.Ready then
    return
  end
  if self.state == Const.ParkourBattleState.Farm or self.state == Const.ParkourBattleState.BossHorizontal then
    self:OnFingerHoldLeftRight(deltaTime)
  elseif self.state == Const.ParkourBattleState.Boss then
    self:OnFingerHoldJoyStick(deltaTime)
  else
    self:TryCallExtendFsmStateFuc("OnFingerHold", deltaTime)
  end
end

function ParkourBattleLogic:OnFingerDownLeftRight(pos)
  local ray = self.touchCamera:ScreenPointToRay(pos)
  local plane = Plane.New(Vector3.up, 0)
  local hit, dis = plane:Raycast(ray)
  local hitPoint = ray:GetPoint(dis)
  self.lastFingerPosX = hitPoint.x
end

function ParkourBattleLogic:OnFingerHoldLeftRight(deltaTime)
  local hit, hitX, _ = CS.CSUtils.GetCameraTouchWorldPos(self.touchCamera)
  if not hit then
    return
  end
  local nowX = self.team:GetPosition().x
  local delta = hitX - self.lastFingerPosX
  if math.abs(delta) < DISPLACE_EPSILON then
    if self.hasHorizonMove then
      self.team:StopHorizontalMove()
    end
    self.hasHorizonMove = false
    return
  end
  self.hasHorizonMove = true
  local clamp = self:ClampMoveX(nowX + delta * self.data.moveDeltaMulti)
  self.lastFingerPosX = hitX
  self.team:MoveHorizontalTo(clamp)
  self.team:MoveHorizontal(delta)
  if self.showGuide then
    self:HideGuide()
  end
end

function ParkourBattleLogic:HasHorizonMove()
  return self.fingerDown and self.hasHorizonMove
end

function ParkourBattleLogic:ClampMoveArea(hitPoint)
  return Mathf.Clamp(hitPoint.x, 31, 41)
end

function ParkourBattleLogic:ClampMoveX(x)
  local minX = defaultMinMoveX
  local maxX = defaultMaxMoveX
  if self.data.soliderLeftBoderDeltaX and self.data.soliderRightBoderDeltaX then
    minX = self.data.initPosX - self.data.soliderLeftBoderDeltaX
    maxX = self.data.initPosX + self.data.soliderRightBoderDeltaX
  end
  return Mathf.Clamp(x, minX, maxX)
end

function ParkourBattleLogic:GetMinMaxMoveX()
  if not self.data then
    return math.mininteger, math.maxinteger
  end
  if self.data.soliderLeftBoderDeltaX and self.data.soliderRightBoderDeltaX then
    local minX = self.data.initPosX - self.data.soliderLeftBoderDeltaX
    local maxX = self.data.initPosX + self.data.soliderRightBoderDeltaX
    return minX, maxX
  end
  return defaultMinMoveX, defaultMaxMoveX
end

function ParkourBattleLogic:GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function ParkourBattleLogic:LoadScene(callBack)
  self.team = ParkourTeam.New(self.data.initPosX, self.data.initPosY, self, self.data.meta.default_hero, self.data:GetAppearanceMap())
  self.team.speedX = self.data.moveSpeedX
  self.team.speedZ = self.initMoveSpeedZ
  self.defenseFakeTeamPosZ = self.team:GetPositionZ()
  local teamDefaultCount = self.team:GetMemberCount()
  self.auto = 0 < teamDefaultCount
  if teamDefaultCount == 0 then
    local squadIndex = self.data:GetFormationSaveType()
    local squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(squadIndex)
    local allHeroes = {}
    if squadData ~= nil then
      local heroes = squadData:GetAllHeroes()
      for slotIndex, heroUuid in pairs(heroes) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData ~= nil then
          allHeroes[slotIndex] = heroData
        end
      end
    end
    self.team:InitHeroes(allHeroes)
    if self.param and self.param.enterType == PVEEnterType.HeroTryOut then
      local squadDataHeroTryOut = DataCenter.HeroTryOutManager:GetArmyFormationInfoByHeroTryOutId(self.param.extraData.cfgId)
      if squadDataHeroTryOut then
        local weaponInfo = squadDataHeroTryOut:GetTacticalWeaponInfo()
        if weaponInfo then
          self.team:InitWeapon(weaponInfo, {})
        end
      end
    else
      local weaponData = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
      local setId = squadData:GetLocalTWSkillChipSetId()
      local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(setId)
      self.team:InitWeapon(weaponData, skillChips)
    end
  end
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(3)
  if self.damageTextMgr then
    self.damageTextMgr:Init(self)
  end
  local sceneCfgArr = self.data.sceneCfgArr
  self.sceneLoadRequest = {}
  self.finishedScene = 0
  self.sceneAnims = {}
  if DataCenter.LWGuideManager:GetCurGuideId() ~= GuideState.LevelOne or DataCenter.LWGuideManager:GetIsStart() then
    self.monsterMgr:Init(self)
  end
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
        Logger.Log("ParkourBattleLogic.LoadScene allFinished")
        if callBack then
          callBack()
        end
        self:LoadSceneComplete()
      else
        Logger.Log("ParkourBattleLogic.LoadScene finishCount : " .. self.finishedScene .. " cur : " .. req.PrefabPath)
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
  if self.detailLog then
    Logger.LogInfo("parkour Init MemberCount : " .. self.team:GetMemberCount() .. ". moveSpeedZ : " .. self.team:GetMoveSpeedZ())
  end
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    local cheatDefaultHeroIds = {}
    for _, id in ipairs(self.team.defaultHeroIds) do
      table.insert(cheatDefaultHeroIds, id + 2)
    end
    self:TryMonsterCheatOther(6, self.levelId, self.initMoveSpeedZ + 2, cheatDefaultHeroIds, self.data.endLine + 2)
  end
end

function ParkourBattleLogic:LoadSceneComplete()
  self.initComplete = true
  local pos = Vector3.New(XCenter, 0, self.team:GetPositionZ())
  self.battleMgr:LookAt(pos)
  self:AddSceneUpdator()
  if not self.param.firstGuideStage then
    if 0 < self.opening_plot then
      Setting:SetPrivateBool("PARKOUR_OPENING_PLOT" .. self.levelId, false)
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.opening_plot,
        hideMainUI = false
      })
    end
    if self.auto then
      if 0 < self.opening_plot then
      else
        self:OnParkourBattleStart()
      end
    elseif self.param.enterType == PVEEnterType.HeroTryOut then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourFormation_HeroTryOut, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.param, self.data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.param, self.data)
    end
  end
  local preloadType = self.data.preloadType
  local preloadAsset = self.data.preloadAsset
  if self.bulletManager ~= nil then
    self.bulletManager:PreloadStraight(preloadType, preloadAsset)
  end
  self:PreloadEffect(preloadType, preloadAsset)
  self:PreloadUnitView(preloadType, preloadAsset)
end

function ParkourBattleLogic:PlaySceneAnim(animName)
  if self.sceneAnims then
    for _, anim in ipairs(self.sceneAnims) do
      if IsNotNull(anim) then
        anim:Play(animName)
      end
    end
  end
end

function ParkourBattleLogic:OnPlotEnd(plotId)
  if plotId == self.opening_plot then
    if self.auto then
      self:OnParkourBattleStart()
    end
  elseif plotId == self.monsterBornTriggerPlotId then
    DataCenter.LWBattleManager:SetGamePause(false)
  end
end

function ParkourBattleLogic:OnPlotViewClosedAbnormally(plotId)
  if plotId == self.opening_plot then
    if self.auto then
      self:OnParkourBattleStart()
    end
  elseif plotId == self.monsterBornTriggerPlotId then
    DataCenter.LWBattleManager:SetGamePause(false)
  end
end

function ParkourBattleLogic:PreloadEffect(preloadType, preloadAsset)
  if preloadAsset and 0 < preloadAsset then
    local template = DataCenter.LWFeaturePreloadAssetTemplateManager:GetTemplate(preloadAsset)
    if template then
      local totalCount = 0
      local effectCount = template.effPreloadCount
      for i = 1, effectCount do
        local asset = template.eff_name[i]
        local count = template.eff_number[i]
        totalCount = totalCount + count
        if not string.IsNullOrEmpty(asset) and 0 < count then
          EffectViewUtil.PreloadEffectGameObject(asset, count)
        end
      end
      if 1400 < totalCount then
        Logger.LogError("ParkourBattleLogic:PreloadEffect too much : " .. totalCount)
      end
      return
    end
  end
  if preloadType == 3 then
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_jiatelin_qiangkou_lod.prefab", 120)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_hit.prefab", 70)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_monster_hit.prefab", 280)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_shengji_01.prefab", 210)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_hit_01.prefab", 180)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_stone_hit.prefab", 220)
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_fuchouzhe_qiangkou_lod.prefab", 90)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/Jiatelin/Eff_hero_jiatelin_hit.prefab", 280)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_duiwujiasu.prefab", 90)
  elseif preloadType == 2 then
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_jiatelin_qiangkou_lod.prefab", 60)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_hit.prefab", 35)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_monster_hit.prefab", 140)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_shengji_01.prefab", 110)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_hit_01.prefab", 90)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_stone_hit.prefab", 110)
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_fuchouzhe_qiangkou_lod.prefab", 45)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/Jiatelin/Eff_hero_jiatelin_hit.prefab", 140)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_duiwujiasu.prefab", 45)
  else
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_jiatelin_qiangkou_lod.prefab", 12)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/AK/Eff_hero_AK_hit.prefab", 7)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_monster_hit.prefab", 28)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_Common_shengji_01.prefab", 21)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/xinshou/Eff_xinshou_hit_01.prefab", 18)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_stone_hit.prefab", 22)
    EffectViewUtil.PreloadEffectGameObject("Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_fuchouzhe_qiangkou_lod.prefab", 9)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Arms/Jiatelin/Eff_hero_jiatelin_hit.prefab", 28)
    EffectViewUtil.PreloadEffectGameObject("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_duiwujiasu.prefab", 9)
  end
end

function ParkourBattleLogic:PreloadUnitView(preloadType, preloadAsset)
  if preloadAsset and 0 < preloadAsset then
    local template = DataCenter.LWFeaturePreloadAssetTemplateManager:GetTemplate(preloadAsset)
    if template then
      local unitCount = template.unitPreloadCount
      local maxCount = 0
      local totalCount = 0
      for i = 1, unitCount do
        local asset = template.unit_name[i]
        local count = template.unit_number[i]
        if maxCount < count then
          maxCount = count
        end
        totalCount = totalCount + count
        if not string.IsNullOrEmpty(asset) and 0 < count then
          PveUnitViewUtil.Preload(asset, count)
        end
      end
      if 0 < maxCount then
        PveUnitViewUtil.PreloadHpBar(maxCount)
      end
      if 220 < totalCount then
        Logger.LogError("ParkourBattleLogic:PreloadUnitView too much : " .. totalCount)
      end
      return
    end
  end
  if preloadType == 3 then
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle.prefab", 70)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan.prefab", 90)
    PveUnitViewUtil.PreloadHpBar(100)
  elseif preloadType == 13 then
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_AK_gpu.prefab", 60)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_DDC_gpu.prefab", 61)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HG_gpu.prefab", 62)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HJT_gpu.prefab", 63)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HP_gpu.prefab", 64)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JJQ_gpu.prefab", 65)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JTL_gpu.prefab", 66)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_SQ_gpu.prefab", 67)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle_gpu.prefab", 70)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan_gpu.prefab", 90)
    PveUnitViewUtil.PreloadHpBar(100)
  elseif preloadType == 2 then
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle.prefab", 35)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan.prefab", 45)
    PveUnitViewUtil.PreloadHpBar(50)
  elseif preloadType == 12 then
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_AK_gpu.prefab", 30)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_DDC_gpu.prefab", 31)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HG_gpu.prefab", 32)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HJT_gpu.prefab", 33)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HP_gpu.prefab", 34)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JJQ_gpu.prefab", 35)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JTL_gpu.prefab", 36)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_SQ_gpu.prefab", 37)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle_gpu.prefab", 38)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan_gpu.prefab", 45)
    PveUnitViewUtil.PreloadHpBar(50)
  elseif preloadType == 11 then
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_AK_gpu.prefab", 0)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_DDC_gpu.prefab", 1)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HG_gpu.prefab", 2)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HJT_gpu.prefab", 3)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_HP_gpu.prefab", 4)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JJQ_gpu.prefab", 5)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_JTL_gpu.prefab", 6)
    PveUnitViewUtil.Preload("Assets/Prefabs/NewBies/Prefab/bubing11_SQ_gpu.prefab", 7)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle_gpu.prefab", 8)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan_gpu.prefab", 9)
    PveUnitViewUtil.PreloadHpBar(10)
  else
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing11/prefab/A_Hero_bubing11_battle.prefab", 7)
    PveUnitViewUtil.Preload("Assets/_Art_LastWar/Models/Characters/Soldier/bubing04/prefab/A_Hero_bubing04_lan.prefab", 9)
    PveUnitViewUtil.PreloadHpBar(10)
  end
end

function ParkourBattleLogic:AddSceneUpdator()
  if self.sceneUpdateTimer == nil then
    function self.sceneUpdateTimer()
      self:SceneUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.sceneUpdateTimer)
  end
end

function ParkourBattleLogic:RemoveSceneUpdator()
  if self.sceneUpdateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.sceneUpdateTimer)
    self.sceneUpdateTimer = nil
  end
end

function ParkourBattleLogic:SceneUpdate()
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
  EffectViewUtil.Update(Time.deltaTime)
  ProfilerUtil.BeginSample("UnitViewLoaded")
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId, objHandle = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded(false, objHandle)
      end
    end
  end
  ProfilerUtil.EndSample()
end

function ParkourBattleLogic:OnFrontBreakSundayChallengeResult(result)
  self.waitingFrontBreakSundayChallengeResult = false
  if result and not result.errorCode then
    local param = {}
    param.time = self.useTime
    param.kill = self.killNum
    param.stageId = result.curStage
    param.state = result.state
    param.showStatistic = false
    param.enterType = self.param.enterType
    param.fromActFrontBreakSunday = true
    param.curLeft = result.curLeft
    param.totalLeft = result.totalLeft
    param.topRankOld = result.globalRankOld
    param.topRankNew = result.globalRankNew
    param.alRankOld = result.alRankOld
    param.alRankNew = result.alRankNew
    param.serRankOld = result.serRankOld
    param.serRankNew = result.serRankNew
    param.newRecord = result.newRecord
    param.extraData = self.param.extraData
    param.loseToShowVideo = self.loseToShowVideo
    param.loseToShowVideoURL = self.loseToShowVideoURL
    param.frontBreakSundayActId = self.param.frontBreakSundayActId
    if result.state == 2 then
      if self:IsFrontBreakSundayNewRecord(param) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFrontBreakOutSundayNewRecord, {anim = false}, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultFrontBreakSundayVictory, {anim = true, playEffect = 10024}, param)
      end
    elseif result.state == 3 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultFrontBreakSundayDefeat, {anim = true, playEffect = 10023}, param)
    end
  else
    self:NoticeLose()
    self.battleMgr:Exit(nil, "lose")
  end
end

function ParkourBattleLogic:TryCheatCheck()
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    self.toCheatExit = true
  end
end

function ParkourBattleLogic:TryMonsterCheatCheck(monsterId, initHp)
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    SFSNetwork.SendMessage(MsgDefines.CheckActivityFeatureMonster, monsterId, initHp)
  end
end

function ParkourBattleLogic:TryCheatBullet(meta, rowCount, waveCount, ownerId, skillId)
  if meta == nil then
    return
  end
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    local metaId = meta.id
    if not ownerId then
      if self.isDebug then
        Logger.LogError("ParkourBattleLogic:TryCheatBullet invalid ownerId. id : " .. metaId)
      end
      return
    end
    if self.bulletCheatData == nil then
      self.bulletCheatData = {}
    end
    local cheatData = self.bulletCheatData[ownerId]
    if cheatData == nil then
      cheatData = {}
      self.bulletCheatData[ownerId] = cheatData
    end
    if cheatData[metaId] then
      return
    end
    cheatData[metaId] = true
    local replaceTriggerId = self:GetReplaceNormalSkillTrigger(ownerId)
    self:TryMonsterCheatOther(8, ownerId, rowCount + 2, waveCount + 2, meta.bullet_damage_count + 2, meta.colliderRadius + 2, skillId + 2, metaId + 2, replaceTriggerId + 2)
  end
end

function ParkourBattleLogic:TryCheatTriggerItem(id, param1, sourceId)
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    if not sourceId then
      if self.isDebug then
        Logger.LogError("ParkourBattleLogic:TryCheatTriggerItem invalid source. id : " .. id)
      end
      return
    end
    self:TryMonsterCheatOther(7, sourceId, param1, id + 2)
  end
end

function ParkourBattleLogic:TryMonsterCheatOther(type, cfgId, param1, param2, param3, param4, param5, param6, param7)
  if self.data and self.param and self.param.fromActFrontBreakSunday and self.param.cheatCheck then
    SFSNetwork.SendMessage(MsgDefines.CheckActivityFeatureOther, type, cfgId, param1, param2, param3, param4, param5, param6, param7)
  end
end

function ParkourBattleLogic:OnParkourBattleStart()
  self:RemoveSceneUpdator()
  self.heroStatisticalData = {
    makeDmg = {},
    takeDmg = {},
    death = {}
  }
  if self.team then
    self.team:OnStartBattle(not self.auto)
    local heroTrack, heroSlot1, heroSlot2, heroSlot3, heroSlot4, heroSlot5, heroLevel1, heroLevel2, heroLevel3, heroLevel4, heroLevel5, equipSlot1, equipSlot2, equipSlot3, equipSlot4, equipSlot5
    if self.param and self.param.enterType and (self.param.enterType == PVEEnterType.TowerupJeepAdventure or self.param.enterType == PVEEnterType.Monopoly) then
      heroTrack = true
    end
    local heroes = self.team.teamUnits
    for slot, hero in pairs(heroes) do
      local uuId = hero.hero.uuid
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(uuId)
      if heroData ~= nil or hero.hero.fromTemplate then
        self.heroStatisticalData.makeDmg[uuId] = 0
        self.heroStatisticalData.takeDmg[uuId] = 0
        self.heroStatisticalData.death[uuId] = false
      end
      hero:SetInitUnit()
      if heroTrack and hero and hero.hero.heroId then
        if slot == 1 then
          heroSlot1 = hero.hero.heroId
          heroLevel1 = hero.hero.level
          for i = 1, 4 do
            local equipData = hero.hero:GetEquipBySlotType(i)
            if equipData ~= nil then
              if equipSlot1 == nil then
                equipSlot1 = equipData.configId .. "," .. equipData.level
              else
                equipSlot1 = equipSlot1 .. ";" .. equipData.configId .. "," .. equipData.level
              end
            end
          end
        elseif slot == 2 then
          heroSlot2 = hero.hero.heroId
          heroLevel2 = hero.hero.level
          for i = 1, 4 do
            local equipData = hero.hero:GetEquipBySlotType(i)
            if equipData ~= nil then
              if equipSlot2 == nil then
                equipSlot2 = equipData.configId .. "," .. equipData.level
              else
                equipSlot2 = equipSlot2 .. ";" .. equipData.configId .. "," .. equipData.level
              end
            end
          end
        elseif slot == 3 then
          heroSlot3 = hero.hero.heroId
          heroLevel3 = hero.hero.level
          for i = 1, 4 do
            local equipData = hero.hero:GetEquipBySlotType(i)
            if equipData ~= nil then
              if equipSlot3 == nil then
                equipSlot3 = equipData.configId .. "," .. equipData.level
              else
                equipSlot3 = equipSlot3 .. ";" .. equipData.configId .. "," .. equipData.level
              end
            end
          end
        elseif slot == 4 then
          heroSlot4 = hero.hero.heroId
          heroLevel4 = hero.hero.level
          for i = 1, 4 do
            local equipData = hero.hero:GetEquipBySlotType(i)
            if equipData ~= nil then
              if equipSlot4 == nil then
                equipSlot4 = equipData.configId .. "," .. equipData.level
              else
                equipSlot4 = equipSlot4 .. ";" .. equipData.configId .. "," .. equipData.level
              end
            end
          end
        elseif slot == 5 then
          heroSlot5 = hero.hero.heroId
          heroLevel5 = hero.hero.level
          for i = 1, 4 do
            local equipData = hero.hero:GetEquipBySlotType(i)
            if equipData ~= nil then
              if equipSlot5 == nil then
                equipSlot5 = equipData.configId .. "," .. equipData.level
              else
                equipSlot5 = equipSlot5 .. ";" .. equipData.configId .. "," .. equipData.level
              end
            end
          end
        end
      end
    end
    if heroTrack then
      local stageId = ""
      if self.param and self.param.levelId then
        stageId = tostring(self.param.levelId)
      end
      PostEventLog.Track(PostEventLog.Defines.BattleHeroSlot, {
        stageId = stageId,
        i_para1 = heroSlot1 or 0,
        i_para2 = heroSlot2 or 0,
        i_para3 = heroSlot3 or 0,
        i_para4 = heroSlot4 or 0,
        i_para5 = heroSlot5 or 0,
        formation_power1 = heroLevel1 or 0,
        formation_power2 = heroLevel2 or 0,
        formation_power3 = heroLevel3 or 0,
        formation_power4 = heroLevel4 or 0,
        formation_type = heroLevel5 or 0,
        power_11 = equipSlot1 or "0",
        power_12 = equipSlot2 or "0",
        power_13 = equipSlot3 or "0",
        power_14 = equipSlot4 or "0",
        power_15 = equipSlot5 or "0"
      })
    end
  end
  self.weaponStatisticalData = {makeDmg = 0, takeDmg = 0}
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIParkourBattleMain) then
    local param = {}
    
    local function onOpen()
      if self.mainUI then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourFormation)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourFormation_HeroTryOut)
        self.mainUI:ShowWinCondition(function()
        end, self.data.hideTitle, self.data.winCondition)
        self:ReadyGo()
      end
    end
    
    param.onOpen = onOpen
    param.dashBonus = self.bonusType and self.bonusType == Const.ParkourBattleBonusType.Dash
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourBattleMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, param)
    self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIParkourBattleMain).View
  else
    self:ReadyGo()
  end
  self.delaySound = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_start_2)
  end, SoundDelayTime)
end

function ParkourBattleLogic:ReadyGo()
  self:ChangeStage(Const.ParkourBattleState.Farm)
  self.battleMgr:SetGameStart(true)
  if self.data.meta.sound_id_bgm == 0 then
    Logger.LogError("\232\183\145\233\133\183\229\133\179\229\141\161bgm\228\184\186\231\169\186\239\188\140levelId=" .. self.data.meta.id)
  else
    CommonUtil.ClearGameBgMusicData()
    DataCenter.LWSoundManager:PlayMusicById(self.data.meta.sound_id_bgm, true)
    if not string.IsNullOrEmpty(self.data.meta.bgm_1) then
      self.delayEnvSound = TimerManager:GetInstance():DelayInvoke(function()
        self.delayEnvSound = nil
        self.envSoundHandle = DataCenter.LWSoundManager:PlaySound(tonumber(self.data.meta.bgm_1), true, true)
      end, 0.5)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_start, {
    self.data.battleType,
    self.data.metaId
  })
  self:TryShowGuide()
  self:TriggerStartEffect()
end

function ParkourBattleLogic:OnUpdatePause()
  if self.damageTextMgr then
    self.damageTextMgr:OnUpdate()
  end
end

function ParkourBattleLogic:OnUpdate()
  local deltaTime = Time.deltaTime
  local unscaledDeltaTime = Time.unscaledDeltaTime
  self.frames = self.frames + 1
  self.frameTimer = self.frameTimer + unscaledDeltaTime
  if self.state == Const.ParkourBattleState.Ready then
    return
  end
  if self.touchCamera and self.staticMgr then
    CS.CSUtils.UpdatePVEStaticMgr(self.touchCamera, self.staticMgr)
  end
  ProfilerUtil.BeginSample("UnitViewLoaded")
  local loadedViewCount = PveUnitViewUtil.CheckLoadedCount()
  if 0 < loadedViewCount then
    for i = 1, loadedViewCount do
      local objId, objHandle = PveUnitViewUtil.GetLoadedObjId(i)
      local unit = self.unitMgr:GetUnit(objId)
      if unit and unit.OnViewLoaded then
        unit:OnViewLoaded(false, objHandle)
      end
    end
  end
  ProfilerUtil.EndSample()
  ProfilerUtil.BeginSample("BulletManagerUpdate")
  if self.userCollider2D then
    PvePhysicsUtil.UpdateCollider()
  end
  if not self:IsBattleFinish() then
    self.bulletManager:OnUpdate()
  end
  ProfilerUtil.EndSample()
  EffectViewUtil.Update(deltaTime)
  if self.damageTextMgr then
    self.damageTextMgr:OnUpdate()
  end
  local winCondition = self.winConditions
  if winCondition[Const.ParkourWinType.FinishPoint] then
    self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.FinishPoint)
  end
  if self.extendFsm and self.extendFsm:GetStateIndex() == self.state then
    self.extendFsm:OnUpdate()
  elseif self.state == Const.ParkourBattleState.Farm then
    local winConditions = self:GetCheckWinConditions()
    local curZ = self.team:GetPositionZ()
    if curZ - self.preConditionTeamZ < self.endLine then
      if self.bonusType == Const.ParkourBattleBonusType.Dash and self.stopFireZ and curZ - self.preConditionTeamZ >= self.stopFireZ then
        self:OnEnterPreDashBonus()
      end
    elseif winConditions[Const.ParkourWinType.FinishPoint] then
      local condition = winConditions[Const.ParkourWinType.FinishPoint]
      if not condition.finish then
        condition.finish = true
        self:OnWinConditionMet()
      end
    else
      if self.data.teamBossControlState == Const.ParkourTeamBossControlState.AllDirection then
        self:ChangeStage(Const.ParkourBattleState.Boss)
      elseif self.data.teamBossControlState == Const.ParkourTeamBossControlState.Stay then
        self:ChangeStage(Const.ParkourBattleState.BossStay)
      elseif self.data.teamBossControlState == Const.ParkourTeamBossControlState.Horizontal then
        self:ChangeStage(Const.ParkourBattleState.BossHorizontal)
      end
      self.monsterMgr:EnterBossLine()
    end
  end
  if self.fingerDown then
    self:OnFingerHold(deltaTime)
  end
  local playerPos = self.team:GetPosition()
  if self.rvoMgr ~= nil then
    self.rvoMgr:Update(playerPos.x, playerPos.z)
  end
  ProfilerUtil.BeginSample("MonsterManagerUpdate")
  if self.monsterMgr ~= nil and not self:IsBattleFinish() then
    if self.battleType == Const.ParkourBattleType.Defense then
      self.monsterMgr:UpdateDefense(self.team:GetPositionZ(), self.defenseOffsetZ, deltaTime)
    else
      self.monsterMgr:Update(self.team:GetPositionZ(), deltaTime)
    end
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
  if self.battleType == Const.ParkourBattleType.Defense then
    self:UpdateDefenseFakeTeamPosZ()
  end
  self:CheckWinConditionCache()
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
  if self.detailLog and self.state == Const.ParkourBattleState.Farm then
    if self.captureTimer == 0 then
      self.captureTimer = self.captureTime
      if self.team.TryCapture then
        self.team:TryCapture()
      end
    else
      self.captureTimer = self.captureTimer - 1
    end
  end
end

function ParkourBattleLogic:UpdateDefenseFakeTeamPosZ()
  local deltaTime = Time.deltaTime
  local position = self.defenseFakeTeamPosZ
  local add = self.initMoveSpeedZ * deltaTime
  local z = position + add
  self.defenseFakeTeamPosZ = z
  self.endLine = self.endLine - add
  self.defenseOffsetZ = self.defenseOffsetZ - add
end

function ParkourBattleLogic:GetMoveSpeedZ()
  return self.initMoveSpeedZ
end

function ParkourBattleLogic:OnUpdateSec()
  self.useTime = self.useTime + 1
  self.sampleCd = self.sampleCd - 1
  if self.sampleCd <= 0 then
    self.sampleCd = FPS_SAMPLE_CD
    local fps = (Time.frameCount - self.sampleFrame) / FPS_SAMPLE_CD
    self.sampleFrame = Time.frameCount
    if fps < self.lowestFps then
      self.lowestFps = fps
    end
  end
  local winConditions = self:GetCheckWinConditions()
  if winConditions[Const.ParkourWinType.Time] then
    local winCondition = winConditions[Const.ParkourWinType.Time]
    self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.Time)
    if self.useTime - self.preConditionUseTime >= winCondition.needTime and not winCondition.finish then
      winCondition.finish = true
      self:OnWinConditionMet()
    end
  end
end

local velocity = Vector3.unity_vector3(0, 0, 0)
local bossSmoothTime = 0.3
local immediateSmoothTime = 0
local normalSmoothTime = 0.3
local tmpV1 = Vector3.New(0, 0, 0)
local tmpV2 = Vector3.New(0, 0, 0)
local tmpV3 = Vector3.New(0, 0, 1)

function ParkourBattleLogic:UpdateCameraFollow(deltaTime)
  if self.state == Const.ParkourBattleState.Exit then
    return
  end
  if self.bonusCameraChangeTimer then
    self.bonusCameraChangeTimer = self.bonusCameraChangeTimer + deltaTime
    local pro = self.bonusCameraChangeTimer / self.bonusCameraChangeInterval
    pro = Mathf.Min(pro, 1)
    local y = Mathf.Lerp(0, self.bonusCameraTargetY, pro)
    local z = Mathf.Lerp(0, self.bonusCameraTargetZ, pro)
    self.bonusCameraOffset.y = y
    self.bonusCameraTargetZ = z
    if 1 <= pro then
      self.bonusCameraChangeTimer = nil
    end
  end
  local v1 = self.battleMgr:GetFollowCameraTarget()
  tmpV1:Set(v1.x, v1.y, v1.z)
  local camLeftBordX = self.data.cameraLeftBoderX
  local camRightBordX = self.data.cameraRightBoderX
  local smoothTime = 0
  if self.state == Const.ParkourBattleState.Boss then
    local teamPos = self.team:GetPosition()
    local teamPosX = teamPos.x
    if camLeftBordX and camRightBordX then
      teamPosX = Mathf.Clamp(teamPosX, camLeftBordX, camRightBordX)
    end
    tmpV2:Set(teamPosX, 0, teamPos.z + LookOffsetBoss)
    smoothTime = bossSmoothTime
  else
    local teamPos = self.team:GetPosition()
    local teamPosX = teamPos.x
    local zOffset = self.cameraFollowOffsetZ
    if self.data.cameraNoOffset then
      zOffset = 0
    end
    if camLeftBordX and camRightBordX then
      teamPosX = Mathf.Clamp(teamPosX, camLeftBordX, camRightBordX)
      tmpV2:Set(teamPosX, 0, teamPos.z + zOffset)
      smoothTime = normalSmoothTime
    else
      tmpV2:Set(XCenter, 0, teamPos.z + zOffset)
      smoothTime = immediateSmoothTime
    end
  end
  if not self.data.cameraNoOffset then
    tmpV2.x = tmpV2.x + tmpV3.x * 0.3
    tmpV2.y = tmpV2.y + tmpV3.y * 0.3
    tmpV2.z = tmpV2.z + tmpV3.z * 0.3
  end
  if self.bonusCameraOffset then
    tmpV2.x = tmpV2.x + self.bonusCameraOffset.x
    tmpV2.y = tmpV2.y + self.bonusCameraOffset.y
    tmpV2.z = tmpV2.z + self.bonusCameraOffset.z
  end
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

function ParkourBattleLogic:TeamObjectActive(isShow)
  if self.team then
    self.team:SetActive(isShow)
  end
end

function ParkourBattleLogic:MonsterInit()
  self:OnParkourBattleStart()
  self.monsterMgr:Init(self)
end

function ParkourBattleLogic:GetGuideTimelineOffset()
  return Vector3.New(-0.4, 0, 4.7)
end

function ParkourBattleLogic:OnGuideTimelineStart(timelineGO)
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

function ParkourBattleLogic:OnWinConditionMet()
  if self.state < Const.ParkourBattleState.PreExit and self.extendFsm then
    if self.bonusType == Const.ParkourBattleBonusType.GoldMonster and self.state ~= Const.ParkourBattleState.GoldMonsterBonus then
      self:CheckWinConditionCache()
      self:ChangeStage(Const.ParkourBattleState.GoldMonsterBonus)
    elseif self.bonusType == Const.ParkourBattleBonusType.ProgressMonster and self.state ~= Const.ParkourBattleState.ProgressMonsterBonus then
      self:CheckWinConditionCache()
      self:ChangeStage(Const.ParkourBattleState.ProgressMonsterBonus)
    elseif self.bonusType == Const.ParkourBattleBonusType.Dash and self.state ~= Const.ParkourBattleState.DashBonus then
      self:CheckWinConditionCache()
      self:ChangeStage(Const.ParkourBattleState.DashBonus)
    elseif self.bonusType == Const.ParkourBattleBonusType.KatyushaSpecial and self.state ~= Const.ParkourBattleState.KatyushaSpecialBonus then
      self:CheckWinConditionCache()
      self:ChangeStage(Const.ParkourBattleState.KatyushaSpecialBonus)
    else
      self:OnBattleWin()
    end
  else
    self:CheckBattleIsWin()
  end
end

function ParkourBattleLogic:OnEnterPreDashBonus()
  self.stopFireZ = nil
  self.team:ChangeStage(Const.ParkourBattleState.PreDashBonus)
  self.monsterMgr:ClearMonsterByView()
  self.bonusCameraChangeTimer = 0
  self.bonusCameraChangeInterval = 2
  self.bonusCameraTargetY = 3
  self.bonusCameraTargetZ = 0
  self.bonusCameraOffset = Vector3.zero
end

function ParkourBattleLogic:OnParkourBonusDashProgressChange(progress)
  if self.bonusType == nil or self.bonusType ~= Const.ParkourBattleBonusType.Dash then
    return
  end
  if self.extendFsm == nil then
    return
  end
  if self.state == nil or self.state ~= Const.ParkourBattleState.DashBonus then
    return
  end
  progress = tonumber(progress) or 0
  local dataList = DataCenter.LWBattleManager:GetBonusDashLevelData()
  for i = #dataList, 1, -1 do
    local data = dataList[i]
    if progress >= data.progress then
      local eff = data.eff
      self.team:ShowBonusDashEffect(eff)
      self.bonusDashDamageCoefficient = data.damageCof
      self.tmpBonusSpeed = data.speedCof
      local anim = data.anim
      if not string.IsNullOrEmpty(anim) then
        self.team:PlayTeamAnim(anim)
      end
      break
    end
  end
end

function ParkourBattleLogic:OnParkourBonusDashStart(damageCoefficient)
  if self.bonusType == nil or self.bonusType ~= Const.ParkourBattleBonusType.Dash then
    return
  end
  if self.extendFsm == nil then
    return
  end
  if self.state == nil or self.state ~= Const.ParkourBattleState.DashBonus then
    return
  end
  if self.tmpBonusSpeed <= 0 then
    self.tmpBonusSpeed = 1
  end
  self.dashBonusSpeed = self.tmpBonusSpeed
  local extendData = self.data.bonusExtendData
  self.bonusDashHeroToEnemy = math.ceil(extendData.heroToEnemy * self.bonusDashDamageCoefficient)
  self.bonusDashSoliderToEnemy = math.ceil(extendData.soliderToEnemy * self.bonusDashDamageCoefficient)
  self:RefreshBonusDashCounter()
end

function ParkourBattleLogic:RefreshBonusDashCounter()
  local lastSolider = false
  local bonusDashMonsterCounter = -1
  local lastUnit = self.team:GetLastUnit()
  if lastUnit ~= nil then
    if lastUnit.initUnit then
    end
    lastSolider = true
    bonusDashMonsterCounter = lastSolider and self.bonusDashSoliderToEnemy or self.bonusDashHeroToEnemy
  end
  self.lastBonusDashSolider = lastSolider
  self.bonusDashMonsterCounter = bonusDashMonsterCounter
end

function ParkourBattleLogic:LoadBonusDashLevelText()
  self:ClearBonusDashLevelText()
  if self.bonusType and self.bonusType == Const.ParkourBattleBonusType.Dash then
    local extendData = self.data.bonusExtendData
    if extendData == nil then
      return
    end
    local rewardData = extendData.rewardData
    if rewardData == nil then
      return
    end
    self.bonusDashLevelTextReqList = {}
    local path = "Assets/Main/Prefabs/LWBattle/BonusLevelSceneText.prefab"
    for _, data in ipairs(rewardData) do
      local req = Resource:InstantiateAsync(path, ObjectPoolTag.BattleScene)
      req:completed("+", function(handle)
        if handle.isError then
          return
        end
        local go = handle.gameObject
        local transform = go.transform
        transform:Set_localPosition(self:GetParkourRushX(), 0.01, data[1])
        transform:Set_localScale(1, 1, 1)
        local text = go:GetComponent(typeof(CS.TextMeshProEx))
        if not IsNull(text) then
          text.text = "\195\151" .. data[2]
        end
      end)
      table.insert(self.bonusDashLevelTextReqList, req)
    end
  end
end

function ParkourBattleLogic:ClearBonusDashLevelText()
  if self.bonusDashLevelTextReqList then
    for _, req in pairs(self.bonusDashLevelTextReqList) do
      req:Destroy()
    end
    self.bonusDashLevelTextReqList = nil
  end
end

function ParkourBattleLogic:CheckBattleIsWin()
  local finishAllCondition = true
  for winType, winCondition in pairs(self.winConditions) do
    if not winCondition.finish then
      finishAllCondition = false
      break
    end
  end
  if finishAllCondition then
    self:OnBattleWin()
  end
end

function ParkourBattleLogic:OnBattleWin()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.bonusType and self.bonusType == Const.ParkourBattleBonusType.Dash then
    self.bonusDashLevel = 1
    self.maxBonus = false
    local extendData = self.data.bonusExtendData
    if extendData and extendData.rewardData then
      local count = #extendData.rewardData
      local teamY = self.team:GetPositionZ()
      for i = count, 1, -1 do
        local data = extendData.rewardData[i]
        if teamY >= data[1] then
          self.bonusDashLevel = data[2]
          self.maxBonus = i == count
          break
        end
      end
    end
  end
  if self.monsterMgr then
    self.monsterMgr:SetGamePause(true)
  end
  self:ChangeStage(Const.ParkourBattleState.PreExit)
end

function ParkourBattleLogic:OnBattleLose()
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

function ParkourBattleLogic:GetPlayerPosZ()
  if not self.initComplete then
    return self.data.initPosY
  end
  return self.team:GetPositionZ()
end

function ParkourBattleLogic:ShakeCameraWithParam(param)
  self.battleMgr:ShakeCameraWithParam(param)
end

function ParkourBattleLogic:DoVibration(intensity, sharpness, duration)
  if self.highQualityMode then
    self.battleMgr:DoVibration(intensity, sharpness, duration)
  end
end

function ParkourBattleLogic:DealDamage(params)
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
  self:ShowDamageText(hurt, hitPoint, damageTextType, bulletMeta.damage_type, critical)
end

function ParkourBattleLogic:DealMemberDie(hero)
  self.team:RemoveMember(hero)
  if self.team:GetMemberCount() < 1 then
    if self.bonusType == Const.ParkourBattleBonusType.Dash and self.state == Const.ParkourBattleState.DashBonus then
      self:OnWinConditionMet()
    else
      self:OnBattleLose()
    end
  end
end

function ParkourBattleLogic:OnMemberDeath(unit)
  if unit and unit.initUnit then
    self.initUnitDeath = true
    if unit.hero and unit.hero.uuid then
      self.heroStatisticalData.death[unit.hero.uuid] = true
    end
  end
  if self.team:GetMemberCount() < 1 then
    if self.bonusType == Const.ParkourBattleBonusType.Dash and self.state == Const.ParkourBattleState.DashBonus then
      self:OnWinConditionMet()
    else
      self:OnBattleLose()
    end
  end
end

function ParkourBattleLogic:ShowDamageText(damage, position, style, damageType, isCritical, time)
  if not self.damageTextMgr then
    return
  end
  if self.data.hideDamage and style ~= DamageTextType.GetBuff and style ~= DamageTextType.TriggerItem then
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

function ParkourBattleLogic:ShowBuffText(txt, position, isDebuff, iconPath, time)
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

function ParkourBattleLogic:Destroy()
  if self.setSceneShadowSuccess then
    CS.SceneManager.ResetSceneShadow()
    self.setSceneShadowSuccess = nil
  end
  self:RemoveListener(EventId.OpenUI)
  self:RemoveListener(EventId.LWBattleBuffStart)
  self:RemoveListener(EventId.LWBattleBuffEnd)
  self:RemoveListener(EventId.ParkourBattleStart)
  self:RemoveListener(EventId.FrontBreakSundayChallengeSaveResult)
  self:RemoveListener(EventId.PlotGroupDone)
  self:RemoveListener(EventId.PlotViewClosedAbnormally)
  self:RemoveListener(EventId.ParkourBonusDashStart)
  self:RemoveListener(EventId.ParkourBonusDashProgressChange)
  self.userCollider2D = false
  PvePhysicsUtil.ExitBattle()
  if self.extendFsm then
    self.extendFsm:Delete()
    self.extendFsm = nil
  end
  self:ClearPreWinConditionCheck()
  for _, v in pairs(self.delayEvents) do
    v:Stop()
  end
  self.delayEvents = {}
  self:UnInitCamera()
  self.touchCamera = nil
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
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
  if self.rvoMgr then
    self.rvoMgr:Destory()
    self.rvoMgr = nil
  end
  self.sceneAnims = nil
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
  self.heroStatisticalData = nil
  self.weaponStatisticalData = nil
  self.heroIdReplaceNormalSkillMap = nil
  self.heroIdReplaceSkillTriggerMap = nil
  self.heroIdReplaceAppearanceMap = nil
  self.heroIdGlobalBuffMap = nil
  self.heroIdReplaceActiveSkillMap = nil
  self.waitingFrontBreakSundayChallengeResult = nil
  self:RemoveSceneUpdator()
  if self.envSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.envSoundHandle)
    self.envSoundHandle = nil
  end
  if self.delaySound then
    self.delaySound:Stop()
    self.delaySound = nil
  end
  if self.delayEnvSound then
    self.delayEnvSound:Stop()
    self.delayEnvSound = nil
  end
  self:ClearFlyNodeData()
  self.hitWhiteMPB = nil
  self.MPB = nil
  self.toCheatExit = nil
  self:ClearBonusDashLevelText()
  if self.battleEffectTimer then
    self.battleEffectTimer:Stop()
    self.battleEffectTimer = nil
  end
  if self.openEffectTimer then
    self.openEffectTimer:Stop()
    self.openEffectTimer = nil
  end
  self.testWaterFresnelMPB = nil
  self.bulletCheatData = nil
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.sharedHeroInfo = nil
  end
  DataCenter.LWHeroUpgradePVEManager:ClearData()
end

function ParkourBattleLogic:AfterExit()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourBattleMain, {anim = false})
  CommonUtil.ProtectCall(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourFormation)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeMain)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroDetailPanel, {anim = false})
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipDetailPanel)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipListPanel)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEquipPromote)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRedEquipLimitTip)
  end)
  self.mainUI = nil
  self:HideGuide()
end

function ParkourBattleLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function ParkourBattleLogic:AddGlobalTauntUnit(unit)
  self.unitMgr:AddGlobalTauntUnit(unit)
  self.tauntVersion = self.tauntVersion + 1
end

function ParkourBattleLogic:CheckGlobalTauntUnit(version)
  local checkVersion = version or 0
  return checkVersion ~= self.tauntVersion, self.tauntVersion
end

function ParkourBattleLogic:RemoveUnit(guid)
  self.unitMgr:RemoveUnitById(guid)
  self:ReleaseTrigger130SlotByPetGuid(guid)
end

function ParkourBattleLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function ParkourBattleLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function ParkourBattleLogic:CheckHasPetUnit()
  return self.team and self.team:CheckHasPetUnit() or false
end

function ParkourBattleLogic:CheckIsPetUnit(guid)
  return self.team and self.team:CheckIsPetUnit(guid) or false
end

function ParkourBattleLogic:ShowEffectObj(path, pos, rot, time, parent, type, scale)
  if string.IsNullOrEmpty(path) then
    return
  end
  type = type == EffectObjType.Sprite and 1 or 0
  time = time or 1
  scale = scale or 1
  if pos == nil and rot == nil then
    return EffectViewUtil.ShowEffectOnlyParent(path, time, type, parent, scale)
  elseif pos == nil then
    return EffectViewUtil.ShowEffectZeroPos(path, time, type, rot, parent)
  elseif rot == nil then
    return EffectViewUtil.ShowEffectZeroRot(path, time, type, pos, parent)
  else
    return EffectViewUtil.ShowEffect(path, time, type, pos, rot, parent)
  end
end

function ParkourBattleLogic:ShowHitEffectForViewTarget(path, worldPos, worldHitDir, hitDirType, time, parentViewHandle, hitEffectLimitNum, useLossyScale)
  local type = 0
  time = time or 1
  hitDirType = hitDirType or 1
  EffectViewUtil.ShowHitEffectForViewTarget(path, worldPos, worldHitDir, hitDirType, time, parentViewHandle, type, hitEffectLimitNum, useLossyScale)
end

function ParkourBattleLogic:RemoveEffectObj(id)
  if not id then
    return
  end
  EffectViewUtil.RemoveEffect(id)
end

function ParkourBattleLogic:RemoveAllHitEffectObjByParentViewHandle(parentViewHandle)
  if not parentViewHandle then
    return
  end
  EffectViewUtil.RemoveAllHitEffectByParentViewHandle(parentViewHandle)
end

function ParkourBattleLogic:OnWorkerSave()
  if self.battleMgr.gameOver then
    return
  end
  local winConditions = self:GetCheckWinConditions()
  if winConditions[Const.ParkourWinType.SaveWorker] then
    local winCondition = winConditions[Const.ParkourWinType.SaveWorker]
    self.saveNum = self.saveNum + 1
    self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.SaveWorker)
    if self.saveNum - self.preConditionSaveNum >= winCondition.needSaveNum then
      winCondition.finish = true
      self:OnWinConditionMet()
    end
  end
end

function ParkourBattleLogic:OnBonusDashMonsterDeath(monster)
  if self.state ~= Const.ParkourBattleState.DashBonus then
    return
  end
  self:OnMonsterDeath(monster)
  if self.bonusDashMonsterCounter and self.bonusDashMonsterCounter > 0 then
    self.bonusDashMonsterCounter = self.bonusDashMonsterCounter - 1
    if self.bonusDashMonsterCounter <= 0 then
      local lastUnit = self.team:GetLastUnit()
      if lastUnit ~= nil then
        if lastUnit.Die then
          lastUnit:Die()
        else
          self:DealMemberDie(lastUnit)
        end
      end
      if self.state == Const.ParkourBattleState.DashBonus then
        self:RefreshBonusDashCounter()
      end
    end
  end
end

function ParkourBattleLogic:OnMonsterDeath(monster)
  if self.battleMgr.gameOver then
    return
  end
  local winConditions = self:GetCheckWinConditions()
  if monster:GetIsCountKillNum() then
    self.killNum = self.killNum + 1
  end
  for winType, condition in pairs(winConditions) do
    if not condition.finish then
      self:CheckMonsterWinConditionFinish(monster, condition)
    end
  end
  self:TryCallExtendFsmStateFuc("OnMonsterDeath", monster)
end

function ParkourBattleLogic:CheckMonsterWinConditionFinish(monster, winCondition)
  if winCondition.winType == Const.ParkourWinType.KillMonster then
    self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.KillMonster)
    if self.killNum - self.preConditionKillNum >= winCondition.needKillNum then
      winCondition.finish = true
      self:OnWinConditionMet()
    end
  elseif winCondition.winType == Const.ParkourWinType.KillTargetMonster then
    local target = winCondition.needKillTarget[monster.monsterMeta.id]
    local preFinish = 0
    if self.preConditionKillTargetMonster and self.preConditionKillTargetMonster[monster.monsterMeta.id] then
      preFinish = self.preConditionKillTargetMonster[monster.monsterMeta.id]
    end
    if target and target.finish - preFinish < target.need then
      target.finish = target.finish + 1
      self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.KillTargetMonster)
      local allFinish = true
      for k, v in pairs(winCondition.needKillTarget) do
        if v.finish < v.need then
          allFinish = false
          break
        end
      end
      if allFinish then
        winCondition.finish = true
        self:OnWinConditionMet()
      end
    end
  elseif winCondition.winType == Const.ParkourWinType.KillBoss then
    if monster.monsterMeta.is_boss == 1 or monster.monsterMeta.monster_type == Const.MonsterType.Boss then
      table.removebyvalue(self.boss, monster, true)
      self.killBossNum = self.killBossNum + 1
      if self.killBossNum - self.preConditionKillBossNum == winCondition.needKillNum then
        self.unitMgr:ForceFinishFlash()
        self.battleMgr:SetGamePause(true)
        if not self.winTimer then
          Time.timeScale = 0.5
          self.winTimer = TimerManager:GetInstance():GetTimer(4, function()
            self.battleMgr:SetGamePause(false)
            Time.timeScale = 1
            winCondition.finish = true
            self:OnWinConditionMet()
            self.winTimer:Stop()
            self.winTimer = nil
          end, nil, true, false, true)
          self.winTimer:Start()
        end
      end
      self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.KillBoss)
    end
  elseif winCondition.winType == Const.ParkourWinType.BlastStandingWaterBottle and monster.monsterMeta.monster_type == Const.MonsterType.StandingWaterBottle then
    self.blastStandingWaterBottleNum = self.blastStandingWaterBottleNum + 1
    self:BroadcastParkourWinConditionRefresh(Const.ParkourWinType.BlastStandingWaterBottle)
    if self.blastStandingWaterBottleNum - self.preConditionBlastStandingWaterBottleNum >= winCondition.needKillNum then
      winCondition.finish = true
      self:OnWinConditionMet()
    end
  end
end

function ParkourBattleLogic:OnBossEnterBattle(boss)
  local winCondition = self.winCondition
  for _, winConditionData in ipairs(winCondition) do
    if winConditionData.winType == Const.ParkourWinType.KillBoss then
      table.insert(self.boss, boss)
    end
  end
end

function ParkourBattleLogic:OnOpenUI(name)
end

function ParkourBattleLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ParkourBattleLogic:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function ParkourBattleLogic:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function ParkourBattleLogic:OnBuffChange()
  if not self.team then
    return
  end
  self.team.moveSpeedDirty = true
  self.team.moveSpeedZDirty = true
  self.team.superArmorDirty = true
end

function ParkourBattleLogic:GetStageId()
  return self.data.meta.id
end

function ParkourBattleLogic:GetTotalKill()
  return self.killNum
end

function ParkourBattleLogic:GetCostTime()
  return self.useTime
end

function ParkourBattleLogic:GetAvgFPS()
  if self.frameTimer == 0 then
    return -1
  end
  return self.frames / self.frameTimer
end

function ParkourBattleLogic:GetLowestFPS()
  return math.min(self.lowestFps, self:GetAvgFPS())
end

function ParkourBattleLogic:GetMemberCount()
  if self.team then
    return self.team:GetMemberCount()
  end
  return -1
end

function ParkourBattleLogic:GetRemainUnitCount()
  if self.team then
    return self.team:GetRemainUnitCount()
  end
  return -1
end

function ParkourBattleLogic:RecordGoods(goodsId, goodsCount)
  if not self.goods[goodsId] then
    self.goods[goodsId] = 0
  end
  self.goods[goodsId] = self.goods[goodsId] + goodsCount
  if self.data.collectType and self.data.collectType ~= DetectEventRetryTaskCollectType.Soldier then
    local collectNum = self.goods[DetectEventRetryTaskCollectType2ResourceType[self.data.collectType]]
    if collectNum and self.data.collectMaxNum and self.team then
      self.team:RefreshHummerHero(collectNum / self.data.collectMaxNum)
    end
  end
end

function ParkourBattleLogic:GetGoods()
  return self.goods
end

function ParkourBattleLogic:SetJoystick(joystick)
  self.joystick = joystick
  self:DisableJoystick()
end

function ParkourBattleLogic:EnableJoystick()
  self.joystick:SetEnabled(true)
end

function ParkourBattleLogic:DisableJoystick()
  if self.fingerDown then
    self.fingerDown = false
    self.joystick:Reset()
  end
  self.joystick:SetEnabled(false)
end

function ParkourBattleLogic:IsFingerOnUI()
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

function ParkourBattleLogic:OnFingerDownJoyStick(pos)
  if not (self.joystick and self.joystick:GetEnabled()) or self:IsFingerOnUI() then
    return
  end
  self.joystick:OnFingerDown(pos)
  self.team:OnFingerDown(pos)
end

function ParkourBattleLogic:OnFingerUpJoyStick()
  self.joystick:OnFingerUp()
  self.team:OnFingerUp()
end

function ParkourBattleLogic:OnFingerHoldJoyStick(deltaTime)
  local vx, vz = self.joystick:OnUpdate()
  self.team:OnFingerHold(vx, vz, deltaTime)
end

function ParkourBattleLogic:ChangeStage(newStage)
  if self.extendFsm and Const.ParkourBattleExtendFsmState[newStage] then
    self.state = newStage
    self.extendFsm:ChangeState(Const.ParkourBattleExtendFsmState[newStage], newStage)
    return
  end
  if self.extendFsm then
    self.extendFsm:ChangeState(Const.ParkourBattleExtendFsmState.Normal)
  end
  local oldStage = self.state
  if newStage == Const.ParkourBattleState.Ready then
    self.state = Const.ParkourBattleState.Ready
  elseif newStage == Const.ParkourBattleState.Farm then
    self.state = Const.ParkourBattleState.Farm
    self.team:ChangeStage(self.state)
  elseif newStage == Const.ParkourBattleState.Boss then
    self.state = Const.ParkourBattleState.Boss
    self.team:ChangeStage(self.state)
    local hei = 30
    if self.data.bossCameraZoom then
      hei = self.data.bossCameraZoom
    end
    self.battleMgr:AutoZoom(hei)
    self:EnableJoystick()
    if self:GetStageId() == 109 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITutorialAnimation, {anim = false}, 3)
    end
    self:OnFingerUp()
  elseif newStage == Const.ParkourBattleState.BossStay then
    self.state = Const.ParkourBattleState.BossStay
    self.team:ChangeStage(self.state)
    self:OnFingerUp()
  elseif newStage == Const.ParkourBattleState.BossHorizontal then
    self.state = Const.ParkourBattleState.BossHorizontal
    self.team:ChangeStage(self.state)
  elseif newStage == Const.ParkourBattleState.PreExit then
    if oldStage == Const.ParkourBattleState.PreExit or oldStage == Const.ParkourBattleState.Exit or oldStage == Const.ParkourBattleState.Lose then
      return
    end
    self.state = Const.ParkourBattleState.PreExit
    if self.team == nil then
      Logger.LogInfo("ParkourBattleLogic ChangeStage PreExit Error: team is nil, oldStage:" .. tostring(oldStage) .. " levelId:" .. tostring(self.levelId))
    end
    self.team:ChangeStage(self.state)
    if self.mainUI then
      self.mainUI:OnParkourBattleWin()
      self:DoVibration(0.5, 0.3, 0.3)
    end
    if self.bonusType == Const.ParkourBattleBonusType.Dash then
      self:ChangeStage(Const.ParkourBattleState.Exit)
    else
      self:AddDelayEvent(function()
        self:ChangeStage(Const.ParkourBattleState.Exit)
      end, 0.7)
      self.winToRemoveEffect = true
    end
  elseif newStage == Const.ParkourBattleState.Exit then
    if oldStage ~= Const.ParkourBattleState.PreExit then
      return
    end
    self.state = Const.ParkourBattleState.Exit
    self:DisableJoystick()
    if self.bonusType == Const.ParkourBattleBonusType.Dash then
      self.team:ChangeStage(Const.ParkourBattleState.DashBonusExit)
    else
      self.team:ChangeStage(self.state)
    end
    local memberCount = self.team:GetRemainUnitCount()
    self.remainMember = memberCount
    if self.bonusType ~= Const.ParkourBattleBonusType.None and self.bonusType ~= Const.ParkourBattleBonusType.KatyushaSpecial then
      local param = {}
      param.enterType = self.param.enterType
      param.stageId = self.data.meta.id
      param.stageRewardList = self.data.stageRewardList
      param.goods = self:GetGoods()
      param.bonusType = self.bonusType
      param.bonusWinConditions = self.data.bonusWinConditions
      param.extendData = self.data.bonusExtendData
      param.extraData = self.param.extraData
      if self.bonusType == Const.ParkourBattleBonusType.Dash then
        local dashLevel = self.bonusDashLevel or 1
        param.bonusLevel = dashLevel
        param.maxBonus = self.maxBonus
        self:RecordGoods(ResourceType.GoldProgress, Mathf.Ceil(dashLevel * 100))
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourBonusVictory, {anim = false, playEffect = 10024}, param)
    elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureVictory, {anim = true, playEffect = 10024}, self.param)
      self:NoticeWin()
    elseif self.param.enterType == PVEEnterType.OpeningStage or self.param.enterType == PVEEnterType.CityFakeZombie then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultNewbieVictory, {anim = true, playEffect = 10024}, param)
      self:NoticeWin()
    elseif self.param.enterType == PVEEnterType.DetectRetryTask then
      self:OpenDetectRetryTaskResult()
    elseif self.param.enterType == PVEEnterType.DetectAttackCityS0 then
      self:OpenDetectRetryAttackCityS0Result(true)
    elseif self.param.enterType == PVEEnterType.DetectZombieBusTrain then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.showStatistic = self.data.showStatistic
      param.enterType = self.param.enterType
      param.absoluteBtn = self.param.absoluteBtn
      local zombieBusTrainData = {}
      zombieBusTrainData.isInWorld = self.param.extraData.isInWorld
      zombieBusTrainData.busId = self.param.extraData.busId
      zombieBusTrainData.busIndex = self.param.extraData.busIndex
      zombieBusTrainData.eventUuid = self.param.extraData.eventUuid
      param.zombieBusTrainData = zombieBusTrainData
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultRadarZombieBusTrainVictory, {anim = true, playEffect = 10024}, param)
      self:NoticeWin()
    elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.showStatistic = self.data.showStatistic
      param.enterType = self.param.enterType
      param.fromChapter = self.param.fromChapter
      param.fromActFrontBreakSunday = false
      param.absoluteBtn = self.param.absoluteBtn
      param.buildUuid = self.param.buildUuid
      param.featureId = self.param.featureId
      param.rank = math.random(94, 99)
      local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.param.featureId)
      local index = 1
      if 1 < #feature.winType then
        index = table.indexof(feature.stages, self.param.levelId)
      end
      if feature.winType[index] == 1 then
        local coin = self:GetGoldCount()
        local needCount = feature.winNeedCount[index]
        param.coin = coin
        if coin >= needCount then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
          self:NoticeWin()
          PostEventLog.BattleResultLog(PVEType.Parkour, 1)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
          PostEventLog.BattleResultLog(PVEType.Parkour, 0)
        end
      elseif feature.winType[index] == 2 then
        DataCenter.StageFeatureBuildingManager:SaveScore(param.buildUuid, memberCount)
        local totalScore = DataCenter.StageFeatureBuildingManager:GetScore(param.buildUuid)
        local needTotal = feature.winNeedCount[index]
        if #feature.winType == 1 then
          if param.stageId == feature.stages[#feature.stages] then
            if totalScore >= needTotal then
              param.remainNumber = memberCount
              param.remainTotalNumber = totalScore
              param.needTotalNumber = needTotal
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
              self:NoticeWin()
              PostEventLog.BattleResultLog(PVEType.Parkour, 1)
            else
              param.remainNumber = memberCount
              param.remainTotalNumber = totalScore
              param.needTotalNumber = needTotal
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
              PostEventLog.BattleResultLog(PVEType.Parkour, 0)
            end
          else
            param.remainNumber = memberCount
            param.remainTotalNumber = totalScore
            param.needTotalNumber = needTotal
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
            self:NoticeWin()
            PostEventLog.BattleResultLog(PVEType.Parkour, 1)
          end
        elseif memberCount >= needTotal then
          param.remainNumber = memberCount
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
          self:NoticeWin()
          PostEventLog.BattleResultLog(PVEType.Parkour, 1)
        else
          param.remainNumber = memberCount
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
          PostEventLog.BattleResultLog(PVEType.Parkour, 0)
        end
      elseif feature.winType[index] == 0 then
        param.time = self.useTime
        param.kill = self.killNum
        self:NoticeWin()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
      elseif feature.winType[index] == 3 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourBattleWin, {anim = false, playEffect = 10024}, param)
        self:NoticeWin()
      end
    elseif self.param.enterType == PVEEnterType.HeroTryOut then
      local p = {}
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITowerupBattleWin, {anim = false, playEffect = 10024}, p, self.param)
      self:NoticeWin()
    elseif self.param.enterType == PVEEnterType.Monopoly then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.showStatistic = self.data.showStatistic
      param.enterType = self.param.enterType
      param.absoluteBtn = self.param.absoluteBtn
      if param.showStatistic then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultStatisticVictory, {anim = true, playEffect = 10024}, param)
      elseif string.IsNullOrEmpty(self.data.meta.default_hero) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourVictory, {anim = true, playEffect = 10024}, param)
      else
        if DataCenter.ParkourManager.reward ~= nil then
          Logger.LogError("[ParkourBattleLogic] \229\164\167\229\175\140\231\191\129\229\133\179\229\141\161\230\156\137\233\187\152\232\174\164\232\139\177\233\155\132\230\151\182\232\191\152\233\133\141\231\189\174\228\186\134\229\165\150\229\138\177\239\188\140\233\156\128\232\166\129\229\164\132\231\144\134: " .. tostring(self.data.meta.id))
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultNewbieVictory, {anim = true, playEffect = 10024}, param)
      end
      self:NoticeWin()
    else
      if not self.param.fromActFrontBreakSunday then
        local param = {}
        param.time = self.useTime
        param.kill = self.killNum
        param.stageId = self.data.meta.id
        param.showStatistic = self.data.showStatistic
        param.enterType = self.param.enterType
        param.fromChapter = self.param.fromChapter
        param.absoluteBtn = self.param.absoluteBtn
        param.isIntegratedStage = self.param.isIntegratedStage
        param.integratedStageDifficulty = self.param.integratedStageDifficulty
        if param.fromChapter then
          param.score = self.remainMember
          local rankNum = param.score >= self.data.expect_num and 99 or math.floor(param.score / self.data.expect_num * 100)
          local randomNum = math.random(1, 99)
          param.rank = string.format("%02d.%02d%%", rankNum, randomNum)
          if self.param.isChapterHelp then
            param.rankPercentNum = rankNum * 100 + randomNum
            self.rankPercentNum = param.rankPercentNum
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultFrontBreakVictory, {anim = true, playEffect = 10024}, param)
        elseif param.showStatistic then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultStatisticVictory, {anim = true, playEffect = 10024}, param)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourVictory, {anim = true, playEffect = 10024}, param)
        end
      end
      self:NoticeWin()
    end
    if self.param.enterType ~= PVEEnterType.StageFeatureBuilding then
      PostEventLog.BattleResultLog(PVEType.Parkour, 1)
    end
    self:AddDelayEvent(function()
      if self.battleMgr then
        self.battleMgr:SetGameOver(true)
      end
    end, 4)
  elseif newStage == Const.ParkourBattleState.Lose then
    if oldStage == Const.ParkourBattleState.PreExit or oldStage == Const.ParkourBattleState.Exit or oldStage == Const.ParkourBattleState.Lose then
      return
    end
    self.state = Const.ParkourBattleState.Lose
    if self.team then
      self.team:ChangeStage(self.state)
    end
    if self.mainUI and self.mainUI.OnParkourBattleLose then
      self.mainUI:OnParkourBattleLose()
    end
    self.battleMgr:SetGameOver(true)
    EffectViewUtil.Update(Time.deltaTime)
    if self.param.enterType == PVEEnterType.TowerupJeepAdventure then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat, {anim = true, playEffect = 10023}, self.param)
    elseif self.param.enterType == PVEEnterType.OpeningStage or self.param.enterType == PVEEnterType.CityFakeZombie then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultNewbieDefeat, {anim = true, playEffect = 10023}, param)
    elseif self.param.enterType == PVEEnterType.DetectRetryTask then
      self:OpenDetectRetryTaskResult()
    elseif self.param.enterType == PVEEnterType.DetectAttackCityS0 then
      self:OpenDetectRetryAttackCityS0Result()
    elseif self.param.enterType == PVEEnterType.DetectCaveExploreEnter then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.hideTryAgainBtn = true
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourDefeat, {anim = true, playEffect = 10023}, param)
    elseif self.param.enterType == PVEEnterType.StageFeatureBuilding then
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.extraData = self.param.extraData
      param.showStatistic = self.data.showStatistic
      param.enterType = self.param.enterType
      param.suggest_herolv = self.suggest_herolv
      param.absoluteBtn = self.param.absoluteBtn
      param.buildUuid = self.param.buildUuid
      param.featureId = self.param.featureId
      param.rank = math.random(90, 100)
      local feature = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(self.param.featureId)
      local index = 1
      if 1 < #feature.winType then
        index = table.indexof(feature.stages, self.param.levelId)
      end
      local needTotal = feature.winNeedCount[index]
      if feature.winType[index] == 1 then
        local coin = self:GetGoldCount() or 0
        param.currentNumber = coin
        param.needTotalNumber = needTotal
        param.coin = coin
        if needTotal <= coin then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleWin, {anim = false, playEffect = 10024}, param)
          self:NoticeWin()
          PostEventLog.BattleResultLog(PVEType.Parkour, 1)
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10024}, param)
          PostEventLog.BattleResultLog(PVEType.Parkour, 0)
        end
      elseif feature.winType[index] == 2 then
        local memberCount = self.team:GetRemainUnitCount()
        DataCenter.StageFeatureBuildingManager:SaveScore(param.buildUuid, memberCount)
        local totalScore = DataCenter.StageFeatureBuildingManager:GetScore(param.buildUuid)
        param.remainNumber = memberCount
        param.remainTotalNumber = totalScore
        param.needTotalNumber = needTotal
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10023}, param)
        PostEventLog.BattleResultLog(PVEType.Parkour, 0)
      elseif feature.winType[index] == 0 then
        param.showStatistic = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourMysteryTreasureBattleLose, {anim = false, playEffect = 10023}, param)
      elseif feature.winType[index] == 3 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourBattleLose, {anim = false, playEffect = 10023}, param)
        PostEventLog.BattleResultLog(PVEType.Parkour, 0)
      end
    elseif self.param.fromActFrontBreakSunday then
      SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayGetChallengeResult, self.data.meta.id, self.remainMember)
      self:TryAddFrontBreakSundayTimeOutCheckTimer()
    else
      local param = {}
      param.time = self.useTime
      param.kill = self.killNum
      param.stageId = self.data.meta.id
      param.extraData = self.param.extraData
      param.showStatistic = self.data.showStatistic
      param.enterType = self.param.enterType
      param.fromChapter = self.param.fromChapter
      param.loseToShowVideo = self.loseToShowVideo
      param.loseToShowVideoURL = self.loseToShowVideoURL
      param.suggest_herolv = self.suggest_herolv
      param.fromActFrontBreakSunday = false
      param.absoluteBtn = self.param.absoluteBtn
      param.isChapterHelp = self.param.isChapterHelp
      param.isIntegratedStage = self.param.isIntegratedStage
      param.integratedStageDifficulty = self.param.integratedStageDifficulty
      if param.fromChapter then
        if param.isIntegratedStage then
          DataCenter.LWIntegratedStageFeatureChapterManager:AddFailStage(param.integratedStageDifficulty, param.stageId)
        else
          DataCenter.LWStageFeatureChapterManager:AddFailStage(param.stageId)
          DataCenter.LWEasyStageFeatureChapterManager:AddFailStage(param.stageId)
        end
        local failSkipNum = self.data.failSkipNum
        param.chapterFailSkipNum = failSkipNum
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultFrontBreakDefeat, {anim = true, playEffect = 10023}, param)
      elseif param.showStatistic then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultStatisticDefeat, {anim = true, playEffect = 10023}, param)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourDefeat, {anim = true, playEffect = 10023}, param)
      end
    end
    if self.param.enterType ~= PVEEnterType.StageFeatureBuilding then
      PostEventLog.BattleResultLog(PVEType.Parkour, 0)
    end
  end
end

function ParkourBattleLogic:GetGoldCount()
  local goods = self:GetGoods()
  if goods and goods[2] then
    return goods[2]
  end
end

function ParkourBattleLogic:TryAddFrontBreakSundayTimeOutCheckTimer()
  if self.waitingFrontBreakSundayChallengeResult == true then
    return
  end
  self.waitingFrontBreakSundayChallengeResult = true
  self:AddDelayEvent(function()
    if self.waitingFrontBreakSundayChallengeResult then
      self.waitingFrontBreakSundayChallengeResult = false
      self:ReactFrontBreakSundayTimeOut()
    end
  end, 5)
end

function ParkourBattleLogic:ReactFrontBreakSundayTimeOut()
  self:NoticeLose()
  self.battleMgr:Exit(nil, "lose")
  UIUtil.ShowTips(Localization:GetString("activity_breakthrough_tips_58"))
end

function ParkourBattleLogic:IsBattleFinish()
  return self.state >= Const.ParkourBattleState.PreExit
end

function ParkourBattleLogic:NoticeWin()
  if not self.param.isChapterHelp then
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleWin, self.data.meta.id)
    EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_win, self.data.meta.id)
  end
  if self.param.enterType == PVEEnterType.StageFeatureBuilding then
    local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(tonumber(self.param.featureId))
    local idx = table.indexof(template.stages, self.param.levelId)
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
  end
  if self.param.enterType == PVEEnterType.DetectZombieBusTrain then
    SFSNetwork.SendMessage(MsgDefines.DetectEventZombieBusPassFeature, self.param.extraData.eventUuid, self.param.extraData.busIndex)
    return
  end
  if self.param.enterType == PVEEnterType.DetectRetryTask then
    SFSNetwork.SendMessage(MsgDefines.DetectEventTaskRetryEnd, self.param.extraData.uuid, self.param.extraData.eventType, self.param.extraData.resultRewardNum, self.levelId)
    return
  end
  if self.param.enterType == PVEEnterType.DetectAttackCityS0 and self.param.extraData then
    DataCenter.AttackCityAnimManager:SaveMonsterRadarPointIdAndPrefab(self.param.extraData.pointId, self.param.extraData.prefabPath)
    SFSNetwork.SendMessage(MsgDefines.DetectEventCityCompetitionS0End, self.param.extraData.uuid, self.param.extraData.eventType)
    return
  end
  if self.param.enterType == PVEEnterType.HeroTryOut and self.param.extraData then
    DataCenter.HeroTryOutManager:SendHeroTryOutBattleMessage(self.param.extraData.cfgId)
    return
  end
  if not self.param.isChapterHelp then
    SFSNetwork.SendMessage(MsgDefines.ParkourInfoMessage, self.data.meta.id, self.goods)
  end
  if self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
    local uuid = self.param.extraData.uuid
    SFSNetwork.SendMessage(MsgDefines.DetectEventPveFeatureEnd, uuid, true)
  end
  if self.param.fromChapter then
    local id = self.data.meta.id
    if self.param.isChapterHelp then
      SFSNetwork.SendMessage(MsgDefines.HelpPlaneFeatureFinish, self.param.helpUuid, id, self.remainMember, self.rankPercentNum)
    elseif self.param.isIntegratedStage then
      local difficulty = self.param.integratedStageDifficulty
      SFSNetwork.SendMessage(MsgDefines.StageFeatureIntegratedRecordMessage, id, self.remainMember, difficulty)
    else
      SFSNetwork.SendMessage(MsgDefines.StageFeatureChapterRecordMessage, id, self.remainMember)
    end
  end
  if self.param.fromActFrontBreakSunday then
    local id = self.data.meta.id
    SFSNetwork.SendMessage(MsgDefines.FrontBreakSundayGetChallengeResult, id, self.remainMember)
    self:TryAddFrontBreakSundayTimeOutCheckTimer()
  end
  if self.param.enterType == PVEEnterType.DetectCaveExploreEnter then
    local data = self.param.caveData
    if data then
      DataCenter.CaveExplorationManager:TryNextStep(data.eventUuid, data.configId, data.index)
    else
      Logger.LogError("Missing caveData")
    end
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    local cfgId = -1
    if self.param.extraData ~= nil and self.param.extraData.cfgId ~= nil then
      cfgId = self.param.extraData.cfgId
    end
    SFSNetwork.SendMessage(MsgDefines.LWSaveTowerupRecord, cfgId)
  end
end

function ParkourBattleLogic:NoticeLose()
  EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_lose, self.data.meta.id)
  if self.param.enterType == PVEEnterType.DetectRetryTask or self.param.enterType == PVEEnterType.DetectAttackCityS0 then
    return
  end
  if self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
    local uuid = self.param.extraData.uuid
    SFSNetwork.SendMessage(MsgDefines.DetectEventPveFeatureEnd, uuid, false)
  end
end

function ParkourBattleLogic:GetInitPos()
  return Vector3(self.data.initPosX, 0, self.data.initPosY)
end

function ParkourBattleLogic:GetPVEType()
  return PVEType.Parkour
end

function ParkourBattleLogic:GetSquadMemberPosition()
  if self.team then
    return self.team:ReturnMemberPositions()
  end
  return {}
end

function ParkourBattleLogic:ResetHeroPos()
  if self.team then
    self.team:ResetHeroPosition()
  end
end

function ParkourBattleLogic:SetHeroers(heroes)
  if self.team then
    self.team:ChangeHeroes(heroes)
  end
end

function ParkourBattleLogic:SetHeroPos(index, worldPos)
  if self.team then
    self.team:SetHeroPosition(index, worldPos)
  end
end

function ParkourBattleLogic:HeroMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.5
  if self.team then
    self.team:MoveHeroToIndex(index, dstIndex, animTime)
  end
end

function ParkourBattleLogic:TryShowGuide()
  if self:GetStageId() == DataCenter.LWBattleManager:GetParkourFirstGuideStageId() then
    local guide = Setting:GetPrivateBool(SettingKeys.PARKOUR_FIRST_GUIDE_SHOW, false)
    if guide then
      return
    end
    Setting:SetPrivateBool(SettingKeys.PARKOUR_FIRST_GUIDE_SHOW, true)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourTutorial, {anim = false})
    self.showGuide = true
  end
end

function ParkourBattleLogic:HideGuide()
  if self.showGuide then
    self.showGuide = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIParkourTutorial)
  end
end

function ParkourBattleLogic:SummonMonster(pos, owner, monsterId, count, hpPercent)
  if owner then
    local maxBlood = owner.maxBlood
    maxBlood = maxBlood * hpPercent
    self.monsterMgr:Summon(pos, monsterId, count, maxBlood, owner.meta)
  end
end

function ParkourBattleLogic:SummonMonsterBatch(startPos, monsterId, count, posOffset, hp, monsterMeta)
  self.monsterMgr:SummonBatch(startPos, monsterId, count, posOffset, hp, monsterMeta)
end

function ParkourBattleLogic:SummonPet(master, metaId, count, skill)
  if self.team then
    for i = 1, count do
      if skill.HasSummonFormation and skill:HasSummonFormation() then
        local slot = skill:TryGetSummonSlot()
        if 0 < slot then
          local pet = self.team:CreatePet(metaId, master)
          if pet and pet.SetSummonSlot then
            local offsetX, offsetZ = skill:GetSummonSlotPos(slot)
            skill:SetSummonSlotUnit(slot, pet:GetGuid())
            pet:SetSummonSlot(slot, offsetX, offsetZ, skill.meta.id)
          else
            skill:ReleaseSlot(slot)
          end
        end
      else
        self.team:CreatePet(metaId, master)
      end
    end
  end
end

function ParkourBattleLogic:GetNextSummonPetSlotPos()
  if not self.data or not self.data.GetSummonPetSlotCount then
    Logger.LogError("[GetNextSummonPetSlotPos] summon slot data is nil")
    return nil
  end
  local totalCount = self.data:GetSummonPetSlotCount()
  if totalCount <= 0 then
    Logger.LogError("[GetNextSummonPetSlotPos] summon slot count is invalid, count\228\184\186:" .. totalCount)
    return nil
  end
  for slotIndex = 1, totalCount do
    if not self:IsTrigger130SlotOccupied(slotIndex) then
      local pos = self.data:GetSummonPetSlotPos(slotIndex)
      if pos then
        return pos, slotIndex
      end
      Logger.LogError("[GetNextSummonPetSlotPos] summon slot pos is nil, slotIndex\228\184\186:" .. tostring(slotIndex))
    end
  end
  Logger.LogError("[GetNextSummonPetSlotPos] no idle slot found")
  return nil
end

function ParkourBattleLogic:GetSummonPetSlotPosByIndex(slotIndex)
  if not self.data or not self.data.GetSummonPetSlotPos then
    Logger.LogError("[GetSummonPetSlotPosByIndex] summon slot data is nil, slotIndex\228\184\186:" .. tostring(slotIndex))
    return nil
  end
  if not slotIndex or slotIndex <= 0 then
    Logger.LogError("[GetSummonPetSlotPosByIndex] slotIndex is invalid, slotIndex\228\184\186:" .. tostring(slotIndex))
    return nil
  end
  local pos = self.data:GetSummonPetSlotPos(slotIndex)
  if not pos then
    Logger.LogError("[GetSummonPetSlotPosByIndex] summon slot pos is nil, slotIndex\228\184\186:" .. tostring(slotIndex))
  end
  return pos
end

function ParkourBattleLogic:IsTrigger130SlotOccupied(slotIndex)
  if self.trigger130SlotReserve and 0 < (self.trigger130SlotReserve[slotIndex] or 0) then
    return true
  end
  if not self.trigger130SlotOccupy then
    return false
  end
  local petGuid = self.trigger130SlotOccupy[slotIndex]
  if not petGuid then
    return false
  end
  if self.team and self.team.CheckIsPetUnit and self.team:CheckIsPetUnit(petGuid) then
    return true
  end
  self.trigger130SlotOccupy[slotIndex] = nil
  if self.trigger130PetToSlot then
    self.trigger130PetToSlot[petGuid] = nil
  end
  return false
end

function ParkourBattleLogic:ReserveTrigger130Slot(slotIndex)
  if not slotIndex or slotIndex <= 0 then
    return
  end
  if not self.trigger130SlotReserve then
    self.trigger130SlotReserve = {}
  end
  self.trigger130SlotReserve[slotIndex] = (self.trigger130SlotReserve[slotIndex] or 0) + 1
end

function ParkourBattleLogic:ReleaseTrigger130SlotReserve(slotIndex)
  if not slotIndex or slotIndex <= 0 or not self.trigger130SlotReserve then
    return
  end
  local cnt = (self.trigger130SlotReserve[slotIndex] or 0) - 1
  if 0 < cnt then
    self.trigger130SlotReserve[slotIndex] = cnt
  else
    self.trigger130SlotReserve[slotIndex] = nil
  end
end

function ParkourBattleLogic:OccupyTrigger130Slot(slotIndex, petGuid)
  if not slotIndex or slotIndex <= 0 or not petGuid then
    return
  end
  if not self.trigger130SlotOccupy then
    self.trigger130SlotOccupy = {}
  end
  if not self.trigger130PetToSlot then
    self.trigger130PetToSlot = {}
  end
  self.trigger130SlotOccupy[slotIndex] = petGuid
  self.trigger130PetToSlot[petGuid] = slotIndex
end

function ParkourBattleLogic:ReleaseTrigger130SlotByPetGuid(petGuid)
  if not petGuid or not self.trigger130PetToSlot then
    return
  end
  local slotIndex = self.trigger130PetToSlot[petGuid]
  if slotIndex and self.trigger130SlotOccupy and self.trigger130SlotOccupy[slotIndex] == petGuid then
    self.trigger130SlotOccupy[slotIndex] = nil
  end
  self.trigger130PetToSlot[petGuid] = nil
end

function ParkourBattleLogic:GetSummonFriendlyPetPos(meta, fromPos, needSlotIndex)
  if not meta or not meta.summonFriendlyPetData then
    Logger.LogError("[GetSummonFriendlyPetPos] summonFriendlyPetData is nil")
    if needSlotIndex then
      return fromPos, nil
    end
    return fromPos
  end
  local cfg = meta.summonFriendlyPetData
  if self.data and self.data.isOpenSlot ~= true then
    Logger.LogError("[GetSummonFriendlyPetPos] stage is_open_slot is off, triggerId\228\184\186:" .. tostring(meta.id))
    if needSlotIndex then
      return fromPos, nil
    end
    return fromPos
  end
  if cfg.posType == 1 then
    if cfg.slotIndex == -1 then
      local slotPos, slotIndex = self:GetNextSummonPetSlotPos()
      local finalPos = slotPos or fromPos
      if needSlotIndex then
        return finalPos, slotIndex
      end
      return finalPos
    end
    if self:IsTrigger130SlotOccupied(cfg.slotIndex) then
      local slotPos, slotIndex = self:GetNextSummonPetSlotPos()
      local finalPos = slotPos or fromPos
      if needSlotIndex then
        return finalPos, slotIndex
      end
      return finalPos
    end
    local finalPos = self:GetSummonPetSlotPosByIndex(cfg.slotIndex) or fromPos
    if needSlotIndex then
      return finalPos, cfg.slotIndex
    end
    return finalPos
  elseif cfg.posType == 2 then
    local worldX = XCenter + (cfg.posX or 0)
    local worldZ = (self.data and self.data.initPosY or 0) + (cfg.posZ or 0)
    local finalPos = Vector3.New(worldX, 0, worldZ)
    if needSlotIndex then
      return finalPos, nil
    end
    return finalPos
  end
  Logger.LogError("[GetSummonFriendlyPetPos] posType is invalid, posType\228\184\186:" .. tostring(cfg.posType))
  if needSlotIndex then
    return fromPos, nil
  end
  return fromPos
end

function ParkourBattleLogic:TryGetSummonFriendlyPetFlyData(eventId, extra)
  if not eventId then
    return false, extra, nil
  end
  local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
  if not meta or meta.type ~= TriggerEnum.EventType.SummonFriendlyPet then
    return false, extra, nil
  end
  local extraData = extra
  if type(extraData) ~= "table" then
    extraData = {}
  end
  local fromPos = extraData.fromPos
  local summonPos, summonSlotIndex = self:GetSummonFriendlyPetPos(meta, fromPos, true)
  if summonPos then
    extraData.summonPos = summonPos
    extraData.summonSlotIndex = summonSlotIndex
    if summonSlotIndex and 0 < summonSlotIndex then
      self:ReserveTrigger130Slot(summonSlotIndex)
      extraData.summonSlotReserved = true
    end
  end
  return true, extraData, summonPos
end

function ParkourBattleLogic:CreateFriendlyPetAtWorldPos(metaId, worldPos)
  if not self.team or not worldPos then
    Logger.LogError("[CreateFriendlyPetAtWorldPos] create param is invalid, metaId\228\184\186:" .. tostring(metaId))
    return nil
  end
  local master = self.team:GetLastUnit()
  if not master then
    Logger.LogError("[CreateFriendlyPetAtWorldPos] master is nil, metaId\228\184\186:" .. tostring(metaId))
    return nil
  end
  local pet
  if self.team.CreatePetNoTeam then
    pet = self.team:CreatePetNoTeam(metaId, master, Vector3.New(worldPos.x, 0, worldPos.z))
  elseif self.team.CreatePet then
    pet = self.team:CreatePet(metaId, master)
  end
  if not pet then
    Logger.LogError("[CreateFriendlyPetAtWorldPos] create pet failed, petId\228\184\186:" .. tostring(metaId))
    return nil
  end
  if pet.parent and self.team and self.team.GetPosition and pet.SetLocalPosition then
    local teamPos = self.team:GetPosition()
    pet:SetLocalPosition(Vector3.New(worldPos.x - teamPos.x, 0, worldPos.z - teamPos.z))
  elseif pet.SetLocalPosition then
    pet:SetLocalPosition(Vector3.New(worldPos.x, 0, worldPos.z))
  end
  if pet.SetPosition then
    pet:SetPosition(Vector3.New(worldPos.x, 0, worldPos.z))
  end
  return pet
end

function ParkourBattleLogic:SummonFriendlyPetByTrigger(param, extra, sourceId)
  if not param or not param.summonFriendlyPetData then
    Logger.LogError("[SummonFriendlyPetByTrigger] summonFriendlyPetData is nil, sourceId\228\184\186:" .. tostring(sourceId))
    return
  end
  local petId = param.summonFriendlyPetData.petId or 0
  if petId <= 0 then
    Logger.LogError("[SummonFriendlyPetByTrigger] petId is invalid, petId\228\184\186:" .. tostring(petId))
    return
  end
  local summonPos, summonSlotIndex
  local summonSlotReserved = false
  if type(extra) == "table" then
    summonPos = extra.summonPos
    summonSlotIndex = extra.summonSlotIndex
    summonSlotReserved = extra.summonSlotReserved == true
  end
  if not summonPos then
    local fromPos = type(extra) == "table" and extra.fromPos or nil
    summonPos, summonSlotIndex = self:GetSummonFriendlyPetPos(param, fromPos, true)
  end
  if not summonPos then
    Logger.LogError("[SummonFriendlyPetByTrigger] summonPos is nil, petId\228\184\186:" .. tostring(petId))
    return
  end
  local pet = self:CreateFriendlyPetAtWorldPos(petId, summonPos)
  if summonSlotReserved and summonSlotIndex and 0 < summonSlotIndex then
    self:ReleaseTrigger130SlotReserve(summonSlotIndex)
  end
  if not pet then
    Logger.LogError("[SummonFriendlyPetByTrigger] create pet failed, petId\228\184\186:" .. tostring(petId))
    return
  end
  if summonSlotIndex and 0 < summonSlotIndex and pet.GetGuid then
    self:OccupyTrigger130Slot(summonSlotIndex, pet:GetGuid())
  end
end

function ParkourBattleLogic:RangeSummonMonster(owner, monsterId, count, hpPercent, distanceZ, r1, r2)
  if owner then
    local pos = owner:GetPosition()
    local targetPos = pos + Vector3(0, 0, distanceZ)
    local maxBlood = owner.maxBlood
    maxBlood = maxBlood * hpPercent
    self.monsterMgr:RangeSummon(targetPos, r1, r2, monsterId, count, maxBlood, owner.meta)
  end
end

function ParkourBattleLogic:SummonTriggerItem(pos, owner, triggerItemId, count, castType)
  if owner then
    self.monsterMgr:SummonTriggerItem(pos, triggerItemId, count, owner.meta, castType)
  end
end

function ParkourBattleLogic:RangeSummonTriggerItem(owner, triggerItemId, count, distanceZ, r1, r2, castType)
  if owner then
    local pos = owner:GetPosition()
    local targetPos = pos + Vector3(0, 0, distanceZ)
    self.monsterMgr:RangeSummonTriggerItem(targetPos, r1, r2, triggerItemId, count, owner.meta, castType)
  end
end

function ParkourBattleLogic:AddTrialHero(heroCfg)
  local uuId = heroCfg.uuid
  if not self.heroStatisticalData.makeDmg[uuId] then
    self.heroStatisticalData.makeDmg[uuId] = 0
    self.heroStatisticalData.takeDmg[uuId] = 0
    self.heroStatisticalData.death[uuId] = false
    EventManager:GetInstance():Broadcast(EventId.GF_parkour_battle_add_trail_hero, {
      self.data.metaId,
      heroCfg.heroId
    })
  end
end

function ParkourBattleLogic:ChangeTWSkillChipSetId(setId)
  if self.team then
    local skillChips = DataCenter.TWSkillChipManager:GetChipsByMasterSet(setId)
    self.team:ChangeWeaponSkillChips(skillChips)
  end
end

function ParkourBattleLogic:GetRandomInitUuid()
  if self.team then
    return self.team:GetRandomInitUuid()
  end
  return 0
end

function ParkourBattleLogic:GetInitUuidAuto(index)
  if self.team then
    return self.team:GetInitUuidAuto(index)
  end
  return 0
end

function ParkourBattleLogic:GetInitUuidByHeroIdOrIndex(heroId, index)
  if self.team then
    return self.team:GetInitUuidByHeroIdOrIndex(heroId, index)
  end
  return 0
end

function ParkourBattleLogic:GetHitWhiteMPB()
  if IsNull(self.hitWhiteMPB) then
    local color = CS.UnityEngine.Color(1.0, 0 / 255, 0.0196078431372549, 0)
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    mpb:Clear()
    mpb:SetFloat("_OnHit", 1)
    self.hitWhiteMPB = mpb
  end
  return self.hitWhiteMPB
end

function ParkourBattleLogic:GetDieGrayMPB()
  if IsNull(self.dieGrayMPB) then
    local mpb = CS.UnityEngine.MaterialPropertyBlock()
    mpb:Clear()
    mpb:SetFloat("_BWC", 1)
    self.dieGrayMPB = mpb
  end
  return self.dieGrayMPB
end

function ParkourBattleLogic:AddMember(heroId, heroLevel, showBornTween, bornEffectPath)
  if self.team then
    self.team:AddMember(heroId, heroLevel, showBornTween, bornEffectPath)
  end
end

function ParkourBattleLogic:GetReplaceNormalSkill(heroId)
  if self.heroIdReplaceNormalSkillMap then
    return self.heroIdReplaceNormalSkillMap[heroId] or 0
  end
  return 0
end

function ParkourBattleLogic:GetReplaceNormalSkillTrigger(heroId)
  if self.heroIdReplaceSkillTriggerMap and self.heroIdReplaceSkillTriggerMap[heroId] then
    return self.heroIdReplaceSkillTriggerMap[heroId]
  end
  return 0
end

function ParkourBattleLogic:GetReplaceActiveSkill(heroId)
  if self.heroIdReplaceActiveSkillMap then
    return self.heroIdReplaceActiveSkillMap[heroId] or 0
  end
  return 0
end

function ParkourBattleLogic:GetReplaceAppearance(heroId)
  if self.heroIdReplaceAppearanceMap and self.heroIdReplaceAppearanceMap[heroId] then
    return self.heroIdReplaceAppearanceMap[heroId]
  end
  return 0
end

function ParkourBattleLogic:GetHeroGlobalBuffList(heroId)
  if self.heroIdGlobalBuffMap and self.heroIdGlobalBuffMap[heroId] then
    return self.heroIdGlobalBuffMap[heroId]
  end
  return nil
end

function ParkourBattleLogic:ReplaceHeroUuidNormalAttack(param, heroUuid, skillId)
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

function ParkourBattleLogic:ReplaceHeroIdNormalAttack(param, heroId, skillId, init)
  if self.team then
    if not init then
      if self.heroIdReplaceNormalSkillMap == nil then
        self.heroIdReplaceNormalSkillMap = {}
      end
      self.heroIdReplaceNormalSkillMap[heroId] = skillId
      if self.heroIdReplaceSkillTriggerMap == nil then
        self.heroIdReplaceSkillTriggerMap = {}
      end
      self.heroIdReplaceSkillTriggerMap[heroId] = param.id
    end
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta == nil then
      Logger.LogError("[ReplaceHeroIdNormalAttack]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
    end
    local gain_effect = param.gain_effect
    local gain_effect_multi = param.gain_effect_multi
    local isShowMultiEffect = not string.IsNullOrEmpty(gain_effect_multi)
    local gain_effect_multi_text = param.gain_effect_multi_text
    local isShowMultiTextEffect = not string.IsNullOrEmpty(gain_effect_multi_text)
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceNormalAttack(skillMeta)
          if succeed and not init and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
      if isShowMultiEffect then
        local heroCount = table.count(heroes)
        self:ShowMultiEffect(heroCount, gain_effect_multi)
      end
      if isShowMultiTextEffect then
        self:ShowMultiEffect(1, gain_effect_multi_text)
      end
    end
  end
end

function ParkourBattleLogic:ReplaceHeroIdNormalAttackWithoutInterrupt(param, heroId, skillId)
  if self.team then
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta == nil then
      Logger.LogError("[ReplaceHeroIdNormalAttack]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
      return
    end
    if self.heroIdReplaceNormalSkillMap == nil then
      self.heroIdReplaceNormalSkillMap = {}
    end
    self.heroIdReplaceNormalSkillMap[heroId] = skillId
    local gain_effect = param.gain_effect
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId and hero.ReplaceNormalAttackWithoutInterrupt then
          local maxStar = skillMeta.maxStar
          local groupId = skillMeta.group
          local rank = hero.hero.rank or 0
          local newSkillMeta = skillMeta
          for i = 1, maxStar + 1 do
            local tSkillId = groupId + i - 1
            local newSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(tSkillId)
            if newSkillTemplate ~= nil and not (newSkillTemplate.star > newSkillTemplate.maxStar) then
              if rank >= newSkillTemplate.needRank then
                newSkillMeta = newSkillTemplate
              elseif rank < newSkillTemplate.needRank then
                break
              end
            end
          end
          local succeed = hero:ReplaceNormalAttackWithoutInterrupt(newSkillMeta)
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
  end
end

function ParkourBattleLogic:ReplaceHeroIdActiveAttackWithoutInterrupt(param, heroId, skillId)
  if self.team then
    local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillMeta == nil then
      Logger.LogError("[ReplaceHeroIdNormalAttack]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
      return
    end
    if self.heroIdReplaceActiveSkillMap == nil then
      self.heroIdReplaceActiveSkillMap = {}
    end
    self.heroIdReplaceActiveSkillMap[heroId] = skillId
    local gain_effect = param.gain_effect
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId and hero.ReplaceActiveAttackWithoutInterrupt then
          local maxStar = skillMeta.maxStar
          local groupId = skillMeta.group
          local rank = hero.hero.rank or 0
          local newSkillMeta = skillMeta
          for i = 1, maxStar + 1 do
            local tSkillId = groupId + i - 1
            local newSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(tSkillId)
            if newSkillTemplate ~= nil and not (newSkillTemplate.star > newSkillTemplate.maxStar) then
              if rank >= newSkillTemplate.needRank then
                newSkillMeta = newSkillTemplate
              elseif rank < newSkillTemplate.needRank then
                break
              end
            end
          end
          local succeed = hero:ReplaceActiveAttackWithoutInterrupt(newSkillMeta)
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
  end
end

function ParkourBattleLogic:ReplaceHeroIdAppearance(param, heroId, newHeroId, saveLv)
  if self.team then
    if self.heroIdReplaceAppearanceMap == nil then
      self.heroIdReplaceAppearanceMap = {}
    end
    self.heroIdReplaceAppearanceMap[heroId] = newHeroId
    local gain_effect = param and param.gain_effect
    local gain_effect_multi = param and param.gain_effect_multi
    local isShowMultiEffect = not string.IsNullOrEmpty(gain_effect_multi)
    local gain_effect_multi_text = param.gain_effect_multi_text
    local isShowMultiTextEffect = not string.IsNullOrEmpty(gain_effect_multi_text)
    local heroes = self.team.teamUnits
    if heroes then
      self.team:OnReplaceAppearance(newHeroId)
      for slot, hero in pairs(heroes) do
        if hero.originalHeroId and hero.originalHeroId == heroId then
          hero:ReplaceAppearance(newHeroId, self.team.appearanceMap, saveLv)
          if not string.IsNullOrEmpty(gain_effect) and hero.transform then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, hero:GetPosition(), nil, 5)
          end
        end
      end
      if isShowMultiEffect then
        local heroCount = table.count(heroes)
        self:ShowMultiEffect(heroCount, gain_effect_multi)
      end
      if isShowMultiTextEffect then
        self:ShowMultiEffect(1, gain_effect_multi_text)
      end
    end
  end
end

function ParkourBattleLogic:AddHeroUuidEnergy(param, extra)
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

function ParkourBattleLogic:AddHeroUuidSkill(param, heroUuid, skillId)
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

function ParkourBattleLogic:AddHeroIdSkill(param, heroId, skillId)
  local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if skillMeta == nil then
    Logger.LogError("[AddHeroIdSkill]\230\137\190\228\184\141\229\136\176\230\138\128\232\131\189\239\188\140id\228\184\186:" .. skillId)
  end
  local gain_effect = param.gain_effect
  local gain_effect_multi = param.gain_effect_multi
  local isShowMultiEffect = not string.IsNullOrEmpty(gain_effect_multi)
  local gain_effect_multi_text = param.gain_effect_multi_text
  local isShowMultiTextEffect = not string.IsNullOrEmpty(gain_effect_multi_text)
  local heroes = self.team.teamUnits
  if heroes then
    for _, hero in pairs(heroes) do
      if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
        hero.skillManager:AddSkill(skillMeta)
        if not string.IsNullOrEmpty(gain_effect) then
          DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
        end
      end
    end
    if isShowMultiEffect then
      local heroCount = table.count(heroes)
      self:ShowMultiEffect(heroCount, gain_effect_multi)
    end
    if isShowMultiTextEffect then
      self:ShowMultiEffect(1, gain_effect_multi_text)
    end
  end
end

function ParkourBattleLogic:ReplaceHeroIdNormalBullet(param, heroId, bulletId)
  if self.team then
    local heroes = self.team.teamUnits
    local gain_effect = param.gain_effect
    local gain_effect_multi = param.gain_effect_multi
    local isShowMultiEffect = not string.IsNullOrEmpty(gain_effect_multi)
    local gain_effect_multi_text = param.gain_effect_multi_text
    local isShowMultiTextEffect = not string.IsNullOrEmpty(gain_effect_multi_text)
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceNormalBullet(bulletId)
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
      if isShowMultiEffect then
        local heroCount = table.count(heroes)
        self:ShowMultiEffect(heroCount, gain_effect_multi)
      end
      if isShowMultiTextEffect then
        self:ShowMultiEffect(1, gain_effect_multi_text)
      end
    end
  end
end

function ParkourBattleLogic:ReplaceHeroIdActiveBullet(param, heroId, bulletId)
  if self.team then
    local heroes = self.team.teamUnits
    local gain_effect = param.gain_effect
    local gain_effect_multi = param.gain_effect_multi
    local isShowMultiEffect = not string.IsNullOrEmpty(gain_effect_multi)
    local gain_effect_multi_text = param.gain_effect_multi_text
    local isShowMultiTextEffect = not string.IsNullOrEmpty(gain_effect_multi_text)
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.hero and hero.hero.heroId and hero.hero.heroId == heroId then
          local succeed = hero.skillManager:ReplaceActiveBullet(bulletId)
          if succeed and not string.IsNullOrEmpty(gain_effect) then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
      if isShowMultiEffect then
        local heroCount = table.count(heroes)
        self:ShowMultiEffect(heroCount, gain_effect_multi)
      end
      if isShowMultiTextEffect then
        self:ShowMultiEffect(1, gain_effect_multi_text)
      end
    end
  end
end

function ParkourBattleLogic:AddHeroIdGlobalBuff(param, heroId, buffList)
  if self.team and buffList then
    if self.heroIdGlobalBuffMap == nil then
      self.heroIdGlobalBuffMap = {}
    end
    if self.heroIdGlobalBuffMap[heroId] == nil then
      self.heroIdGlobalBuffMap[heroId] = {}
    end
    for i, v in ipairs(buffList) do
      table.insert(self.heroIdGlobalBuffMap[heroId], v)
    end
    local gain_effect = param.gain_effect
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.originalHeroId and hero.originalHeroId == heroId then
          for _, buffId in ipairs(buffList) do
            hero:AddBuff(buffId)
          end
          if not string.IsNullOrEmpty(gain_effect) and hero.transform then
            DataCenter.LWBattleManager.logic:ShowEffectObj(gain_effect, nil, nil, 5, hero.transform)
          end
        end
      end
    end
  end
end

function ParkourBattleLogic:FlyNodeToTeam(request, eventId, extra, sourceId)
  if not self.team then
    self:TriggerFlyNode(eventId, extra, sourceId)
    return
  end
  local teamTrans = self.team.transform
  if not teamTrans then
    self:TriggerFlyNode(eventId, extra, sourceId)
    return
  end
  local go = request.gameObject
  if IsNull(go) then
    self:TriggerFlyNode(eventId, extra, sourceId)
    return
  end
  local isSummonFriendlyPet, newExtra, targetPos = self:TryGetSummonFriendlyPetFlyData(eventId, extra)
  if isSummonFriendlyPet then
    self:FlyNodeToWorldPos(request, eventId, newExtra, sourceId, targetPos)
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
  for _, v in ipairs(renders) do
    CS.AppearenceUtils.HitWhiteV2(v, true, false)
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
  local effectFlyScale = 1 / math.max(scaleX, scaleY, scaleZ, 0.1)
  self:ShowEffectObj(Const.ParkourFlyNodeEndEffectPath, nil, nil, 0.5, transform, EffectObjType.Normal, effectFlyScale)
  if self.battleMgr.gamePause then
    tween:Pause()
    delay:Pause()
    sequence:Pause()
  end
  local data = self:CreateOneFlyNodeData(request, tween, sequence, delay, eventId, extra, curIndex, renders, nil, sourceId)
  table.insert(self.flyNodeDataList, data)
end

function ParkourBattleLogic:FlyNodeToWorldPos(request, eventId, extra, sourceId, targetPos)
  if not targetPos then
    self:TriggerFlyNode(eventId, extra, sourceId)
    return
  end
  local go = request and request.gameObject or nil
  if IsNull(go) then
    self:TriggerFlyNode(eventId, extra, sourceId)
    return
  end
  local transform = go.transform
  transform:SetParent(nil)
  local from = transform.position
  local to = Vector3.New(targetPos.x, 2, targetPos.z)
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
  for _, v in ipairs(renders) do
    CS.AppearenceUtils.HitWhiteV2(v, true, false)
  end
  if self.flyNodeDataList == nil then
    self.flyNodeDataList = {}
    self.flyNodeDataIndex = 0
  end
  self.flyNodeDataIndex = self.flyNodeDataIndex + 1
  local curIndex = self.flyNodeDataIndex
  local control = Vector3.New((from.x + to.x) * 0.5, from.y + 7, (from.z + to.z) * 0.5)
  local path = {
    to,
    control,
    control
  }
  local tween = transform:DOPath(path, 0.5, CS.DG.Tweening.PathType.CubicBezier, CS.DG.Tweening.PathMode.Ignore, 10, Color.cyan)
  local delay = TimerManager:GetInstance():DelayInvoke(function()
    self:OnTweenFinish(curIndex)
  end, 0.5)
  local scaleX, scaleY, scaleZ = transform:Get_localScale()
  local scaleTo = Vector3.New(scaleX * 1.2, scaleY * 1.2, scaleZ * 1.2)
  local scaleEnd = Vector3.New(scaleX * 0.8, scaleY * 0.8, scaleZ * 0.8)
  local sequence = CS.DG.Tweening.DOTween.Sequence()
  sequence:Append(transform:DOScale(scaleTo, 0.25))
  sequence:Append(transform:DOScale(scaleEnd, 0.25))
  local effectFlyScale = 1 / math.max(scaleX, scaleY, scaleZ, 0.1)
  self:ShowEffectObj(Const.ParkourFlyNodeEndEffectPath, nil, nil, 0.5, transform, EffectObjType.Normal, effectFlyScale)
  if self.battleMgr.gamePause then
    tween:Pause()
    delay:Pause()
    sequence:Pause()
  end
  local data = self:CreateOneFlyNodeData(request, tween, sequence, delay, eventId, extra, curIndex, renders, nil, sourceId)
  table.insert(self.flyNodeDataList, data)
end

function ParkourBattleLogic:WaterBottleDynamicResFlyToTeam(request, eventId, extra, monsterType, flyEffectPath)
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
  local effectLocalPosition = Vector3.zero
  local effectLocalRotation = Quaternion.Euler(0, 0, 0)
  if monsterType == Const.MonsterType.StandingWaterBottle then
    effectLocalPosition = Vector3.New(0, 0.05, 0.76)
    effectLocalRotation = Quaternion.Euler(-9.06, 0, 0)
    local dynamicResGameObjectAnim = transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if dynamicResGameObjectAnim then
      local state = dynamicResGameObjectAnim:GetState("fly")
      if state ~= nil then
        dynamicResGameObjectAnim:Play("fly")
      else
        Logger.LogError(string.format("%s \230\178\161\230\156\137fly\231\138\182\230\128\129", dynamicResGameObjectAnim.name))
      end
    end
  end
  local from = Vector3.New()
  from.x, from.y, from.z = transform:Get_localPosition()
  local to = Vector3.New(0, 2, 0)
  local flyEffectId = self:ShowEffectObj(flyEffectPath, effectLocalPosition, effectLocalRotation, 0, transform)
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
  local sequence
  if monsterType == Const.MonsterType.HorizontalWaterBottle then
    local scaleX, scaleY, scaleZ = transform:Get_localScale()
    local scaleTo = Vector3.New(scaleX * 1.2, scaleY * 1.2, scaleZ * 1.2)
    local scaleEnd = Vector3.New(scaleX * 0.8, scaleY * 0.8, scaleZ * 0.8)
    sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Append(transform:DOScale(scaleTo, 0.25))
    sequence:Append(transform:DOScale(scaleEnd, 0.25))
  end
  if self.battleMgr.gamePause then
    tween:Pause()
    delay:Pause()
    if sequence then
      sequence:Pause()
    end
  end
  local data = self:CreateOneFlyNodeData(request, tween, sequence, delay, eventId, extra, curIndex, nil, flyEffectId)
  table.insert(self.flyNodeDataList, data)
end

function ParkourBattleLogic:CreateOneFlyNodeData(request, tween, sequence, delay, eventId, extra, curIndex, renders, flyEffectId, sourceId)
  local data = {}
  data.request = request
  data.tween = tween
  data.sequence = sequence
  data.delay = delay
  data.eventId = eventId
  data.extra = extra
  data.index = curIndex
  data.renders = renders
  data.flyEffectId = flyEffectId
  data.sourceId = sourceId
  return data
end

function ParkourBattleLogic:TriggerFlyNode(eventId, extra, sourceId)
  if not self.team then
    return
  end
  if not self.triggerEventMgr then
    return
  end
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta and meta.isUnAddEnergyType then
      self.triggerEventMgr:Trigger(meta.type, meta, extra, sourceId)
    end
  end
end

function ParkourBattleLogic:GetParkourRushX()
  local rushX = Const.ParkourSceneCenter
  if self.data.soliderRushValue then
    rushX = self.data.soliderRushValue
  end
  return rushX
end

function ParkourBattleLogic:OnTweenFinish(index)
  if self.flyNodeDataList then
    local findIndex = 0
    for i, data in ipairs(self.flyNodeDataList) do
      if data and data.index == index then
        findIndex = i
        local sourceId = data.sourceId
        self:ClearOneFlyNodeData(data)
        self:TriggerFlyNode(data.eventId, data.extra, sourceId)
        break
      end
    end
    if 0 < findIndex then
      table.remove(self.flyNodeDataList, findIndex)
    end
  end
end

function ParkourBattleLogic:ClearOneFlyNodeData(data)
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
        CS.AppearenceUtils.HitWhiteV2(v, false, false)
      end
      data.renders = nil
    end
    if data.request then
      data.request:Destroy()
      data.request = nil
    end
    if data.flyEffectId then
      self:RemoveEffectObj(data.flyEffectId)
      data.flyEffectId = nil
    end
    data.sourceId = nil
  end
end

function ParkourBattleLogic:ClearFlyNodeData()
  if self.flyNodeDataList then
    for _, data in ipairs(self.flyNodeDataList) do
      self:ClearOneFlyNodeData(data)
    end
    self.flyNodeDataList = nil
  end
end

function ParkourBattleLogic:GetFreezeXAxisMoveMinDistance()
  return self.data.monsterAttackRange
end

function ParkourBattleLogic:GetFreezeXAxisMoveMinDistanceSquare()
  return self.data.monsterAttackRangeSquare
end

function ParkourBattleLogic:RefreshWinConditions(winConditions)
  self:SavePreWinConditionCheck()
  self.winConditions = winConditions
end

function ParkourBattleLogic:GetCheckWinConditions()
  return self.winConditions
end

function ParkourBattleLogic:GetWinConditionDataByWinType(winType)
  return self.winConditions[winType]
end

function ParkourBattleLogic:ClearPreWinConditionCheck()
  self.preConditionTeamZ = 0
  self.preConditionUseTime = 0
  self.preConditionSaveNum = 0
  self.preConditionKillNum = 0
  self.preConditionKillBossNum = 0
  self.preConditionKillTargetMonster = nil
  self.preConditionBlastStandingWaterBottleNum = 0
end

function ParkourBattleLogic:SavePreWinConditionCheck()
  self.preConditionTeamZ = self.team and self.team:GetPositionZ() or 0
  self.preConditionUseTime = self.useTime or 0
  self.preConditionSaveNum = self.saveNum or 0
  self.preConditionKillNum = self.killNum or 0
  self.preConditionKillBossNum = self.killBossNum or 0
  self.preConditionBlastStandingWaterBottleNum = self.blastStandingWaterBottleNum or 0
  local winConditions = self:GetCheckWinConditions()
  local winCondition = winConditions[Const.ParkourWinType.KillTargetMonster]
  if winCondition then
    if self.preConditionKillTargetMonster == nil then
      self.preConditionKillTargetMonster = {}
    end
    for k, v in pairs(winCondition.needKillTarget) do
      if self.preConditionKillTargetMonster[k] == nil then
        self.preConditionKillTargetMonster[k] = 0
      end
      self.preConditionKillTargetMonster[k] = self.preConditionKillTargetMonster[k] + v.finish
    end
  end
end

function ParkourBattleLogic:InitExtendFsm()
  self.extendFsm = FSM.New()
  self.extendFsm:AddState(Const.ParkourBattleExtendFsmState.Normal, require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleExtendState").New(self))
  if self.bonusType == Const.ParkourBattleBonusType.GoldMonster then
    self.extendFsm:AddState(Const.ParkourBattleExtendFsmState[Const.ParkourBattleState.GoldMonsterBonus], require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleGoldMonsterBonusState").New(self))
  elseif self.bonusType == Const.ParkourBattleBonusType.ProgressMonster then
    self.extendFsm:AddState(Const.ParkourBattleExtendFsmState[Const.ParkourBattleState.ProgressMonsterBonus], require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleProgressMonsterBonusState").New(self))
  elseif self.bonusType == Const.ParkourBattleBonusType.Dash then
    self.extendFsm:AddState(Const.ParkourBattleExtendFsmState[Const.ParkourBattleState.DashBonus], require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleDashBonusState").New(self))
  elseif self.bonusType == Const.ParkourBattleBonusType.KatyushaSpecial then
    self.extendFsm:AddState(Const.ParkourBattleExtendFsmState[Const.ParkourBattleState.KatyushaSpecialBonus], require("DataCenter.LWBattle.Logic.ParkourBattle.ExtendState.ParkourBattleKatyushaSpecialBonusState").New(self))
  end
  self.extendFsm:ChangeState(Const.ParkourBattleExtendFsmState.Normal)
end

function ParkourBattleLogic:TryCallExtendFsmStateFuc(funcName, ...)
  if self.extendFsm and self.extendFsm:GetStateIndex() == self.state then
    local extendState = self.extendFsm:GetCurState()
    if extendState and extendState[funcName] then
      return true, extendState[funcName](extendState, ...)
    end
  end
  return false, nil
end

function ParkourBattleLogic:BroadcastParkourWinConditionRefresh(winType)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.needUpdateWinCondition = true
    if self.winTypeCache == nil then
      self.winTypeCache = {}
    end
    self.winTypeCache[winType] = true
  else
    self:RealBroadcastParkourWinConditionRefresh(winType)
  end
end

function ParkourBattleLogic:RealBroadcastParkourWinConditionRefresh(winType)
  if self.state == Const.ParkourBattleState.GoldMonsterBonus or self.state == Const.ParkourBattleState.ProgressMonsterBonus then
    local param = {}
    param.useTime = self.useTime
    self.mainUI:OnBonusWinConditionRefresh(param)
  else
    EventManager:GetInstance():Broadcast(EventId.ParkourWinConditionRefresh, winType)
  end
end

function ParkourBattleLogic:CheckWinConditionCache()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if self.needUpdateWinCondition then
      for winType, check in pairs(self.winTypeCache) do
        if check then
          self:RealBroadcastParkourWinConditionRefresh(winType)
          self.winTypeCache[winType] = false
        end
      end
    end
    self.needUpdateWinCondition = false
  end
end

function ParkourBattleLogic:OpenDetectRetryTaskResult()
  local p = {}
  local collectNum = 0
  if self.data.collectType == DetectEventRetryTaskCollectType.Soldier then
    collectNum = self.remainMember or 0
  else
    collectNum = self.goods[DetectEventRetryTaskCollectType2ResourceType[self.data.collectType]] or 0
  end
  p.collectType = self.data.collectType
  p.resultCacheNum = collectNum
  local inRangeNum = Mathf.Clamp(collectNum, self.data.collectMinNum, self.data.collectMaxNum)
  p.resultRewardNum = Mathf.Ceil(inRangeNum / self.data.collectMaxNum * self.data.collectRewardNum)
  p.resultMaxNum = self.data.collectMaxNum
  p.endTime = self.param.extraData.endTime
  self.param.extraData.resultRewardNum = p.resultRewardNum
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIParkourDetectRetryTaskResult, {anim = false, playEffect = 10024}, p)
end

function ParkourBattleLogic:OpenDetectRetryAttackCityS0Result(win)
  if win then
    local param = {}
    param.enterType = self.param.enterType
    param.stageId = self.data.meta.id
    param.stageRewardList = self.data.stageRewardList
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAttackCityS0ParkourBonusResultView, {anim = false, playEffect = 10024}, param)
  else
    local param = {}
    param.time = self.useTime
    param.kill = self.killNum
    param.stageId = self.data.meta.id
    param.extraData = self.param.extraData
    param.enterType = PVEEnterType.DetectAttackCityS0
    param.absoluteBtn = true
    param.hideTryAgainBtn = true
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultParkourDefeat, {anim = true, playEffect = 10023}, param)
  end
end

function ParkourBattleLogic:CheckIsReachSkillDamageLimit(defender, skill, hurt)
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

function ParkourBattleLogic:SetGamePause(pause)
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

function ParkourBattleLogic:SetSceneShadow()
  local sceneCfgArr = self.data.sceneCfgArr
  for _, sceneCfg in ipairs(sceneCfgArr) do
    if not string.IsNullOrEmpty(sceneCfg.meta.shadow_para) then
      local strArr = string.split(sceneCfg.meta.shadow_para, "|")
      if not table.IsNullOrEmpty(strArr) and table.count(strArr) == 2 then
        local colorArr = string.split(strArr[1], ",")
        if table.count(colorArr) == 4 then
          local color = Color.New(tonumber(colorArr[1]), tonumber(colorArr[2]), tonumber(colorArr[3]), tonumber(colorArr[4]))
          local shadowFalloff = tonumber(strArr[2])
          self.setSceneShadowSuccess = CS.SceneManager.SetSceneShadow(color, shadowFalloff)
          break
        end
      end
    end
  end
end

function ParkourBattleLogic:UpdateBulletLogicAfterBuffRemove(bulletObjId, buffId)
  if self.bulletManager and self.bulletManager.UpdateBulletLogicAfterBuffRemove then
    self.bulletManager:UpdateBulletLogicAfterBuffRemove(bulletObjId, buffId)
  end
end

function ParkourBattleLogic:GetBullet(bulletObjId)
  if self.bulletManager then
    return self.bulletManager:GetBullet(bulletObjId)
  end
  return nil
end

function ParkourBattleLogic:TestSetWaterFresnelValue(value)
  local success = false
  if self.sceneExtReq then
    local go = self.sceneExtReq.gameObject
    if not IsNull(go) then
      local meshRenderer = go:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
      if not IsNull(meshRenderer) then
        local length = meshRenderer.Length
        if 0 < length then
          if IsNull(self.testWaterFresnelMPB) then
            self.testWaterFresnelMPB = CS.UnityEngine.MaterialPropertyBlock()
          end
          self.testWaterFresnelMPB:SetFloat("_FresnelScale", value)
          for i = 0, length - 1 do
            local singleMeshRender = meshRenderer[i]
            singleMeshRender:SetPropertyBlock(self.testWaterFresnelMPB)
          end
          success = true
        end
      end
    end
  end
  if not success then
    UIUtil.ShowTips("\230\178\161\230\156\137\230\137\190\229\136\176\230\176\180\231\154\132\230\142\167\228\187\182\239\188\140\230\151\160\230\179\149\232\174\190\231\189\174\230\176\180\231\154\132\233\165\177\229\146\140\229\186\166")
  end
end

function ParkourBattleLogic:LogTeamPos()
  if not self.detailLog then
    return
  end
  if self.team == nil then
    return
  end
  local x, z = self.team:GetTeamPosLog()
  Logger.LogInfo(string.format("parkour TeamPos x : %s. z : %s. defenseOffsetZ : %s", x, z, self.defenseOffsetZ))
end

function ParkourBattleLogic:TriggerStartEffect()
  local sparkTriggerList = DataCenter.LWCivilizationSparkManager:GetBattleStartTriggerList(self.param.enterType)
  if sparkTriggerList then
    local startTriggerTask = BattleStartTriggerTask.New(sparkTriggerList)
    startTriggerTask:Gen()
  end
end

function ParkourBattleLogic:GetSharedHeroInfo(heroId)
  local heroInfo = self.sharedHeroInfo[heroId]
  local needInit = false
  if nil == heroInfo then
    heroInfo = HeroInfo.New()
    self.sharedHeroInfo[heroId] = heroInfo
    needInit = true
  end
  return heroInfo, needInit
end

function ParkourBattleLogic:IsFrontBreakSundayNewRecord(param)
  local stageIdIndex = DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId):GetStageIndex(param.stageId)
  local stagesCount = #DataCenter.ActFrontBreakSundayDataManager:GetActData(param.frontBreakSundayActId).stageIds
  if stageIdIndex == stagesCount then
    local isInAlliance = LuaEntry.Player:IsInAlliance()
    local topRankOld = param.topRankOld or 0
    local topRankNew = param.topRankNew or 0
    local isTopRankNew = 0 < topRankNew and (topRankOld == 0 or topRankOld > topRankNew)
    if isTopRankNew then
      return true
    end
    local alRankOld = param.alRankOld or 0
    local alRankNew = param.alRankNew or 0
    local isAlRankNew = isInAlliance and 0 < alRankNew and (alRankOld == 0 or alRankOld > alRankNew)
    if isAlRankNew then
      return true
    end
    local serRankOld = param.serRankOld or 0
    local serRankNew = param.serRankNew or 0
    local isSerRankNew = 0 < serRankNew and (serRankOld == 0 or serRankOld > serRankNew)
    if isSerRankNew then
      return true
    end
  end
  return false
end

function ParkourBattleLogic:GetGainEffectScaleByTeamCount(count)
  local scale = 1
  if 21 <= count and count <= 50 then
    scale = 1.5
  elseif 51 <= count then
    scale = 2
  end
  return scale
end

function ParkourBattleLogic:ShowMultiEffect(teamMemberCount, effectPath)
  if not self.team then
    return
  end
  local scale = self:GetGainEffectScaleByTeamCount(teamMemberCount)
  DataCenter.LWBattleManager.logic:ShowEffectObj(effectPath, nil, nil, 5, self.team.transform, EffectObjType.Normal, scale)
end

function ParkourBattleLogic:ShowGainText(text, time)
  if not self.team then
    return
  end
  if string.IsNullOrEmpty(text) then
    return
  end
  local param = self.damageTextMgr:GetParam()
  param.txt = Localization:GetString(text)
  param.position = self.team:GetPosition()
  param.style = DamageTextType.TriggerItem
  param.time = time
  param.damage = 0
  self.damageTextMgr:GenText(param)
end

function ParkourBattleLogic:IsMonsterHasBornState(monster)
  if self.state == Const.ParkourBattleState.KatyushaSpecialBonus then
    return true
  end
  return false
end

function ParkourBattleLogic:GetTeamHeroByUuid(uuid)
  if self.team then
    return self.team:GetHeroInfoByUuid(uuid)
  end
  return nil
end

function ParkourBattleLogic:OnMonsterBornTriggered(bornMeta)
  if not bornMeta then
    return
  end
  if self.param and self.param.enterType == PVEEnterType.HeroTryOut and self.param.extraData and self.param.extraData.heroTryOutTemplate then
    local plotId = self.param.extraData.heroTryOutTemplate:GetPlotIdByMonsterBornId(bornMeta.id)
    if plotId and 0 < plotId then
      self.monsterBornTriggerPlotId = plotId
      DataCenter.LWBattleManager:SetGamePause(true)
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.monsterBornTriggerPlotId,
        hideMainUI = false
      })
    end
  end
end

function ParkourBattleLogic:OnGuideTimelineDone()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PveUnitViewUtil.CreateUnitViewList()
  end
  if self.team then
    local heroes = self.team.teamUnits
    if heroes then
      for _, hero in pairs(heroes) do
        if hero.SampleAnim then
          hero:SampleAnim()
        end
      end
    end
  end
end

return ParkourBattleLogic
