local base = require("DataCenter.LWBattle.Logic.LWBattleLogicInterface")
local FakePVPLogic = BaseClass("FakePVPLogic", base)
local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local PVEDecorationPath = "Assets/Main/Prefabs/PVELevel/%s/decoration.bytes"
local Time = _ENV.Time
local rapidjson = require("rapidjson")
local Army = require("Scene.LWBattle.Skirmish.Army")
local SkirmishSceneData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishSceneData")
local SkirmishBattleData = require("DataCenter.LWBattle.Logic.Skirmish.SkirmishBattleData")
local DamageTextManager = require("DataCenter.ZombieBattle.DamageTextManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local ULTIMATE_ADVANCE_OFFSET = 0.5
local Localization = CS.GameEntry.Localization
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Squad = require("Scene.LWBattle.BarrageBattle.Squad")
local GameObject = CS.UnityEngine.GameObject
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local BattleEnumType = require("DataCenter.LWBattle.BattleEnumType")
local LINEUP_ENEMY_OFFSET = Vector3.New(36, 0, 30.19)

function FakePVPLogic:Enter(param)
  self.param = param
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.stage = FakePVPStage.Lineup
  self.staticMgr = CS.PVEStaticManager()
  self.staticMgr:InitLW(10, 10)
  self.staticMgr:SetVisibleChunk(2)
  self.levelId = param.levelId
  self.sceneId = param.sceneId
  self.squadIndex = 1
  self.formationPositionType = nil
  if self.param.enterType == PVEEnterType.Radar then
    self.squadIndex = 2
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
    self.squadIndex = 1
    if self.param.extraData.pageType == JeepAdventurePageType.Domintor and self.param.extraData.cfgId then
      local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(self.param.extraData.cfgId)
      if dominatorUpTemplate then
        self.squadIndex = dominatorUpTemplate:GetFormationSaveType()
        self.formationPositionType = dominatorUpTemplate:GetFormationPositionType()
      end
    end
  elseif self.param.enterType == PVEEnterType.PVPArena or self.param.enterType == PVEEnterType.ActivityArena or self.param.enterType == PVEEnterType.ActivityArenaV2 or self.param.enterType == PVEEnterType.NewPeakArena or self.param.enterType == PVEEnterType.NewGaleArena then
    self.squadIndex = param.extraData.ownerInfo.squadNo
  elseif self.param.enterType == PVEEnterType.BeginnerEvent then
    self.squadIndex = 16
  elseif self.param.enterType == PVEEnterType.DetectZombieBusTrain then
    self.squadIndex = 21
  elseif self.param.enterType == PVEEnterType.T11IdleGameBattleEvent then
    self.squadIndex = FormationSaveType.T11IdleGameBattleEvent
  elseif self.param.enterType == PVEEnterType.HeroTryOut then
    local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
    if tryOutTemplate ~= nil and tryOutTemplate.lattice_type > 0 then
      self.formationPositionType = tryOutTemplate.lattice_type
    end
  end
  self.sceneData = SkirmishSceneData.New()
  self.sceneData.MAX_MINION_PER_HERO = 0
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), self.sceneId)
  local sceneName = sceneMeta.asset
  self.sceneData.sceneName = sceneName
  self.sceneData.enterType = self.param.enterType
  
  function self.onCreateComplete()
    self:LoadSceneComplete()
  end
  
  self.LINEUP_ENEMY_OFFSET = LINEUP_ENEMY_OFFSET
  CommonUtil.ClearGameBgMusicData()
  DataCenter.LWSoundManager:PlayPveSceneBGMusicLW()
end

function FakePVPLogic:__delete()
  self:Destroy()
end

function FakePVPLogic:Destroy()
  if self.delayEvents then
    for _, v in pairs(self.delayEvents) do
      v:Stop()
    end
  end
  self:ClearAllFormingEffects()
  self.delayEvents = {}
  self.delayActions = {}
  if self.pauseBattleTimer ~= nil then
    self.pauseBattleTimer:Stop()
    self.pauseBattleTimer = nil
  end
  self:UnInitCamera()
  self:RemoveListeners()
  self:DestroyFakeEnemy()
  if self.squad then
    self.squad:Delete()
    self.squad = nil
  end
  self.touchCamera = nil
  if self.staticMgr then
    self.staticMgr:UnInit()
    self.staticMgr = nil
  end
  if self.bulletManager then
    self.bulletManager:Delete()
  end
  self.captains = {}
  if self.armys then
    for _, v in pairs(self.armys) do
      v:Destroy()
    end
    self.armys = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.damageTextMgr ~= nil then
    self.damageTextMgr:Destroy()
    self.damageTextMgr = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
  end
  if self.sceneLoadRequest then
    for _, sceneReq in pairs(self.sceneLoadRequest) do
      sceneReq:Destroy()
    end
    self.sceneLoadRequest = nil
  end
  self.battleData = nil
  self.stage = FakePVPStage.Lineup
end

function FakePVPLogic:LoadSceneComplete()
  self:OnGameStart()
end

function FakePVPLogic:OnGameStart()
  if self.param.enterType == PVEEnterType.Radar and self.param.extraData ~= nil and self.param.extraData.uuid ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.DetectEventPVE, self.param.extraData.uuid)
  elseif self.param.enterType == PVEEnterType.TruckRob then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.TruckRob, self.param.extraData.trainData)
  elseif self.param.enterType == PVEEnterType.HSRRob then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.HSRRob, self.param.victim)
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure and self.param.extraData ~= nil and self.param.extraData.cfgId ~= nil then
    local isAutoOn = DataCenter.TowerUpSaveDataManager:IsAutoNextStage()
    local isOpenFormation = true
    if isAutoOn then
      if self.param.extraData.pageType == JeepAdventurePageType.Domintor then
        local isCanAuto = DataCenter.TowerUpSaveDataManager:IsCanAutoNextStageDominator()
        if isCanAuto then
          isOpenFormation = false
        end
      else
        isOpenFormation = false
      end
    end
    if isOpenFormation then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, EnterHeroSquadPanelWay.TowerupJeepAdventure, self.param.extraData, self.levelId)
    elseif self.param.extraData.pageType == JeepAdventurePageType.TowerUp then
      SFSNetwork.SendMessage(MsgDefines.LWSaveTowerupRecord, self.param.extraData.cfgId)
    elseif self.param.extraData.pageType == JeepAdventurePageType.Domintor then
      local squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.TowerupJeepAdventure, self.squadIndex)
      if squadData and DataCenter.TowerUpSaveDataManager:IsSquadDataValidInDominator(squadData, self.formationPositionType) then
        SFSNetwork.SendMessage(MsgDefines.LWSaveDominatorUpRecord, self.param.extraData.cfgId)
      end
    end
  elseif self.param.enterType == PVEEnterType.BeginnerEvent and self.param.extraData ~= nil and self.param.extraData.bossIndx ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.BeginnerEvent, self.param.extraData.bossIndx)
  elseif self.param.enterType == PVEEnterType.DetectZombieBusTrain and self.param.extraData ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.DetectZombieBusTrain, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.PVPArena then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.PVPArena, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.ActivityArena then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.ActivityArena, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.TrailTower then
    local towerId = self.param.extraData.trailTowerLevelTemplate.towerId
    local auto = DataCenter.LWTrailTowerManager:IsAutoNextStage(towerId)
    if auto then
      local stageId = self.param.extraData.trailTowerLevelTemplate.id
      local trailTowerInfo = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(towerId)
      if trailTowerInfo ~= nil then
        local sfs = ArmyFormationUtils.GenerateServerHeroArray(trailTowerInfo.heroInfosDic)
        SFSNetwork.SendMessage(MsgDefines.TrailTowerBattle, towerId, stageId, sfs, trailTowerInfo.chipSetId)
      else
        Logger.LogError("Get TrailTowerInfo ById is null " .. "towerId:" .. tostring(towerId))
      end
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, EnterHeroSquadPanelWay.TrailTower, self.param.extraData)
    end
  elseif self.param.enterType == PVEEnterType.ActivityArenaV2 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.ActivityArenaV2, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.NewPeakArena then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.NewPeakArena, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.NewGaleArena then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.NewGaleArena, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.T11IdleGameBattleEvent then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.T11IdleGameBattleEvent, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.HeroTryOut then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation_HeroTryOut, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.HeroTryOut, self.param.extraData)
  elseif self.param.enterType == PVEEnterType.SeasonTower then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroFakePVPFormation_SeasonTower, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, EnterHeroSquadPanelWay.SeasonTower, self.param.extraData)
  end
  self.stage = FakePVPStage.Lineup
