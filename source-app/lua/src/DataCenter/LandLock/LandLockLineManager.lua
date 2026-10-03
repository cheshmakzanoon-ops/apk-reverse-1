local LandLockLineManager = BaseClass("LandLockLineManager")
local Resource = CS.GameEntry.Resource
local LinePrefabPath = "Assets/_Art/Models/Environment/Interactive/JieSuoDiKuai_ui/prefab/O_env_xuxian_line_%s.prefab"
local LineType = {H = 1, V = 2}
local LineTypes = {
  LineType.H,
  LineType.V
}
local LineOffsets = {
  [LineType.H] = Vector3.New(0, 0.1, 1),
  [LineType.V] = Vector3.New(1, 0.1, 0)
}
local CornerType = {
  NONE = 0,
  TR = 1,
  TL = 2,
  BL = 3,
  BR = 4,
  ALL = 5
}
local CornerPrefabPath = "Assets/_Art/Models/Environment/Interactive/JieSuoDiKuai_ui/prefab/O_env_xuxian_corner_%s.prefab"
local CornerOffsets = {
  [CornerType.TR] = Vector3.New(-1, 0.11, -1),
  [CornerType.TL] = Vector3.New(1, 0.11, -1),
  [CornerType.BL] = Vector3.New(1, 0.11, 1),
  [CornerType.BR] = Vector3.New(-1, 0.11, 1),
  [CornerType.ALL] = Vector3.New(1, 0.11, 1)
}
local MainRoadCoords = {47, 49}

local function __init(self)
  self.canShowLineCache = {
    {},
    {}
  }
  self.landLockIdToPointIds = {
    {},
    {}
  }
  self.pointIdToLandLockIds = {
    {},
    {}
  }
  self.lineReqs = {
    {},
    {}
  }
  self.cornerTypeCache = {}
  self.landLockIdToCornerPointIds = {}
  self.cornerPointIdToLandLockIds = {}
  self.cornerReqs = {}
  for _, template in pairs(DataCenter.LandLockManager.templateDict) do
    local id = template.id
    local tops, bottoms, rights, lefts = {}, {}, {}, {}
    for _, tile in ipairs(template:GetBoundingRectTiles()) do
      local x = tile.x + DataCenter.BuildManager.main_city_pos.x
      local y = tile.y + DataCenter.BuildManager.main_city_pos.y
      tops[x] = tops[x] == nil and y or math.max(tops[x], y)
      bottoms[x] = bottoms[x] == nil and y - 1 or math.min(bottoms[x], y - 1)
      rights[y] = rights[y] == nil and x or math.max(rights[y], x)
      lefts[y] = lefts[y] == nil and x - 1 or math.min(lefts[y], x - 1)
    end
    self.landLockIdToPointIds[LineType.H][id] = {}
    self.landLockIdToPointIds[LineType.V][id] = {}
    for x, y in pairs(tops) do
      local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.City)
      if self.pointIdToLandLockIds[LineType.H][pointId] == nil then
        self.pointIdToLandLockIds[LineType.H][pointId] = {}
      end
      table.insert(self.landLockIdToPointIds[LineType.H][id], pointId)
      table.insert(self.pointIdToLandLockIds[LineType.H][pointId], id)
    end
    for x, y in pairs(bottoms) do
      local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.City)
      if self.pointIdToLandLockIds[LineType.H][pointId] == nil then
        self.pointIdToLandLockIds[LineType.H][pointId] = {}
      end
      table.insert(self.landLockIdToPointIds[LineType.H][id], pointId)
      table.insert(self.pointIdToLandLockIds[LineType.H][pointId], id)
    end
    for y, x in pairs(rights) do
      local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.City)
      if self.pointIdToLandLockIds[LineType.V][pointId] == nil then
        self.pointIdToLandLockIds[LineType.V][pointId] = {}
      end
      table.insert(self.landLockIdToPointIds[LineType.V][id], pointId)
      table.insert(self.pointIdToLandLockIds[LineType.V][pointId], id)
    end
    for y, x in pairs(lefts) do
      local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.City)
      if self.pointIdToLandLockIds[LineType.V][pointId] == nil then
        self.pointIdToLandLockIds[LineType.V][pointId] = {}
      end
      table.insert(self.landLockIdToPointIds[LineType.V][id], pointId)
      table.insert(self.pointIdToLandLockIds[LineType.V][pointId], id)
    end
    local xMin, xMax, yMin, yMax = template:GetBoundingRect()
    xMin = xMin + DataCenter.BuildManager.main_city_pos.x
    xMax = xMax + DataCenter.BuildManager.main_city_pos.x
    yMin = yMin + DataCenter.BuildManager.main_city_pos.y
    yMax = yMax + DataCenter.BuildManager.main_city_pos.y
    self.landLockIdToCornerPointIds[id] = {}
    for _, x in ipairs({
      xMin - 1,
      xMin,
      xMax,
      xMax + 1
    }) do
      for _, y in ipairs({
        yMin - 1,
        yMin,
        yMax,
        yMax + 1
      }) do
        local pointId = SceneUtils.TileXYToIndex(x, y, ForceChangeScene.City)
        if self.cornerPointIdToLandLockIds[pointId] == nil then
          self.cornerPointIdToLandLockIds[pointId] = {}
        end
        table.insert(self.landLockIdToCornerPointIds[id], pointId)
        table.insert(self.cornerPointIdToLandLockIds[pointId], id)
      end
    end
  end
  self:AddListeners()
