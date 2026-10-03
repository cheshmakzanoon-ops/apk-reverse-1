local PresidentHistoryListInfo = BaseClass("PresidentHistoryListInfo")

local function __init(self)
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.allianceAbbr = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.beKingTime = 0
  self.country = 0
  self.round = 0
end

local function __delete(self)
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.allianceAbbr = ""
  self.country = 0
  self.headSkinId = 0
  self.headSkinET = 0
  self.beKingTime = 0
  self.round = 0
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.pic then
    self.pic = message.pic
  end
  if message.picVer then
    self.picVer = message.picVer
  end
  if message.name then
    self.name = message.name
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  if message.allianceAbbr then
    self.allianceAbbr = message.allianceAbbr
  end
  if message.beKingTime then
    self.beKingTime = message.beKingTime
  end
  if message.country then
    self.country = message.country
  end
  if message.round then
    self.round = message.round
  end
  self.occupyServerId = message.occupyServerId
  self.srcServerId = message.srcServerId
  if self.occupyServerId == 0 then
    self.occupyServerId = nil
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

PresidentHistoryListInfo.__init = __init
PresidentHistoryListInfo.__delete = __delete
PresidentHistoryListInfo.ParseData = ParseData
PresidentHistoryListInfo.GetHeadBgImg = GetHeadBgImg
return PresidentHistoryListInfo
