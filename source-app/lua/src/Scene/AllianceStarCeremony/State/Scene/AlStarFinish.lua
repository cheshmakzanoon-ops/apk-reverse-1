local FSMachine = require("Common.FSMachine")
local base = require("Scene.AllianceStarCeremony.State.AlStarBaseState")
local State = {}
State.__index = State
setmetatable(State, base)

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:CreateFsm()
  self.curState = nil
  self.waitState = self.InnerState.State2
  self.fsm = FSMachine.Create(self)
  self.waitState = self.InnerState.State2
  self.fsm:Add(self.InnerState.State1, require("Scene.AllianceStarCeremony.State.Finish.AlStarFinish_State1").Create(self.InnerState.State1))
  self.fsm:Add(self.InnerState.State2, require("Scene.AllianceStarCeremony.State.Finish.AlStarFinish_State2").Create(self.InnerState.State2))
end

function State:CreateAllElapsedTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.ceremonyInfo.startTimeStamp
  self.allElapsedTime = nowTime - startTime
  self.allElapsedTime = math.max(0, self.allElapsedTime)
end

return State
