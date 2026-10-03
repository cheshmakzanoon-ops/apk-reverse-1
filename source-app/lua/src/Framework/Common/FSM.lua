local FSM = BaseClass("FSM")

local function Init(self)
  self.states = {}
  self.curStateIndex = -1
end

local function __init(self)
  self:Init()
end

local function __delete(self)
  if self.states then
    for _, v in pairs(self.states) do
      v:Delete()
    end
    self.states = nil
  end
  self.curStateIndex = nil
end

local function AddState(self, stateIndex, state)
  if self.states[stateIndex] then
    Logger.LogError("\231\138\182\230\128\129\233\135\141\229\164\141\239\188\154stateEnum")
  else
    self.states[stateIndex] = state
  end
end

local function GetStateIndex(self)
  return self.curStateIndex
end

local function GetCurState(self)
  return self.states[self.curStateIndex]
end

local function ChangeState(self, stateIndex, ...)
  if self.curStateIndex == stateIndex then
    if self.states[self.curStateIndex].OnTransToSelf then
      self.states[self.curStateIndex]:OnTransToSelf(...)
    end
    return true
  end
  if not self:CanChangeTo(stateIndex) then
    return false
  end
  if self.curStateIndex > -1 then
    self.states[self.curStateIndex]:OnExit()
  end
  self.curStateIndex = stateIndex
  self.states[stateIndex]:OnEnter(...)
  return true
end

local function CanChangeTo(self, stateIndex)
  if self.curStateIndex == -1 then
    return true
  end
  local curState = self.states[self.curStateIndex]
  if curState and curState.CanChangeTo ~= nil then
    return curState:CanChangeTo(stateIndex)
  end
  return true
end

local function OnUpdate(self, ...)
  if self.curStateIndex > -1 then
    self.states[self.curStateIndex]:OnUpdate(...)
  end
end

local function HandleInput(self, ...)
  if self.curStateIndex > -1 then
    self.states[self.curStateIndex]:HandleInput(...)
  end
end

FSM.Init = Init
FSM.__init = __init
FSM.__delete = __delete
FSM.AddState = AddState
FSM.GetStateIndex = GetStateIndex
FSM.ChangeState = ChangeState
FSM.OnUpdate = OnUpdate
FSM.HandleInput = HandleInput
FSM.GetCurState = GetCurState
FSM.CanChangeTo = CanChangeTo
return FSM
