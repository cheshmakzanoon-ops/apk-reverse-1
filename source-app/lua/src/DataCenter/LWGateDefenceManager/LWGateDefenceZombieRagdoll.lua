local LWGateDefenceZombieRagdoll = BaseClass("LWGateDefenceZombieRagdoll")
local FSMachine = require("Common.FSMachine")
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")
local stateBorn = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateBorn")
local stateIdle = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateIdle")
local stateMove = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateMove")
local stateAttack = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateAttack")
local stateHurt = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateHurt")
local stateRagDoll = require("DataCenter.LWGateDefenceManager.ZombieStates.ZombieStateRagdoll")
local ZOMBIE_RAGDOLL_PREFAB_POOL

function LWGateDefenceZombieRagdoll:__init(grid)
  if ZOMBIE_RAGDOLL_PREFAB_POOL == nil then
    ZOMBIE_RAGDOLL_PREFAB_POOL = {
      "Assets/Main/Prefabs/LWGateDefence/Zombie1_ragdoll.prefab",
      "Assets/Main/Prefabs/LWGateDefence/Zombie2_ragdoll.prefab",
      "Assets/Main/Prefabs/LWGateDefence/Zombie3_ragdoll.prefab"
    }
  end
  self.id = utils.GetNewZombieId()
  self.hp = MNs.ZOMBIE_MAX_HP
  self.grid = grid
  self.faceX = 0
  self.faceZ = 1
  self.modelPath = ZOMBIE_RAGDOLL_PREFAB_POOL[math.random(#ZOMBIE_RAGDOLL_PREFAB_POOL)]
  self.resHandle = CS.GameEntry.Resource:InstantiateAsync(self.modelPath)
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
    self.animator.enabled = true
    self.unityAnimator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
    self.unityAnimator.enabled = true
    self.rigidbodys = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Rigidbody))
    for i = 0, self.rigidbodys.Length - 1 do
      local rigidbody = self.rigidbodys[i]
      rigidbody.isKinematic = true
      if rigidbody.name == "Root_M" then
        self.rootRigidbody = rigidbody
      end
    end
    self.touchTrigger = self.gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
    if not IsNull(self.touchTrigger) then
      function self.touchTrigger.onPointerClick()
        if self.hp > 0 then
          DataCenter.LWGateDefenceManager:SetForceTarget(self.id)
        end
      end
    end
    self.fsm = FSMachine.Create(self)
    self.fsm:Add("Born", stateBorn.Create())
    self.fsm:Add("Idle", stateIdle.Create())
    self.fsm:Add("Move", stateMove.Create())
    self.fsm:Add("Attack", stateAttack.Create())
    self.fsm:Add("Hurt", stateHurt.Create())
    self.fsm:Add("Ragdoll", stateRagDoll.Create())
    self.fsm:Switch("Born")
  end)
end

function LWGateDefenceZombieRagdoll:__delete()
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  if not IsNull(self.touchTrigger) then
    self.touchTrigger.onPointerClick = nil
    self.touchTrigger = nil
  end
  if not IsNull(self.resHandle) then
    self.resHandle:Destroy()
    self.resHandle = nil
  end
  self.modelPath = nil
  self.gameObject = nil
  self.transform = nil
  self.transformValid = nil
  self.animator = nil
  self.unityAnimator = nil
  self.rigidbodys = nil
  self.rootRigidbody = nil
end

function LWGateDefenceZombieRagdoll:Update(dt)
  if self.fsm ~= nil then
    self.fsm:Update(dt)
  end
end

function LWGateDefenceZombieRagdoll:OnHurt(dir)
  if self.hp <= 0 then
    return
  end
  self.hp = self.hp - 1
  if self.hp <= 0 then
    self.fsm:Switch("Ragdoll", dir, math.random() * 2500 + 2500)
    self:OnDead()
  else
    self.fsm:Switch("Hurt", -dir)
  end
end

function LWGateDefenceZombieRagdoll:OnCrashed(dir)
  if self.hp <= 0 then
    return
  end
  self.hp = 0
  self.fsm:Switch("Ragdoll", dir + Vector3.up, math.random() * 5000 + 5000)
  self:OnDead()
end

function LWGateDefenceZombieRagdoll:OnDead()
  if math.random() < MNs.DROP_GOODS_RATE then
    local num = math.random(MNs.DROP_GOODS_NUM_MIN, MNs.DROP_GOODS_NUM_MAX)
    for i = 1, num do
      DataCenter.LWGateTruckGoodsManager:DropGoods(self.hurtVfxDummy.position, math.random(1, 3))
    end
  end
end

return LWGateDefenceZombieRagdoll