end

local function __delete(self)
  self.canShowLineCache = nil
  self.landLockIdToPointIds = nil
  self.pointIdToLandLockIds = nil
  self.lineReqs = nil
  self.cornerTypeCache = nil
  self.landLockIdToCornerPointIds = nil
  self.cornerPointIdToLandLockIds = nil
  self.cornerReqs = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.DomeRangeChanged, self.OnDomeRangeChanged)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.DomeRangeChanged, self.OnDomeRangeChanged)
end

local function Enabled(self)
  return not DataCenter.CityPioneerManager:IsBeforePrologue() and DataCenter.CityDomeManager:GetDomeRangeCache() ~= DomeRange.Zero and CS.SceneManager.IsInCity() and CS.SceneManager.World ~= nil
end

local function RefreshAll(self, clearCache)
  if not self:Enabled() then
    return
  end
  self:RefreshAllLine(clearCache)
  self:RefreshAllCorner(clearCache)
end

local function RefreshByLandLockId(self, id, clearCache)
  if not self:Enabled() then
    return
  end
  self:RefreshLineByLandLockId(id, clearCache)
  self:RefreshCornerByLandLockId(id, clearCache)
end

local function DestroyAll(self)
  self:DestroyAllLine()
  self:DestroyAllCorner()
end

local function RefreshAllLine(self, clearCache)
  for _, lineType in ipairs(LineTypes) do
    for pointId, _ in pairs(self.pointIdToLandLockIds[lineType]) do
      self:RefreshLine(lineType, pointId, clearCache)
    end
  end
end

local function RefreshLineByLandLockId(self, id, clearCache)
  for _, lineType in ipairs(LineTypes) do
    for _, pointId in pairs(self.landLockIdToPointIds[lineType][id]) do
      self:RefreshLine(lineType, pointId, clearCache)
    end
  end
end

local function RefreshLine(self, lineType, pointId, clearCache)
  if self:CanShowLine(lineType, pointId, clearCache) then
    if self.lineReqs[lineType][pointId] ~= nil then
      self:CullLine(lineType, pointId)
    else
      self:CreateLine(lineType, pointId)
    end
  else
    self:DestroyLine(lineType, pointId)
  end
end

local function DestroyAllLine(self)
  for _, lineType in ipairs(LineTypes) do
    for pointId, _ in pairs(self.pointIdToLandLockIds[lineType]) do
      self:DestroyLine(lineType, pointId)
    end
  end
end

local function CanShowLine(self, lineType, pointId, clearCache)
  if clearCache then
    self.canShowLineCache[lineType][pointId] = nil
  end
  if self.canShowLineCache[lineType][pointId] ~= nil then
    return self.canShowLineCache[lineType][pointId]
  end
  local show = true
  local tilePos = SceneUtils.IndexToTilePos(pointId)
  if show and (lineType == LineType.H and table.hasvalue(MainRoadCoords, tilePos.y) or lineType == LineType.V and table.hasvalue(MainRoadCoords, tilePos.x)) then
    show = false
  end
  if show then
    local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City) + LineOffsets[lineType]
    if not DataCenter.CityDomeManager:IsInDome(worldPos) then
      show = false
    end
  end
  if show then
    local locked = false
    local landLockIds = self.pointIdToLandLockIds[lineType][pointId] or {}
    for _, id in ipairs(landLockIds) do
      local data = DataCenter.LandLockManager:GetLandLockDataById(id)
      if data.state == LandLockState.Locked or data.state == LandLockState.Hide then
        locked = true
        break
      end
    end
    if not locked then
      show = false
    end
  end
  self.canShowLineCache[lineType][pointId] = show
  return show
