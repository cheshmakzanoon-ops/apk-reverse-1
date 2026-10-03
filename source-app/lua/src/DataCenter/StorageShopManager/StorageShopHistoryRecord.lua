local StorageShopHistoryRecord = BaseClass("StorageShopHistoryRecord")

local function __init(self)
  self.itemId = 0
  self.num = 0
  self.gold = 0
  self.time = 0
  self.soldOutUid = ""
  self.soldName = ""
  self.alAbbr = ""
  self.picVer = 0
  self.pic = ""
  self.careerType = 0
  self.careerLv = 0
  self.monthCardEndTime = 0
  self.serverId = nil
end

local function __delete(self)
  self.itemId = nil
  self.num = nil
  self.gold = nil
  self.time = nil
  self.soldOutUid = nil
  self.soldName = nil
  self.alAbbr = nil
  self.picVer = nil
  self.pic = nil
  self.careerType = nil
  self.careerLv = nil
  self.monthCardEndTime = nil
  self.serverId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.itemId then
    self.itemId = message.itemId
  end
  if message.num then
    self.num = message.num
  end
  if message.gold then
    self.gold = message.gold
  end
  if message.time then
    self.time = message.time
  end
  if message.soldOutUid then
    self.soldOutUid = message.soldOutUid
  end
  if message.soldName then
    self.soldName = message.soldName
  end
  if message.alAbbr then
    self.alAbbr = message.alAbbr
  end
  if message.picVer then
    self.picVer = message.picVer
  end
  if message.pic then
    self.pic = message.pic
  end
  if message.careerType then
    self.careerType = message.careerType
  end
  if message.careerLv then
    self.careerLv = message.careerLv
  end
  if message.monthCardEndTime then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.serverId then
    self.serverId = message.serverId
  end
end

StorageShopHistoryRecord.__init = __init
StorageShopHistoryRecord.__delete = __delete
StorageShopHistoryRecord.ParseData = ParseData
return StorageShopHistoryRecord
