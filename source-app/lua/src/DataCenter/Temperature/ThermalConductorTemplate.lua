local ThermalConductorTemplate = BaseClass("ThermalConductorTemplate")

function ThermalConductorTemplate:__init()
end

function ThermalConductorTemplate:__delete()
  if self.freeze_picture then
    self.freeze_picture:Delete()
    self.freeze_picture = nil
  end
end

function ThermalConductorTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id"))
  self.type = row:getValue("type")
  self.freeze_time = row:getValue("freeze_time") * 60
  self.ice_wall = row:getValue("ice_wall")
  self.freeze_picture = StringPool.New(row:getValue("freeze_picture"), ";")
  self.freeze_status_info = row:getValue("freeze_status_info")
  self.fire_status_info = row:getValue("fire_status_info")
end

function ThermalConductorTemplate:GetIcePrefabPath(buildUuid)
  local name = self.freeze_picture:GetRandomStable(buildUuid)
  return string.format("Assets/_Art_LastWar/Models/Environment/Build/S2saiji_bingkuai/prefab/%s.prefab", name)
end

return ThermalConductorTemplate
