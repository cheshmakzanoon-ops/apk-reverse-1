local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local DisplaySettings = require("DataCenter.WorldBattle.WorldBattleDisplaySettings")
local WorldFakeBattleManager = BaseClass("WorldFakeBattleManager")
local AlBuildAssistSquad = require("Scene.LWWorldMarch.AlBuildAssistSquad")
local Zombie = require("Scene.LWWorldMarch.WorldFakeBattleZombie")
local zombieSpawnSec = 0.2
local assistAttackSec = 5

function WorldFakeBattleManager:__init()
  self.nextObjId = 1
  self.alBuildSquadDatas = {}
  
  function self.__onUpdateDisplayMode()
    self:UpdateDisplayMode()
  end
  
  function self.onAlAssistDataGet(uuid)
    self:UpdateAlBuildSquad(uuid)
  end
  
  function self.OnSingleMarchStateUpdate(matchUUID)
    self:UpdateAlBuildSquadWhenMarchChange(matchUUID)
  end
  
  EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.__onUpdateDisplayMode)
  EventManager:GetInstance():AddListener(EventId.GetAssistanceData, self.onAlAssistDataGet)
  EventManager:GetInstance():AddListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
end

function WorldFakeBattleManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.__onUpdateDisplayMode)
  EventManager:GetInstance():RemoveListener(EventId.GetAssistanceData, self.onAlAssistDataGet)
  EventManager:GetInstance():RemoveListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
  self.__onUpdateDisplayMode = nil
  self.onAlAssistDataGet = nil
  self.OnSingleMarchStateUpdate = nil
  self:Destroy()
  Zombie.ReleaseAll()
end

function WorldFakeBattleManager:Destroy()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  for bUUId, alBuildSquadData in pairs(self.alBuildSquadDatas) do
    self:RemoveAllianceBuildSquadByUUID(bUUId)
  end
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
    self.effectObjMgr = nil
  end
  self.alBuildSquadDatas = {}
  self.isInWorld = false
end

function WorldFakeBattleManager:OnEnterWorld()
  self.nextObjId = 1
  DataCenter.LWBattleManager:SetCurBattleLogic(self)
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.isInWorld = true
end

function WorldFakeBattleManager:OnExitWorld()
  self:Destroy()
  if DataCenter.LWBattleManager:GetCurBattleType() == PVEType.World then
    DataCenter.LWBattleManager:SetCurBattleLogic()
  end
  self.isInWorld = false
end

function WorldFakeBattleManager:OnUpdate()
  if not self.isInWorld then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = Time.deltaTime
  for uuid, v in pairs(self.alBuildSquadDatas) do
    local fadeTime = v.fadeTime
    if now >= fadeTime then
      self:RemoveAllianceBuildSquadByUUID(uuid)
    elseif v.squardEntity then
      self:DoPerformanceFakeWar(uuid, v, deltaTime)
    end
  end
  if self.effectObjMgr then
    self.effectObjMgr:OnUpdate()
  end
  if self.bulletManager then
    self.bulletManager:OnUpdate()
  end
  if CS.SceneManager.World then
    DisplaySettings.SetWorldZoom(CS.SceneManager.World.Zoom)
  end
end

function WorldFakeBattleManager:DoPerformanceFakeWar(uuid, alBuildSquadData, deltaTime)
  if not alBuildSquadData.spawnZombieCD or alBuildSquadData.spawnZombieCD < 0 then
    alBuildSquadData.spawnZombieCD = zombieSpawnSec
    self:SpawnAlBuildZombie(uuid)
  end
  alBuildSquadData.spawnZombieCD = alBuildSquadData.spawnZombieCD - deltaTime
  local targetZombieInsts = alBuildSquadData.targetZombieInst
  if targetZombieInsts then
    for id, zombieInst in pairs(targetZombieInsts) do
      zombieInst:Update(deltaTime)
    end
    if not alBuildSquadData.attackZombieCd or 0 > alBuildSquadData.attackZombieCd then
      alBuildSquadData.attackZombieCd = assistAttackSec
      self:PlayAnim(uuid, "attack", false)
      self:Attack(uuid)
      if alBuildSquadData.DelayToPlayIdle then
        alBuildSquadData.DelayToPlayIdle:Stop()
        alBuildSquadData.DelayToPlayIdle = nil
      end
      alBuildSquadData.DelayToPlayIdle = TimerManager:GetInstance():DelayInvoke(function()
        alBuildSquadData.DelayToPlayIdle = nil
        self:PlayAnim(uuid, "idle", false)
      end, 3)
    end
    alBuildSquadData.attackZombieCd = alBuildSquadData.attackZombieCd - deltaTime
  end
end

local function GetPointInfo(pointId)
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  return info
end

