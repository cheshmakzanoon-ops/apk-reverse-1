local VirtualRoadManager = BaseClass("VirtualRoadManager")
local VirtualRoadTemplate = require("DataCenter.VirtualRoad.VirtualRoadTemplate")
local Resource = CS.GameEntry.Resource
local PrefabPath = "Assets/_Art/Models/Environment/Build/TuDi/prefab/%s.prefab"

local function __init(self)
  self.templateDict = {}
  self.resTypes = {}
  self.showTypes = {}
  self.reqs = {}
  LocalController:instance():visitTable(TableName.VirtualRoad, function(_, line)
    local template = VirtualRoadTemplate.New()
    template:InitData(line)
    self.templateDict[template.id] = template
  end)
  for _, template in pairs(DataCenter.CollectResourceTemplateManager:GetAllTemplate()) do
    local types = {}
    if template.diffPoint.x < 0 and 0 > template.diffPoint.y then
      types = {2, 6}
    elseif template.diffPoint.x > 0 and 0 > template.diffPoint.y then
      types = {4, 6}
    elseif template.diffPoint.x < 0 and 0 < template.diffPoint.y then
      types = {1, 5}
    elseif template.diffPoint.x > 0 and 0 < template.diffPoint.y then
      types = {3, 5}
    end
    self.resTypes[template.resourceType] = types
  end
  self:AddListeners()
end

local function __delete(self)
  self.templateDict = nil
  self.resTypes = nil
  self.showTypes = nil
  self.reqs = nil
  self:RemoveListeners()
end

local function AddListeners(self)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
end

local function RemoveListeners(self)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnPveLevelEnter)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.OnPveLevelExit)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.OnUpdateBuildData)
end

local function Startup(self)
  self:RefreshShowTypes()
  self:RefreshRoads()
end

local function GetTemplate(self, id)
  return self.templateDict[id]
end

local function RefreshShowTypes(self)
  self.showTypes = {}
  for resType, types in pairs(self.resTypes) do
    local show = true
    local buildId = self:GetBuildIdByResType(resType)
    local buildDataList = buildId and DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
    if buildDataList then
      for _, buildData in ipairs(buildDataList) do
        if buildData ~= nil then
          show = false
          break
        end
      end
    end
    for _, type in ipairs(types) do
      self.showTypes[type] = show
    end
  end
end

local function RefreshRoads(self)
  if CS.SceneManager.IsInPVE() or CS.SceneManager.World == nil then
    return
  end
  for id, template in pairs(self.templateDict) do
    if self.showTypes[template.type] then
      self:CreateOneRoad(id)
    else
      self:DestroyOneRoad(id)
    end
  end
end

local function ClearRoads(self)
  for id, _ in pairs(self.templateDict) do
    self:DestroyOneRoad(id)
  end
end

local function CreateOneRoad(self, id)
  if self.reqs[id] ~= nil then
    return
  end
  local template = self:GetTemplate(id)
  self.reqs[id] = Resource:InstantiateAsync(string.format(PrefabPath, template.prefabName))
  self.reqs[id]:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go:SetActive(true)
    go.name = "VirtualRoad_" .. id
    tf:SetParent(CS.SceneManager.World.DynamicObjNode)
    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    tf.position = SceneUtils.TileIndexToWorld(template:GetPointId())
    tf.rotation = Quaternion.Euler(0, template.rotate, 0)
    local adjuster = go:GetComponent(typeof(CS.AutoAdjustLod))
    if adjuster ~= nil then
      adjuster.enabled = true
    end
  end)
end

local function DestroyOneRoad(self, id)
  if self.reqs[id] == nil then
    return
  end
  self.reqs[id]:Destroy()
  self.reqs[id] = nil
end

local function GetBuildIdByResType(self, resType)
  local buildIds = {}
  if 10000 <= resType then
    buildIds = DataCenter.BuildManager:GetBuildTypesByOutResourceType(ResourceType.ResourceItem, resType)
  else
    buildIds = DataCenter.BuildManager:GetBuildTypesByOutResourceType(resType)
  end
  if table.IsNullOrEmpty(buildIds) then
    return nil
  else
    return buildIds[1]
  end
end

local function OnPveLevelEnter()
  DataCenter.VirtualRoadManager:ClearRoads()
end

local function OnPveLevelExit()
  DataCenter.VirtualRoadManager:RefreshRoads()
end

local function OnEnterWorld()
  DataCenter.VirtualRoadManager:ClearRoads()
end

local function OnEnterCity()
  DataCenter.VirtualRoadManager:RefreshRoads()
end

local function OnUpdateBuildData()
  DataCenter.VirtualRoadManager:RefreshShowTypes()
  DataCenter.VirtualRoadManager:RefreshRoads()
end

VirtualRoadManager.__init = __init
VirtualRoadManager.__delete = __delete
VirtualRoadManager.AddListeners = AddListeners
VirtualRoadManager.RemoveListeners = RemoveListeners
VirtualRoadManager.Startup = Startup
VirtualRoadManager.GetTemplate = GetTemplate
VirtualRoadManager.RefreshShowTypes = RefreshShowTypes
VirtualRoadManager.RefreshRoads = RefreshRoads
VirtualRoadManager.ClearRoads = ClearRoads
VirtualRoadManager.CreateOneRoad = CreateOneRoad
VirtualRoadManager.DestroyOneRoad = DestroyOneRoad
VirtualRoadManager.GetBuildIdByResType = GetBuildIdByResType
VirtualRoadManager.OnPveLevelEnter = OnPveLevelEnter
VirtualRoadManager.OnPveLevelExit = OnPveLevelExit
VirtualRoadManager.OnEnterWorld = OnEnterWorld
VirtualRoadManager.OnEnterCity = OnEnterCity
VirtualRoadManager.OnUpdateBuildData = OnUpdateBuildData
return VirtualRoadManager
