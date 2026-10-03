local CollectResourceTemplate = BaseClass("CollectResourceTemplate")

function CollectResourceTemplate:__init()
  self.id = 0
  self.resourceType = 0
  self.para = ""
  self.diffPoint = {}
  self.pointId = nil
  self.model = ""
end

function CollectResourceTemplate:__delete()
  self.id = 0
  self.resourceType = 0
  self.para = ""
  self.diffPoint = {}
  self.pointId = nil
  self.model = ""
end

function CollectResourceTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.resourceType = row:getValue("resourceType")
  self.para = row:getValue("para")
  local diffPoint = row:getValue("diffPoint")
  if not string.IsNullOrEmpty(diffPoint) then
    local spl = string.split_ii_array(diffPoint, ",")
    if 2 <= #spl then
      self.diffPoint = Vector2.New(spl[1], spl[2])
    end
  end
  self.model = row:getValue("model")
end

function CollectResourceTemplate:GetPointId()
  if self.pointId == nil then
    local vec = {}
    vec.x = DataCenter.BuildManager.main_city_pos.x + self.diffPoint.x
    vec.y = DataCenter.BuildManager.main_city_pos.y + self.diffPoint.y
    self.pointId = SceneUtils.TilePosToIndex(vec, ForceChangeScene.City)
  end
  return self.pointId
end

function CollectResourceTemplate:GetDistance()
  return math.sqrt(self.diffPoint.x * self.diffPoint.x + self.diffPoint.y * self.diffPoint.y)
end

function CollectResourceTemplate:IsResourceByType(resourceType, itemId)
  local strItemId = itemId == nil and "" or tostring(itemId)
  if self.resourceType == resourceType and strItemId == self.para then
    return true
  end
  return false
end

function CollectResourceTemplate:GetModelName()
  return string.format(LoadPath.CollectResource, self.model)
end

return CollectResourceTemplate
