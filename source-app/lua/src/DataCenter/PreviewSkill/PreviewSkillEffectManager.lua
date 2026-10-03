local Resource = CS.GameEntry.Resource
local PVEScenePath = "Assets/Main/Prefabs/PVELevel/%s/scene.prefab"
local Const = require("Scene.LWBattle.Const")
local Member = require("Scene.PreviewSkillScene.Unit.PreviewSkillMember")
local TouchWrapper = CS.BitBenderGames.TouchWrapper
local EventSystem = CS.UnityEngine.EventSystems.EventSystem
local Zombie = require("Scene.PreviewSkillScene.Unit.PreviewSkillZombie")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local EffectObjManager = require("Scene.LWBattle.EffectObj.EffectObjManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local GameQualitySettings = require("Util.GameQualitySettings")
local SkillPreviewScene = "LastWar_Scene_Skill_Preview"
local HPBarCell = require("DataCenter.PreviewSkill.HpBar.PreviewSkillHpBarCell")
local MultHpBarCell = require("DataCenter.PreviewSkill.HpBar.PreviewSkillMultHpBarCell")
local Time = _ENV.Time
local sceneOffset = 4000
local heroPositionOffset = Vector3(-2, 0, 0)
local teamMemberPositionOffset = Vector3(2, 0, 0)
local PreviewSkillEffectManager = BaseClass("PreviewSkillEffectManager")
local LevelState = {
  Init = 0,
  RequestInfo = 1,
  Created = 2,
  Destroying = 3,
  Destroyed = 4
}
PreviewSkillEffectManager.CameraType = {Normal = 0, Long = 1}

local function GetOffsetZ(height, rotation)
  return height / math.tan(rotation * math.pi / 180)
end

function PreviewSkillEffectManager:__init()
  self.nextObjId = 1
  self.sceneObjs = {}
  self.levelState = LevelState.Init
  
  function self.cameraAfterUpdate()
    self:ClampCamera()
  end
  
  self.followCameraTarget = Vector3.zero
  self.wayPoint = {}
  self.nextWayPoint = nil
  self.nextWayPointOrder = 0
  self.squad = nil
  self.buff = {}
  self.squadCreateFinish = nil
  self.unitMgr = UnitManager.New(self)
  self.effectObjMgr = EffectObjManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.containerReq = nil
  self.sceneLoadRequest = nil
  self.rtRect = nil
  self.roundTimer = nil
  self.virtualCamera01 = nil
  self.virtualCamera02 = nil
  self.round = 0
end

function PreviewSkillEffectManager:__delete()
  self:Destroy()
end

function PreviewSkillEffectManager:Destroy(exceptScene)
  self:RemoveUpdateTimer()
  self:StopRoundTimer()
  self:UnInitCamera()
  if self.bulletManager then
    self.bulletManager:Delete()
  end
  if self.squad then
    self.squad:Delete()
    self.squad = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
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
  if self.rvoMgr then
    self.rvoMgr:Destory()
    self.rvoMgr = nil
  end
  if self.sceneLoadRequest then
    self.sceneLoadRequest:Destroy()
  end
  self.sceneLoadRequest = nil
  self.sceneObjs = nil
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
  self.param = nil
  self.monsterRectWidth = nil
  self.monsterRectHeight = nil
  self.monsterSpacing = nil
  self.monsterRectPosition = nil
  self.scene = nil
  self.round = nil
end

function PreviewSkillEffectManager:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function PreviewSkillEffectManager:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function PreviewSkillEffectManager:OnUpdate()
  if self.squad then
    self.squad:OnUpdate()
  end
  self.unitMgr:OnUpdate()
  self.effectObjMgr:OnUpdate()
  self.bulletManager:OnUpdate()
  self:TickGenZombieTask()
end

function PreviewSkillEffectManager:Enter(param)
  self.buff = {}
  self.nextObjId = 1
  self.round = 0
  self.squadCreateFinish = false
  self.param = param
  local monsterRect = param.monster_Rect
  local width = monsterRect[1] or 3
  local height = monsterRect[2] or 3
  self.monsterSpacing = monsterRect[3] or 1
  self.monsterRectWidth = (width - 1) / 2
  self.monsterRectWidth = math.floor(self.monsterRectWidth)
  self.monsterRectHeight = (height - 1) / 2
  self.monsterRectHeight = math.floor(self.monsterRectHeight)
  self.monsterRectPosition = Vector2.New()
  self.monsterRectPosition.x = param.monster_CenterPoint[1]
  self.monsterRectPosition.z = param.monster_CenterPoint[2]
  self:CreateLevel(param)
end

function PreviewSkillEffectManager:Exit(ExitAction, exitType)
  self:Destroy()
end

function PreviewSkillEffectManager:OnLoadedScene()
  self:InitCamera()
  self:InitGame()
  self:AddUpdateTimer()
end

function PreviewSkillEffectManager:LoadScene()
  self.sceneLoadRequest = nil
  local timeStep = 0.033
  local neighborDist = 2
  local maxNeighbors = 8
  local timeHorizon = 1
  local timeHorizonObst = 1
  local radius = 1
  local maxSpeed = 20
  self.finishedScene = 0
  self.onLoadCompleteEvent = {}
  local req = Resource:InstantiateAsync(string.format(PVEScenePath, SkillPreviewScene))
  req:completed("+", function()
    local sceneRoot = req.gameObject.transform
    sceneRoot:Set_localPosition(sceneOffset, 0, sceneOffset)
    self.finishedScene = self.finishedScene + 1
    self.scene = req.gameObject
    self:OnLoadedScene()
  end)
  self.sceneLoadRequest = req
end

function PreviewSkillEffectManager:CreateTestZombie(isMonsterShowBorn)
  if self.param == nil then
    return
  end
  self.unitMgr:RemoveAllUnitByType(UnitType.Zombie)
  for i = -self.monsterRectWidth, self.monsterRectWidth do
    for j = -self.monsterRectHeight, self.monsterRectHeight do
      local realX = self.monsterRectPosition.x + i * self.monsterSpacing
      local realZ = self.monsterRectPosition.z + j * self.monsterSpacing
      local delayTime = 0
      if isMonsterShowBorn then
        local randomTime = math.random()
        delayTime = randomTime * 2
      end
      self:CreateMonster(self.param.monsterId, Vector3.New(realX, 0, realZ), delayTime, isMonsterShowBorn)
    end
  end
end

function PreviewSkillEffectManager:CreateLevel(param)
  self.nextObjId = 1
  self.spawnPos = nil
  self.sceneObjs = {}
  self.wayPoint = {}
  self.genZombieTask = nil
  self.killNum = 0
  self.killTargetNum = 0
  self.killBossNum = 0
  self.startTime = Time.time
  self.useTime = 0
  self.gameOver = false
  self.gamePause = false
  self:LoadScene()
  self.levelState = LevelState.Created
end

function PreviewSkillEffectManager:InitCamera()
  self.cameraTween = nil
  self.camera = self.scene.transform:Find("Camera"):GetComponent(typeof(CS.UnityEngine.Camera))
  self.virtualCamera01 = self.scene.transform:Find("VirtualCamera01").gameObject
  self.virtualCamera02 = self.scene.transform:Find("VirtualCamera02").gameObject
  self.virtualCamera01:SetActive(self.param.cameraType ~= self.CameraType.Long)
  self.virtualCamera02:SetActive(self.param.cameraType == self.CameraType.Long)
  GameQualitySettings.TogglePostProcess(true)
end

function PreviewSkillEffectManager:UnInitCamera()
  self.cameraTween = nil
  if self.camera then
    self.camera.targetTexture = nil
    self.camera = nil
  end
  self.virtualCamera01 = nil
  self.virtualCamera02 = nil
end

function PreviewSkillEffectManager:ClampCamera()
end

local DEFAULT_TANK_PREFAB_ASSET_PATH = "Assets/_Art_LastWar/Models/Cars/tanke/prefab/tank.prefab"

function PreviewSkillEffectManager:CreateHero()
  if self.param.hero == nil then
    Logger.LogError("hero is nil")
    return
  end
  self.unitMgr:RemoveAllUnitByType(UnitType.Member)
  self.unitMgr:RemoveAllUnitByType(UnitType.Pet)
  
  local function CreateHero(heroData, position)
    local path
    if heroData then
      local modelPath, appearanceId, modelSourceType = heroData:GetHeroModelData(HeroModelType.Battle)
      if string.IsNullOrEmpty(modelPath) or appearanceId == nil then
        path = DEFAULT_TANK_PREFAB_ASSET_PATH
      else
        path = modelPath
      end
    else
      path = DEFAULT_TANK_PREFAB_ASSET_PATH
    end
    local objId = self:GetNextObjId()
    local req = Resource:InstantiateAsync(path)
    local member = ObjectPool:GetInstance():Load(Member)
    member:Init(self, objId, req, 1, heroData)
    member.curWorldPos = position
    self:AddUnit(member)
    req:completed("+", function(request)
      if request.isError then
        return
      end
      member:OnCreate()
      request.gameObject.transform.position = position
      self:Lookat(position)
    end)
  end
  
  local hasMember = self.param.teamMemberHero ~= nil
  if hasMember then
    CreateHero(self.param.hero, self.centerPointPos + heroPositionOffset)
    CreateHero(self.param.teamMemberHero, self.centerPointPos + teamMemberPositionOffset)
  else
    CreateHero(self.param.hero, self.centerPointPos)
  end
end

function PreviewSkillEffectManager:InitParam()
  local pos = Vector3.New()
  pos.x = sceneOffset
  pos.y = 0
  pos.z = sceneOffset
  self.centerPointPos = pos
  self.monsterRectPosition.x = self.monsterRectPosition.x + self.centerPointPos.x
  self.monsterRectPosition.y = self.centerPointPos.y
  self.monsterRectPosition.z = self.monsterRectPosition.z + self.centerPointPos.z
end

function PreviewSkillEffectManager:InitGame()
  self:InitParam()
  self:StarRound()
  EventManager:GetInstance():Broadcast(EventId.PreviewSkillSceneInit)
end

function PreviewSkillEffectManager:OnSquadCreateFinish()
  self.squadCreateFinish = true
  EventManager:GetInstance():Broadcast(EventId.OnBattleSquadCreateFinish)
end

function PreviewSkillEffectManager:IsFingerOnUI()
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

function PreviewSkillEffectManager:CloseUIWindows()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldTileUI)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint)
end

