local EquipUpgradeTemplate = BaseClass("EquipUpgradeTemplate")

local function __init(self)
  self.id = 0
  self.slot = 0
  self.quality = 0
  self.heroType = 0
  self.maxLevel = 0
  self.stone_UpgradeCost = {}
  self.resource_UpgradeCost = {}
end

local function __delete(self)
  self.id = nil
  self.slot = nil
  self.quality = nil
  self.heroType = nil
  self.maxLevel = nil
  self.stone_UpgradeCost = nil
  self.resource_UpgradeCost = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.slot = tonumber(row:getValue("slot")) or 0
  self.quality = tonumber(row:getValue("quality")) or 0
  self.heroType = tonumber(row:getValue("army_type")) or 0
  self.maxLevel = tonumber(row:getValue("highest_level")) or 0
  self.stone_UpgradeCost = row:getValue("stone_upgrade_cost") or {}
  local resource_UpgradeCost = row:getValue("coin_upgrade_cost") or ""
  self.resource_UpgradeCost = {}
  if not string.IsNullOrEmpty(resource_UpgradeCost) then
    local resource_UpgradeCostList = string.split(resource_UpgradeCost, "|")
    for i = 1, #resource_UpgradeCostList do
      if not string.IsNullOrEmpty(resource_UpgradeCostList[i]) then
        local costResource = string.split(resource_UpgradeCostList[i], ";")
        if 2 <= #costResource then
          local cost = {
            type = tonumber(costResource[1]),
            value = tonumber(costResource[2])
          }
          if cost ~= nil then
            table.insert(self.resource_UpgradeCost, cost)
          end
        end
      end
    end
  end
end

local function GetCostStoneByLevel(self, level)
  if level + 1 > self.maxLevel then
    level = self.maxLevel - 1
  end
  return self.stone_UpgradeCost[level + 1]
end

local function GetCostResourceTypeByLevel(self, level)
  if level + 1 > self.maxLevel then
    level = self.maxLevel - 1
  end
  local cost = self.resource_UpgradeCost[level + 1]
  if cost == nil then
    return 0
  end
  return cost.type
end

local function GetCostResourceValueByLevel(self, level)
  if level + 1 > self.maxLevel then
    level = self.maxLevel - 1
  end
  local cost = self.resource_UpgradeCost[level + 1]
  if cost == nil then
    return 0
  end
  return cost.value
end

EquipUpgradeTemplate.__init = __init
EquipUpgradeTemplate.__delete = __delete
EquipUpgradeTemplate.InitData = InitData
EquipUpgradeTemplate.GetCostStoneByLevel = GetCostStoneByLevel
EquipUpgradeTemplate.GetCostResourceTypeByLevel = GetCostResourceTypeByLevel
EquipUpgradeTemplate.GetCostResourceValueByLevel = GetCostResourceValueByLevel
return EquipUpgradeTemplate