function WorldFakeBattleManager:CreateAllianceBuildSquad(pointId, parent, isCreate)
  if not self.isInWorld then
    return
  end
  local pointInfo = GetPointInfo(pointId)
  if pointInfo then
    local pointBuildID = pointInfo.buildId
    if pointBuildID ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
      return
    end
    self:RemoveAllianceBuildSquadByUUID(pointInfo.uuid)
    local squadExsit, fadeTime = self:IsBuildSquadExsit(pointInfo.extraInfo)
    if not squadExsit then
      return
    end
    local alBuildSquadData = {}
    alBuildSquadData.pointInfo = pointInfo
    alBuildSquadData.parent = parent
    alBuildSquadData.squadParent = parent:Find("ModelGo/Normal/ModelRoot/Skin/To_unity/DeformationSystem/Root/Root_M/Guadian/NGuadian")
    alBuildSquadData.buildAnimation = parent:GetComponentInChildren(typeof(CS.SimpleAnimation))
    alBuildSquadData.waitingForAssistData = true
    alBuildSquadData.fadeTime = fadeTime
    alBuildSquadData.isCreate = isCreate
    self.alBuildSquadDatas[pointInfo.uuid] = alBuildSquadData
    SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, pointInfo.uuid, AssistanceType.AllianceBuild)
  end
end

function WorldFakeBattleManager:IsBuildSquadExsit(extraInfo)
  local info = PBController.ParsePbFromBytes(extraInfo, "protobuf.AllianceBuildingPointInfo")
  if not info or not info.allianceId then
    return false
  end
  local declareInfo = DataCenter.AllianceDeclareWarManager:GetAlDeclareWarData(info.allianceId)
  if not declareInfo or not declareInfo.content then
    return false
  end
  local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
  local now = UITimeManager:GetInstance():GetServerTime()
  if protectTime > now then
    return true, protectTime
  else
    return false
  end
end

function WorldFakeBattleManager:UpdateAlBuildSquadWhenMarchChange(marchUUID)
  local march = DataCenter.WorldMarchDataManager:GetMarch(marchUUID)
  if not march then
    return
  end
  local marchTargetUUID = march.targetUuid
  local marchTargetPointId = march.targetPos
  if not marchTargetUUID or not marchTargetPointId then
    return
  end
  local status = march:GetMarchStatus()
  local targetAlBuildSquadData = self.alBuildSquadDatas[marchTargetUUID]
  if targetAlBuildSquadData and status == MarchStatus.ASSISTANCE then
    self:UpdateAlBuildSquadWhenMarchAssit(marchTargetPointId, targetAlBuildSquadData)
  elseif march:GetMarchStatus() == MarchStatus.MOVING and march.startPos then
    self:UpdateAlBuildSquadWhenAssisLeave(march.startPos)
  end
end

function WorldFakeBattleManager:UpdateAlBuildSquadWhenMarchAssit(marchTargetPointId, curAlBuildSquadData)
  if not curAlBuildSquadData or curAlBuildSquadData and curAlBuildSquadData.waitingForAssistData or curAlBuildSquadData and curAlBuildSquadData.squardEntity then
    return
  end
  local pointInfo = GetPointInfo(marchTargetPointId)
  if not pointInfo then
    return
  end
  local pointBuildID = pointInfo.buildId
  if pointBuildID ~= BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    return
  end
  local squadExsit, fadeTime = self:IsBuildSquadExsit(pointInfo.extraInfo)
  if not squadExsit then
    return
  end
  curAlBuildSquadData.fadeTime = fadeTime
  curAlBuildSquadData.waitingForAssistData = true
  SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, pointInfo.uuid, AssistanceType.AllianceBuild)
end

function WorldFakeBattleManager:UpdateAlBuildSquadWhenAssisLeave(marchStartPointId)
  local pointInfo = GetPointInfo(marchStartPointId)
  if not pointInfo then
    return
  end
  local curAlBuilidData = self.alBuildSquadDatas[pointInfo.uuid]
  if not curAlBuilidData or not curAlBuilidData.squardEntity then
    return
  end
  curAlBuilidData.waitingForAssistData = true
  SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, pointInfo.uuid, AssistanceType.AllianceBuild)
end

