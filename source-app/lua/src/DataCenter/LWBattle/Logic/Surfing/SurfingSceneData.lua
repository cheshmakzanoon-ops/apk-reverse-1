local SurfingSceneData = BaseClass("SurfingSceneData")

function SurfingSceneData:__init(config, endZ, startZ, index)
  self.config = config
  self.endZ = endZ
  self.startZ = startZ
  self.index = index
end

function SurfingSceneData:__delete()
  self.config = nil
  self.endZ = nil
  self.startZ = nil
  self.index = nil
end

function SurfingSceneData:GetActualIndex()
  return self.config and self.config:GetActualIndex()
end

function SurfingSceneData:GetId()
  return self.config and self.config:GetId()
end

return SurfingSceneData
