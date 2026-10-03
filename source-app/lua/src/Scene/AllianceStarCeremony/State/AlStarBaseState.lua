local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)

function State.Create(stateId)
  local copy = {}
  setmetatable(copy, State)
  copy:Init(stateId)
  return copy
end

function State:Init(stateId)
  self.stateId = stateId
end

function State:Dispose()
  self.stateId = nil
  self:OnExit()
end

function State:OnEnter(ceremonyInfo)
  self.scene = self.owner
  self.manager = self.scene.manager
  local templateGroupDict = self.manager:GetCeremonyTemplateGroupDict()
  self.InnerState = AlStarCeremonyInnerState[self.stateId]
  self.templateGroup = templateGroupDict[self.stateId]
  self.allDuration = 0
  for i, v in ipairs(self.templateGroup) do
    self.allDuration = self.allDuration + v.duration
  end
  self.allDuration = self.allDuration
  self:CreateFsm()
  self:Refresh(ceremonyInfo)
end

function State:OnExit()
  self.scene = nil
  self.manager = nil
  self.InnerState = nil
  self.templateGroup = nil
  self.allDuration = nil
  self.curState = nil
  self.waitState = nil
  if self.fsm ~= nil then
    self.fsm:Dispose()
    self.fsm = nil
  end
  self.ceremonyInfo = nil
  self.allElapsedTime = nil
  self.changeNextTime = nil
  self.uploadTimeout = nil
end

function State:CreateFsm()
end

function State:CreateAllElapsedTime()
end

function State:Refresh(ceremonyInfo)
  self.ceremonyInfo = ceremonyInfo
  local curState = self.waitState
  local elapsedTime = 0
  if self.ceremonyInfo.targetStageId then
    self.allElapsedTime = 0
    for i, v in ipairs(self.templateGroup) do
      if self.ceremonyInfo.targetStageId ~= 0 and i <= self.ceremonyInfo.targetStageId then
        break
      end
      self.allElapsedTime = self.allElapsedTime + v.duration
    end
    curState = self.ceremonyInfo.targetStageId
    elapsedTime = 0
  else
    self:CreateAllElapsedTime()
    elapsedTime = self.allElapsedTime
    for i, v in ipairs(self.templateGroup) do
      if elapsedTime <= v.duration then
        curState = v.innerStateId
        break
      end
      elapsedTime = elapsedTime - v.duration
    end
  end
  self:ChangeState(curState, elapsedTime)
end

function State:OnUpdate(deltaTime)
  if self.fsm then
    self.fsm:Update(deltaTime)
    if self.fsm.currState and self.curState ~= self.waitState and self.fsm.currState:IsFinished() then
      self:ChangeNextState()
    elseif self.stateId ~= AlStarCeremonyState.Finish and self.curState == self.waitState and self.fsm.currState and self.fsm.currState.elapsedTime > 10000 and not self.uploadTimeout then
      self.uploadTimeout = true
      Logger.LogInfo(string.format("AllianceStarState%s Timeout", self.stateId))
    end
  end
end

function State:ChangeState(targetState, elapsedTime)
  self.manager:LogInfo(string.format("State:%s InnerState:%s ElapsedTime:%s", self.stateId, targetState, elapsedTime))
  if self.curState ~= targetState then
    self.curState = targetState
    self.fsm:Switch(targetState, self.ceremonyInfo, elapsedTime)
  elseif self.fsm.currState.elapsedTime ~= elapsedTime then
    self.fsm.currState:Refresh(self.ceremonyInfo, elapsedTime)
  end
end

function State:ChangeNextState()
  local index
  for i, v in ipairs(self.templateGroup) do
    if v.innerStateId == self.curState then
      index = i + 1
      break
    end
  end
  local curState = self.waitState
  if index and index <= #self.templateGroup then
    local template = self.templateGroup[index]
    curState = template.innerStateId
  end
  self:ChangeState(curState, 0)
end

return State
