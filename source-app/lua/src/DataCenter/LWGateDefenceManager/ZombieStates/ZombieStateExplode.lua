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

local BLOOD_EXPLOSION_VFX = "Assets/_Art_LastWar/Effect/Prefab/Common/Eff_shiti_boom.prefab"

function State:OnEnter()
  local zombiePos = Vector3(self.owner.transform:Get_position())
  local bloodVfx = CS.GameEntry.Resource:InstantiateAsync(BLOOD_EXPLOSION_VFX)
  bloodVfx:completed("+", function(handle)
    if IsNull(handle.gameObject) then
      return
    end
    handle.gameObject.transform:Set_position(zombiePos:Split())
    TimerManager:GetInstance():DelayInvoke(function()
      if not IsNull(handle) then
        handle:Destroy()
      end
    end, 2)
  end)
  DataCenter.LWGateDefenceManager:DestroyZombie(self.owner.id)
end

return State
