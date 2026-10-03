local ResourceManager = BaseClass("ResourceManager")
local Localization = CS.GameEntry.Localization

function ResourceManager:__init()
end

function ResourceManager:__delete()
end

function ResourceManager:GetResourceOutBuildings(resourceType)
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
  if template ~= nil then
    return template.out_building
  end
  return nil
end

function ResourceManager:GetResourceOutBuildingUids(resourceType)
  local result = {}
  local buildIds = self:GetResourceOutBuildings(resourceType)
  if buildIds ~= nil then
    for k, v in pairs(buildIds) do
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v)
      if list ~= nil then
        for k1, v1 in ipairs(list) do
          table.insert(result, v1.uuid)
        end
      end
    end
  end
  return result
end

function ResourceManager:GetResourceDescByType(resourceType)
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
  if template ~= nil then
    return Localization:GetString(template.description)
  end
  local description = LocalController:instance():getValue(TableName.Aps_Resource_Item, resourceType, "description")
  if description then
    return Localization:GetString(description)
  end
  return ""
end

function ResourceManager:GetResourceNameByType(resourceType)
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
  if template ~= nil then
    return Localization:GetString(template.name)
  end
  local name = LocalController:instance():getValue(TableName.Aps_Resource_Item, resourceType, "name")
  if name then
    return Localization:GetString(name)
  end
  return ""
end

function ResourceManager:GetResourceIconByType(resourceType, big, seasonType, mainUI)
  if seasonType ~= nil and (resourceType == ResourceType.FLINT or resourceType == ResourceType.OBSIDIAN or resourceType == ResourceType.AllianceStone) then
    local cfg = SeasonUtil.GetWorldSkinConfig(seasonType)
    if cfg then
      local detail
      if resourceType == ResourceType.FLINT then
        detail = cfg.resource_13
      elseif resourceType == ResourceType.OBSIDIAN then
        detail = cfg.resource_10
      elseif resourceType == ResourceType.AllianceStone then
        detail = cfg.resource_alliance
      end
      if not string.IsNullOrEmpty(detail) then
        local theIcon, theName, theDesc = string.match(detail, "([^|]+)|([^|]+)|([^|]+)")
        if theIcon and theName and theDesc then
          return string.format(LoadPath.LWCommonPath, theIcon)
        end
      end
    end
  end
  local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(resourceType)
  local iconPath
  if template ~= nil and not string.IsNullOrEmpty(template.icon) then
    if string.sub(template.icon, 1, 7) == "Assets/" then
      return template.icon
    end
    if big then
      iconPath = template.big_icon
      if not string.IsNullOrEmpty(iconPath) and CS.GameEntry.Resource:HasAsset(iconPath) then
        return iconPath
      end
      iconPath = string.format(LoadPath.ItemPath, template.icon .. ".png")
      if CS.GameEntry.Resource:HasAsset(iconPath) then
        return iconPath
      end
    end
    if mainUI then
      iconPath = string.format(LoadPath.LWMainUINewPath, template.icon .. ".png")
      if CS.GameEntry.Resource:HasAsset(iconPath) then
        return iconPath
      end
    end
    iconPath = string.format(LoadPath.LWCommonPath, template.icon .. ".png")
  end
  if iconPath == nil then
    iconPath = ResourceTypeIconName[resourceType]
  end
  return iconPath
end

return ResourceManager
