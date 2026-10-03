local StorageShopSlotData = BaseClass("StorageShopSlotData")

local function __init(self)
  self.uuid = 0
  self.index = 0
  self.state = 0
  self.itemId = 0
  self.num = 0
  self.price = 0
  self.startTime = 0
  self.cleanEndT = 0
  self.buyerUid = ""
  self.buyerName = ""
  self.buyerAbbr = ""
  self.careerType = 0
  self.careerLv = 0
  self.monthCardEndTime = 0
  self.serverId = nil
end

local function __delete(self)
  self.uuid = nil
  self.index = nil
  self.state = nil
  self.itemId = nil
  self.num = nil
  self.price = nil
  self.startTime = nil
  self.cleanEndT = nil
  self.buyerUid = nil
  self.buyerName = nil
  self.buyerAbbr = nil
  self.careerType = nil
  self.careerLv = nil
  self.monthCardEndTime = nil
  self.serverId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid then
    self.uuid = message.uuid
  end
  if message.index then
    self.index = message.index
  end
  if message.state then
    self.state = message.state
  end
  if message.itemId then
    self.itemId = message.itemId
  end
  if message.num then
    self.num = message.num
  end
  if message.price then
    self.price = message.price
  end
  if message.eT then
    self.cleanEndT = message.eT
    self.startTime = message.eT
  end
  if message.soldOutUid then
    self.buyerUid = message.soldOutUid
  end
  if message.soldName then
    self.buyerName = message.soldName
  end
  if message.alAbbr then
    self.buyerAbbr = message.alAbbr
  end
  if message.pic then
    self.buyerPic = message.pic
  end
  if message.picVer then
    self.buyerPicVer = message.picVer
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
  self:TryAdjustState()
end

local function TryAdjustState(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if self.state == StorageShopSlotState.Cleaning and serverTime > self.cleanEndT then
    self.state = StorageShopSlotState.Empty
  end
end

local function SetState(self, tempState)
  self.state = tempState
end

StorageShopSlotData.__init = __init
StorageShopSlotData.__delete = __delete
StorageShopSlotData.ParseData = ParseData
StorageShopSlotData.SetState = SetState
StorageShopSlotData.TryAdjustState = TryAdjustState
return StorageShopSlotData
