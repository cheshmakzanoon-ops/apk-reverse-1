local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Resource = CS.GameEntry.Resource
local MobileTouchCamera = CS.BitBenderGames.MobileTouchCamera
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
  self.syncCamera = false
  self.canInput = false
end

function State:OnEnter()
  self:InitUI()
end

function State:OnExit()
end

function State:Dispose()
  self:CloseUI()
end

function State:InitUI()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIJeepAdventureMain)
end

function State:CloseUI()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIJeepAdventureMain)
end

return State