function PreviewSkillEffectManager:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function PreviewSkillEffectManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function PreviewSkillEffectManager:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function PreviewSkillEffectManager:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.effectObjMgr:ShowEffectObj(path, pos, rot, time, parent, type)
end

function PreviewSkillEffectManager:RemoveEffectObj(id)
  self.effectObjMgr:RemoveEffectObj(id)
end

function PreviewSkillEffectManager:GetObj(id)
  return self.sceneObjs[id]
end

function PreviewSkillEffectManager:AddObj(id, obj)
  self.sceneObjs[id] = obj
end

function PreviewSkillEffectManager:RemoveObj(id)
  self.sceneObjs[id] = nil
end

function PreviewSkillEffectManager:IsBeRemove(id)
  return false
end

function PreviewSkillEffectManager:IsCarryType(resType)
  return false
end

function PreviewSkillEffectManager:IsResourceType(resType)
  return false
end

function PreviewSkillEffectManager:CanShowBlood()
  return false
end

function PreviewSkillEffectManager:RemoveOneArrowById()
end

function PreviewSkillEffectManager:RefreshCameraRotation()
end

function PreviewSkillEffectManager:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function PreviewSkillEffectManager:IsSkillLevel()
  return false
end

local defaultShakeDur = 0.5
local defaultShakeStrength = Vector3.New(0.5, 0.5, 0)
local defaultShakeVibrato = 30
local cameraOffset = Vector3.New(0, 0, 4)