end

local function ClearCanShowLineCache(self)
  self.canShowLineCache = {
    {},
    {}
  }
end

local function CullLine(self, lineType, pointId)
  if not self:HasLine(lineType, pointId) or IsNull(self.lineReqs[lineType][pointId].gameObject) then
    return
  end
  local range = DataCenter.CityDomeManager:GetDomeRangeCache()
  local exRadius = LandLockDomeExRadius[range]
  local lineTf = self.lineReqs[lineType][pointId].gameObject.transform
  for i = 0, lineTf.childCount - 1 do
    local tf = lineTf:GetChild(i)
    local show = DataCenter.CityDomeManager:IsInDome(tf.position, exRadius)
    if tf.gameObject.activeSelf ~= show then
      tf.gameObject:SetActive(show)
    end
  end
end

local function CreateLine(self, lineType, pointId)
  if self:HasLine(lineType, pointId) then
    return
  end
  self.lineReqs[lineType][pointId] = Resource:InstantiateAsync(string.format(LinePrefabPath, lineType))
  self.lineReqs[lineType][pointId]:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.name = string.format("LandLockLine_%s_%s", lineType == 1 and "H" or "V", pointId)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City) + LineOffsets[lineType]
    go.transform.localScale = Vector3.one
    self:CullLine(lineType, pointId)
  end)
end

local function DestroyLine(self, lineType, pointId)
  if not self:HasLine(lineType, pointId) then
    return
  end
  self.lineReqs[lineType][pointId]:Destroy()
  self.lineReqs[lineType][pointId] = nil
end

local function HasLine(self, lineType, pointId)
  return self.lineReqs[lineType][pointId] ~= nil
end

local function RefreshAllCorner(self, clearCache)
  for pointId, _ in pairs(self.cornerPointIdToLandLockIds) do
    self:RefreshCorner(pointId, clearCache)
  end
end

local function RefreshCornerByLandLockId(self, id, clearCache)
  for _, pointId in pairs(self.landLockIdToCornerPointIds[id]) do
    self:RefreshCorner(pointId, clearCache)
  end
end

local function RefreshCorner(self, pointId, clearCache)
  local cornerType = self:GetCornerType(pointId, clearCache)
  if cornerType ~= CornerType.NONE then
    if self.cornerReqs[pointId] ~= nil then
      self:CullCorner(pointId)
    else
      self:CreateCorner(cornerType, pointId)
    end
  else
    self:DestroyCorner(pointId)
  end
end

local function DestroyAllCorner(self)
  for pointId, _ in pairs(self.cornerPointIdToLandLockIds) do
    self:DestroyCorner(pointId)
  end
end

local function GetCornerType(self, pointId, clearCache)
  if clearCache then
    self.cornerTypeCache[pointId] = nil
  end
  if self.cornerTypeCache[pointId] ~= nil then
    return self.cornerTypeCache[pointId]
  end
  local ids = {
    [-1] = {},
    [0] = {}
  }
  for i = -1, 0 do
    for j = -1, 0 do
      ids[i][j] = SceneUtils.GetIndexByOffset(pointId, i, j, ForceChangeScene.City)
    end
  end
  local cornerType
  if self:CanShowCornerStar(pointId) then
    cornerType = CornerType.ALL
  elseif self:CanShowCornerStar(ids[-1][0]) or self:CanShowCornerStar(ids[-1][-1]) or self:CanShowCornerStar(ids[0][-1]) then
    cornerType = CornerType.NONE
  elseif self:HasLine(LineType.H, ids[0][-1]) and self:HasLine(LineType.V, ids[-1][0]) then
    cornerType = CornerType.TR
  elseif self:HasLine(LineType.H, ids[0][-1]) and self:HasLine(LineType.V, ids[0][0]) then
    cornerType = CornerType.TL
  elseif self:HasLine(LineType.H, ids[0][0]) and self:HasLine(LineType.V, ids[0][0]) then
    cornerType = CornerType.BL
  elseif self:HasLine(LineType.H, ids[0][0]) and self:HasLine(LineType.V, ids[-1][0]) then
    cornerType = CornerType.BR
  else
    cornerType = CornerType.NONE
  end
  self.cornerTypeCache[pointId] = cornerType
  return cornerType
