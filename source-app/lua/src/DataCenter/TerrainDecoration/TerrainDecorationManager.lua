local TerrainDecorationManager = BaseClass("TerrainDecorationManager", Singleton)
local BaseExpansionTemplateManager = require("DataCenter.BaseExpansion.BaseExpansionTemplateManager")
local RefreshTime = 0.33

local function __init(self)
  self.showTrees = true
  self.treeRequests = {}
  self.refreshTimer = nil
  EventManager:GetInstance():AddListener(EventId.RefreshTerrainDecoration, self.RefreshTerrainDecorationSignal)
end

local function __delete(self)
  self.showTrees = nil
  self.treeRequests = nil
  self.refreshTimer = nil
  EventManager:GetInstance():RemoveListener(EventId.RefreshTerrainDecoration, self.RefreshTerrainDecorationSignal)
end

local function Startup(self)
end

local function SetTreeRequest(self, x, y, req)
  if self.treeRequests[x] == nil then
    self.treeRequests[x] = {}
  end
  self.treeRequests[x][y] = req
end

local function GetTreeRequest(self, x, y)
  if self.treeRequests[x] == nil then
    return nil
  end
  return self.treeRequests[x][y]
end

local function RefreshTerrainDecorationSignal(str)
  if string.IsNullOrEmpty(str) then
    DataCenter.TerrainDecorationManager:RefreshTrees(false, nil)
  else
    local p = string.split(str, "|")
    local immediate = p[1] == "true"
    local param = p[2]
    DataCenter.TerrainDecorationManager:RefreshTrees(immediate, param)
  end
end

local function RefreshTrees(self, immediate, param)
  if self.refreshTimer ~= nil then
    self.refreshTimer:Stop()
  end
  if immediate then
    self:RefreshTreesInternal(param)
  else
    self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshTreesInternal(param)
      self.refreshTimer = nil
    end, RefreshTime)
  end
end

local function RefreshTreesInternal(self, param)
  local mainTilePos = DataCenter.BuildManager.main_city_pos
  local mainBuildingLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
  if mainBuildingLevelTemplate == nil then
    return
  end
  for _, template in pairs(BaseExpansionTemplateManager:GetTemplateDict()) do
    if template.range == mainBuildingLevelTemplate.offer_range and template.type == BaseExpansionType.Tree then
      local x = mainTilePos.x + template.x
      local y = mainTilePos.y + template.y
      local canPlace = self:CanPlaceTree(x, y, param)
      local treeReq = self:GetTreeRequest(x, y)
      if canPlace and treeReq == nil then
        self:CreateTree(x, y, template.tree)
      elseif not canPlace and treeReq ~= nil then
        self:DestroyTree(x, y)
      end
    end
  end
end

local function CanPlaceTree(self, x, y, param)
  if param ~= nil then
    local rect = string.split(param, ";")
    if x >= tonumber(rect[1]) and x <= tonumber(rect[2]) and y >= tonumber(rect[3]) and y <= tonumber(rect[4]) then
      return false
    end
  end
  local pointId = SceneUtils.TilePosToIndex({x = x, y = y})
  if CS.SceneManager.World:HasPointInfo(pointId) then
    return false
  end
  return true
end

local function CreateTree(self, x, y, treeType)
  local prefab_path = string.format(LoadPath.DecorationTreePath, treeType)
  local request = CS.GameEntry.Resource:InstantiateAsync(prefab_path)
  request:completed("+", function()
    local worldPos = SceneUtils.TileToWorld({x = x, y = y})
    if request.isError or request.gameObject == nil then
      return
    end
    local tf = request.gameObject.transform
    request.gameObject:SetActive(self.showTrees)
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf:Set_position(worldPos.x, worldPos.y, worldPos.z)
  end)
  self:SetTreeRequest(x, y, request)
end

local function DestroyTree(self, x, y)
  local request = self:GetTreeRequest(x, y)
  if request ~= nil then
    request:Destroy()
  end
  self:SetTreeRequest(x, y, nil)
end

local function DestroyAllTrees(self)
  for _, line in pairs(self.treeRequests) do
    for _, req in pairs(line) do
      req:Destroy()
    end
  end
  self.treeRequests = {}
end

local function ShowAllTrees(self)
  self.showTrees = true
  for i, _ in pairs(self.treeRequests) do
    for j, _ in pairs(self.treeRequests[i]) do
      self.treeRequests[i][j].gameObject:SetActive(true)
    end
  end
end

local function HideAllTrees(self)
  self.showTrees = false
  for i, _ in pairs(self.treeRequests) do
    for j, _ in pairs(self.treeRequests[i]) do
      self.treeRequests[i][j].gameObject:SetActive(false)
    end
  end
end

TerrainDecorationManager.__init = __init
TerrainDecorationManager.__delete = __delete
TerrainDecorationManager.SetTreeRequest = SetTreeRequest
TerrainDecorationManager.GetTreeRequest = GetTreeRequest
TerrainDecorationManager.Startup = Startup
TerrainDecorationManager.RefreshTerrainDecorationSignal = RefreshTerrainDecorationSignal
TerrainDecorationManager.RefreshTrees = RefreshTrees
TerrainDecorationManager.RefreshTreesInternal = RefreshTreesInternal
TerrainDecorationManager.CanPlaceTree = CanPlaceTree
TerrainDecorationManager.CreateTree = CreateTree
TerrainDecorationManager.DestroyTree = DestroyTree
TerrainDecorationManager.DestroyAllTrees = DestroyAllTrees
TerrainDecorationManager.ShowAllTrees = ShowAllTrees
TerrainDecorationManager.HideAllTrees = HideAllTrees
return TerrainDecorationManager
