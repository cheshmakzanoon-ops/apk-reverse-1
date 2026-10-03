local LWHummerScene = BaseClass("LWHummerScene")
local Resource = CS.GameEntry.Resource
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function LWHummerScene:__init(sceneData, logic)
  self.sceneData = sceneData
  self.logic = logic
end

function LWHummerScene:__delete()
  self:OnDestroy()
end

function LWHummerScene:OnDestroy()
  if self.assetReq then
    self.assetReq:Destroy()
    self.assetReq = nil
  end
end

function LWHummerScene:OnLoad(callback)
  self.loadCallback = callback
  self:LoadAsset()
end

function LWHummerScene:LoadAsset()
  local assetPath = self.sceneData.config.asset
  local req = Resource:InstantiateAsync(string.format(Constant.PVEScenePath, assetPath))
  req:completed("+", function(request)
    if not self.logic or not self.logic.inLogic then
      request:Destroy()
      return
    end
    self.sceneRoot = request.gameObject.transform
    self.sceneRoot:Set_position(0, 0, self.sceneData.config.offset)
    if self.loadCallback then
      self.loadCallback()
      self.loadCallback = nil
    end
  end)
  self.assetReq = req
  if self.logic then
    local offset = self.sceneData.config.offset
    if self.logic.staticMgr then
      self.logic.staticMgr:Append(string.format(Constant.PVEDecorationPath, assetPath), offset)
    end
  end
end

function LWHummerScene:GetStartZ()
  if self.sceneData ~= nil then
    return self.sceneData.startZ
  end
  return 0
end

function LWHummerScene:GetEndZ()
  if self.sceneData ~= nil then
    return self.sceneData.endZ
  end
  return 0
end

function LWHummerScene:IsContainsZ(z)
  return z >= self:GetStartZ() and z < self:GetEndZ()
end

function LWHummerScene:GetPreviousScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index - 2 then
        return v
      end
    end
  end
end

function LWHummerScene:GetNextScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index + 1 then
        return v
      end
    end
  end
end

return LWHummerScene
