local WarFlagData = BaseClass("WarFlagData")

function WarFlagData:__init(msg)
  self:ParseData(msg)
end

function WarFlagData:__delete()
  self:Destroy()
end

function WarFlagData:Destroy()
  self.meta = nil
end

function WarFlagData:ParseData(message)
  if message == nil then
    return
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.ownerId then
    self.ownerId = message.ownerId
  end
  if message.allianceId then
    self.allianceId = message.allianceId
  end
  if message.worldId then
    self.worldId = message.worldId
  end
  if message.cfgId then
    self.cfgId = message.cfgId
    self.meta = DataCenter.WarFlagDataManager:GetMeta(self.cfgId)
  end
  if message.pointId then
    self.pointId = message.pointId
    local v2 = SceneUtils.IndexToTilePos(self.pointId, ForceChangeScene.World)
    local unique = SceneUtils.TileToUniqueTile(v2, self.serverId)
    self.x = v2.x
    self.y = v2.y
    self.minX = unique.x - self.meta.halo_radius
    self.minY = unique.y - self.meta.halo_radius
    self.maxX = unique.x + self.meta.halo_radius
    self.maxY = unique.y + self.meta.halo_radius
  end
  if message.endTime then
    self.endTime = message.endTime
  end
  self.releaseName = nil
  if message.avatar and message.avatar.name then
    self.releaseName = message.avatar.name
  end
end

function WarFlagData:SetMeta(meta)
  self.meta = meta
end

function WarFlagData:IsInRange(x, y)
  return x >= self.minX and x <= self.maxX and y >= self.minY and y <= self.maxY
end

function WarFlagData:IsOccupied(pointId, serverId)
  return self.pointId == pointId and self.serverId == serverId
end

function WarFlagData:IsTargetMe()
  if self.meta.target_type == 3 then
    return true
  end
  if self.meta.target_type == 1 then
    return self.allianceId and LuaEntry.Player:GetAllianceUid() == self.allianceId
  end
  if self.meta.target_type == 2 then
    return self.allianceId and LuaEntry.Player:GetAllianceUid() == self.allianceId and LuaEntry.Player:GetUid() ~= self.ownerId
  end
end

function WarFlagData:Description()
  return string.format("[%s,%s]id:%s, oId:%s, meta:%s", self.x, self.y, self.uuid, self.ownerId, self.cfgId)
end

return WarFlagData
