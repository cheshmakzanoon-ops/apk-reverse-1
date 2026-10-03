local LWGateDefenceZombie = BaseClass("LWGateDefenceZombie")
local FSMachine = require("Common.FSMachine")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")
local stateBorn = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateBorn")
local stateIdle = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateIdle")
local stateMove = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateMove")
local stateAttack = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateAttack")
local stateHurt = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateHurt")
local stateFall = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateFall")
local stateExplode = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateExplode")
local ZOMBIE_PREFAB_POOL, BIG_ZOMBIE_PREFAB_POOL
local __Inst_Pool = {}

function LWGateDefenceZombie.Create(grid, dstGrid, lifeTime, bigZombie, hp)
  local inst
  if 0 < #__Inst_Pool then
    inst = table.remove(__Inst_Pool)
  else
    inst = LWGateDefenceZombie.New()
  end
  inst:Initialize(grid, dstGrid, lifeTime, bigZombie, hp)
  return inst
end

function LWGateDefenceZombie.Return(inst)
  if inst == nil then
    return
  end
  inst:Clear()
  table.insert(__Inst_Pool, inst)
end

function LWGateDefenceZombie.ReleaseAll()
  for i = 1, #__Inst_Pool do
    __Inst_Pool[i]:Delete()
  end
  __Inst_Pool = {}
end

function LWGateDefenceZombie:__init()
  if ZOMBIE_PREFAB_POOL == nil then
    ZOMBIE_PREFAB_POOL = {
      "Assets/Main/Prefabs/LWGateDefence/Zombie2.prefab",
      "Assets/Main/Prefabs/LWGateDefence/Zombie2.prefab",
      "Assets/Main/Prefabs/LWGateDefence/Zombie3.prefab"
    }
  end
  if BIG_ZOMBIE_PREFAB_POOL == nil then
    BIG_ZOMBIE_PREFAB_POOL = {
      "Assets/Main/Prefabs/LWGateDefence/BigZombie1.prefab",
      "Assets/Main/Prefabs/LWGateDefence/BigZombie2.prefab"
    }
  end
  self.fsm = FSMachine.Create(self)
  self.fsm:Add("Born", stateBorn.Create())
  self.fsm:Add("Idle", stateIdle.Create())
  self.fsm:Add("Move", stateMove.Create())
  self.fsm:Add("Attack", stateAttack.Create())
  self.fsm:Add("Hurt", stateHurt.Create())
  self.fsm:Add("Fall", stateFall.Create())
  self.fsm:Add("Explode", stateExplode.Create())
end

function LWGateDefenceZombie:__delete()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self:Clear()
end

function LWGateDefenceZombie:Initialize(grid, dstGrid, lifeTime, bigZombie, hp)
  assert(self.fsm ~= nil, "LWGateDefenceZombie -> fsm is nil.")
  self.id = utils.GetNewZombieId()
  local zombieHp = MNs.ZOMBIE_MAX_HP
  if hp then
    zombieHp = hp
  end
  self.hp = zombieHp
  self.grid = grid
  self.dstGrid = dstGrid
  self.faceX = 0
  self.faceZ = 1
  self.lifeTime = lifeTime or -1
  self.remainLifeTime = self.lifeTime
  self.bigZombie = bigZombie
  if self.bigZombie then
    self.modelPath = BIG_ZOMBIE_PREFAB_POOL[math.random(#BIG_ZOMBIE_PREFAB_POOL)]
  else
    self.modelPath = ZOMBIE_PREFAB_POOL[math.random(#ZOMBIE_PREFAB_POOL)]
  end
  self.resHandle = CS.GameEntry.Resource:InstantiateAsync(self.modelPath, ObjectPoolTag.Normal, LoadPriority.Low)
  self.resHandle:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      Logger.LogError("load res failed:" .. self.modelPath)
      DataCenter.LWGateDefenceManager:DestroyZombie(self.id)
      return
    end
    self.gameObject = handle.gameObject
    self.transform = self.gameObject.transform
    self.transformValid = true
    self.transform.position = utils.Grid_2_World(self.grid.row, self.grid.col)
    self.transform.forward = Vector3(0, 0, 1)
    self.hurtVfxDummy = self.transform:Find("Skin/To_unity/DeformationSystem/Root/guadian_R")
    self.animator = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    self.touchTrigger = self.gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
    if not IsNull(self.transform) then
      function self.touchTrigger.onPointerClick()
        if self.hp > 0 then
          DataCenter.LWGateDefenceManager:SetForceTarget(self.id)
        end
      end
    end
    self.fsm:Switch("Born")
  end)
end

function LWGateDefenceZombie:Clear()
  self.id = nil
  self.hp = nil
  self.grid = nil
  self.dstGrid = nil
  self.modelPath = nil
  self.bigZombie = nil
  if not IsNull(self.touchTrigger) then
    self.touchTrigger.onPointerClick = nil
    self.touchTrigger = nil
  end
  if not IsNull(self.resHandle) then
    self.resHandle:Destroy()
    self.resHandle = nil
  end
  self.gameObject = nil
  self.transform = nil
  self.transformValid = nil
  self.animator = nil
  self.lifeTime = nil
  self.remainLifeTime = nil
  if self.fsm ~= nil then
    self.fsm:Reset()
  end
end

function LWGateDefenceZombie:Update(dt)
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
  if self.gameObject and self.hp > 0 and 0 < self.remainLifeTime then
    self.remainLifeTime = self.remainLifeTime - dt
    if 0 >= self.remainLifeTime then
      self:OnLifeTimeEnd()
    end
  end
end

function LWGateDefenceZombie:OnHurt()
  if self.hp <= 0 then
    return
  end
  self.hp = self.hp - 1
  if self.hp <= 0 then
    self:OnDead()
    self.fsm:Switch("Fall")
  else
    self.fsm:Switch("Hurt")
  end
end

function LWGateDefenceZombie:OnCrashed()
  if self.hp <= 0 then
    return
  end
  self.hp = 0
  self:OnDead()
  if self.bigZombie then
    self.fsm:Switch("Fall")
  else
    self.fsm:Switch("Explode")
  end
end

function LWGateDefenceZombie:OnLifeTimeEnd()
  if self.hp <= 0 then
    return
  end
  self.hp = 0
  self:OnDead()
  self.fsm:Switch("Fall")
end

function LWGateDefenceZombie:GetDropPosition()
  return self.hurtVfxDummy.position
end

function LWGateDefenceZombie:OnDead()
  DataCenter.LWGateDefenceManager:OnZombieDead(self.id)
end

return LWGateDefenceZombie
