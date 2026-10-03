local S0AllianceBossRankData = BaseClass("S0AllianceBossRankData")

local function __init(self)
  self.rank = -1
  self.damage = 0
  self.uid = ""
  self.name = ""
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
  self.uid = nil
  self.rank = nil
  self.damage = nil
  self.name = nil
  self.abbr = nil
  self.headPic = nil
  self.headPicVer = nil
  self.country = nil
  self.chatBubbleId = nil
  self.chatBubbleET = nil
  self.headSkinId = nil
  self.headSkinET = nil
end

local function ParseData(self, info)
  if info == nil then
    return
  end
  if info.uid ~= nil then
    self.uid = info.uid or ""
  end
  if info.rank ~= nil then
    self.rank = info.rank or 0
  end
  if info.damage ~= nil then
    self.damage = info.damage or 0
  end
  if info.name ~= nil then
    self.name = info.name or ""
  end
  if info.abbr ~= nil then
    self.abbr = info.abbr or ""
  end
  if info.headPic ~= nil then
    self.headPic = info.headPic or ""
  elseif info.pic ~= nil then
    self.headPic = info.pic or ""
  end
  if info.headPicVer ~= nil then
    self.headPicVer = info.headPicVer or 0
  elseif info.picVer ~= nil then
    self.headPicVer = info.picVer or 0
  end
  if info.country ~= nil then
    self.country = info.country or ""
  end
  if info.chatBubbleId ~= nil then
    self.chatBubbleId = info.chatBubbleId or 0
  end
  if info.chatBubbleET ~= nil then
    self.chatBubbleET = info.chatBubbleET or 0
  end
  if info.headSkinId ~= nil then
    self.headSkinId = info.headSkinId or 0
  end
  if info.headSkinET ~= nil then
    self.headSkinET = info.headSkinET or 0
  end
end

S0AllianceBossRankData.__init = __init
S0AllianceBossRankData.__delete = __delete
S0AllianceBossRankData.ParseData = ParseData
return S0AllianceBossRankData
