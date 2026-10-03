local FireState = {}
local FSMachine = require("Common.FSMachine")
FireState.__index = FireState
setmetatable(FireState, FSMachine.State)

function FireState.Create()
  local copy = {}
  setmetatable(copy, FireState)
  copy:Init()
  return copy
end

local FIRE_VFX = "Assets/Main/Prefabs/LWBattle/Effect_Lod/Eff_hero_xiandanqiang_qiangkou_lod.prefab"
local BLOOD_VFX = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_shiti_boom.prefab"

function FireState:Init()
  self.fireVfxHandle = CS.GameEntry.Resource:InstantiateAsync(FIRE_VFX)
  self.fireVfxHandle:completed("+", function(handle)
    handle:Destroy()
  end)
  self.bloodVfxHandle = CS.GameEntry.Resource:InstantiateAsync(BLOOD_VFX)
  self.bloodVfxHandle:completed("+", function(handle)
    handle:Destroy()
  end)
end

function FireState:Dispose()
  if not IsNull(self.fireVfxHandle) then
    self.fireVfxHandle:Destroy()
    self.fireVfxHandle = nil
  end
  if not IsNull(self.bloodVfxHandle) then
    self.bloodVfxHandle:Destroy()
    self.bloodVfxHandle = nil
  end
end

function FireState:OnEnter(target)
  TimerManager:GetInstance():DelayInvoke(function()
    if not IsNull(self.fireVfxHandle) then
      self.fireVfxHandle:Destroy()
    end
    self.fireVfxHandle = CS.GameEntry.Resource:InstantiateAsync(FIRE_VFX)
    self.fireVfxHandle:completed("+", function(handle)
      handle.gameObject.transform.position = self.owner.muzzle.transform.position
      handle.gameObject.transform.forward = self.owner.muzzle.transform.forward
      handle.gameObject.transform.localScale = Vector3(2, 2, 2)
    end)
    if not IsNull(self.bloodVfxHandle) then
      self.bloodVfxHandle:Destroy()
    end
    self.bloodVfxHandle = CS.GameEntry.Resource:InstantiateAsync(BLOOD_VFX)
    self.bloodVfxHandle:completed("+", function(handle)
      if IsNull(target.transform) then
        return
      end
      handle.gameObject.transform.position = target.transform.position
      handle.gameObject.transform.localScale = Vector3(1, 1, 1)
      target:DestroySelf()
    end)
    if self.owner.animator == nil then
      return
    end
    self.owner.animator:Play("attack")
    TimerManager:GetInstance():DelayInvoke(function()
      if self.owner == nil or self.owner.fsm == nil then
        return
      end
      self.owner.fsm:Switch("Reload")
    end, 0.3)
  end, 0.5)
end

return FireState
