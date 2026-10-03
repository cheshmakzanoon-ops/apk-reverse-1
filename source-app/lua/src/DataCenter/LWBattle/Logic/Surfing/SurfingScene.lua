local SurfingScene = BaseClass("SurfingScene")
local Resource = CS.GameEntry.Resource
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function SurfingScene:__init(sceneData, logic, scenePool)
  self.sceneData = sceneData
  self.logic = logic
  self.scenePool = scenePool
end

function SurfingScene:__delete()
  self:OnDestroy()
end

function SurfingScene:OnDestroy()
  if self.assetReq then
    self.scenePool:ReleaseScene(self.sceneData.config.sceneId, self.assetReq)
    self.assetReq = nil
  end
end

function SurfingScene:OnLoad(callback)
  self.loadCallback = callback
  self:LoadAsset()
end

function SurfingScene:LoadAsset()
  local assetPath = self.sceneData.config.asset
  local req = self.scenePool:GetScene(self.sceneData.config.sceneId, function(request)
    self.sceneRoot = request.gameObject.transform
    self.sceneRoot:Set_position(0, 0, self.sceneData.config.offset + self.logic.renderOffsetZ)
    if self.loadCallback then
      self.loadCallback()
      self.loadCallback = nil
    end
  end)
  self.assetReq = req
  if self.logic then
    if DataCenter.LWBattleManager.ignoreDecoration then
      return
    end
    if not self.logic:CheckUpdateDecoration() then
      return
    end
    local offset = self.sceneData.config.offset
    if self.logic.staticMgr then
      self.logic.staticMgr:Append(assetPath, offset)
    end
  end
end

function SurfingScene:GetStartZ()
  if self.sceneData ~= nil then
    return self.sceneData.startZ
  end
  return 0
end

function SurfingScene:GetEndZ()
  if self.sceneData ~= nil then
    return self.sceneData.endZ
  end
  return 0
end

function SurfingScene:IsContainsZ(z)
  return z >= self:GetStartZ() and z < self:GetEndZ()
end

function SurfingScene:GetPreviousScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index - 2 then
        return v
      end
    end
  end
end

function SurfingScene:GetNextScene()
  if self.logic ~= nil and self.logic.scenes ~= nil and self.sceneData ~= nil then
    for i, v in pairs(self.logic.scenes) do
      if v.sceneData and v.sceneData.index == self.sceneData.index + 1 then
        return v
      end
    end
  end
end

function SurfingScene:GetActualIndex()
  return self.sceneData and self.sceneData:GetActualIndex()
end

function SurfingScene:GetId()
  return self.sceneData and self.sceneData:GetId()
end

function SurfingScene:ResetRenderPosition()
  if self.assetReq and IsNotNull(self.sceneRoot) then
    self.sceneRoot:Set_position(0, 0, self.sceneData.config.offset + self.logic.renderOffsetZ)
  end
end

return SurfingScene
