local SplinterExchangeRecordData = BaseClass("SplinterExchangeRecordData")

local function __init(self)
  self.uuid = 0
  self.ownerId = ""
  self.like = 0
  self.uid = ""
  self.time = ""
  self.name = ""
  self.abbr = ""
  self.headPic = ""
  self.headPicVer = 0
  self.getFragment = ""
  self.costFragment = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.leftInfo = nil
end

local function __delete(self)
  self.uuid = nil
  self.ownerId = nil
  self.like = nil
  self.uid = nil
  self.time = nil
  self.name = nil
  self.abbr = nil
  self.headPic = nil
  self.headPicVer = nil
  self.getFragment = nil
  self.costFragment = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.leftInfo = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.ownerId ~= nil then
    self.ownerId = message.ownerId
  end
  if message.isLike ~= nil then
    self.like = message.isLike
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.time ~= nil then
    self.time = message.time
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.headPic ~= nil then
    self.headPic = message.headPic
  end
  if message.headPicVer ~= nil then
    self.headPicVer = message.headPicVer
  end
  if message.getFragment ~= nil then
    self.getFragment = message.getFragment
  end
  if message.costFragment ~= nil then
    self.costFragment = message.costFragment
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
  if message.leftInfo ~= nil then
    self.leftInfo = message.leftInfo
  end
end

SplinterExchangeRecordData.__init = __init
SplinterExchangeRecordData.__delete = __delete
SplinterExchangeRecordData.ParseData = ParseData
return SplinterExchangeRecordData
