local SplinterExchangeData = BaseClass("SplinterExchangeData")

local function __init(self)
  self.type = 1
  self.uuid = -1
  self.ownerId = ""
  self.allianceId = ""
  self.needFragment = ""
  self.costFragment = ""
  self.updateTime = ""
  self.name = ""
  self.recordShow = nil
  self.uid = ""
  self.headPic = ""
  self.headPicVer = 0
  self.headSkinId = 0
  self.headSkinET = 0
end

local function __delete(self)
  self.type = nil
  self.uuid = nil
  self.ownerId = nil
  self.allianceId = nil
  self.needFragment = nil
  self.costFragment = nil
  self.updateTime = nil
  self.name = nil
  self.recordShow = nil
  self.uid = nil
  self.headPic = nil
  self.headPicVer = nil
  self.headSkinId = nil
  self.headSkinET = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.ownerId ~= nil then
    self.ownerId = message.ownerId
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.needFragment ~= nil then
    self.needFragment = message.needFragment
  end
  if message.costFragment ~= nil then
    self.costFragment = message.costFragment
  end
  if message.updateTime ~= nil then
    self.updateTime = message.updateTime
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.recordShow ~= nil then
    self.recordShow = message.recordShow
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.headPic ~= nil then
    self.headPic = message.headPic
  end
  if message.headPicVer ~= nil then
    self.headPicVer = message.headPicVer
  end
  if message.headSkinId ~= nil then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET ~= nil then
    self.headSkinET = message.headSkinET
  end
end

local function RefreshRecordShowData(self, message)
  if message == nil then
    return
  end
  if self.recordShow and message.uuid and message.uuid == self.recordShow.uuid then
    self.recordShow.isLike = message.isLike
    EventManager:GetInstance():Broadcast(EventId.SplinterRefreshSelf, self.type)
  end
end

SplinterExchangeData.__init = __init
SplinterExchangeData.__delete = __delete
SplinterExchangeData.ParseData = ParseData
SplinterExchangeData.RefreshRecordShowData = RefreshRecordShowData
return SplinterExchangeData
