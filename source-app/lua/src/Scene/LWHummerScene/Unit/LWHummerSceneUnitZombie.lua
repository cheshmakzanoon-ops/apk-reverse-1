local base = require("Scene.LWHummerScene.Unit.LWHummerSceneUnitBase")
local LWHummerSceneUnitZombie = BaseClass("LWHummerSceneUnitZombie", base)
local FSMachine = require("Common.FSMachine")
local LWBattleRVOAgent = CS.LWBattleRVOAgent
LWHummerSceneUnitZombie.State = {
  None = 0,
  Born = 1,
  Run = 2,
  Fly = 3,
  Die = 4
}

function LWHummerSceneUnitZombie:OnDestroy()
  base.OnDestroy(self)
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.agent = nil
  self.cfgId = nil
  self.cfg = nil
end

function LWHummerSceneUnitZombie:__init(param)
  self.layerMask = LayerMask.GetMask(LayerType.Member)
  self.curState = self.State.None
  self.fsm = FSMachine.Create(self)
  self.fsm:Add(self.State.Born, require("Scene.LWHummerScene.State.Zombie.LWHummerSceneZombieBorn").Create())
  self.fsm:Add(self.State.Run, require("Scene.LWHummerScene.State.Zombie.LWHummerSceneZombieRun").Create())
  self.fsm:Add(self.State.Fly, require("Scene.LWHummerScene.State.Zombie.LWHummerSceneZombieFly").Create())
  self.fsm:Add(self.State.Die, require("Scene.LWHummerScene.State.Zombie.LWHummerSceneZombieDie").Create())
end

function LWHummerSceneUnitZombie:OnInited()
  base.OnInited(self)
  self.cfgId = self.bornData.cfgId
  self.cfg = DataCenter.PveMonsterTemplateManager:GetTemplate(self.cfgId)
  self.effectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.cfg.monster_effect)
  if self.transform then
    self.sid = self.logic.rvoMgr:AddAgent(self:GetPosition(), self.gameObject, 5, 2)
    self.agent = self.transform:GetComponent(typeof(LWBattleRVOAgent))
    if self.agent then
      self.agent.speed = 0
      self.agent:SetActive(false)
    end
  end
  self.showRewardDrop = true
  self:ChangeState(self.State.Born)
end

function LWHummerSceneUnitZombie:ChangeState(targetState, param)
  if self.curState == targetState then
    return
  end
  self.fsm:Switch(targetState, param)
  self.curState = targetState
end

function LWHummerSceneUnitZombie:OnUpdate(dt)
  base.OnUpdate(self, dt)
  if self.isLoaded and self.curPos.z < self.logic:GetFollowCameraTarget().z then
    self.logic:RemoveUnit(self)
    return
  end
  if self.fsm then
    self.fsm:Update(dt)
  end
end

function LWHummerSceneUnitZombie:SetDestination(x, z)
  if self.agent then
    return self.agent:SetTargetPosition(x, z)
  end
end

function LWHummerSceneUnitZombie:RemoveDestination()
  if self.agent then
    return self.agent:SetActive(false)
  end
end

function LWHummerSceneUnitZombie:GetTargetPos()
  local targetPos = self:GetPosition()
  if self.logic and self.logic.player then
    targetPos = self.logic.player:GetPosition()
  end
  return targetPos
end

function LWHummerSceneUnitZombie:OnCollisionPlayer(other, trigger)
  if trigger and self.curState == self.State.Run then
    local unitType = self.logic:GetUnitType(trigger.ObjectId)
    if unitType == HummerSceneUnitType.Player then
      self.colliderComponent.active = false
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.zombie_hit, false)
      self:ChangeState(self.State.Fly)
    end
  end
end

function LWHummerSceneUnitZombie:Recycle()
  base.Recycle(self)
  if self.fsm then
    self.fsm:Reset()
  end
end

function LWHummerSceneUnitZombie:OnBulletHit(hit_effect, hitPoint, hitDir)
  if hit_effect then
    local localPos = self.transform:InverseTransformPoint(hitPoint)
    self:PlayReplayableEffect(hit_effect, localPos, nil, nil, self.transform)
  end
  self:ChangeState(self.State.Die)
end

function LWHummerSceneUnitZombie:OnChangeBattle()
  self.showRewardDrop = false
  self:ChangeState(self.State.Die)
end

return LWHummerSceneUnitZombie
