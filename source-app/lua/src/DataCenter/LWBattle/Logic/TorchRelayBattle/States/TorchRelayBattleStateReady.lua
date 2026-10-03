local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Const = require("Scene.LWBattle.Const")
local Resource = CS.GameEntry.Resource
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = true
  self.canInput = false
end

function State:OnExit()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function State:OnEnter(callBack)
  local owner = self.owner
  local z = owner.player:GetPosition().z
  if owner.battleMgr then
    local camPos = Vector3.New(TorchConstant.SCENE_CENTER_X, 0, z) + TorchConstant.CAMERA_OFFSET
    owner.battleMgr:LookAt(camPos)
  end
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if callBack then
      callBack()
    end
  end, 0.2)
end

function State:Dispose()
  local owner = self.owner
  if owner.staticMgr then
    owner.staticMgr:UnInit()
    owner.staticMgr = nil
  end
end

return State
