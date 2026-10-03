local CollectResourceManager = BaseClass("CollectResourceManager")
local ResourceManager = CS.GameEntry.Resource

function CollectResourceManager:__init()
  self:AddListener()
  self.collectResourceTile = nil
  self.collectResourceRange = nil
  self.allCollect = {}
  self.allCollectRange = {}
  self.guidPoint = nil
end

function CollectResourceManager:__delete()
  self:RemoveListener()
  self.collectResourceTile = nil
  self.collectResourceRange = nil
  self.allCollect = {}
  self.allCollectRange = {}
  self.guidPoint = nil
end

function CollectResourceManager:Startup()
end

function CollectResourceManager:AddListener()
end

function CollectResourceManager:RemoveListener()
end

function CollectResourceManager:ShowGreenBlocks(pointId)
end

function CollectResourceManager:GetCollectResourceTile()
  if self.collectResourceTile == nil then
    self.collectResourceTile = LuaEntry.DataConfig:TryGetNum("collect_resource_birth", "k1")
  end
  return self.collectResourceTile
end

function CollectResourceManager:GetCollectResourceRange()
  if self.collectResourceRange == nil then
    self.collectResourceRange = LuaEntry.DataConfig:TryGetNum("collect_resource_birth", "k2")
  end
  return self.collectResourceRange
end

function CollectResourceManager:GetCollectResourceBuildRange()
  return BuildingUtils.GetCircleRange(self:GetCollectResourceRange()) - BuildingUtils.GetCircleRange(self:GetCollectResourceTile()) + 1
end

function CollectResourceManager:GetAllCollectPointByCollectPoint(index)
  local result = {}
  local collectSelf = BuildingUtils.GetCircleRange(self:GetCollectResourceTile())
  for i = 0, collectSelf do
    local list = BuildingUtils.GetOutermostIndexByIndex(index, i, collectSelf, collectSelf, ForceChangeScene.City)
    if list ~= nil then
      for k, v in ipairs(list) do
        table.insert(result, v)
      end
    end
  end
  return result
end

function CollectResourceManager:GetAllCollectRangePoint(index)
  local result = {}
  local collectSelf = BuildingUtils.GetCircleRange(self:GetCollectResourceTile())
  local collectRange = BuildingUtils.GetCircleRange(self:GetCollectResourceRange())
  for i = collectSelf + 1, collectRange do
    local list = BuildingUtils.GetOutermostIndexByIndex(index, i, collectRange, collectRange, ForceChangeScene.City)
    if list ~= nil then
      for k, v in ipairs(list) do
        table.insert(result, v)
      end
    end
  end
  return result
end

function CollectResourceManager:GetNearestResourcePointByResourceType(resourceType, itemId)
  local list = DataCenter.CollectResourceTemplateManager:GetAllTemplateByResourceType(resourceType, itemId)
  local count = #list
  if count == 1 then
    return list[1]:GetPointId()
  elseif 1 < count then
    local result = {}
    for k, v in ipairs(list) do
      local param = {}
      param.pointId = v:GetPointId()
      param.dis = v:GetDistance()
      table.insert(result, param)
    end
    table.sort(result, function(a, b)
      return a.dis < b.dis
    end)
    return result[1].pointId
  end
end

function CollectResourceManager:GetResourcePointInfoByIndex(index)
  return self.allCollect[index]
end

function CollectResourceManager:GetAllCanPlantResourcePointInOneRange(index, buildId, buildUuid)
  local pointInfo = self:GetCollectRangeInfoByIndex(index)
  local result = {}
  if pointInfo ~= nil then
    table.walk(self.allCollectRange, function(k, v)
      if v.pointId == pointInfo.pointId then
        local putState = BuildingUtils.IsCanPutDownByBuild(buildId, k, buildUuid)
        if putState == BuildPutState.Ok then
          table.insert(result, k)
        end
      end
    end)
  end
  return result
end

function CollectResourceManager:GetAllMinePoints()
  local tmp = {}
  table.walk(self.allCollectRange, function(k, v)
    table.insert(tmp, k)
  end)
  table.walk(self.allCollect, function(k, v)
    table.insert(tmp, k)
  end)
  return tmp
end

function CollectResourceManager:GetMineMainPoints()
  local tmp = {}
  table.walk(self.allCollectRange, function(k, v)
    tmp[v.pointId] = 1
  end)
  return table.keys(tmp)
end

function CollectResourceManager:GetCollectRangeInfoByIndex(index)
  return self.allCollectRange[index]
end

function CollectResourceManager:InitCollectPoint()
  self.allCollect = {}
  self.allCollectRange = {}
  local list = DataCenter.CollectResourceTemplateManager:GetAllTemplate()
  for k, v in pairs(list) do
    local pointId = v:GetPointId()
    local pointList = self:GetAllCollectPointByCollectPoint(pointId)
    for k1, v1 in ipairs(pointList) do
      self.allCollect[v1] = v
    end
    local ranges = self:GetAllCollectRangePoint(pointId)
    for k1, v1 in ipairs(ranges) do
      self.allCollectRange[v1] = v
    end
  end
end

function CollectResourceManager:GetShowObjectModelParam()
  local result = {}
  local list = DataCenter.CollectResourceTemplateManager:GetAllTemplate()
  for k, v in pairs(list) do
    local param = {}
    param.pointId = v:GetPointId()
    param.modelName = v:GetModelName()
    param.resourceType = v.resourceType
    param.itemId = v.para
    table.insert(result, param)
  end
  return result
end

function CollectResourceManager:SetFindResPoint(pointId)
  self.guidPoint = pointId
end

function CollectResourceManager:GetFindResPoint()
  return self.guidPoint
end

return CollectResourceManager
