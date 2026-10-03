local WorldMoveModelCtrlManager = BaseClass("WorldMoveModelCtrlManager")
local WorldMoveModelCtrl = require("Scene.WorldMoveModel.WorldMoveModelCtrl")

local function __init(self)
  self:Init()
end

local function __delete(self)
  self:Dispose()
end

local function Init(self)
  self.movingModelCtrl = nil
  self:AddListeners()
end

local function Dispose(self)
  self:RemoveListeners()
  if self.movingModelCtrl then
    self.movingModelCtrl:Dispose()
    self.movingModelCtrl = nil
  end
end

local function EnterWorld(self)
  self:Init()
end

local function ExitWorld(self)
  self:Dispose()
end

local function AddListeners(self)
end

local function RemoveListeners(self)
end

local function CreateMovingModel(self, transform)
  self:RemoveMovingModel()
  self.movingModelCtrl = WorldMoveModelCtrl.New(transform)
end

local function RemoveMovingModel(self)
  if self.movingModelCtrl then
    self.movingModelCtrl:Dispose()
    self.movingModelCtrl = nil
  end
end

WorldMoveModelCtrlManager.__init = __init
WorldMoveModelCtrlManager.__delete = __delete
WorldMoveModelCtrlManager.Init = Init
WorldMoveModelCtrlManager.Dispose = Dispose
WorldMoveModelCtrlManager.EnterWorld = EnterWorld
WorldMoveModelCtrlManager.ExitWorld = ExitWorld
WorldMoveModelCtrlManager.AddListeners = AddListeners
WorldMoveModelCtrlManager.RemoveListeners = RemoveListeners
WorldMoveModelCtrlManager.CreateMovingModel = CreateMovingModel
WorldMoveModelCtrlManager.RemoveMovingModel = RemoveMovingModel
return WorldMoveModelCtrlManager