function WorldFakeBattleManager:UpdateAlBuildSquad(alBuildUUid)
  local alBuildSquadData = self.alBuildSquadDatas[alBuildUUid]
  if not alBuildSquadData or not alBuildSquadData.waitingForAssistData then
    return
  end
  alBuildSquadData.waitingForAssistData = false
  local zombieInsts = alBuildSquadData.targetZombieInst
  if zombieInsts then
    for id, zombieInst in pairs(zombieInsts) do
      Zombie.Return(zombieInst)
    end
  end
  alBuildSquadData.targetZombieInst = nil
  alBuildSquadData.targetZombieAmount = 0
  local alBuildSquadEntity = alBuildSquadData.squardEntity
  if alBuildSquadEntity then
    alBuildSquadEntity:Delete()
    ObjectPool:GetInstance():Save(alBuildSquadEntity)
  end
  alBuildSquadData.squardEntity = nil
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(alBuildUUid)
  local firstMember
  if info and info.memberList then
    for id, member in pairs(info.memberList) do
      firstMember = member
      break
    end
  end
  local isCreate = alBuildSquadData.isCreate
  local now = UITimeManager:GetInstance():GetServerTime()
  if now < alBuildSquadData.fadeTime then
    if firstMember then
      self:CreateAlBuildSquad(firstMember, alBuildUUid, alBuildSquadData)
      if alBuildSquadData.buildAnimation then
        if isCreate then
          alBuildSquadData.buildAnimation:Play("born")
        end
        alBuildSquadData.buildAnimation:PlayQueued("attack")
      end
    elseif alBuildSquadData.buildAnimation then
      if isCreate then
        alBuildSquadData.buildAnimation:Play("born")
      end
      alBuildSquadData.buildAnimation:PlayQueued("idle")
    end
  elseif firstMember then
    if alBuildSquadData.buildAnimation then
      if isCreate then
        alBuildSquadData.buildAnimation:Play("born")
      end
      alBuildSquadData.buildAnimation:PlayQueued("attack_skill")
      alBuildSquadData.buildAnimation:PlayQueued("attack_idle")
    end
  elseif alBuildSquadData.buildAnimation then
    if isCreate then
      alBuildSquadData.buildAnimation:Play("born")
    end
    alBuildSquadData.buildAnimation:PlayQueued("idle")
  end
end

function WorldFakeBattleManager:CreateAlBuildSquad(firstMember, alBuildUUid, alBuildSquadData)
  local heroDatas = firstMember.armyInfos.heros
  local allHeroes = {}
  local leaderIdx
  for i = 1, #heroDatas do
    local heroData = heroDatas[i]
    local heroId = heroData.heroId
    local heroInfo = {}
    heroInfo.heroId = heroId
    heroInfo.quality = heroData.heroQuality
    heroInfo.meta = DataCenter.HeroTemplateManager:GetTemplate(heroId)
    heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(heroInfo.meta.appearance)
    local weaponLevel = heroData.weaponLevel or 0
    if 0 < weaponLevel then
      local uniqueWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(heroId, weaponLevel)
      if uniqueWeaponTemplate then
        heroInfo.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(uniqueWeaponTemplate.modelId)
      end
    end
    allHeroes[i] = heroInfo
    if leaderIdx == nil or allHeroes[leaderIdx].quality < heroInfo.quality then
      leaderIdx = i
    end
  end
  if leaderIdx ~= nil then
    allHeroes[leaderIdx].isLeader = true
  end
  local formation = require("Scene.LWWorldMarch.AlAssistFormation")
  local alBuildAssistSquad = ObjectPool:GetInstance():Load(AlBuildAssistSquad)
  local objId = self:GetNextObjId()
  alBuildAssistSquad:Init(self, objId, alBuildUUid, allHeroes, formation, alBuildSquadData.squadParent or alBuildSquadData.parent, 0.5, DisplaySettings.Levels.High)
  alBuildAssistSquad:OnCreate()
  alBuildSquadData.squardEntity = alBuildAssistSquad
  self:PlayAnim(alBuildUUid, "idle", false)
end

function WorldFakeBattleManager:RemoveAllianceBuildSquadByPoint(pointId)
  local pointInfo = GetPointInfo(pointId)
  if not pointInfo then
    return
  end
  self:RemoveAllianceBuildSquadByUUID(pointInfo.uuid)
end

function WorldFakeBattleManager:RemoveAllianceBuildSquadByUUID(uuid)
  local alBuildSquadData = self.alBuildSquadDatas[uuid]
  if not alBuildSquadData then
    return
  end
  alBuildSquadData.pointInfo = nil
  alBuildSquadData.parent = nil
  alBuildSquadData.buildAnimation = nil
  alBuildSquadData.isCreate = nil
  alBuildSquadData.squadParent = nil
  local zombieInsts = alBuildSquadData.targetZombieInst
  if zombieInsts then
    for id, zombieInst in pairs(zombieInsts) do
      Zombie.Return(zombieInst)
    end
  end
  alBuildSquadData.targetZombieInst = nil
  alBuildSquadData.targetZombieAmount = 0
  if alBuildSquadData.DelayToPlayIdle then
    alBuildSquadData.DelayToPlayIdle:Stop()
  end
  alBuildSquadData.DelayToPlayIdle = nil
  local alBuildSquadEntity = alBuildSquadData.squardEntity
  if alBuildSquadEntity then
    alBuildSquadEntity:Delete()
    ObjectPool:GetInstance():Save(alBuildSquadEntity)
  end
  alBuildSquadData.squardEntity = nil
  self.alBuildSquadDatas[uuid] = nil