end

function FakePVPLogic:LoadScene(callBack)
  self.nextObjId = 1
  self:LineupLoadScene(callBack)
  self:CreateSquad()
  self:CreateFakeEnemy()
  self:AddListeners()
end

function FakePVPLogic:AddListeners()
  EventManager:GetInstance():AddListener(EventId.TowerupFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.TrainSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.PVPArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.TrailTowerBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.CheckTrainRefreshReceived, self.OnCheckTrainRefreshReceived)
  EventManager:GetInstance():AddListener(EventId.NewPeakArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.NewGaleArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.CityEventFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.DetectZombieBusTrainBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.HeroTryOutFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():AddListener(EventId.SeasonTowerFakePVPBattleDataGet, self.OnGetBattleData)
end

function FakePVPLogic:RemoveListeners()
  EventManager:GetInstance():RemoveListener(EventId.TowerupFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.TrainSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.PVPArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.TrailTowerBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.CheckTrainRefreshReceived, self.OnCheckTrainRefreshReceived)
  EventManager:GetInstance():RemoveListener(EventId.NewPeakArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.NewGaleArenaSkirmishDataReceived, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.CityEventFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.DetectZombieBusTrainBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.HeroTryOutFakePVPBattleDataGet, self.OnGetBattleData)
  EventManager:GetInstance():RemoveListener(EventId.SeasonTowerFakePVPBattleDataGet, self.OnGetBattleData)
end

function FakePVPLogic:LineupLoadScene(callBack)
  local sceneName = self.sceneData.sceneName
  self.sceneLoadRequest = {}
  local req = Resource:InstantiateAsync(string.format(PVEScenePath, sceneName), ObjectPoolTag.BattleScene)
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_position(self.sceneData.scenePosOffset:Split())
    if self.onCreateComplete then
      self.onCreateComplete()
      self.onCreateComplete = nil
    end
    if callBack then
      callBack()
    end
  end)
  table.insert(self.sceneLoadRequest, req)
  self.staticMgr:Append(string.format(PVEDecorationPath, sceneName), 0)
end

function FakePVPLogic:InitCamera()
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

function FakePVPLogic:UnInitCamera()
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
    self.touchCamera.AfterUpdate = nil
    self.touchCamera = nil
    self.onFingerDown = nil
    self.onFingerUp = nil
  end
end

