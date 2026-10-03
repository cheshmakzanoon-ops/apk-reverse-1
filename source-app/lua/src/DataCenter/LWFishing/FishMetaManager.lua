local FishMetaManager = BaseClass("FishMetaManager")

function FishMetaManager:__init()
  self.fishCollectDic = nil
  self.camp2Species = nil
  self.camp2Ids = nil
  self.camp2Levels = nil
end

function FishMetaManager:__delete()
  self.fishCollectDic = nil
  self.camp2Species = nil
  self.camp2Ids = nil
  self.camp2Levels = nil
end

function FishMetaManager:InitCollectMeta()
  self.fishCollectDic = {}
  self.camp2Species = {}
  self.camp2Ids = {}
  self.camp2Levels = {}
  LocalController:instance():visitTable(TableName.FishCollect, function(id, lineData)
    local camp = lineData:getIntValue("camp")
    if self.fishCollectDic[camp] == nil then
      self.fishCollectDic[camp] = {}
      self.camp2Levels[camp] = {}
    end
    local level = lineData:getIntValue("pond_level")
    self.fishCollectDic[camp][level] = {}
    self.fishCollectDic[camp][level] = lineData:getValue("fish")
    table.insert(self.camp2Levels[camp], level)
  end)
  for _, v in pairs(self.camp2Levels) do
    table.sort(v, function(a, b)
      return a < b
    end)
  end
  local allHashSet = {}
  for campId, camp in pairs(self.fishCollectDic) do
    local hashSet = {}
    for _, level in pairs(camp) do
      for _, id in pairs(level) do
        hashSet[id] = true
        allHashSet[id] = true
      end
    end
    self.camp2Ids[campId] = hashSet
    self.camp2Species[campId] = 0
    camp[0] = {}
    for id, _ in pairs(hashSet) do
      table.insert(camp[0], id)
      self.camp2Species[campId] = self.camp2Species[campId] + 1
    end
    table.sort(camp[0], function(a, b)
      return a < b
    end)
  end
  self.camp2Species[0] = table.count(allHashSet)
end

function FishMetaManager:GetMeta(id)
  return LocalController:instance():getLine(TableName.Fish, id)
end

function FishMetaManager:GetIdList(camp, level)
  if self.fishCollectDic == nil then
    self:InitCollectMeta()
  end
  if self.fishCollectDic[toInt(camp)] then
    return self.fishCollectDic[toInt(camp)][toInt(level)] or {}
  end
  return {}
end

function FishMetaManager:GetCollectDic()
  if self.fishCollectDic == nil then
    self:InitCollectMeta()
  end
  return self.fishCollectDic
end

function FishMetaManager:GetPondLevelList(camp)
  if self.camp2Levels == nil then
    self:InitCollectMeta()
  end
  return self.camp2Levels[camp] or {}
end

function FishMetaManager:GetFishBookCount(camp)
  if self.camp2Species == nil then
    self:InitCollectMeta()
  end
  return self.camp2Species[camp] or 0
end

function FishMetaManager:GetFishBookHash(camp)
  if self.camp2Ids == nil then
    self:InitCollectMeta()
  end
  return self.camp2Ids[camp] or {}
end

function FishMetaManager:GetMinMaxWeight()
  if not self.minWeight then
    local k7 = LuaEntry.DataConfig:TryGetStr("season_pond", "k7", "110;200")
    local k8 = LuaEntry.DataConfig:TryGetStr("season_pond", "k8", "110;200")
    local k9 = LuaEntry.DataConfig:TryGetStr("season_pond", "k9", "110;200")
    k7 = string.split(k7, ";")
    k8 = string.split(k8, ";")
    k9 = string.split(k9, ";")
    self.minWeight = 0.01 * math.min(tonumber(k7[1]), tonumber(k8[1]), tonumber(k9[1]))
    self.maxWeight = 0.01 * math.max(tonumber(k7[2]), tonumber(k8[2]), tonumber(k9[2]))
  end
  return self.minWeight, self.maxWeight
end

function FishMetaManager:GetBaitItemIdAndCost(baitLevel)
  if self.bait == nil then
    self.bait = {}
    local idCost = LuaEntry.DataConfig:TryGetStr("season_pond", "k2", "650090;1")
    idCost = string.split(idCost, ";")
    self.bait[0] = {
      id = tonumber(idCost[1]),
      cost = tonumber(idCost[2])
    }
    idCost = LuaEntry.DataConfig:TryGetStr("season_pond", "k3", "650091;1")
    idCost = string.split(idCost, ";")
    self.bait[1] = {
      id = tonumber(idCost[1]),
      cost = tonumber(idCost[2])
    }
  end
  return self.bait[baitLevel].id, self.bait[baitLevel].cost
end

function FishMetaManager:IsCrocodile(id)
  local meta = self:GetMeta(id)
  return meta and meta.type == 3
end

return FishMetaManager
