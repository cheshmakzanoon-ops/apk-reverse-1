local GhostParkourSceneData = BaseClass("GhostParkourSceneData")

function GhostParkourSceneData:__init(config, endZ, startZ, index)
  self.config = config
  self.endZ = endZ
  self.startZ = startZ
  self.index = index
end

function GhostParkourSceneData:__delete()
  self.config = nil
  self.endZ = nil
  self.startZ = nil
  self.index = nil
end

function GhostParkourSceneData:GetActualIndex()
  return self.config and self.config:GetActualIndex()
end

function GhostParkourSceneData:GetId()
  return self.config and self.config:GetId()
end

return GhostParkourSceneData