function FakePVPLogic:InitCameraParams()
  local height = self.sceneData.OPENING_CAMERA_HEIGHT
  local fov = self.sceneData.OPENING_CAMERA_FOV
  local rotation = self.sceneData.OPENING_CAMERA_ROTATION
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = self:GetOffsetZ(height, rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = 10
  self.camera.transform.eulerAngles = Vector3.New(rotation, 0, 0)
end

function FakePVPLogic:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function FakePVPLogic:GetFollowCameraTarget()
  return self.followCameraTarget
end

function FakePVPLogic:CameraFollowLookat(targetPos)
  local transform = self.touchCamera.transform
  local x, y, z = transform:Get_position()
  local offset = targetPos - self.followCameraTarget
  transform:Set_position(x + offset.x, y + offset.y, z + offset.z)
  self.followCameraTarget = Vector3.New(targetPos.x, targetPos.y, targetPos.z)
end

function FakePVPLogic:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function FakePVPLogic:CreateSquad()
  local objId = self:GetNextObjId()
  local squadData
  if self.param.enterType == PVEEnterType.TruckRob or self.param.enterType == PVEEnterType.HSRRob then
    squadData = DataCenter.LWMyStationDataManager:GetRobFormation()
  elseif self.param.enterType == PVEEnterType.PVPArena or self.param.enterType == PVEEnterType.ActivityArena or self.param.enterType == PVEEnterType.ActivityArenaV2 or self.param.enterType == PVEEnterType.NewPeakArena or self.param.enterType == PVEEnterType.NewGaleArena then
    squadData = ArmyFormationInfo.New()
    squadData:ParseData(self.param.extraData.ownerInfo)
  elseif self.param.enterType == PVEEnterType.SeasonTower then
    squadData = DataCenter.LWSeasonTowerManager:GetFormation(self.param.extraData.stageId)
  else
    squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(self.squadIndex)
  end
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
  local weaponData = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  local weaponSkinId
  if weaponData then
    weaponSkinId = DataCenter.TacticalWeaponManager:GetWeaponAppearance(weaponData.id)
  end
  self.squad = Squad.New(self, objId, allHeroes, nil, nil, weaponData, weaponSkinId, nil, true, self.formationPositionType)
  self.squad:OnCreate()
  self.squad:InitPosition(self.sceneData.armyBirthPos[1])
end

function FakePVPLogic:CreateFakeEnemyHeroData()
  self.heroDataList = {}
  if self.param.enterType == PVEEnterType.TruckRob then
    local trainData = self.param.extraData.trainData
    if not trainData then
      return
    end
    for i = 1, ArmyFormationSlot.Dominator do
      local trainHero = trainData.heroInfo[i]
      if trainHero then
        self.heroDataList[i] = HeroInfo.New()
        self.heroDataList[i]:UpdateFromMailData(trainHero.id, trainHero.level, {}, trainHero.weaponLevel, trainHero.rankLv, trainHero.awakenLv, trainHero.heroSkinId)
      end
    end
  elseif self.param.enterType == PVEEnterType.HSRRob then
    local victim = self.param.victim
    if not victim then
      return
    end
    for i = 1, ArmyFormationSlot.Dominator do
      local trainHero = victim.heroInfo[i]
      if trainHero then
        self.heroDataList[i] = HeroInfo.New()
        self.heroDataList[i]:UpdateFromMailData(trainHero.heroId, trainHero.heroLevel, {}, trainHero.weaponLevel, trainHero.rankLv, trainHero.awakenLv, trainHero.heroSkinId)
      end
    end
  elseif self.param.enterType == PVEEnterType.PVPArena or self.param.enterType == PVEEnterType.ActivityArena or self.param.enterType == PVEEnterType.ActivityArenaV2 or self.param.enterType == PVEEnterType.NewPeakArena or self.param.enterType == PVEEnterType.NewGaleArena then
    local otherInfo = self.param.extraData.otherInfo
    if not otherInfo then
      return
    end
    for _, v in pairs(otherInfo.heros) do
      self.heroDataList[v.index] = HeroInfo.New()
      self.heroDataList[v.index]:UpdateFromMailData(v.heroId, v.heroLevel, {}, v.weaponLevel, v.rankLv, v.awakenLv, v.heroSkinId)
    end
  elseif self.param.enterType == PVEEnterType.SeasonTower then
    local lwArmyTemplate = DataCenter.LWSeasonTowerArmyTemplateManager:GetArmyTemplate(self.param.levelId)
    if not lwArmyTemplate then
      return
    end
    for i = 1, ArmyFormationSlot.Dominator do
      local armyData = lwArmyTemplate.line_up[i]
      if armyData and armyData.heroData then
        local heroData = armyData.heroData
        self.heroDataList[i] = HeroInfo.New()
        self.heroDataList[i]:UpdateFromMailData(heroData.metaId, heroData.level, {}, heroData.weaponLevel, nil, heroData.awakenLv)
      end
    end
  else
    local lwArmyTemplate = DataCenter.LWArmyTemplateManager:GetArmyTemplate(self.param.levelId)
    if not lwArmyTemplate then
      return
    end
    for i = 1, ArmyFormationSlot.Dominator do
      local armyData = lwArmyTemplate.line_up[i]
      if armyData and armyData.heroData then
        self.heroDataList[i] = HeroInfo.New()
        self.heroDataList[i]:UpdateFromMailData(armyData.heroData.metaId, armyData.heroData.level, {}, armyData.heroData.weaponLevel, nil, armyData.heroData.awakenLv)
      end
    end
  end
  if not self.allUnits then
    self.allUnits = {}
  end
  for i = 1, ArmyFormationSlot.Dominator do
    local pvpSlot = self.sceneData.FormationSlot2PVPSlot(i, false)
    if self.heroDataList[i] then
      self.allUnits[pvpSlot] = self.heroDataList[i]
    else
      self.allUnits[pvpSlot] = nil
    end
  end
  self:RefreshBattleEffect()
end

function FakePVPLogic:CreateEnemyWepaonInfo()
  local weaponInfo, appearance, chips
  if self.param.enterType == PVEEnterType.PVPArena or self.param.enterType == PVEEnterType.ActivityArena or self.param.enterType == PVEEnterType.ActivityArenaV2 or self.param.enterType == PVEEnterType.NewPeakArena or self.param.enterType == PVEEnterType.NewGaleArena then
    local otherInfo = self.param.extraData.otherInfo
    if otherInfo.weapon then
      weaponInfo = TacticalWeaponInfo.New()
      weaponInfo:CreateFromTemplate(otherInfo.weapon.id, otherInfo.weapon.lv)
      local skinId = otherInfo.weapon.uavSkinId
      local appearanceId = DataCenter.TacticalWeaponManager:GetWeaponAppearanceData(weaponInfo, skinId)
      appearance = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    end
  end
  return weaponInfo, appearance
end

function FakePVPLogic:CreateFakeEnemy()
  self:DestroyFakeEnemy()
  self:CreateFakeEnemyHeroData()
  self.sceneData:InitData(false, self.heroDataList[ArmyFormationSlot.Dominator] ~= nil)
  local go = GameObject("ArmyRoot")
  self.armyRoot = go
  local armyRootTransform = go.transform
  local pos = LINEUP_ENEMY_OFFSET + self.sceneData.scenePosOffset
  armyRootTransform:Set_position(pos.x, 0, pos.z)
  armyRootTransform:Set_eulerAngles(0, 180, 0)
  self.platoonGoList = {}
  self.heroReqList = {}
  self.qualitySlots = {}
  for i = 1, ArmyFormationSlot.Dominator do
    local index = i + 5
    if i == ArmyFormationSlot.Dominator then
      index = PVPBattleSlot.EnemyDominator
      if not self.heroDataList[i] then
        goto lbl_183
      end
    end
    local platoonGo = GameObject("PlatoonRoot" .. index)
    self.platoonGoList[i] = platoonGo
    local platoonTransform = platoonGo.transform
    platoonTransform:SetParent(armyRootTransform)
    platoonTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local localPosition = self.sceneData.platoonLocalPos[index]
    platoonTransform:Set_localPosition(localPosition.x, localPosition.y, localPosition.z)
    local sprite
    if i ~= ArmyFormationSlot.Dominator then
      local obj = CS.UnityEngine.GameObject("QualitySlot" .. index)
      obj.transform:SetParent(self.platoonGoList[i].transform, false)
      obj.transform:Set_localEulerAngles(90, 0, 0)
      obj.transform.localPosition = Vector3.New(0, 0.2, 0)
      obj.transform.localScale = Vector3.New(1.5, 1.5, 1)
      sprite = obj:AddComponent(typeof(CS.UnityEngine.SpriteRenderer))
      self.qualitySlots[i] = sprite
    end
    local hero = self.heroDataList[i]
    if hero then
      local path, appearanceId = hero:GetHeroModelData(HeroModelType.Battle)
      if path and appearanceId then
        local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
        self.heroReqList[i] = Resource:InstantiateAsync(path)
        self.heroReqList[i]:completed("+", function(request)
          local gameObject = request.gameObject
          local transform = gameObject.transform
          transform:SetParent(self.platoonGoList[i].transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          transform:Set_localPosition(0, 0, 0)
          transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size, appearanceMeta.model_size)
          local animator = gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
          if not IsNull(animator) then
            animator:Play(AnimName.Idle)
          end
        end)
        if sprite then
          sprite:LoadSprite(string.format("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_%d.png", hero.meta.quality))
        end
      end
    elseif sprite then
      sprite:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_dige_kong.png")
    end
    ::lbl_183::
  end
  local weaponInfo, weaponAppearance = self:CreateEnemyWepaonInfo()
  if weaponInfo and weaponAppearance then
    local armyRootTransform = self.armyRoot.transform
    self.opponentWeaponGo = nil
    self.opponentWeaponInfo = nil
    self.opponentWeaponReq = nil
    local index = 12
    local weaponGo = GameObject("WeaponRoot")
    self.opponentWeaponGo = weaponGo
    local weaponTransform = weaponGo.transform
    weaponTransform:SetParent(armyRootTransform)
    weaponTransform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    local localPosition = self.sceneData.platoonLocalPos[index]
    weaponTransform:Set_localPosition(localPosition.x, localPosition.y, localPosition.z)
    local path = weaponAppearance.model_path
    self.opponentWeaponReq = Resource:InstantiateAsync(path)
    self.opponentWeaponReq:completed("+", function(request)
      local gameObject = request.gameObject
      local transform = gameObject.transform
      transform:SetParent(self.opponentWeaponGo.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_localScale(weaponAppearance.model_size, weaponAppearance.model_size, weaponAppearance.model_size)
    end)
  end
end

function FakePVPLogic:DestroyFakeEnemy()
  if self.heroDataList then
    for k, v in pairs(self.heroDataList) do
      self.heroDataList[k]:Delete()
    end
    self.heroDataList = nil
  end
  if self.heroReqList then
    for k, v in pairs(self.heroReqList) do
      self.heroReqList[k]:Destroy()
    end
    self.heroReqList = nil
  end
  if self.platoonGoList then
    for i = 1, #self.platoonGoList do
      CS.UnityEngine.GameObject.Destroy(self.platoonGoList[i])
    end
    self.platoonGoList = nil
  end
  if self.opponentWeaponReq then
    self.opponentWeaponReq:Destroy()
    self.opponentWeaponReq = nil
  end
  if self.opponentWeaponGo then
    CS.UnityEngine.GameObject.Destroy(self.opponentWeaponGo)
    self.opponentWeaponGo = nil
  end
  if self.armyRoot then
    CS.UnityEngine.GameObject.Destroy(self.armyRoot)
    self.armyRoot = nil
  end
  if self.qualitySlots then
    for _, v in pairs(self.qualitySlots) do
      if not IsNull(v) then
        CS.UnityEngine.GameObject.Destroy(v.gameObject)
      end
    end
    self.qualitySlots = nil
  end
end

function FakePVPLogic:SetSquadCreateFinishFlag(state)
  self.squadCreateFinish = state
end

function FakePVPLogic:OnSquadCreateFinish()
  self.squadCreateFinish = true
  EventManager:GetInstance():Broadcast(EventId.OnBattleSquadCreateFinish)
end

function FakePVPLogic:GetSquadMemberPosition()
  if self.squad then
    return self.squad:ReturnMemberPositions()
  else
    return {}
  end
end

function FakePVPLogic:GetEnemyMemberPosition()
  local pos = {}
  if self.platoonGoList ~= nil then
    for i = 1, ArmyFormationSlot.Dominator do
      if self.platoonGoList[i] then
        table.insert(pos, self.platoonGoList[i].transform:TransformPoint(0, -0.6, 0))
      end
    end
  end
  return pos
end

function FakePVPLogic:SetHeroers(heroes)
  if self.squad then
    self.squad:ChangeHeroes(heroes)
  end
  if not self.allUnits then
    self.allUnits = {}
  end
  for i = 1, ArmyFormationSlot.Dominator do
    local pvpSlot = self.sceneData.FormationSlot2PVPSlot(i, true)
    if heroes[i] then
      self.allUnits[pvpSlot] = heroes[i]
    else
      self.allUnits[pvpSlot] = nil
    end
  end
  self:RefreshBattleEffect()
end

function FakePVPLogic:SetHeroPos(index, pos)
  if self.squad then
    self.squad:SetHeroPosition(index, pos)
  end
  if self.sourceEffects and self.sourceEffects[index] then
    for _, v in pairs(self.sourceEffects[index]) do
      v:UpdateStartPos(pos)
    end
  end
  if self.targetEffects and self.targetEffects[index] then
    for _, v in pairs(self.targetEffects[index]) do
      v:UpdateTargetPos(pos)
    end
  end
end

function FakePVPLogic:ResetHeroPos()
  if self.squad then
    self.squad:ResetHeroPosition()
  end
end

function FakePVPLogic:OnDragHeroEnd(dragHeroIdx)
  if self.squad then
    self.squad:ResetHeroPosition()
    if self.sourceEffects and self.sourceEffects[dragHeroIdx] then
      for _, v in pairs(self.sourceEffects[dragHeroIdx]) do
        v:UpdateStartPos(v:GetStartIdxPos())
        v:ReplayDstEffect()
      end
    end
    if self.targetEffects and self.targetEffects[dragHeroIdx] then
      for _, v in pairs(self.targetEffects[dragHeroIdx]) do
        v:UpdateTargetPos(v:GetTargetIdxPos())
      end
    end
  end
end

function FakePVPLogic:HeroMoveToIndex(index, dstIndex, time)
  local animTime = time or 0.5
  if self.squad then
    self.squad:MoveHeroToIndex(index, dstIndex, animTime)
  end
end

function FakePVPLogic.OnGetBattleData(msg)
  local self = DataCenter.LWBattleManager:GetCurBattleLogic()
  if self.param.enterType == PVEEnterType.TruckRob then
    if msg and msg.reward then
      self.param.attackTrainReward = msg.reward
      if msg.extraPlunder then
        for i = 1, #msg.extraPlunder do
          local extraReward = msg.extraPlunder[i]
          extraReward.trainRewardState = TrainRewardState.Extra
          table.insert(self.param.attackTrainReward, extraReward)
        end
      end
      if msg.retake then
        for i = 1, #msg.retake do
          local retakeReward = msg.retake[i]
          retakeReward.trainRewardState = TrainRewardState.Recapture
          table.insert(self.param.attackTrainReward, retakeReward)
        end
      end
    end
    if msg and msg.mail_id then
      self.param.mailUid = msg.mail_id
    end
  elseif msg and msg.reward then
    self.param.reward = msg.reward
  end
  if self.param.enterType == PVEEnterType.TowerupJeepAdventure and self.param.extraData then
    self.param.extraData.serverMsg = msg
  end
  if (self.param.enterType == PVEEnterType.NewPeakArena or self.param.enterType == PVEEnterType.NewGaleArena) and msg.curRank and msg.oldRank and msg.ownerOldScore and msg.ownerNewScore and msg.otherOldScore and msg.otherNewScore then
    local rankChange = {}
    rankChange.curRank = msg.curRank
    rankChange.oldRank = msg.oldRank
    rankChange.ownerOldScore = msg.ownerOldScore
    rankChange.ownerNewScore = msg.ownerNewScore
    rankChange.otherOldScore = msg.otherOldScore
    rankChange.otherNewScore = msg.otherNewScore
    self.param.rankChange = rankChange
  end
  if self.stage == FakePVPStage.Lineup then
    if self.param.enterType == PVEEnterType.TrailTower and self.param.extraData.isBattleSweep then
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroFakePVPFormation) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation)
      end
      DataCenter.LWBattleManager:Exit()
      return
    end
    self:EnterBattleGame(msg)
    local isTrunkQuick = self.param ~= nil and self.param.extraData ~= nil and self.param.extraData.isTruckQuickRob
    if isTrunkQuick then
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroFakePVPFormation) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation)
      end
      self:JumpToEnd()
    end
  end
