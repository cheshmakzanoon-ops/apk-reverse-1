local base = require("Scene.LWUIModelShow.UIModelShowCtrl")
local KillZombieALKirovModel = BaseClass("KillZombieALKirovModel", base)

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
      self.modelNode = node.gameObject
    end
  end
end

local function ChangeModelType(self, modelType, nodePathStr, showEffectList, animName, callback, normalizedTime)
  if self.modelType ~= modelType then
    self:DestroyModel()
    self.modelType = modelType
  end
  self:ReInit(nodePathStr, showEffectList, animName, callback, normalizedTime)
end

KillZombieALKirovModel.OnCreate = OnCreate
KillZombieALKirovModel.OnDestroy = OnDestroy
KillZombieALKirovModel.DataDefine = DataDefine
KillZombieALKirovModel.DataDestroy = DataDestroy
KillZombieALKirovModel.OnEnable = OnEnable
KillZombieALKirovModel.OnDisable = OnDisable
KillZombieALKirovModel.ShowModel = ShowModel
KillZombieALKirovModel.ChangeModelType = ChangeModelType
return KillZombieALKirovModel
