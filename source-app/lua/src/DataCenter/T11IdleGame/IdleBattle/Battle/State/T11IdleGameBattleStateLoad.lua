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
  self.isSquadFinish = false
  self.isSceneFinish = false
  local owner = self.owner
  if owner then
    owner:CreateSquad(function()
      self:OnSquadLoadFinish()
    end)
    owner:CreateSceneManager(function()
      self:OnSceneLoadFinish()
    end)
  end
end

function State:Dispose()
end

function State:OnSquadLoadFinish()
  self.isSquadFinish = true
  local owner = self.owner
  if owner and self.isSceneFinish == true and self.isSquadFinish == true then
    owner:OnLoadFinish()
  end
end

function State:OnSceneLoadFinish()
  self.isSceneFinish = true
  local owner = self.owner
  if owner and self.isSceneFinish == true and self.isSquadFinish == true then
    owner:OnLoadFinish()
  end
end

return State
