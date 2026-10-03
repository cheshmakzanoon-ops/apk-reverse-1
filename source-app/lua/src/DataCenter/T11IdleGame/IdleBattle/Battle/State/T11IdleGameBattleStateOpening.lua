local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Resource = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnUpdate(deltaTime)
end

function State:OnExit()
  if self.delayExitTimer then
    self.delayExitTimer:Stop()
    self.delayExitTimer = nil
  end
end

function State:OnEnter(callBack)
  if self.delayExitTimer then
    self.delayExitTimer:Stop()
    self.delayExitTimer = nil
  end
  local owner = self.owner
  if owner then
    owner:ChangeSquadState(Const.SoldierState.Opening)
    self.delayExitTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayExitTimer = nil
      if owner then
        owner:ChangeState(Const.State.Going, {
          preState = Const.State.Opening
        })
      end
    end, Const.OpeningStateTimeDuration)
  end
end

function State:Dispose()
  if self.delayExitTimer then
    self.delayExitTimer:Stop()
    self.delayExitTimer = nil
  end
end

return State
