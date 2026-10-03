local Depot = BaseClass("Depot")

function Depot:__init(index, id, subType, worldCityTableName, serverId)
  self.index = index
  self.subType = subType
  self.id = id
  self.worldCityTableName = worldCityTableName
  self.serverId = serverId
end

function Depot:__delete()
  self.index = nil
  self.subType = nil
  self.id = nil
  self.worldCityTableName = nil
  self.serverId = nil
  self.pos = nil
end

function Depot:GetPos()
  if self.pos then
    return self.pos
  end
  if self.subType == TrainStationType.City then
    local meta = self:GetConfig()
    if meta then
      local pos = SceneUtils.TileToWorld(meta.pos, ForceChangeScene.World, self.serverId)
      self.pos = Vector3.New(pos.x, 0, pos.z)
    else
      self.pos = Vector3.zero
    end
  elseif self.subType == TrainStationType.Main then
    local pos = SceneUtils.TileIndexToWorld(self.id, ForceChangeScene.World, self.serverId)
    self.pos = Vector3.New(pos.x, 0, pos.z)
  end
  return self.pos
end

function Depot:GetName()
  if self.subType == TrainStationType.City then
    local meta = self:GetConfig()
    if meta then
      return meta:GetFullName()
    end
  end
end

function Depot:GetConfig()
  if self.config ~= nil then
    return self.config
  end
  local meta = DataCenter.AllianceCityTemplateManager:GetTemplateByTableName(self.id, self.worldCityTableName)
  if meta == nil then
    meta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.id, self.serverId)
  end
  if meta == nil or meta.name == nil or meta.pos == nil then
    Logger.LogError("AllianceCityTemplate not found , id : " .. tostring(self.id) .. "," .. self.worldCityTableName)
    self.config = false
    return
  end
  self.config = meta
  return self.config
end

function Depot:ToString()
  return string.format("Depot:%s,%s", self.subType == TrainStationType.City and "alCity" or "player", Vector3.ToString(self.pos))
end

return Depot
