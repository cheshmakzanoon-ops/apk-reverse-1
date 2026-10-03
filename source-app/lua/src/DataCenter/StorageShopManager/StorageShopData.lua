local StorageShopData = BaseClass("StorageShopData")

local function __init(self)
  self.pointId = 0
  self.uid = ""
  self.name = ""
  self.picVer = ""
  self.pic = ""
  self.abbr = ""
  self.slotList = {}
  self.serverId = 0
end

local function __delete(self)
  self.pointId = nil
  self.uid = nil
  self.name = nil
  self.picVer = nil
  self.pic = nil
  self.abbr = nil
  self.slotList = nil
  self.serverId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.pointId then
    self.pointId = message.pointId
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.name then
    self.name = message.name
  end
  if message.picVer then
    self.picVer = message.picVer
  end
  if message.pic then
    self.pic = message.pic
  end
  if message.alAbbr then
    self.abbr = message.alAbbr
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.slotArr then
    self.slotList = {}
    for i, v in pairs(message.slotArr) do
      local newSlot = StorageShopSlotData.New()
      newSlot:ParseData(v)
      table.insert(self.slotList, newSlot)
    end
    table.sort(self.slotList, function(a, b)
      if a.index ~= b.index then
        return a.index < b.index
      else
        return false
      end
    end)
  end
end

local function GetOnSaleSlots(self, forceShowAll)
  local retTb = {}
  local confDelayS = 0
  if not forceShowAll then
    local isSelfAlliance = false
    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBase and allianceBase.abbr == self.abbr then
      isSelfAlliance = true
    end
    if not isSelfAlliance then
      confDelayS = LuaEntry.DataConfig:TryGetStr("tradingbank_para", "k20")
    end
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  for i, v in ipairs(self.slotList) do
    if v.state == StorageShopSlotState.OnSell and serverTime > v.startTime + confDelayS * 1000 then
      table.insert(retTb, v)
    end
  end
  return retTb
end

StorageShopData.__init = __init
StorageShopData.__delete = __delete
StorageShopData.ParseData = ParseData
StorageShopData.GetOnSaleSlots = GetOnSaleSlots
return StorageShopData
