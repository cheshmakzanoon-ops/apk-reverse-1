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
  self.waitState = self.InnerState.State0
  self.fsm = FSMachine.Create(self)
  self.waitState = self.InnerState.State0
  self.fsm:Add(self.InnerState.State0, require("Scene.AllianceStarCeremony.State.Applaud.AlStarApplaud_State0").Create(self.InnerState.State0))
  self.fsm:Add(self.InnerState.State1, require("Scene.AllianceStarCeremony.State.Applaud.AlStarApplaud_State1").Create(self.InnerState.State1))
end

function State:CreateAllElapsedTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.ceremonyInfo.startTimeStamp
  self.allElapsedTime = nowTime - startTime
  self.allElapsedTime = math.max(0, self.allElapsedTime)
end

return State