end

function FakePVPLogic.OnCheckTrainRefreshReceived(uuid)
  local self = DataCenter.LWBattleManager:GetCurBattleLogic()
  if self.stage ~= FakePVPStage.Lineup then
    return
  end
  if self and self.param and self.param.enterType == PVEEnterType.TruckRob and self.param.extraData and self.param.extraData.trainData and self.param.extraData.trainData.uuid == uuid then
    local trainData = self.param.extraData.trainData
    if not trainData then
      return
    end
    for i = 1, 5 do
      local trainHero = trainData.heroInfo[i]
      local heroData = self.heroDataList[i]
      if trainHero and heroData and trainHero.id == heroData.heroId then
        heroData.level = trainHero.level
      end
    end
    EventManager:GetInstance():Broadcast(EventId.RobTruckTryRefreshView, uuid)
  end
end

function FakePVPLogic:EnterBattleGame(t)
  local ext = MailBattleReport.New()
  if t.contentArray then
    ext:ParseContentForSkirmish(t.contentArray[1])
  else
    ext:ParseContentForSkirmish(t)
  end
  self.param.mailExtData = ext
  self:DestroyFakeEnemy()
  self:ClearAllFormingEffects()
  if self.squad then
    self.squad:Delete()
    self.squad = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
  end
  self.unitMgr = UnitManager.New(self)
  self.battleMgr = DataCenter.LWBattleManager
  self.battleData = SkirmishBattleData.New(self.param.mailExtData)
  self.sceneData:InitData(self.battleData:SelfHaveDominator(), self.battleData:EnemyHasDominator(), self.formationPositionType)
  self.battleMgr.cameraOffset:Set(0, 0, 0)
  self:ChangeStage(FakePVPStage.Load)
  local enemyData = self.battleData.extData.player[2]
  if enemyData and self.levelId and 0 < self.levelId then
    local template
    if self.param.enterType == PVEEnterType.SeasonTower then
      template = DataCenter.LWSeasonTowerArmyTemplateManager:GetArmyTemplate(self.param.levelId)
    else
      template = DataCenter.LWArmyTemplateManager:GetArmyTemplate(self.levelId)
    end
    if template then
      enemyData.uid = nil
      enemyData.pic = UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, template.army_icon)
      enemyData.name = Localization:GetString(template.name)
      enemyData.level = 1
    end
  end
  if self.param and self.param.enterType == PVEEnterType.TruckRob and self.param.extraData then
    local trainData = self.param.extraData.trainData
    if enemyData and trainData then
      if enemyData.name == nil then
        local abbr = trainData.abbr
        enemyData.name = UIUtil.FormatAllianceAndName(abbr, trainData.name)
      end
      if enemyData.level == nil then
        enemyData.level = trainData.ownerLv
      end
      if enemyData.uid == nil then
        enemyData.uid = trainData.ownerId
        enemyData.headSkinId = trainData.headSkinId
        enemyData.pic = trainData.pic
        enemyData.picVer = trainData.picVer
        enemyData.headSkinET = trainData.headSkinET
      end
    end
  end
  local playerData = self.battleData.extData.player[1]
  if playerData and playerData.uid == nil then
    playerData.uid = LuaEntry.Player.uid
    playerData.pic = LuaEntry.Player.pic
    playerData.picVer = LuaEntry.Player.picVer
    playerData.name = LuaEntry.Player:GetFullName()
    playerData.level = LuaEntry.Player.level
  end
  self.bulletManager = BulletManager.New(self)
  self.damageTextMgr = DamageTextManager.New()
  self.prevActIndex = 0
  self.useTime = 0
  self.startFrame = Time.frameCount
  self.killNum = 0
  self.unitGuid = 0
  self.delayEvents = {}
  self.__event_handlers = {}
  self.delayActions = {}
  self.captains = {}
  self.pauseBattleTimer = nil
  TimerManager:GetInstance():DelayInvoke(function()
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    local log = ""
    if logic and logic:GetPVEType() == PVEType.FakePVP and logic.stage == FakePVPStage.Lineup then
      log = "wrong stage FakePVPStage.Lineup"
    end
    if log ~= "" then
      Logger.LogWarning("FakePVPLogic Close FormationView Warning Log:" .. log)
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation_HeroTryOut)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation_SeasonTower)
  end, 0.1)
  self:StartBattleLoadScene()
  self:StartBattleInitCamera()