end

function WorldFakeBattleManager:AddUnit(unit)
  if self.unitMgr then
    self.unitMgr:AddUnit(unit)
  end
end

function WorldFakeBattleManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function WorldFakeBattleManager:RemoveUnitTotal(unit)
  self.unitMgr:RemoveUnitTotal(unit)
end

function WorldFakeBattleManager:ShowEffectObj(path, pos, rot, time, parent, type)
  if self.effectObjMgr then
    return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
  end
end

function WorldFakeBattleManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function WorldFakeBattleManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function WorldFakeBattleManager:PlayAnim(uuid, anim, rewind)
  if not self.isInWorld then
    return
  end
  local squadEntity = self.alBuildSquadDatas[uuid] and self.alBuildSquadDatas[uuid].squardEntity
  if squadEntity then
    squadEntity:PlayAnim(anim, rewind)
  end
  if anim ~= "attack" then
    if self.effectObjMgr then
      self.effectObjMgr:ResetData()
    end
    if self.bulletManager then
      self.bulletManager:ResetData()
    end
  end
end

function WorldFakeBattleManager:SetRotation(uuid, quat)
  if not self.isInWorld then
    return
  end
  local squadEntity = self.alBuildSquadDatas[uuid] and self.alBuildSquadDatas[uuid].squardEntity
  if squadEntity then
    squadEntity:SetRotation(quat)
  end
end

function WorldFakeBattleManager:Attack(uuid)
  if not self.isInWorld then
    return
  end
  local squadEntity = self.alBuildSquadDatas[uuid] and self.alBuildSquadDatas[uuid].squardEntity
  if not squadEntity then
    return
  end
  if squadEntity and DisplaySettings.PlayBattleSkills(squadEntity.displayLevel) then
    local targetZombieInst = self.alBuildSquadDatas[uuid].targetZombieInst
    if targetZombieInst then
      local attackPostion
      for id, targetZombie in pairs(targetZombieInst) do
        attackPostion = targetZombie.pos
        targetZombie:OnHurt()
      end
      squadEntity:Attack(attackPostion)
    end
  end
end

function WorldFakeBattleManager:ShakeCameraWithParam()
end

function WorldFakeBattleManager:DealDamage()
end

function WorldFakeBattleManager:GetPVEType()
  return PVEType.World
end

function WorldFakeBattleManager:UpdateDisplayMode()
  for _, v in pairs(self.alBuildSquadDatas) do
    local alBuildSquadEntity = v.squardEntity
    if alBuildSquadEntity then
      alBuildSquadEntity:UpdateDisplayMode()
    end
    local targetZombieInsts = v.targetZombieInst
    if targetZombieInsts then
      for id, zombieInst in pairs(targetZombieInsts) do
        zombieInst:UpdateDisplayMode()
      end
    end
  end
end

function WorldFakeBattleManager:SpawnAlBuildZombie(buuid)
  local alBuildSquadData = self.alBuildSquadDatas[buuid]
  if not alBuildSquadData then
    return
  end
  local squadEntity = alBuildSquadData.squardEntity
  if not squadEntity or not DisplaySettings.PlayBattleSkills(squadEntity.displayLevel) then
    return
  end
  if not alBuildSquadData.targetZombieInst then
    alBuildSquadData.targetZombieInst = {}
    alBuildSquadData.targetZombieAmount = 0
  end
  if alBuildSquadData.targetZombieAmount >= 10 then
    return
  end
  local alBuildPosition = alBuildSquadData.parent.transform.position
  local alBuildForward = alBuildSquadData.parent.transform.forward
  local endPos = alBuildPosition + alBuildForward * 0.5
  local startPos = alBuildPosition + alBuildForward * 10
  local horzionDir = Vector3.Cross(alBuildForward, Vector3.up)
  local degree = math.random(-2, 2)
  startPos = startPos + degree * horzionDir
  local zombieInst = Zombie.Create(startPos, endPos, buuid)
  alBuildSquadData.targetZombieInst[zombieInst.id] = zombieInst
  alBuildSquadData.targetZombieAmount = alBuildSquadData.targetZombieAmount + 1
end

function WorldFakeBattleManager:DestroyZombie(zombieId, buuid)
  local alBuildSquadData = self.alBuildSquadDatas[buuid]
  if not alBuildSquadData then
    return
  end
  local targetZombieInst = alBuildSquadData.targetZombieInst
  if not targetZombieInst then
    return
  end
  local zombieInst = targetZombieInst[zombieId]
  targetZombieInst[zombieId] = nil
  alBuildSquadData.targetZombieAmount = alBuildSquadData.targetZombieAmount - 1
  Zombie.Return(zombieInst)
end

return WorldFakeBattleManager
