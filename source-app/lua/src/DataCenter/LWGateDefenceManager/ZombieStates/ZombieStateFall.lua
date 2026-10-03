local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local MNs = require("DataCenter.LWGateDefenceManager.LWGateDefenceMagicNumbers")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnEnter()
  self.owner.animator:CrossFade("dead", 0.5)
  self.animTimer = self.owner.animator:GetClipLength("dead") or 0
  self.disTimer = MNs.FALLING_TIME or 0
  self.fallX, self.fallY, self.fallZ = self.owner.transform:Get_position()
  local dummyPX, dummyPY, dummyPZ = self.owner.hurtVfxDummy:Get_position()
  local dummyRX, dummyRY, dummyRZ, dummyRW = self.owner.hurtVfxDummy:Get_rotation()
  self.hurtVfx = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_monster_hit.prefab", ObjectPoolTag.Normal, LoadPriority.Low)
  self.hurtVfx:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      return
    end
    handle.gameObject.transform:Set_position(dummyPX, dummyPY, dummyPZ)
    handle.gameObject.transform:Set_rotation(dummyRX, dummyRY, dummyRZ, dummyRW)
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(handle) then
        handle:Destroy()
      end
    end, 1)
  end)
end

function State:OnUpdate(deltaTime)
  if self.animTimer > 0 then
    self.animTimer = self.animTimer - deltaTime
  end
  if self.animTimer <= 0 and 0 < self.disTimer then
    self.disTimer = self.disTimer - deltaTime
    if 0 >= self.disTimer then
      DataCenter.LWGateDefenceManager:DestroyZombie(self.owner.id)
    else
      local t = self.disTimer / MNs.FALLING_TIME
      if not IsNull(self.booldRenderer) then
        self.booldRenderer.color = Color(1, 1, 1, t)
      end
      if self.owner.transformValid then
        local py = self.fallY - MNs.FALLING_HEIGHT * (1 - t)
        self.owner.transform:Set_position(self.fallX, py, self.fallZ)
      end
    end
  end
end

function State:OnExit()
  if not IsNull(self.hurtVfx) then
    self.hurtVfx:Destroy()
    self.hurtVfx = nil
  end
end

return State
