local base = require("Scene.LWUIModelShow.UIModelShowCtrl")
local UIKillZombieBoxModel = BaseClass("UIKillZombieBoxModel", base)

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  self.lastNode = nil
  base.DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ShowModel(self, nodePathStr)
  if not string.IsNullOrEmpty(nodePathStr) and self.worldModel then
    local node = self.worldModel:Find(nodePathStr)
    if node then
      node.gameObject:SetActive(true)
      if self.modelNode then
        self.modelNode:SetActive(false)
      end
      self.lastNode = self.modelNode
      self.modelNode = node.gameObject
    end
  end
end

UIKillZombieBoxModel.OnCreate = OnCreate
UIKillZombieBoxModel.OnDestroy = OnDestroy
UIKillZombieBoxModel.DataDefine = DataDefine
UIKillZombieBoxModel.DataDestroy = DataDestroy
UIKillZombieBoxModel.OnEnable = OnEnable
UIKillZombieBoxModel.OnDisable = OnDisable
UIKillZombieBoxModel.ShowModel = ShowModel
return UIKillZombieBoxModel