end

function FakePVPLogic:StartBattleInitCamera()
  self.camera = self.battleMgr.camera
  self.hudCamera = self.battleMgr.hudCamera
  self.touchCamera = self.battleMgr.touchCamera
  self.touchCamera.CanMoveing = false
  self:StartBattleInitCameraParams()
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

function FakePVPLogic:OnFingerDown()
end

function FakePVPLogic:OnFingerUp()
end

function FakePVPLogic:StartBattleInitCameraParams()
  local height = self.sceneData.OPENING_CAMERA_HEIGHT
  local fov = self.sceneData.OPENING_CAMERA_FOV
  local rotation = self.sceneData.OPENING_CAMERA_ROTATION
  self.touchCamera.CamZoom = height
  self.touchCamera.LodLevel = 1
  self.camera.fieldOfView = fov
  self.hudCamera.fieldOfView = fov
  local offsetZ = self:GetOffsetZ(height, rotation)
  self.touchCamera:SetZoomParams(1, height, offsetZ, 25)
  self.defaultHeight = height
  self.touchCamera.CamZoomMin = 10
  self.camera.transform.eulerAngles = Vector3.New(rotation, 0, 0)
end

function FakePVPLogic:GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function FakePVPLogic:UpdateCameraFollow()
end

function FakePVPLogic:ShakeCameraWithParam(param)
  self.battleMgr:ShakeCameraWithParam(param)
end

function FakePVPLogic:StartBattleLoadScene(callBack)
  self.captains = {}
  self.armys = {}
  self.armys[1] = Army.New(self, 1, self.sceneData, self.battleData)
  self.armys[2] = Army.New(self, 2, self.sceneData, self.battleData)
  self.damageTextMgr:Init(self)
  self:ChangeStage(FakePVPStage.Opening)
end

function FakePVPLogic:OnUpdate()
  if self.stage == FakePVPStage.Lineup then
    return
  end
  if self.fightPause == true then
    return
  end
  self.bulletManager:OnUpdate()
  self.effectObjMgr:OnUpdate()
  self.damageTextMgr:OnUpdate()
  if self.armys then
    self.armys[1]:OnUpdate()
    self.armys[2]:OnUpdate()
  end
  if self.stage == FakePVPStage.Fight then
    self:OnUpdateFight()
  end
  self.unitMgr:OnUpdate()
  self:OnUpdateDoDelayAction()
end

function FakePVPLogic:OnUpdateSec()
  self.useTime = self.useTime + 1
end

function FakePVPLogic:DealDamage(params)
  local defender = params.defender
  local hitPoint = params.hitPoint
  local hitDir = params.hitDir
  local whiteTime = params.whiteTime
  local stiffTime = params.stiffTime
  local hitBackDistance = params.hitBackDistance
  local hitEff = params.hitEff
  local skill = params.skill
  defender:AfterBeAttack(0, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
end

function FakePVPLogic:ShowDamageText(damage, position, style, damageType, isCritical, time)
  local param = self.damageTextMgr:GetParam()
  param.damage = damage
  param.position = position
  param.style = style
  param.damageType = damageType
  param.isCritical = isCritical
  param.time = time
  self.damageTextMgr:GenText(param)
end

function FakePVPLogic:ShowBuffText(txt, position, isDebuff, iconPath, time)
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

function FakePVPLogic:ShowEffectText(txt, position, style, isDebuff, time, combo)
  local param = self.damageTextMgr:GetParam()
  param.txt = txt
  param.position = position
  param.style = style
  param.isDebuff = isDebuff
  param.time = time
  param.damage = 0
  param.combo = combo or 0
  self.damageTextMgr:GenText(param)
end

function FakePVPLogic:AfterExit()
  if self.param.enterType == PVEEnterType.Radar then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
  elseif self.param.enterType == PVEEnterType.TruckRob then
  elseif self.param.enterType == PVEEnterType.HeroTryOut then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation_HeroTryOut, {anim = false})
  elseif self.param.enterType == PVEEnterType.SeasonTower then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation_SeasonTower, {anim = false})
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroFakePVPFormation, {anim = false})
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkirmishMain, {anim = false})
  self.mainUI = nil