function PreviewSkillEffectManager:ShakeCameraWithParam(param)
end

function PreviewSkillEffectManager:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function PreviewSkillEffectManager:GetFollowCameraTarget()
  return self.followCameraTarget
end

function PreviewSkillEffectManager:InitCameraPos()
end

function PreviewSkillEffectManager:Lookat(lookWorldPosition)
end

function PreviewSkillEffectManager:CameraFollowLookat(targetPos)
end

function PreviewSkillEffectManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function PreviewSkillEffectManager:GetBuffEffectValueByType(buffType)
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

function PreviewSkillEffectManager:GetSpeedMulti()
  return self.speedMulti or 1
end

function PreviewSkillEffectManager:SetSpeedMulti(speedMulti)
  self.speedMulti = speedMulti
end

function PreviewSkillEffectManager:AddGenZombieTask(task)
  if self.genZombieTask == nil then
    self.genZombieTask = {}
  end
  self.genZombieTask[task.id] = task
end

function PreviewSkillEffectManager:RemoveGenZombieTask(task)
  if self.genZombieTask == nil then
    return
  end
  self.genZombieTask[task.id] = nil
end

function PreviewSkillEffectManager:TickGenZombieTask()
  if self.genZombieTask == nil or table.count(self.genZombieTask) == 0 then
    return
  end
  for k, v in pairs(self.genZombieTask) do
    v:Update()
  end
