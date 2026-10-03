local SurfingSceneInfo = BaseClass("SurfingSceneInfo")

function SurfingSceneInfo:__init()
  self.logic = nil
  self.sceneId = nil
  self.asset = nil
  self.sizeZ = nil
  self.index = nil
  self.offset = nil
  self.speed_z = nil
  self.farmMonster = nil
  self.infiniteMark = nil
  self.groupIndex = nil
  self.groupId = nil
  self.baseTime = nil
  self.baseDistance = nil
  self.startSpeed = nil
  self.endSpeed = nil
end

function SurfingSceneInfo:__delete()
  self.logic = nil
  self.sceneId = nil
  self.asset = nil
  self.sizeZ = nil
  self.index = nil
  self.offset = nil
  self.speed_z = nil
  self.farmMonster = nil
  self.infiniteMark = nil
  self.groupIndex = nil
  self.groupId = nil
  self.baseTime = nil
  self.baseDistance = nil
  self.startSpeed = nil
  self.endSpeed = nil
end

function SurfingSceneInfo:SetData(logic, id, asset, sizeZ, index, offset, speed_z, farmMonster, infiniteMark, groupIndex, groupId, baseTime, baseDistance, startSpeed, endSpeed)
  self.logic = logic
  self.sceneId = id
  self.asset = asset
  self.sizeZ = sizeZ
  self.index = index
  self.offset = offset
  self.speed_z = speed_z
  self.farmMonster = farmMonster
  self.infiniteMark = infiniteMark
  self.groupIndex = groupIndex
  self.groupId = groupId
  self.baseTime = baseTime
  self.baseDistance = baseDistance
  self.startSpeed = startSpeed
  self.endSpeed = endSpeed
end

function SurfingSceneInfo:GetActualIndex()
  return self.groupIndex
end

function SurfingSceneInfo:GetId()
  return self.groupId
end

function SurfingSceneInfo:GetSceneId()
  return self.sceneId
end

return SurfingSceneInfo