end

function FakePVPLogic:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function FakePVPLogic:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function FakePVPLogic:AllotUnitGuid()
  self.unitGuid = self.unitGuid + 1
  return self.unitGuid
end

function FakePVPLogic:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function FakePVPLogic:ShowEffectObj(path, pos, rot, time, parent, type, isImportant)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type, isImportant)
end

function FakePVPLogic:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function FakePVPLogic:AddListener(msg_name, callback)
  local function bindFunc(...)
    callback(self, ...)
  end
  
  self.__event_handlers[msg_name] = bindFunc
  EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function FakePVPLogic:RemoveListener(msg_name, callback)
  local bindFunc = self.__event_handlers[msg_name]
  if not bindFunc then
    return
  end
  self.__event_handlers[msg_name] = nil
  EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function FakePVPLogic:AddDelayEvent(event, delay)
  assert(event, "event invalid")
  local timer = TimerManager:GetInstance():DelayInvoke(event, delay)
  table.insert(self.delayEvents, timer)
end

function FakePVPLogic:GetTotalKill()
  return self.killNum
end

function FakePVPLogic:GetFightDuration()
  return self.battleData.fightDuration
end

function FakePVPLogic:GetWatchTime()
  return self.useTime
end

function FakePVPLogic:GetAvgFPS()
  if self.useTime == 0 then
    return -1
  end
  return (Time.frameCount - self.startFrame) / self.useTime
end

function FakePVPLogic:Lookat(lookWorldPosition)
  local cameraOffset = Vector3.New(0, 0, 4.1)
  self.followCameraTarget = Vector3.New(lookWorldPosition.x, lookWorldPosition.y, lookWorldPosition.z)
  self.touchCamera:LookAt(lookWorldPosition + cameraOffset)
end

function FakePVPLogic:ChangeStage(newStage, param)
  local oldStage = self.stage
  if newStage == FakePVPStage.Load then
    self.stage = newStage
  elseif newStage == FakePVPStage.Opening then
    if oldStage ~= FakePVPStage.Load then
      return
    end
    self.stage = newStage
    local isTrunkQuick = self.param ~= nil and self.param.extraData ~= nil and self.param.extraData.isTruckQuickRob
    if not isTrunkQuick and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UISkirmishMain) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      })
      self.mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UISkirmishMain).View
    end
    self.battleMgr:LookAt(self.sceneData.camPoint + Vector3(0, 0, -27))
    self.battleMgr:SetGameStart(true)
    self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT, self.sceneData.OPENING_TIME)
    self:AddDelayEvent(function()
      self:ChangeStage(FakePVPStage.Fight)
    end, self.sceneData.OPENING_TIME)
  elseif newStage == FakePVPStage.Fight then
    if oldStage ~= FakePVPStage.Opening then
      return
    end
    Logger.Log("SkirmishState.Fight")
    self.stage = newStage
    self.fightTime = 0
    EventManager:GetInstance():Broadcast(EventId.SkirmishFightStage)
  elseif newStage == FakePVPStage.End then
    if oldStage ~= FakePVPStage.Opening and oldStage ~= FakePVPStage.Fight then
      return
    end
    Logger.Log("SkirmishState.End")
    self.stage = newStage
    EventManager:GetInstance():Broadcast(EventId.SkirmishEndStage)
    local popDelay = param or 3
    self:AddDelayEvent(function()
      if self.param.enterType == PVEEnterType.TowerupJeepAdventure or self.param.enterType == PVEEnterType.TruckRob or self.param.enterType == PVEEnterType.HSRRob or self.param.enterType == PVEEnterType.TrailTower or self.param.enterType == PVEEnterType.DetectZombieBusTrain or self.param.enterType == PVEEnterType.T11IdleGameBattleEvent or self.param.enterType == PVEEnterType.HeroTryOut then
        if not self.battleData.topPlayerWin then
          local p = {}
          p.stageId = self.levelId
          if self.param.enterType == PVEEnterType.TrailTower then
            p.stageId = self.param.extraData.trailTowerLevelTemplate.id
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrailTowerBattleWin, {anim = false, playEffect = 10024}, p, self.param)
          elseif self.param.enterType == PVEEnterType.T11IdleGameBattleEvent then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventBattleWin, {anim = false, playEffect = 10024}, p, self.param)
          elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureVictory, {anim = true, playEffect = 10024}, self.param)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UITowerupBattleWin, {anim = false, playEffect = 10024}, p, self.param)
          end
        else
          local p = {}
          p.stageId = self.levelId
          if self.param.enterType == PVEEnterType.T11IdleGameBattleEvent then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIIdleGameTaskEventBattleLose, {anim = false, playEffect = 10023}, p, self.param)
          elseif self.param.enterType == PVEEnterType.TowerupJeepAdventure then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleResultJeepAdventureDefeat, {anim = true, playEffect = 10023}, self.param)
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UITowerupBattleLose, {anim = false, playEffect = 10023}, p, self.param)
          end
        end
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISkirmishResult, {anim = false}, self.param)
      end
    end, popDelay)
  end
  if self.armys then
    for _, army in pairs(self.armys) do
      army:ChangeStage(newStage)
    end
  end
end

function FakePVPLogic:SetMinionFightPause(isPause)
  if self.armys then
    for _, army in pairs(self.armys) do
      for _, platoon in pairs(army.platoons) do
        for _, minion in pairs(platoon.minions) do
          minion:SetMinionFightPause(isPause)
        end
      end
    end
  end
end

function FakePVPLogic:SetCaptainFightPause(isPause)
  self.fightPause = isPause
  if not isPause and self.battleMgr ~= nil and self.sceneData ~= nil and self.prevActIndex ~= nil and self.battleData ~= nil then
    if self.stage ~= FakePVPStage.Fight then
      Logger.Log("SkirmishState.Fight")
      self.stage = FakePVPStage.Fight
      self.battleMgr:AutoZoom(self.sceneData.FIGHT_CAMERA_HEIGHT)
    end
    if self.armys then
      for _, army in pairs(self.armys) do
        army:ChangeStage(FakePVPStage.Fight)
      end
    end
    if self.prevActIndex <= 0 then
      self.fightTime = 0
    else
      self.fightTime = self.battleData.actions[self.prevActIndex].time
    end
  end
end

function FakePVPLogic:ReDo()
  if self.prevActIndex >= #self.battleData.actions then
    return nil
  end
  self:DoAction(self.prevActIndex + 1)
  self.prevActIndex = self.prevActIndex + 1
  return true
end

function FakePVPLogic:UnDo()
  if self.prevActIndex <= 0 then
    return nil
  end
  self:UnDoAction(self.prevActIndex)
  self.prevActIndex = self.prevActIndex - 1
  return true
