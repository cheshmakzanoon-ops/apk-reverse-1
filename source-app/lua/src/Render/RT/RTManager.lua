local RTManager = BaseClass("RTManager", Singleton)
local RTCtrl = require("Render.RT.RTCtrl")
local RTScene = require("Render.RT.RTScene")
local CTRL_INSTANCE_ID = 0
local SCENE_INSTANCE_ID = 0

function RTManager:__init()
  self.ctrlMap = {}
end

function RTManager:__delete()
  self:MapClear(self.ctrlMap)
  self.ctrlMap = nil
  self:ClearPool()
end

function RTManager:ClearPool()
  self:MapClear(self.scenePool)
  self:MapClear(self.ctrlPool)
  self.scenePool = nil
  self.ctrlPool = nil
end

function RTManager:MapClear(map)
  if map == nil then
    return
  end
  for i, v in pairs(map) do
    if v then
      v:Delete()
    end
  end
end

function RTManager:GetCtrl()
  local ctrl
  if self.ctrlPool and #self.ctrlPool > 0 then
    ctrl = table.remove(self.ctrlPool)
  else
    ctrl = RTCtrl.New()
  end
  local instanceId = self:GetCtrlInstanceID()
  ctrl:Create(instanceId)
  self.ctrlMap[instanceId] = ctrl
  return ctrl
end

function RTManager:RecycleCtrl(ctrl)
  if ctrl == nil then
    return
  end
  if self.ctrlPool == nil then
    self.ctrlPool = {}
  end
  self.ctrlMap[ctrl.instanceId] = nil
  ctrl:Clear()
  table.insert(self.ctrlPool, ctrl)
end

function RTManager:GetRTScene()
  local scene
  if self.scenePool and #self.scenePool > 0 then
    scene = table.remove(self.scenePool)
  else
    scene = RTScene.New()
  end
  return scene
end

function RTManager:RecycleRTScene(scene)
  if scene == nil then
    return
  end
  if self.scenePool == nil then
    self.scenePool = {}
  end
  scene:Clear()
  table.insert(self.scenePool, scene)
end

function RTManager:GetCtrlInstanceID()
  CTRL_INSTANCE_ID = (CTRL_INSTANCE_ID + 1) % 1000000
  return CTRL_INSTANCE_ID
end

return RTManager
