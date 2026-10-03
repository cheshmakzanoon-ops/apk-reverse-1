local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local Member = require("Scene.LWHummerScene.Battle.LWHummerSceneBattleMember")
local Zombie = require("Scene.LWHummerScene.Battle.LWHummerSceneBattleZombie")
local UnitManager = require("Scene.LWBattle.BarrageBattle.Unit.UnitManager")
local BulletManager = require("Scene.LWBattle.Bullet.BulletManager")
local HummerConstant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local LWHummerSceneBattleManager = BaseClass("LWHummerSceneBattleManager")
LWHummerSceneBattleManager.State = {
  None = 1,
  AfterEnter = 2,
  Battle = 3,
  BeforExit = 4,
  Exit = 5
}

function LWHummerSceneBattleManager:__init()
  self.nextObjId = 1
  self.sceneObjs = {}
  self.buff = {}
  self.unitMgr = UnitManager.New(self)
  self.bulletManager = BulletManager.New(self)
  self.curState = self.State.None
end

function LWHummerSceneBattleManager:__delete()
  self:Destroy()
end

function LWHummerSceneBattleManager:Destroy()
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
  if self.unitMgr then
    self.unitMgr:Destroy()
    self.unitMgr = nil
  end
  self.sceneObjs = nil
  self.buff = nil
  self.param = nil
  self.logic = nil
  self.monsterSpacing = nil
  self.monsterSpawnPoints = nil
  self.monsterTimeInterval = nil
end

function LWHummerSceneBattleManager:OnUpdate(dt)
  self.unitMgr:OnUpdate()
  self.bulletManager:OnUpdate()
  if table.count(self.unitMgr:GetAllZombie()) == 0 then
    self:SetGameOver(true)
  end
  self.gameOverTime = self.gameOverTime - dt
  if 0 >= self.gameOverTime then
    local idStr = ""
    for i, v in ipairs(self.param.heroList) do
      idStr = idStr .. v.heroId
    end
    Logger.LogError("LWHummerSceneBattle OverTime :" .. idStr)
    self:SetGameOver(true)
  end
end

function LWHummerSceneBattleManager:Enter(param)
  self.buff = {}
  self.param = param
  self.logic = param.logic
  self.monsterCfg = param.monsterCfg
  self.monsterSpacing = param.monsterCfg.monsterSpace
  self.monsterSpawnPoints = param.monsterCfg.monsterSpawnPoints
  self.monsterTimeInterval = param.monsterCfg.monsterTimeInterval
  self.playerPos = self.logic.player:GetPosition()
  self.curState = self.State.None
  self.gameOverTime = param.monsterCfg.battleOverTime
  self:SetGameOver(false)
  self:CreateLevel(param)
end

function LWHummerSceneBattleManager:Exit()
  self:OnExit()
  self:Destroy()
end

function LWHummerSceneBattleManager:CreateLevel(param)
  self.nextObjId = 1
  self.sceneObjs = {}
end

function LWHummerSceneBattleManager:CreateHero(hero, trans)
  local modelPath, appearanceId, modelSourceType = hero:GetHeroModelData(HeroModelType.Battle)
  if string.IsNullOrEmpty(modelPath) or appearanceId == nil then
    return
  end
  local path = modelPath
  local objId = self:GetNextObjId()
  local req = Resource:InstantiateAsync(path)
  local member = ObjectPool:GetInstance():Load(Member)
  member:Init(self, objId, req, 1, hero)
  member.curWorldPos = trans.position
  self:AddUnit(member)
  req:completed("+", function(request)
    if not self.logic or not self.logic.inLogic then
      request:Destroy()
      return
    end
    member:OnCreate()
    request.gameObject.transform.parent = trans
    request.gameObject.transform.localPosition = Vector3.zero
  end)
end

function LWHummerSceneBattleManager:CreateTestZombie()
  if self.param == nil then
    return
  end
  self.unitMgr:RemoveAllUnitByType(UnitType.Zombie)
  local pos1 = self.monsterSpawnPoints[1]
  local pos2 = self.monsterSpawnPoints[2]
  for i = 1, pos2[2] - pos1[2] do
    for j = 1, pos2[1] - pos1[1] do
      local random = math.random()
      local realX = pos1[1] + (j - 1) * self.monsterSpacing + self.playerPos.x + random
      local realZ = pos1[2] + (i - 1) * self.monsterSpacing + self.playerPos.z + random
      local delayTime = random + self.monsterTimeInterval * (i - 1)
      self:CreateMonster(self.monsterCfg:GetRandomZombieId(), Vector3.New(realX, 0, realZ), delayTime)
    end
  end
end

function LWHummerSceneBattleManager:CreateMonster(metaId, pos, delayTime)
  local meta = DataCenter.PveMonsterTemplateManager:GetTemplate(metaId)
  local objId = Const.ZombieIdMin + self:GetNextObjId()
  if objId > Const.ZombieIdMax then
    Logger.LogError("objId > Const.ZombieIdMax")
  end
  local zombie = ObjectPool:GetInstance():Load(Zombie)
  zombie:Init(self, objId, meta)
  zombie:Create(pos, self.logic.player:GetPosition(), delayTime)
  self:AddUnit(zombie)
