local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local utils = require("DataCenter.LWGateDefenceManager.LWGateDefenceUtils")
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Dispose()
  if self.fireVfxTimer then
    self.fireVfxTimer:Stop()
    self.fireVfxTimer = nil
  end
  if self.fireVfx then
    self.fireVfx:Destroy()
    self.fireVfx = nil
  end
end

local EXPLOSION_VFX_POOL = {
  "Assets/Main/Prefabs/LWGateDefence/Explosion1.prefab",
  "Assets/Main/Prefabs/LWGateDefence/Explosion2.prefab",
  "Assets/Main/Prefabs/LWGateDefence/Explosion3.prefab",
  "Assets/Main/Prefabs/LWGateDefence/Explosion4.prefab"
}

function State:OnEnter(targetZombieInst)
  self.targetZombieInst = targetZombieInst
  self.owner.animator:CrossFade("attack", 0.2)
  self.animTime = self.owner.animator:GetClipLength("attack")
  self.fireDelay = self.owner.fireEffectContext.delay
end

function State:OnUpdate(deltaTime)
  if self.fireDelay > 0 then
    self.fireDelay = self.fireDelay - deltaTime
    if self.fireDelay <= 0 then
      self:Fire()
    end
  end
  if 0 < self.animTime then
    self.animTime = self.animTime - deltaTime
    if 0 >= self.animTime then
      if self.owner.fireEffectContext.bullet == 2 then
        self:PlayExplosionVFX()
        self:DealExplosionDamage()
      end
      self.owner.fsm:Switch("Reload")
    end
  end
end

function State:Fire()
  if not self.targetZombieInst or not self.targetZombieInst.transformValid then
    return
  end
  local muzzlePos = Vector3(self.owner.transform:Get_position()) + Vector3(0, 1.5, 0)
  local muzzleRot = Quaternion(self.owner.transform:Get_rotation())
  if self.owner.fireEffectContext.muzzle then
    muzzlePos = Vector3(self.owner.fireEffectContext.muzzle:Get_position())
    muzzleRot = Quaternion(self.owner.fireEffectContext.muzzle:Get_rotation())
  end
  if not string.IsNullOrEmpty(self.owner.fireEffectContext.vfxPath) then
    self.fireVfx = CS.GameEntry.Resource:InstantiateAsync(self.owner.fireEffectContext.vfxPath, ObjectPoolTag.Normal, LoadPriority.Low)
    self.fireVfx:completed("+", function(handle)
      if IsNull(handle.gameObject) then
        return
      end
      handle.gameObject.transform:Set_position(muzzlePos:Split())
      handle.gameObject.transform:Set_rotation(muzzleRot:Split())
      handle.gameObject.transform:Set_localScale(1, 1, 1)
      if self.fireVfxTimer then
        self.fireVfxTimer:Stop()
      end
      self.fireVfxTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.fireVfx then
          self.fireVfx:Destroy()
        end
      end, 1)
    end)
  end
  if self.owner.fireEffectContext.bullet == 1 then
    DataCenter.LWGateDefenceManager:CreateBullet(muzzlePos, self.targetZombieInst.hurtVfxDummy.position, self.targetZombieInst.id)
  else
    local accuracyError = math.random() * (MNs.ArtilleryAccuracyError * 2) - MNs.ArtilleryAccuracyError
    local x, _, z = self.targetZombieInst.transform:Get_position()
    self.explosionPosX = x + accuracyError
    self.explosionPosZ = z + accuracyError
  end
end

function State:PlayExplosionVFX()
  local vfx = CS.GameEntry.Resource:InstantiateAsync(EXPLOSION_VFX_POOL[math.random(#EXPLOSION_VFX_POOL)])
  vfx:completed("+", function(handle)
    if IsNull(handle.gameObject) or not self.explosionPosX then
      return
    end
    local transform = handle.gameObject.transform
    transform:Set_position(self.explosionPosX, 0, self.explosionPosZ)
    transform:Set_localScale(MNs.ArtilleryExplosionVFXScale.x, MNs.ArtilleryExplosionVFXScale.y, MNs.ArtilleryExplosionVFXScale.z)
    TimerManager:GetInstance():DelayInvoke(function()
      if handle then
        handle:Destroy()
      end
    end, 2)
  end)
end

function State:DealExplosionDamage()
  local groundZeroGrid = utils.World_2_Grid_XZ(self.explosionPosX, self.explosionPosZ)
  if not groundZeroGrid then
    return
  end
  local centerGrids = utils.GetAdjacentNodes(groundZeroGrid, MNs.ArtilleryCenterGridsOffset)
  for _, grid in ipairs(centerGrids) do
    local zombies = DataCenter.LWGateDefenceManager:GetZombiesByGrid(grid)
    if zombies then
      for _, zombie in pairs(zombies) do
        if zombie.transformValid then
          zombie:OnCrashed()
        end
      end
    end
  end
  local splashGrids = utils.GetAdjacentNodes(groundZeroGrid, MNs.ArtillerySplashGridsOffset)
  for _, grid in ipairs(splashGrids) do
    local zombies = DataCenter.LWGateDefenceManager:GetZombiesByGrid(grid)
    if zombies then
      for _, zombie in pairs(zombies) do
        if zombie.transformValid then
          zombie:OnHurt()
        end
      end
    end
  end
end

function State:OnExit()
  self.targetZombieInst = nil
end

return State
