local CityZoneTemplate = BaseClass("CityZoneTemplate")

function CityZoneTemplate:__init()
  self.id = 0
  self.zone_type = 0
  self.pos = {}
  self.pointId = nil
end

function CityZoneTemplate:__delete()
  self.id = 0
  self.zone_type = 0
  self.pos = {}
  self.pointId = nil
end

function CityZoneTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.zone_type = row:getValue("zone_type")
  local pos = row:getValue("pos")
  if not string.IsNullOrEmpty(pos) then
    local spl = string.split_ii_array(pos, ",")
    if 2 <= #spl then
      self.pos = Vector2.New(spl[1], spl[2])
    end
  end
end

function CityZoneTemplate:GetPointId()
  if self.pointId == nil then
    local vec = {}
    vec.x = DataCenter.BuildManager.main_city_pos.x + self.pos.x
    vec.y = DataCenter.BuildManager.main_city_pos.y + self.pos.y
    self.pointId = SceneUtils.TilePosToIndex(vec, ForceChangeScene.City)
  end
  return self.pointId
end

function CityZoneTemplate:CanPutByZoneType(zoneType)
  if self.zone_type == BuildZoneType.No then
    return false
  end
  if zoneType == BuildZoneType.All then
    return true
  end
  if self.zone_type == BuildZoneType.All and zoneType ~= BuildZoneType.SeasonBuild then
    return true
  end
  return zoneType == self.zone_type
end

return CityZoneTemplate