end

function FakePVPLogic:UnReDo()
  return self:UnDo() and self:ReDo()
end

function FakePVPLogic:OnUpdateFight()
  if self.fightPause then
    return
  end
  if self.prevActIndex >= #self.battleData.actions then
    self:ChangeStage(FakePVPStage.End)
    return
  end
  local oldFightTime = self.fightTime
  self.fightTime = self.fightTime + Time.deltaTime
  for i = self.prevActIndex + 1, #self.battleData.actions do
    if self.battleData.actions[i].time < self.fightTime then
      self:DoAction(i)
      self.prevActIndex = i
    else
      break
    end
  end
  local oldAdvanceTime = oldFightTime + ULTIMATE_ADVANCE_OFFSET
  local advanceTime = self.fightTime + ULTIMATE_ADVANCE_OFFSET
  for i = self.prevActIndex + 1, #self.battleData.actions do
    if oldAdvanceTime > self.battleData.actions[i].time then
    elseif advanceTime > self.battleData.actions[i].time then
      self:CheckUltimateBubble(i)
    else
      break
    end
  end
end

function FakePVPLogic:CheckUltimateBubble(index)
  local curAction = self.battleData.actions[index]
  if curAction.phase == ActionPhase.Cast then
    local caster = self.captains[curAction.casterIndex]
    local isUltimateSkill = false
    if caster then
      local skillInfo = caster:GetSkillInfo(curAction.skillId)
      if skillInfo then
        isUltimateSkill = skillInfo:IsUltimateSkill()
      end
    end
    if curAction.casterIndex <= 5 and isUltimateSkill then
      EventManager:GetInstance():Broadcast(EventId.SkirmishUltimateBubble, curAction)
    end
  end
end

function FakePVPLogic:DoAction(index)
  local curAction = self.battleData.actions[index]
  self:LogAction(curAction)
  if curAction.phase == ActionPhase.Cast or curAction.phase == ActionPhase.FIRE_BULLET or curAction.phase == ActionPhase.SPLASH_DAMAGE or curAction.phase == ActionPhase.SkillCast or curAction.phase == ActionPhase.Bounce then
    self.captains[curAction.casterIndex]:DoAction(curAction)
  elseif curAction.phase == ActionPhase.Buff then
    local skillLv = 1
    local skillId = curAction.skillId
    local casterIndex = curAction.casterIndex
    if skillId and 0 < skillId and casterIndex and 0 < casterIndex then
      local unit = self:GetCaptain(casterIndex)
      if unit and unit.heroData then
        if unit.heroData.skillLevels then
          skillLv = unit.heroData.skillLevels[skillId]
        elseif unit.heroData.skillInfos then
          for _, v in pairs(unit.heroData.skillInfos) do
            if v.skillId == skillId then
              skillLv = v.skillLv
              break
            end
          end
        end
      end
    end
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v, skillLv)
    end
  elseif curAction.phase == ActionPhase.Dot then
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v)
    end
  elseif curAction.phase == ActionPhase.Damage or curAction.phase == ActionPhase.ShieldDamage then
    if #curAction.targets == 1 then
      self.captains[curAction.targets[1].index]:DoAction(curAction, curAction.targets[1])
    elseif 1 < #curAction.targets then
      local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(curAction.skillId)
      local effectId = curAction.effectId
      if effectId == 0 then
        effectId = curAction.skillId * 10
      end
      local skillEffectMeta = DataCenter.SkillEffectPvpTemplateManager:GetTemplate(effectId)
      if skillEffectMeta and skillEffectMeta.pvp_bullet == 0 and skillEffectMeta.pvp_actionType == SkillActionType.NoBulletDamage then
        for _, v in pairs(curAction.targets) do
          self.captains[v.index]:DoAction(curAction, v)
        end
      else
        if skillEffectMeta == nil or 0 >= skillEffectMeta.pvp_bullet then
          Logger.LogError("skill effect meta is nil or bulletId is <=0,  effectId:" .. tostring(curAction.effectId))
          return
        end
        local bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(skillEffectMeta.pvp_bullet)
        local bullet_row_count = bulletMeta.bullet_row_count_replay
        local bullet_wave_count = bulletMeta.bullet_wave_count_replay
        local bullet_diff_time = bulletMeta.bullet_diff_time_replay
        local bullet_wave_diff_time = bulletMeta.bullet_wave_diff_time_replay
        if bullet_row_count == 1 and bullet_wave_count == 1 then
          for _, v in pairs(curAction.targets) do
            self.captains[v.index]:DoAction(curAction, v)
          end
        else
          local hitsClientConfig = bullet_wave_count * bullet_row_count
          local hitsServerConfig = skillEffectMeta.pvp_cast_count
          local totalTargets = #curAction.targets
          local hitIndex = 0
          local targetIndex = 0
          local delayTime = 0
          local targetPerHits = math.ceil(totalTargets / hitsServerConfig)
          for i = 0, bullet_wave_count - 1 do
            for j = 0, bullet_row_count - 1 do
              delayTime = bullet_wave_diff_time * i + bullet_diff_time * j
              for k = 1, targetPerHits do
                targetIndex = targetIndex + 1
                if curAction.targets[targetIndex] then
                  curAction.targets[targetIndex].delayTime = delayTime
                else
                  goto lbl_270
                end
              end
              hitIndex = hitIndex + 1
            end
          end
          ::lbl_270::
          for i = targetIndex + 1, totalTargets do
            if curAction.targets[i] then
              curAction.targets[i].delayTime = delayTime
            end
          end
          curAction.pastIndex = 0
          curAction.pastTime = 0
          table.insert(self.delayActions, curAction)
        end
      end
    end
  elseif curAction.phase == ActionPhase.REMOVE_BUFF then
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:DoAction(curAction, v)
    end
  elseif curAction.phase == ActionPhase.SummonPet then
    for _, v in pairs(curAction.summonUnit) do
      local petInfo = DeepCopy(v)
      if self.battleData:NeedSwap() then
        petInfo.index = self.battleData.Swap(petInfo.index)
      end
      local index = petInfo.index
      local armyIndex = 5 < index and 2 or 1
      self.armys[armyIndex]:CreatePet(petInfo)
    end
  elseif curAction.phase == ActionPhase.BeforeHeroAwakenSkillCast then
    local isSelfHero = curAction.casterIndex <= PVPBattleSlot.SelfHero5
    if isSelfHero then
      self.captains[curAction.casterIndex]:DoAction(curAction)
      self:SetGamePauseForTime(1)
      EventManager:GetInstance():Broadcast(EventId.SkirmishCastHeroAwakenSkill, self.captains[curAction.casterIndex])
    end
  end
  if CommonUtil.IsDebug() then
    EventManager:GetInstance():Broadcast(EventId.SkirmishDoAction, curAction)
  end
end

function FakePVPLogic:OnUpdateDoDelayAction()
  for i = #self.delayActions, 1, -1 do
    local action = self.delayActions[i]
    if action.pastIndex >= #action.targets then
      table.remove(self.delayActions, i)
    else
      action.pastTime = action.pastTime + Time.deltaTime
      for j = action.pastIndex + 1, #action.targets do
        local target = action.targets[j]
        if target.delayTime and target.delayTime <= action.pastTime then
          self.captains[target.index]:DoAction(action, target)
          action.pastIndex = j
        else
          action.pastIndex = j - 1
          break
        end
      end
    end
  end
