local AllianceShopDataManager = BaseClass("AllianceShopDataManager")

local function __init(self)
  self.alliancePoint = 0
  self.accPoint = 0
  self.allianceBagList = {}
  self.allianceShopList = {}
end

local function __delete(self)
  self.alliancePoint = nil
  self.accPoint = nil
  self.allianceBagList = nil
  self.allianceShopList = nil
end

local function InitAllianceBag(self)
  local data = DataCenter.ItemTemplateManager:GetAllianceItemTemplate()
  self.allianceBagList_id = {}
  table.walk(data, function(k, v)
    table.insert(self.allianceBagList_id, v.id)
    self.allianceBagList[v.id] = v
  end)
end

local function RefreshAllianceShopList(self, message)
  self.allianceShopList = {}
  if message.goods ~= nil and message.nextWeekTime ~= nil then
    local list = message.goods
    self.allianceShopList_id = {}
    self.nextWeekTime = tonumber(message.nextWeekTime)
    table.walk(list, function(k, v)
      if v.goodsId ~= nil then
        local id = v.goodsId
        if v.count ~= nil and tonumber(v.count) > 0 then
          table.insert(self.allianceShopList_id, id)
        end
        self.allianceShopList[id] = v
      end
    end)
  end
end

local function GetNextWeekTime(self)
  if self.nextWeekTime ~= nil then
    return self.nextWeekTime
  else
    return 0
  end
end

local function SetAlliancePoint(self, alliancePoint)
  self.alliancePoint = alliancePoint
end

local function SetAccPoint(self, accPoint)
  self.accPoint = accPoint
end

local function GetAccPoint(self)
  return self.accPoint
end

local function GetAlliancePoint(self)
  return self.alliancePoint
end

local function GetAllianceShopOneData(self, id)
  return self.allianceShopList[id]
end

local function GetAllianceBagOneData(self, id)
  return self.allianceBagList[id]
end

local function GetAllianceShopIdList(self)
  if self.allianceShopList_id ~= nil then
    return self.allianceShopList_id
  else
    return {}
  end
end

local function GetAllianceBagIdList(self)
  if self.allianceBagList_id ~= nil then
    return self.allianceBagList_id
  else
    return {}
  end
end

AllianceShopDataManager.__init = __init
AllianceShopDataManager.__delete = __delete
AllianceShopDataManager.InitAllianceBag = InitAllianceBag
AllianceShopDataManager.RefreshAllianceShopList = RefreshAllianceShopList
AllianceShopDataManager.SetAlliancePoint = SetAlliancePoint
AllianceShopDataManager.GetAlliancePoint = GetAlliancePoint
AllianceShopDataManager.SetAccPoint = SetAccPoint
AllianceShopDataManager.GetAccPoint = GetAccPoint
AllianceShopDataManager.GetAllianceShopOneData = GetAllianceShopOneData
AllianceShopDataManager.GetAllianceBagOneData = GetAllianceBagOneData
AllianceShopDataManager.GetAllianceShopIdList = GetAllianceShopIdList
AllianceShopDataManager.GetAllianceBagIdList = GetAllianceBagIdList
AllianceShopDataManager.GetNextWeekTime = GetNextWeekTime
return AllianceShopDataManager
