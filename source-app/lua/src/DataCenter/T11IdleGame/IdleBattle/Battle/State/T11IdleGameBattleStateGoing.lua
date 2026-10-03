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

function State:OnEnter(param)
  local owner = self.owner
  if owner then
    owner:ChangeSquadState(Const.SoldierState.Run)
    if param and (param.preState == Const.State.Load or param.preState == Const.State.Opening) then
      owner:StartSceneManager()
    else
      owner:ResumeSceneManager()
    end
  end
end

function State:Dispose()
end

function State:OnUpdate100MS()
  local owner = self.owner
  if owner then
    local infoData = owner:GetInfoData()
    if infoData then
      local nextTriggerNode = infoData:GetNextTriggerNodeData()
      if nextTriggerNode ~= nil then
        owner:TryTriggerNode(nextTriggerNode)
      elseif infoData:IsCanEnd() then
        owner:OnFinalNodeFinish()
      end
    end
  end
end

return State
