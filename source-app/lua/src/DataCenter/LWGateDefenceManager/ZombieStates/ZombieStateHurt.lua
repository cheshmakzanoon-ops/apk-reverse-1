local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:OnEnter()
  self.owner.animator:CrossFade("hurt", 0.2)
  self.timer = self.owner.animator:GetClipLength("hurt")
  local dummyPos = Vector3(self.owner.hurtVfxDummy:Get_position())
  local dummyRot = Quaternion(self.owner.hurtVfxDummy:Get_rotation())
  self.hurtVfx = CS.GameEntry.Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/Common/Eff_monster_hit.prefab", ObjectPoolTag.Normal, LoadPriority.Low)
  self.hurtVfx:completed("+", function(handle)
    handle.gameObject.transform:Set_position(dummyPos:Split())
    handle.gameObject.transform:Set_rotation(dummyRot:Split())
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(handle) then
        handle:Destroy()
      end
    end, 1)
  end)
end

function State:OnUpdate(deltaTime)
  self.timer = self.timer - deltaTime
  if self.timer <= 0 then
    if self.owner.fsm.prevStateName == "Attack" then
      self.owner.fsm:Switch("Attack")
    else
      self.owner.fsm:Switch("Move")
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
