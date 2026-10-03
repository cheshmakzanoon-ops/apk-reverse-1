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
  self.fsm:Add(self.InnerState.State0, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State0").Create(self.InnerState.State0))
  self.fsm:Add(self.InnerState.State1, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State1").Create(self.InnerState.State1))
  self.fsm:Add(self.InnerState.State2, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State2").Create(self.InnerState.State2))
  self.fsm:Add(self.InnerState.State3, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State3").Create(self.InnerState.State3))
  self.fsm:Add(self.InnerState.State4, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State4").Create(self.InnerState.State4))
  self.fsm:Add(self.InnerState.State5, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State5").Create(self.InnerState.State5))
  self.fsm:Add(self.InnerState.State6, require("Scene.AllianceStarCeremony.State.ReadPersonReward.AlStarReadPersonReward_State6").Create(self.InnerState.State6))
end

function State:CreateAllElapsedTime()
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.ceremonyInfo.startTimeStamp
  self.allElapsedTime = nowTime - startTime
  self.allElapsedTime = math.max(0, self.allElapsedTime)
end

return State
