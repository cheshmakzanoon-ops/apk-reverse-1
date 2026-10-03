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
end

function State:OnEnter(callBack)
  local owner = self.owner
  if owner then
    owner:PlayAnim("idle_game_open_chest")
  end
end

function State:Dispose()
end

return State