end

function LWHummerSceneBattleManager:OnAfterEnter()
  self.curState = self.State.AfterEnter
  local transList = self.logic:GetEnterTransList()
  self.unitMgr:RemoveAllUnitByType(UnitType.Member)
  self.unitMgr:RemoveAllUnitByType(UnitType.Pet)
  for i, v in ipairs(self.param.heroList) do
    self:CreateHero(v, transList[i])
  end
  self:CreateTestZombie()
end

function LWHummerSceneBattleManager:OnBattle()
  self.curState = self.State.Battle
  for i, v in ipairs(self.unitMgr:GetAllMember()) do
    v:HandleInput(MemberCommand.AutoAttack)
  end
end

function LWHummerSceneBattleManager:OnBeforExit()
  self.curState = self.State.BeforExit
  for i, v in ipairs(self.unitMgr:GetAllMember()) do
    v:OnBeforExit()
  end
  if self.bulletManager then
    self.bulletManager:Delete()
    self.bulletManager = nil
  end
end

function LWHummerSceneBattleManager:OnExit()
  self.curState = self.State.Exit
end

function LWHummerSceneBattleManager:AddUnit(unit)
  self.unitMgr:AddUnit(unit)
end

function LWHummerSceneBattleManager:GetUnit(id)
  return self.unitMgr:GetUnit(id)
end

function LWHummerSceneBattleManager:RemoveUnit(unit)
  self.unitMgr:RemoveUnit(unit)
end

function LWHummerSceneBattleManager:ShowEffectObj(path, pos, rot, time, parent, type)
  return self.logic:ShowEffectObj(path, pos, rot, time, parent, type)
end

function LWHummerSceneBattleManager:RemoveEffectObj(id)
  self.logic:RemoveEffectObj(id)
end

function LWHummerSceneBattleManager:GetObj(id)
  return self.sceneObjs[id]
end

function LWHummerSceneBattleManager:AddObj(id, obj)
  self.sceneObjs[id] = obj
end

function LWHummerSceneBattleManager:RemoveObj(id)
  self.sceneObjs[id] = nil
end

function LWHummerSceneBattleManager:IsBeRemove(id)
  return false
end

function LWHummerSceneBattleManager:IsCarryType(resType)
  return false
end

function LWHummerSceneBattleManager:IsResourceType(resType)
  return false
end

function LWHummerSceneBattleManager:CanShowBlood()
  return false
end

function LWHummerSceneBattleManager:RemoveOneArrowById()
end

function LWHummerSceneBattleManager:RefreshCameraRotation()
end

function LWHummerSceneBattleManager:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function LWHummerSceneBattleManager:IsSkillLevel()
  return false
end

function LWHummerSceneBattleManager:ShakeCameraWithParam(param)
end

function LWHummerSceneBattleManager:IsPlayingShakeCamera()
  return self.cameraTween ~= nil
end

function LWHummerSceneBattleManager:GetFollowCameraTarget()
  return self.followCameraTarget
end

function LWHummerSceneBattleManager:InitCameraPos()
end

function LWHummerSceneBattleManager:Lookat(lookWorldPosition)
end

function LWHummerSceneBattleManager:CameraFollowLookat(targetPos)
end

function LWHummerSceneBattleManager:GetNextObjId()
  local nextObjId = self.nextObjId
  self.nextObjId = nextObjId + 1
  return nextObjId
end

function LWHummerSceneBattleManager:GetBuffEffectValueByType(buffType)
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

function LWHummerSceneBattleManager:GetSpeedMulti()
  return self.speedMulti or 1
end

function LWHummerSceneBattleManager:SetSpeedMulti(speedMulti)
  self.speedMulti = speedMulti
end

function LWHummerSceneBattleManager:OnMonsterDeath(monster)
end

function LWHummerSceneBattleManager:OnBattleReset(squadIndex, supply, heroes)
end

function LWHummerSceneBattleManager:SetGameOver(v)
  self.gameOver = v
end

function LWHummerSceneBattleManager:SetGamePause(v)
  self.gamePause = v
end

function LWHummerSceneBattleManager:DealDamage(params)
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

function LWHummerSceneBattleManager:ShowDamageText(damage, position, style)
end

function LWHummerSceneBattleManager:GetHpBarCellPos(modelPos)
  if self.rtRect == nil or IsNull(self.hpBarParent) then
    return Vector3.zero
  end
  local newPos = PosConverse.WorldToScreenPos(modelPos, self.camera)
  newPos.x = newPos.x
  newPos.y = newPos.y
  return newPos
end

function LWHummerSceneBattleManager:GetHpBarCellType()
end

function LWHummerSceneBattleManager:GetMultHpBarCellType()
end

function LWHummerSceneBattleManager:SetHpBarParent(obj)
  self.hpBarParent = obj
end

function LWHummerSceneBattleManager:UnSetHpBarParent()
  self.hpBarParent = nil
end

function LWHummerSceneBattleManager:GetHpBarParent()
  return self.hpBarParent
end

function LWHummerSceneBattleManager:GetPVEType()
  return PVEType.Preview
end

return LWHummerSceneBattleManager
