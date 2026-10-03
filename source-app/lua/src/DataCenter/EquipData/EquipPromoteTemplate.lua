local EquipPromoteTemplate = BaseClass("EquipPromoteTemplate")

local function __init(self)
  self.id = 0
  self.level = 0
  self.cost_resource = {}
  self.cost_resItem = {}
end

local function __delete(self)
  self.id = nil
  self.level = nil
  self.cost_resource = nil
  self.cost_resItem = nil
  self.viewCost = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  local cost_resource = row:getValue("cost_resource") or ""
  self.cost_resource = {}
  if not string.IsNullOrEmpty(cost_resource) then
    local cost_resourceList = string.split(cost_resource, "|")
    for i = 1, #cost_resourceList do
      if not string.IsNullOrEmpty(cost_resourceList[i]) then
        local costResource = string.split(cost_resourceList[i], ";")
        if 2 <= #costResource then
          local cost = {
            type = tonumber(costResource[1]),
            value = tonumber(costResource[2])
          }
          if cost ~= nil then
            table.insert(self.cost_resource, cost)
          end
        end
      end
    end
  end
  local cost_resItem = row:getValue("cost_resItem") or ""
  self.cost_resItem = {}
  if not string.IsNullOrEmpty(cost_resItem) then
    local cost_resItemList = string.split(cost_resItem, "|")
    for i = 1, #cost_resItemList do
      if not string.IsNullOrEmpty(cost_resItemList[i]) then
        local costResItem = string.split(cost_resItemList[i], ";")
        if 2 <= #costResItem then
          local cost = {
            type = tonumber(costResItem[1]),
            value = tonumber(costResItem[2])
          }
          if cost ~= nil then
            table.insert(self.cost_resItem, cost)
          end
        end
      end
    end
  end
end

local function ParseData(self)
  if self.viewCost ~= nil then
    return self.viewCost
  end
  local cost = {}
  for i = 1, #self.cost_resource do
    local costItem = {}
    costItem.isResource = true
    costItem.id = self.cost_resource[i].type
    costItem.value = self.cost_resource[i].value
    table.insert(cost, costItem)
  end
  for i = 1, #self.cost_resItem do
    local costItem = {}
    costItem.isResource = false
    costItem.id = self.cost_resItem[i].type
    costItem.value = self.cost_resItem[i].value
    table.insert(cost, costItem)
  end
  self.viewCost = cost
  return cost
end

EquipPromoteTemplate.__init = __init
EquipPromoteTemplate.__delete = __delete
EquipPromoteTemplate.InitData = InitData
EquipPromoteTemplate.ParseData = ParseData
return EquipPromoteTemplate