end

function FakePVPLogic:DoDelayActionInstantly()
  for i = #self.delayActions, 1, -1 do
    local action = self.delayActions[i]
    for j = action.pastIndex + 1, #action.targets do
      local target = action.targets[j]
      self.captains[target.index]:DoAction(action, target)
    end
    table.remove(self.delayActions, i)
  end
end

function FakePVPLogic:UnDoAction(index)
  local curAction = self.battleData.actions[index]
  if curAction.phase == ActionPhase.Cast then
    self.captains[curAction.casterIndex]:UnDoAction(curAction)
  elseif curAction.phase == ActionPhase.Damage or curAction.phase == ActionPhase.Dot then
    self:DoDelayActionInstantly()
    for _, v in pairs(curAction.targets) do
      self.captains[v.index]:UnDoAction(curAction, v)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.SkirmishUnDoAction, curAction)
end

function FakePVPLogic:LogAction(action)
  local jsonData = rapidjson.encode(action)
  Logger.Log(jsonData .. "uuid" .. self.battleData.extData.uuid)
end

function FakePVPLogic:ErrorAction(action)
  local jsonData = rapidjson.encode(action)
  Logger.LogError(jsonData .. "uuid" .. self.battleData.extData.uuid)
end

function FakePVPLogic:AddCaptain(index, captain)
  self.captains[index] = captain
end

function FakePVPLogic:GetCaptain(index)
  if self.captains[index] then
    return self.captains[index]
  else
    return nil
  end
end

function FakePVPLogic:OnCaptainDeath()
end

function FakePVPLogic:GetRandomTargetPos(index)
  return self.armys[index % 2 + 1]:GetRandomPosition()
end

function FakePVPLogic:GetPVEType()
  return PVEType.FakePVP
end

function FakePVPLogic:Exit()
  self.battleMgr:Exit()
end

function FakePVPLogic:JumpToEnd()
  self:ChangeStage(FakePVPStage.End, 0)
end

function FakePVPLogic:GetMailUuid()
  if self.battleData and self.battleData.extData then
    return self.battleData.extData.uuid
  end
  return nil
end

function FakePVPLogic:IsEffectValid(id)
  return self.effectObjMgr:IsEffectValid(id)
end

function FakePVPLogic:ReplayEffect(id, time)
  self.effectObjMgr:ReplayEffect(id, time)
end

local ObjectPoolIns = ObjectPool:GetInstance()

function FakePVPLogic:RefreshBattleEffect()
  if not self.allUnits then
    self:ClearAllFormingEffects()
  end
  local validEffects = {}
  for idx, hero in pairs(self.allUnits) do
    local skills = hero:GetAllSkillsReadOnly()
    for _, skill in pairs(skills) do
      if skill:IsUnlock() then
        local template = skill:GetTemplateData()
        local formingEffect = template:GetFormingEffect()
        if not table.IsNullOrEmpty(formingEffect) then
          for i = 1, #formingEffect do
            local effect = formingEffect[i]
            local displayType, targetEffect, lineEffect = effect.displayType, effect.targetEffect, effect.lineEffect
            if BattleEnumType.inverseBattleFormingEffect[displayType] then
              if not self.targetEffClsMap then
                self.targetEffClsMap = {}
              end
              if not self.targetEffClsMap[displayType] then
                self.targetEffClsMap[displayType] = require(BattleEnumType.BattleFormingEffectClass[displayType])
              end
              local cls = self.targetEffClsMap[displayType]
              local oppositePos = cls.GetOppositeIdx(self.sceneData, self.allUnits, idx)
              if not oppositePos then
                break
              end
              local oppositeHero = self.allUnits[oppositePos]
              if not oppositeHero then
                break
              end
              local hash = cls.GetHash(idx, oppositePos, targetEffect, lineEffect)
              if self.m_formingEffects and self.m_formingEffects[hash] then
                validEffects[hash] = self.m_formingEffects[hash]
                break
              end
              local effectInfo = ObjectPoolIns:Load(cls)
              effectInfo:Init(idx, oppositePos, targetEffect, lineEffect, self)
              effectInfo:Load()
              validEffects[hash] = effectInfo
              if not self.m_formingEffects then
                self.m_formingEffects = {}
              end
              self.m_formingEffects[hash] = effectInfo
              if not self.sourceEffects then
                self.sourceEffects = {}
              end
              if not self.sourceEffects[idx] then
                self.sourceEffects[idx] = {}
              end
              self.sourceEffects[idx][hash] = effectInfo
              if not self.endEffects then
                self.endEffects = {}
              end
              if not self.endEffects[oppositePos] then
                self.endEffects[oppositePos] = {}
              end
            end
          end
        end
      end
    end
  end
  if self.m_formingEffects then
    for hash, effect in pairs(self.m_formingEffects) do
      if not validEffects[hash] then
        local srcIdx = effect.srcIdx
        local targetIdx = effect.dstIdx
        self.m_formingEffects[hash] = nil
        if effect then
          effect:Delete()
          ObjectPoolIns:Save(effect)
        end
        if self.sourceEffects[srcIdx] and self.sourceEffects[srcIdx][hash] then
          self.sourceEffects[srcIdx][hash] = nil
        end
        if self.endEffects[targetIdx] and self.endEffects[targetIdx][hash] then
          self.endEffects[targetIdx][hash] = nil
        end
      end
    end
  end
end

function FakePVPLogic:ClearAllFormingEffects()
  if not table.IsNullOrEmpty(self.m_formingEffects) then
    for hash, effectInfo in pairs(self.m_formingEffects) do
      effectInfo:Delete()
      ObjectPoolIns:Save(effectInfo)
    end
    self.m_formingEffects = nil
    self.sourceEffects = nil
    self.endEffects = nil
    self.targetEffClsMap = nil
  end
end

function FakePVPLogic:GetTeamHeroByUuid(uuid)
  if self.squad then
    return self.squad:GetHeroInfoByUuid(uuid)
  end
  return nil
end

function FakePVPLogic:SetGamePause(isPause)
  self:SetCaptainFightPause(isPause)
  self:SetMinionFightPause(isPause)
end

function FakePVPLogic:SetGamePauseForTime(time)
  local leftPauseTime = time
  if self.pauseBattleTimer ~= nil then
    leftPauseTime = leftPauseTime + checknumber(self.pauseBattleTimer.left)
    self.pauseBattleTimer:Stop()
    self.pauseBattleTimer = nil
  end
  if 0 < leftPauseTime then
    self:SetGamePause(true)
    self.pauseBattleTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:SetGamePause(false)
    end, leftPauseTime)
  end
end

function FakePVPLogic:IsGamePaused()
  return self.fightPause == true
end

function FakePVPLogic:IsHideSkipBtn()
  if self.param ~= nil and self.param.enterType == PVEEnterType.HeroTryOut and self.param.extraData and self.param.extraData.cfgId then
    local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
    if tryOutTemplate ~= nil and not tryOutTemplate:IsCanSkip() then
      return true
    end
  end
  return false
end

return FakePVPLogic
