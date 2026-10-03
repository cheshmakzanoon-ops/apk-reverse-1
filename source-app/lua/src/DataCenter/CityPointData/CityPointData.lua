local CityPointData = BaseClass("CityPointData")

local function __init(self)
  self.uuid = 0
  self.pointId = 0
  self.type = 0
  self.itemId = ""
  self.size = Vector2.New(0, 0)
  self.rewardList = {}
end

local function __delete(self)
  self.uuid = nil
  self.pointId = nil
  self.type = nil
  self.itemId = nil
  self.size = nil
  self.rewardList = nil
end

local function SetData(self, data)
  if data == nil then
    return
  end
  self.uuid = tonumber(data.uuid)
  self.pointId = tonumber(data.pointId)
  self.type = tonumber(data.type)
  self.itemId = data.itemId
  self.size = Vector2.New(1, 1)
  if data.type == CityPointType.Garbage then
    local template = DataCenter.SingleMapJunkTemplateManager:GetTemplate(data.itemId)
    self.size.x = template.scale.x
    self.size.y = template.scale.y
  end
  self.rewardList = data.reward
end

local function GetCenterWorldPos(self)
  local tr = CS.SceneManager.World.TileIndexToWorld(pointId)
  local bl = CS.SceneManager.World.TileIndexToWorld(SceneManager.World.GetIndexByOffset(pointId, -size.x, -size.y))
  return (tr + bl) / 2
end

CityPointData.__init = __init
CityPointData.__delete = __delete
CityPointData.SetData = SetData
CityPointData.GetCenterWorldPos = GetCenterWorldPos
return CityPointData
