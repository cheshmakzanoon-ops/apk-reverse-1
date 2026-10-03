local GhostParkourSceneInfo = BaseClass("GhostParkourSceneInfo")

function GhostParkourSceneInfo:__init()
  self.sceneId = nil
  self.asset = nil
  self.sizeZ = nil
  self.index = nil
  self.offset = nil
  self.speed_z = nil
  self.farmMonster = nil
  self.groupIndex = nil
  self.groupId = nil
end

function GhostParkourSceneInfo:__delete()
  self.sceneId = nil
  self.asset = nil
  self.sizeZ = nil
  self.index = nil
  self.offset = nil
  self.speed_z = nil
  self.farmMonster = nil
  self.groupIndex = nil
  self.groupId = nil
end

function GhostParkourSceneInfo:SetData(id, asset, sizeZ, index, offset, speed_z, farmMonster, groupIndex, groupId)
  self.sceneId = id
  self.asset = asset
  self.sizeZ = sizeZ
  self.index = index
  self.offset = offset
  self.speed_z = speed_z
  self.farmMonster = farmMonster
  self.groupIndex = groupIndex
  self.groupId = groupId
end

function GhostParkourSceneInfo:GetActualIndex()
  return self.groupIndex
end

function GhostParkourSceneInfo:GetId()
  return self.groupId
end

function GhostParkourSceneInfo:GetSceneId()
  return self.sceneId
end

return GhostParkourSceneInfo
