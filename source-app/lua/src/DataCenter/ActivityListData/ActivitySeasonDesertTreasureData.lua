local base = ActivityInfoData
local ActivitySeasonDesertTreasureData = BaseClass("ActLeadingQuestData", base)

function ActivitySeasonDesertTreasureData:__init()
  base.__init(self)
  self.openShopArr = nil
  self.shopExchangeRecord = nil
  self.plotGroup1 = nil
  self.plotGroup2 = nil
end

function ActivitySeasonDesertTreasureData:__delete()
  self.openShopArr = nil
  self.shopExchangeRecord = nil
  self.plotGroup1 = nil
  self.plotGroup2 = nil
  base.__delete()
end

function ActivitySeasonDesertTreasureData:ParseActivityData(data)
  base.ParseActivityData(self, data)
  if data.openShopArr then
    self.openShopArr = data.openShopArr
  end
  if not string.IsNullOrEmpty(self.para_2) then
    self.plotGroup1 = string.split(self.para_2, "|")
  end
  if not string.IsNullOrEmpty(self.para_3) then
    self.plotGroup2 = string.split(self.para_3, "|")
  end
end

function ActivitySeasonDesertTreasureData:GetRandomGroup1()
  if self.plotGroup1 then
    local key = table.randomKey(self.plotGroup1)
    if key ~= self.preKey1 then
      self.preKey1 = key
      return self.plotGroup1[key]
    else
      key = key + 1
      if key > #self.plotGroup1 then
        key = 1
      end
      self.preKey1 = key
      return self.plotGroup1[key]
    end
  end
end

function ActivitySeasonDesertTreasureData:GetRandomGroup2()
  if self.plotGroup2 then
    local key = table.randomKey(self.plotGroup2)
    if key ~= self.preKey2 then
      self.preKey2 = key
      return self.plotGroup2[key]
    else
      key = key + 1
      if key > #self.plotGroup2 then
        key = 1
      end
      self.preKey2 = key
      return self.plotGroup2[key]
    end
  end
end

function ActivitySeasonDesertTreasureData:InitShopExchangeRecord(data)
  self.shopExchangeRecord = {}
  if data then
    for i, v in ipairs(data) do
      self.shopExchangeRecord[v.configId] = {
        num = v.num,
        refreshTime = v.refreshTime
      }
    end
  end
end

function ActivitySeasonDesertTreasureData:GetShopExchangeRecord(configId)
  if self.shopExchangeRecord then
    return self.shopExchangeRecord[configId] and self.shopExchangeRecord[configId].num or 0
  end
  return 0
end

function ActivitySeasonDesertTreasureData:GetShopExchangeBuyTime(configId)
  if self.shopExchangeRecord then
    return self.shopExchangeRecord[configId] and self.shopExchangeRecord[configId].refreshTime or 0
  end
  return 0
end

function ActivitySeasonDesertTreasureData:SetShopExchangeRecord(configId, num, refreshTime)
  if self.shopExchangeRecord == nil then
    self.shopExchangeRecord = {}
  end
  self.shopExchangeRecord[configId] = {
    num = num,
    refreshTime = refreshTime or 0
  }
end

function ActivitySeasonDesertTreasureData:GetTodayShopData()
  if self.openShopArr then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    for i, v in ipairs(self.openShopArr) do
      if curTime > v.startTime and curTime < v.endTime then
        return v
      end
    end
  end
  return nil
end

function ActivitySeasonDesertTreasureData:IsInitShopRecord()
  return self.shopExchangeRecord ~= nil
end

return ActivitySeasonDesertTreasureData
