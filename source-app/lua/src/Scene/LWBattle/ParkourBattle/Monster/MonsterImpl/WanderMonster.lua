local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster")
local WanderMonster = BaseClassCache("WanderMonster", base)
local BornState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateBorn")
local WanderStateIdle = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.Wander.WanderStateIdle")
local WanderStateRun = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.Wander.WanderStateRun")
local RunState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRun")
local AttackState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateAttack")
local DieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DieState")
local ZombieStateHardControl = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl")
local FSM = require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local BattleColliderUtils = CS.BattleColliderUtils

function WanderMonster:OnLoadComplete()
  self.agent = pveUnitViewUtil.AddAgent(self.mgr.logic.rvoMgr, self.viewHandle, 5.0, self.monsterMeta.collide_radius * 1.0)
  self:InitSkills()
  self:InitFsm()
  if self.monsterMeta.is_boss == 1 then
    self:InitHpBar()
  end
end

function WanderMonster:InitFsm()
  self.fsm = ObjectPool:GetInstance():Load(FSM)
  self.fsm:Init(self)
  local bornState = ObjectPool:GetInstance():Load(BornState)
  bornState:Init(self)
  self.fsm:AddState(ZombieState.Born, bornState)
  local idleState = ObjectPool:GetInstance():Load(WanderStateIdle)
  idleState:Init(self)
  self.fsm:AddState(ZombieState.Idle, idleState)
  local runState = ObjectPool:GetInstance():Load(WanderStateRun)
  runState:Init(self)
  self.fsm:AddState(ZombieState.Run, runState)
  local dieStateObj = ObjectPool:GetInstance():Load(DieState)
  dieStateObj:Init(self)
  self.fsm:AddState(ZombieState.Die, dieStateObj)
  local hardControlState = ObjectPool:GetInstance():Load(ZombieStateHardControl)
  hardControlState:Init(self)
  self.fsm:AddState(ZombieState.HardControl, hardControlState)
  self.fsm:ChangeState(ZombieState.Idle)
end

function WanderMonster:GetMoveAnimPercent()
  return 1
end

return WanderMonster
