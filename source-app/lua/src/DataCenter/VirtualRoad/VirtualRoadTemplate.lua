local VirtualRoadTemplate = BaseClass("VirtualRoadTemplate")

local function __init(self)
  self.id = 0
  self.prefabName = ""
  self.type = 0
  self.pos = {x = 0, y = 0}
  self.size = {x = 0, y = 0}
  self.rotate = 0
end

local function __delete(self)
  self.id = nil
  self.prefabName = nil
  self.type = nil
  self.pos = nil
  self.size = nil
  self.rotate = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.prefabName = row:getValue("model") or ""
  self.type = tonumber(row:getValue("type")) or 0
  local posStrs = string.split(row:getValue("Pos") or "", ";")
  if #posStrs == 2 then
    self.pos.x = tonumber(posStrs[1]) or 0
    self.pos.y = tonumber(posStrs[2]) or 0
  end
  local sizeStrs = string.split(row:getValue("size") or "", ";")
  if #sizeStrs == 2 then
    self.size.x = tonumber(sizeStrs[1]) or 0
    self.size.y = tonumber(sizeStrs[2]) or 0
  end
  self.rotate = tonumber(row:getValue("rotate")) or 0
end

local function GetPointId(self)
  local tilePosX = DataCenter.BuildManager.main_city_pos.x + 1 + self.pos.x
  local tilePosY = DataCenter.BuildManager.main_city_pos.y + 1 + self.pos.y
  return SceneUtils.TileXYToIndex(tilePosX, tilePosY)
end

VirtualRoadTemplate.__init = __init
VirtualRoadTemplate.__delete = __delete
VirtualRoadTemplate.InitData = InitData
VirtualRoadTemplate.GetPointId = GetPointId
return VirtualRoadTemplate
