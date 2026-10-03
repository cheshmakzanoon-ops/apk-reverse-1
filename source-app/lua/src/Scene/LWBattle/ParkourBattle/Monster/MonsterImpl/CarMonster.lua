local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster")
local CarMonster = BaseClassCache("CarMonster", base)
local CarIdleState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.Car.CarIdleState")
local CarRunState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.Car.CarRunState")
local RunState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRun")
local AttackState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateAttack")
local DieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DieState")
local ZombieStateHardControl = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl")
local FSM = require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local BattleColliderUtils = CS.BattleColliderUtils

function CarMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.dontCollid = {}
  self.collidCnt = monsterMeta.collide_count
  if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
    self.eulerY = 180
  end
end

function CarMonster:OnLoadComplete()
  self.agent = pveUnitViewUtil.AddAgent(self.mgr.logic.rvoMgr, self.viewHandle, 99.0, self.monsterMeta.collide_radius * 1.0)
  self:InitSkills()
  self:InitFsm()
  if self.monsterMeta.monster_type == Const.MonsterType.Boss then
    self:InitHpBar()
  end
  BattleColliderUtils.AddMonsterCollider(self.viewHandle, self.guid, LayerMask.GetMask("Member"))
end

function CarMonster:InitFsm()
  self.fsm = FSM.New()
  self.fsm:AddState(ZombieState.Idle, CarIdleState.New(self))
  local runState = ObjectPool:GetInstance():Load(CarRunState)
  runState:Init(self)
  self.fsm:AddState(ZombieState.Run, runState)
  self.fsm:AddState(ZombieState.Attack, AttackState.New(self))
  local dieState = ObjectPool:GetInstance():Load(DieState)
  dieState:Init(self)
  self.fsm:AddState(ZombieState.Die, dieState)
  local hardControl = ObjectPool:GetInstance():Load(ZombieStateHardControl)
  hardControl:Init(self)
  self.fsm:AddState(ZombieState.HardControl, hardControl)
  self.fsm:ChangeState(ZombieState.Idle)
end

function CarMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
end

function CarMonster:OnCollisionViewHandle(colliderCount, startIndex, resultList)
  for i = 1, colliderCount do
    local index = startIndex + i
    local targetObjId = resultList[index]
    self:AttackTarget(targetObjId)
  end
end

function CarMonster:AttackTarget(targetObjId)
  if self.dontCollid[targetObjId] ~= nil then
    return
  end
  base.DoColliderEffect(self)
  self.dontCollid[targetObjId] = 1
  local tar = DataCenter.LWBattleManager.logic:GetUnit(targetObjId)
  local collide_damage = self.monsterMeta.collide_damage
  if tar and 0 < (tar.curBlood or 0) and #collide_damage == 3 and collide_damage[1] == 2 then
    self:CollidEffect(tar)
    self.battleMgr:DealDamage(self, tar, {}, 1, tar:GetPosition(), nil, 0.2, nil, nil, nil, nil, collide_damage[2], collide_damage[3])
    self.collidCnt = self.collidCnt - 1
    if self.collidCnt == 0 then
      self:Death()
    end
  end
end

function CarMonster:BeAttackEffect(stiffTime, dir)
  if dir and self.meta.ignore_hit_back == 0 then
    if dir.x then
      dir.x = 0
    end
    if 0 < self.curBlood then
      self.fsm:ChangeState(ZombieState.HardControl, HardControlType.HitBack, 0.5, self.transform.position + dir)
    end
  elseif stiffTime and 0 < stiffTime and self.meta.ignore_hit_stiff == 0 and 0 < self.curBlood then
    self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Stiff, stiffTime)
  end
end

function CarMonster:OnBuffAdded(buff)
  if self.fsm then
    local curState = self.fsm:GetStateIndex()
    if curState == ZombieState.Idle or curState == ZombieState.Run then
      self.agent.speed = self.meta.move_speed * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
    end
    if buff.meta.type == BuffType.Charge and curState == ZombieState.Idle or curState == ZombieState.Run then
      self.fsm:ChangeState(ZombieState.HardControl, HardControlType.Charge, buff.duration)
    end
  end
  base.OnBuffAdded(self, buff)
end

function CarMonster:OnBuffRemoved(buff)
  if self.fsm then
    local curState = self.fsm:GetStateIndex()
    if curState == ZombieState.Idle or curState == ZombieState.Run then
      self.agent.speed = self.meta.move_speed * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
    end
    if buff.meta.type == BuffType.Charge and curState == ZombieState.HardControl then
      self.fsm:ChangeState(ZombieState.Run)
    end
  end
  base.OnBuffRemoved(self, buff)
end

function CarMonster:DestroyView()
  base.DestroyView(self)
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
end

function CarMonster:DestroyData()
  self.dontCollid = nil
  self.collidCnt = nil
  base.DestroyData(self)
end

function CarMonster:CollidEffect(tar)
  self.battleMgr:ShowEffectObj(Const.ParkourCollidEffectPath, tar:GetPosition(), nil, 1, nil)
end

function CarMonster:CheckOutOfRenderRange()
  if self.battleMgr.team:GetPosition().z - self:GetPosition().z > ZOMBIE_REMOVE_DISTANCE_Z then
    DataCenter.LWBattleManager.logic:OnMonsterDeath(self)
    self.mgr:RemoveMonster(self.guid)
  end
end

return CarMonster