end

function PreviewSkillEffectManager:CreateMonster(metaId, pos, delayTime, isMonsterShowBorn)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(metaId)
  local objId = Const.ZombieIdMin + self:GetNextObjId()
  if objId > Const.ZombieIdMax then
    Logger.LogError("objId > Const.ZombieIdMax")
  end
  local zombie = ObjectPool:GetInstance():Load(Zombie)
  zombie:Init(self, objId, meta)
  zombie:Create(pos, self.centerPointPos, delayTime, isMonsterShowBorn)
  self:AddUnit(zombie)
end

function PreviewSkillEffectManager:OnMonsterDeath(monster)
end

function PreviewSkillEffectManager:OnBattleReset(squadIndex, supply, heroes)
end

function PreviewSkillEffectManager:SetGameOver(v)
  self.gameOver = v
end

function PreviewSkillEffectManager:SetGamePause(v)
  self.gamePause = v
end

function PreviewSkillEffectManager:DealDamage(params)
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
  local hurt, isCritical, isMiss, nakedDmg = PveUtil.CalculateDamage(attacker, defender, bulletMeta.damage_type, damageMultiplier, isCritical)
  if hurt <= 0 then
    return
  end
  defender:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  defender:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill)
end

function PreviewSkillEffectManager:StartRoundTimer()
  if self.param == nil then
    return
  end
  self.roundTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:FinishRound()
    self:StarRound()
  end, self.param.duration)
end

function PreviewSkillEffectManager:StopRoundTimer()
  if self.roundTimer then
    self.roundTimer:Stop()
    self.roundTimer = nil
  end
end

function PreviewSkillEffectManager:StarRound()
  if self.param == nil then
    return
  end
  self.round = self.round + 1
  local isShowMonsterBorn = self.param.isMonsterIdleAtStart == nil or self.param.isMonsterIdleAtStart == false or self.round > 1
  self:CreateHero()
  self:CreateTestZombie(isShowMonsterBorn)
  self:AddUpdateTimer()
  self:StopRoundTimer()
  self:StartRoundTimer()
end

function PreviewSkillEffectManager:FinishRound()
  if self.unitMgr then
    self.unitMgr:Delete()
  end
  if self.effectObjMgr then
    self.effectObjMgr:Delete()
  end
  if self.bulletManager then
    self.bulletManager:Delete()
  end
  self:RemoveUpdateTimer()
end

function PreviewSkillEffectManager:ShowDamageText(damage, position, style)
end

function PreviewSkillEffectManager:GetHpBarCellPos(modelPos)
  if self.rtRect == nil or IsNull(self.hpBarParent) then
    return Vector3.zero
  end
  local newPos = PosConverse.WorldToScreenPos(modelPos, self.camera)
  newPos.x = newPos.x
  newPos.y = newPos.y
  return newPos
end

function PreviewSkillEffectManager:GetHpBarCellType()
  return HPBarCell
end

function PreviewSkillEffectManager:GetMultHpBarCellType()
  return MultHpBarCell
end

function PreviewSkillEffectManager:SetHpBarParent(obj)
  self.hpBarParent = obj
end

function PreviewSkillEffectManager:UnSetHpBarParent()
  self.hpBarParent = nil
end

function PreviewSkillEffectManager:GetHpBarParent()
  return self.hpBarParent
end

function PreviewSkillEffectManager:GetPVEType()
  return PVEType.Preview
end

return PreviewSkillEffectManager
