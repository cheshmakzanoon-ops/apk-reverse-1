local BuildUpgradeStockInfo = BaseClass("BuildUpgradeStockInfo")

function BuildUpgradeStockInfo:__init()
  self.uuid = 0
  self.resources = {}
  self.resourceItems = {}
  self.items = {}
end

function BuildUpgradeStockInfo:__delete()
  self.uuid = 0
  self.resources = {}
  self.resourceItems = {}
  self.items = {}
end

function BuildUpgradeStockInfo:UpdateInfo(message)
  if message == nil then
    return
  end
  self.uuid = message.uuid
  self.resources = {}
  local resource = message.resources
  if resource ~= nil then
    for k, v in ipairs(resource) do
      self.resources[v.type] = v.value
    end
  end
  self.resourceItems = {}
  resource = message.resourceItems
  if resource ~= nil then
    for k, v in ipairs(resource) do
      self.resourceItems[v.type] = v.value
    end
  end
  self.items = {}
  resource = message.items
  if resource ~= nil then
    for k, v in ipairs(resource) do
      self.items[v.type] = v.value
    end
  end
end

function BuildUpgradeStockInfo:GetSubmitCountByResource(id)
  if self.resources[id] ~= nil then
    return self.resources[id]
  end
  return 0
end

function BuildUpgradeStockInfo:GetSubmitCountByResourceItem(id)
  if self.resourceItems[id] ~= nil then
    return self.resourceItems[id]
  end
  return 0
end

function BuildUpgradeStockInfo:GetSubmitCountByItem(id)
  local strInt = tostring(id)
  if self.items[strInt] ~= nil then
    return self.items[strInt]
  end
  return 0
end

return BuildUpgradeStockInfo
