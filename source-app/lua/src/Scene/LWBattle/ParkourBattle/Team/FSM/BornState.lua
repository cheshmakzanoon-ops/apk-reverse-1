local BornState = BaseClass("BornState")
local Const = require("Scene.LWBattle.Const")

function BornState:__init(unit)
  self.unit = unit
end

function BornState:StopCall()
  if self.changeStateCall then
    self.changeStateCall:Stop()
    self.changeStateCall = nil
  end
end

function BornState:__delete()
  self.unit = nil
  self:StopCall()
end

function BornState:OnEnter()
  if not self.unit then
    return
  end
  if not self.unit.fsm then
    return
  end
  local animLength = self.unit:GetAnimLength(AnimName.Born)
  if 0 < animLength then
    self.unit:RewindAndPlaySimpleAnim(AnimName.Born)
    self.changeStateCall = TimerManager:GetInstance():DelayInvoke(function()
      self.unit.fsm:ChangeState(Const.ParkourFireState.Stay)
    end, animLength)
  else
    self.unit.fsm:ChangeState(Const.ParkourFireState.Stay)
  end
end

function BornState:OnExit()
  self:StopCall()
end

function BornState:OnUpdate()
end

return BornState
