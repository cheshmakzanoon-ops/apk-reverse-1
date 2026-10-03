local CityZoneManager = BaseClass("CityZoneManager")
local Localization = CS.GameEntry.Localization
local GameObject = CS.UnityEngine.GameObject
local PerZoneRange = Vector2.New(2, 0.5)

function CityZoneManager:__init()
  self.allZonePoint = {}
  self.zoneTypePoint = {}
  self.buildZoneTypePoint = {}
  self:AddListener()
end

function CityZoneManager:__delete()
  self.allZonePoint = {}
  self.zoneTypePoint = {}
  self.buildZoneTypePoint = {}
  self:RemoveListener()
end

function CityZoneManager:Startup()
end

function CityZoneManager:AddListener()
end

function CityZoneManager:RemoveListener()
end

function CityZoneManager:InitZonePoint()
  self.allZonePoint = {}
  self.zoneTypePoint = {}
  local zoneType = 0
  local list = DataCenter.CityZoneTemplateManager:GetAllTemplate()
  for k, v in pairs(list) do
    local pointId = v:GetPointId()
    self.allZonePoint[pointId] = v
    zoneType = v.zone_type
    if self.zoneTypePoint[zoneType] == nil then
      self.zoneTypePoint[zoneType] = {}
    end
    table.insert(self.zoneTypePoint[zoneType], pointId)
  end
  self:InitZoneEffect()
end

function CityZoneManager:InitZoneEffect()
end

function CityZoneManager:DestroyZoneEffect()
  if self.areaObject ~= nil then
    GameObject.Destroy(self.areaObject.gameObject)
    self.areaObject = nil
  end
end

function CityZoneManager:CanPutBuildByPoint(pointId, zoneType)
  if self.allZonePoint[pointId] ~= nil then
    return self.allZonePoint[pointId]:CanPutByZoneType(zoneType)
  end
  return false
end

function CityZoneManager:GetZoneName(zoneType)
  if BuildZoneName[zoneType] ~= nil then
    return Localization:GetString(BuildZoneName[zoneType])
  end
  return ""
end

function CityZoneManager:GetZoneListPointByZoneType(zoneType)
  return self.zoneTypePoint[zoneType]
end

function CityZoneManager:GetBuildZoneListPointByZoneType(zoneType)
  if self.buildZoneTypePoint[zoneType] == nil then
    local result = {}
    self.buildZoneTypePoint[zoneType] = result
    if zoneType ~= BuildZoneType.No then
      for k, v in pairs(self.allZonePoint) do
        if v:CanPutByZoneType(zoneType) then
          table.insert(result, v:GetPointId())
        end
      end
    end
  end
  return self.buildZoneTypePoint[zoneType]
end

function CityZoneManager:GetAllUnlockPoint()
  local result = {}
  for _, v in pairs(self.allZonePoint) do
    if v.zone_type ~= BuildZoneType.No and DataCenter.LandLockManager:CanBuildByPointId(v:GetPointId()) then
      table.insert(result, v:GetPointId())
    end
  end
  return result
end

function CityZoneManager:GetGridEffectPointIndex(buildTemplate)
  local zoneType = buildTemplate.zoneType
  local list = self:GetBuildZoneListPointByZoneType(zoneType)
  local result = {}
  for _, v in pairs(list) do
    if DataCenter.LandLockManager:CanBuildByPointId(v) then
      table.insert(result, v)
    end
  end
  return result
end

function CityZoneManager:ShowZoneEffect(buildTemplate)
  local zoneType = buildTemplate.zoneType
  local buildId = buildTemplate.id
  local resourceType = DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
  local collectPara = buildTemplate.para4
  if self.areaObject ~= nil then
    local list = self:GetBuildZoneListPointByZoneType(zoneType)
    if list ~= nil then
      local result = ""
      local allUnlock = true
      for k, v in pairs(list) do
        if DataCenter.LandLockManager:CanBuildByPointId(v) then
          local collect = DataCenter.CollectResourceManager:GetResourcePointInfoByIndex(v)
          local collectRange = DataCenter.CollectResourceManager:GetCollectRangeInfoByIndex(v)
          if (collect == nil or collect:IsResourceByType(resourceType, collectPara)) and (collectRange == nil or collectRange:IsResourceByType(resourceType, collectPara)) then
            if result == "" then
              result = v
            else
              result = result .. "," .. v
            end
          end
        else
          allUnlock = false
        end
      end
      if result ~= "" then
        if allUnlock then
          self.areaObject:AddRevealerString(result, PerZoneRange)
        else
          self.areaObject:AddRevealerString(result, PerZoneRange)
        end
      end
      self.areaObject:ExecStart("0")
      self.areaObject:ToggleRenderFeature(true)
    end
  end
end

function CityZoneManager:HideZoneEffect()
  if self.areaObject ~= nil then
    self.areaObject:ToggleRenderFeature(false)
  end
end

return CityZoneManager