end

local function ClearCornerTypeCache(self)
  self.cornerTypeCache = {}
end

local function CullCorner(self, pointId)
  if self.cornerReqs[pointId] == nil or IsNull(self.cornerReqs[pointId].gameObject) then
    return
  end
  local range = DataCenter.CityDomeManager:GetDomeRangeCache()
  local exRadius = LandLockDomeExRadius[range]
  local cornerGo = self.cornerReqs[pointId].gameObject
  local show = DataCenter.CityDomeManager:IsInDome(cornerGo.transform.position, exRadius)
  if cornerGo.activeSelf ~= show then
    cornerGo:SetActive(show)
  end
end

local function CreateCorner(self, cornerType, pointId)
  if self.cornerReqs[pointId] ~= nil then
    return
  end
  self.cornerReqs[pointId] = Resource:InstantiateAsync(string.format(CornerPrefabPath, cornerType))
  self.cornerReqs[pointId]:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    go.name = string.format("LandLockCorner_%s", pointId)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    go.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.City) + CornerOffsets[cornerType]
    self:CullCorner(pointId)
  end)
end

local function DestroyCorner(self, pointId)
  if self.cornerReqs[pointId] == nil then
    return
  end
  self.cornerReqs[pointId]:Destroy()
  self.cornerReqs[pointId] = nil
end

local function CanShowCornerStar(self, pointId)
  local topPointId = SceneUtils.GetIndexByOffsetY(pointId, 1, ForceChangeScene.City)
  local rightPointId = SceneUtils.GetIndexByOffsetX(pointId, 1, ForceChangeScene.City)
  return self:HasLine(LineType.H, pointId) and self:HasLine(LineType.H, rightPointId) and self:HasLine(LineType.V, pointId) and self:HasLine(LineType.V, topPointId)
end

local function OnPveLevelEnter()
  DataCenter.LandLockLineManager:DestroyAll()
end

local function OnPveLevelExit()
  DataCenter.LandLockLineManager:RefreshAll()
end

local function OnEnterCity()
  DataCenter.LandLockLineManager:RefreshAll()
end

local function OnDomeRangeChanged()
  DataCenter.LandLockLineManager:RefreshAll(true)
end

LandLockLineManager.__init = __init
LandLockLineManager.__delete = __delete
LandLockLineManager.AddListeners = AddListeners
LandLockLineManager.RemoveListeners = RemoveListeners
LandLockLineManager.Enabled = Enabled
LandLockLineManager.RefreshAll = RefreshAll
LandLockLineManager.RefreshByLandLockId = RefreshByLandLockId
LandLockLineManager.DestroyAll = DestroyAll
LandLockLineManager.RefreshAllLine = RefreshAllLine
LandLockLineManager.RefreshLineByLandLockId = RefreshLineByLandLockId
LandLockLineManager.RefreshLine = RefreshLine
LandLockLineManager.DestroyAllLine = DestroyAllLine
LandLockLineManager.CanShowLine = CanShowLine
LandLockLineManager.ClearCanShowLineCache = ClearCanShowLineCache
LandLockLineManager.CullLine = CullLine
LandLockLineManager.CreateLine = CreateLine
LandLockLineManager.DestroyLine = DestroyLine
LandLockLineManager.HasLine = HasLine
LandLockLineManager.RefreshAllCorner = RefreshAllCorner
LandLockLineManager.RefreshCornerByLandLockId = RefreshCornerByLandLockId
LandLockLineManager.RefreshCorner = RefreshCorner
LandLockLineManager.DestroyAllCorner = DestroyAllCorner
LandLockLineManager.GetCornerType = GetCornerType
LandLockLineManager.ClearCornerTypeCache = ClearCornerTypeCache
LandLockLineManager.CullCorner = CullCorner
LandLockLineManager.CreateCorner = CreateCorner
LandLockLineManager.DestroyCorner = DestroyCorner
LandLockLineManager.CanShowCornerStar = CanShowCornerStar
LandLockLineManager.OnPveLevelEnter = OnPveLevelEnter
LandLockLineManager.OnPveLevelExit = OnPveLevelExit
LandLockLineManager.OnEnterCity = OnEnterCity
LandLockLineManager.OnDomeRangeChanged = OnDomeRangeChanged
return LandLockLineManager
