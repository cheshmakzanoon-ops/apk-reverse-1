local S0AllianceBossDonateInfo = BaseClass("S0AllianceBossDonateInfo")

local function __init(self)
  self.time = 0
  self.name = ""
  self.multi = 0
  self.uid = ""
  self.damage = 0
  self.abbr = ""
  self.headPic = ""
  self.headPicVer = 0
  self.country = ""
  self.chatBubbleId = 0
  self.chatBubbleET = 0
  self.headSkinId = 0
  self.headSkinET = 0
end

local function __delete(self)
  self.time = nil
  self.name = nil
  self.multi = nil
  self.uid = nil
  self.damage = nil
  self.abbr = nil
  self.headPic = nil
  self.headPicVer = nil
  self.country = nil
  self.chatBubbleId = nil
  self.chatBubbleET = nil
  self.headSkinId = nil
  self.headSkinET = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.time ~= nil then
    self.time = message.time or 0
  end
  if message.name ~= nil then
    self.name = message.name or ""
  end
  if message.multi ~= nil then
    self.multi = message.multi or 0
  end
  if message.uid ~= nil then
    self.uid = message.uid or ""
  end
  if message.damage ~= nil then
    self.damage = message.damage or 0
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr or ""
  end
  if message.headPic ~= nil then
    self.headPic = message.headPic or ""
  end
  if message.headPicVer ~= nil then
    self.headPicVer = message.headPicVer or 0
  end
  if message.country ~= nil then
    self.country = message.country or ""
  end
  if message.chatBubbleId ~= nil then
    self.chatBubbleId = message.chatBubbleId or 0
  end
  if message.chatBubbleET ~= nil then
    self.chatBubbleET = message.chatBubbleET or 0
  end
  if message.headSkinId ~= nil then
    self.headSkinId = message.headSkinId or 0
  end
  if message.headSkinET ~= nil then
    self.headSkinET = message.headSkinET or 0
  end
end

S0AllianceBossDonateInfo.__init = __init
S0AllianceBossDonateInfo.__delete = __delete
S0AllianceBossDonateInfo.ParseData = ParseData
return S0AllianceBossDonateInfo
