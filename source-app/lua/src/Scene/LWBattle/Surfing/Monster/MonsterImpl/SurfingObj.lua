local base = require("Scene.LWBattle.Surfing.Monster.MonsterImpl.SurfingBaseObj")
local SurfingObj = BaseClass("SurfingObj", base)
local BattleColliderUtils = CS.BattleColliderUtils
local SurfingObjectMoveState = require("Scene.LWBattle.Surfing.Monster.MonsterState.SurfingObjectMoveState")
local SurfingObjectIdleState = require("Scene.LWBattle.Surfing.Monster.MonsterState.SurfingObjectIdleState")
local FSM = require("Framework.Common.FSMWithPool")
local SHOW_EFFECT_OFFSET = 6

function SurfingObj:Init(logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  base.Init(self, logic, mgr, x, y, z, monsterMeta, bornId, param, oriId)
  self.triggerLine = param and param.triggerLine or 0
  self.triggerLineOffset = param and param.triggerLineOffset or 0
  self.stageSceneIndex = param.stageSceneIndex
  self.move_speed = self.monsterMeta.move_speed or 0
  self.dontCollide = {}
end

function SurfingObj:OnCollisionViewHandle(target)
  if self.dontCollide[target.guid] == nil then
    self.dontCollide[target.guid] = 1
    if target and 0 < (target.curBlood or 0) then
      self:OnCollide(target)
    end
  end
end

function SurfingObj:OnLoadComplete()
  base.OnLoadComplete(self)
  if self.move_speed > 0 then
    self:InitFsm()
  end
  if 0 < self.triggerLine and self.move_speed > 0 then
    self.effectParent = self.transform
  end
end

function SurfingObj:InitFsm()
  self.fsm = ObjectPool:GetInstance():Load(FSM)
  self.fsm:Init(self)
  local moveState = ObjectPool:GetInstance():Load(SurfingObjectMoveState)
  moveState:Init(self)
  self.fsm:AddState(SurfingMonsterState.Run, moveState)
  local idleState = ObjectPool:GetInstance():Load(SurfingObjectIdleState)
  idleState:Init(self)
  self.fsm:AddState(SurfingMonsterState.Idle, idleState)
end

function SurfingObj:OnCollide(target)
  self:Death()
end

function SurfingObj:OnUpdate(deltaTime, viewY)
  base.OnUpdate(self, deltaTime, viewY)
  if self._showStaticEffect then
    local z = self:GetDataZ()
    if self.staticEffectId then
      if z < viewY - SHOW_EFFECT_OFFSET then
        self:RemoveEffect()
      end
    elseif z <= viewY + self.loadEffectOffset and z > viewY - SHOW_EFFECT_OFFSET then
      self:ShowEffect()
    end
  end
  if self.fsm then
    self.fsm:OnUpdate(deltaTime)
  end
  if self.logic and self.move_speed > 0 and 0 < self.triggerLine then
    self:CheckEnemyTriggerLine()
  end
end

function SurfingObj:DestroyView()
  self:RemoveEffect()
  base.DestroyView(self)
  if self.fsm then
    self.fsm:Delete()
    ObjectPool:GetInstance():Save(self.fsm)
    self.fsm = nil
  end
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
end

function SurfingObj:DestroyData()
  self.dontCollide = nil
  self.effectParent = nil
  self.curState = nil
  base.DestroyData(self)
end

function SurfingObj:ShowEffect()
  if self.transform == nil then
    return
  end
  if self.staticEffectId == nil then
    self:ShowStaticEffect()
  end
end

function SurfingObj:ShowStaticEffect(x, y, z, path)
end

function SurfingObj:ResetEffectPosition()
  if self.effectParent == nil and self.staticEffectId then
    local p = self.curWorldPos
    self.logic:ResetEffectPosition(self.staticEffectId, p.x, p.y, p.z)
  end
end

function SurfingObj:ResetRenderPosition()
  base.ResetRenderPosition(self)
  self:ResetEffectPosition()
end

function SurfingObj:RemoveEffect()
  if self.staticEffectId then
    self.logic:RemoveEffectObj(self.staticEffectId)
    self.staticEffectId = nil
  end
end

function SurfingObj:CheckEnemyTriggerLine()
  if self.curState == SurfingMonsterState.Run or self.isMoving then
    return
  end
  local posZ = self.logic:GetCurDistanceData()
  if posZ >= self.triggerLine and self.fsm then
    self.fsm:ChangeState(SurfingMonsterState.Run)
    self.curState = SurfingMonsterState.Run
    self:OnObjStartMoved()
  end
  return posZ >= self.triggerLine
end

function SurfingObj:ResetToIdle()
  if self.curState and self.curState == SurfingMonsterState.Run then
    self.fsm:ChangeState(SurfingMonsterState.Idle)
    self.curState = SurfingMonsterState.Idle
  end
end

function SurfingObj:IsMoving()
  return self.curState == SurfingMonsterState.Run
end

function SurfingObj:OnObjStartMoved()
end

return SurfingObj
