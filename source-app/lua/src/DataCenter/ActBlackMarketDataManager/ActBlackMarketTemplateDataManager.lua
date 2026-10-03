local ActBlackMarketTemplateDataManager = BaseClass("ActBlackMarketTemplateDataManager")
local Localization = CS.GameEntry.Localization
local ActInfiniteGiftTemplate = require("DataCenter.ActBlackMarketDataManager.ActBlackMarketTemplate")

local function InitAllTemplate(self)
  LocalController:instance():visitTable(TableName.Activity_BlackMarket, function(id, lineData)
    local template = ActInfiniteGiftTemplate.New()
    template:InitData(lineData)
    self.templateDict[tonumber(id)] = template
    if not self.typeDict[template.type] then
      self.typeDict[template.type] = {}
    end
    self.typeDict[template.type][#self.typeDict[template.type] + 1] = template
    if not self.typeRandomPoolDict[template.type] then
      self.typeRandomPoolDict[template.type] = {}
    end
    if not self.typeRandomPoolDict[template.type][template.random_pool] then
      self.typeRandomPoolDict[template.type][template.random_pool] = {}
    end
    self.typeRandomPoolDict[template.type][template.random_pool][#self.typeRandomPoolDict[template.type][template.random_pool] + 1] = template
  end)
end

local function __init(self)
  self.templateDict = {}
  self.typeDict = {}
  self.typeRandomPoolDict = {}
  self.probabInfos = {}
  InitAllTemplate(self)
end

local function __delete(self)
  self.templateDict = nil
  self.typeDict = nil
  self.typeRandomPoolDict = nil
  self.probabInfos = nil
end

local function GetTemplate(self, id)
  local _id = tonumber(id)
  if self.templateDict[_id] then
    return self.templateDict[_id]
  end
end

local function GetTypeRandomPoolTypes(self, type)
  local randomPoolTypes = {}
  for randomPool, _ in pairs(self.typeRandomPoolDict[type]) do
    randomPoolTypes[randomPool] = true
  end
  return randomPoolTypes
end

local function GetProbabInfo(self, type, random_pool)
  if self.probabInfos[type] and self.probabInfos[type][random_pool] then
    return self.probabInfos[type][random_pool]
  end
  local probabInfo = {
    poolCount = 0,
    pools = {}
  }
  local pools = probabInfo.pools
  local templateList = self.typeRandomPoolDict[type][random_pool]
  local totalWeight = 0
  if templateList then
    for i, template in ipairs(templateList) do
      totalWeight = totalWeight + template.pool_count
    end
  end
  local maxProbabIndex = 0
  local maxProbab = 0
  local formattedToitalWeight = 0
  for i, template in ipairs(templateList) do
    if not (0 >= template.pool_count) then
      local probab = template.pool_count / totalWeight
      probab = math.floor(probab * 10000) / 100
      formattedToitalWeight = formattedToitalWeight + probab
      if maxProbab < probab then
        maxProbab = probab
        maxProbabIndex = #pools + 1
      end
      pools[#pools + 1] = {item = template, probab = probab}
    end
  end
  if formattedToitalWeight < 100 then
    local diff = 100 - formattedToitalWeight
    pools[maxProbabIndex].probab = pools[maxProbabIndex].probab + diff
  end
  table.sort(pools, function(a, b)
    local aDisplayOrder = a.item.display_order
    local bDisplayOrder = b.item.display_order
    if aDisplayOrder == bDisplayOrder then
      return a.item.id < b.item.id
    else
      return aDisplayOrder < bDisplayOrder
    end
  end)
  probabInfo.poolCount = totalWeight
  if not self.probabInfos[type] then
    self.probabInfos[type] = {}
  end
  self.probabInfos[type][random_pool] = probabInfo
  return probabInfo
end

ActBlackMarketTemplateDataManager.__init = __init
ActBlackMarketTemplateDataManager.__delete = __delete
ActBlackMarketTemplateDataManager.GetTemplate = GetTemplate
ActBlackMarketTemplateDataManager.GetProbabInfo = GetProbabInfo
ActBlackMarketTemplateDataManager.GetTypeRandomPoolTypes = GetTypeRandomPoolTypes
return ActBlackMarketTemplateDataManager
