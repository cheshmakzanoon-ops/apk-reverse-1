local BuildingOfficialHistoryRecord = BaseClass("BuildingOfficialHistoryRecord")

local function __init(self)
end

local function __delete(self)
  self.appointTime = nil
  self.buildingId = nil
  self.fireTime = nil
  self.positionId = nil
  self.uid = nil
  self.pic = nil
  self.picVer = nil
  self.name = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.serverId = nil
  self.abbr = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.appointTime then
    self.appointTime = message.appointTime
  end
  if message.buildingId then
    self.buildingId = message.buildingId
  end
  if message.fireTime then
    self.fireTime = message.fireTime
  end
  if message.positionId then
    self.positionId = toInt(message.positionId)
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.user then
    local user = message.user
    if user.abbr then
      self.abbr = user.abbr
    end
    if user.headSkinId then
      self.headSkinId = user.headSkinId
    end
    if user.headSkinET then
      self.headSkinET = user.headSkinET
    end
    if user.headPic then
      self.pic = user.headPic
    end
    if user.headPicVer then
      self.picVer = user.headPicVer
    end
    if user.serverId then
      self.serverId = user.serverId
    end
    if user.name then
      self.name = user.name
    end
    if user.allianceId then
      self.allianceId = user.allianceId
    end
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function GetFullName(self, uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.name)
  if string.IsNullOrEmpty(self.abbr) then
    return showName
  else
    return "[" .. self.abbr .. "] " .. showName
  end
end

BuildingOfficialHistoryRecord.__init = __init
BuildingOfficialHistoryRecord.__delete = __delete
BuildingOfficialHistoryRecord.ParseData = ParseData
BuildingOfficialHistoryRecord.GetHeadBgImg = GetHeadBgImg
BuildingOfficialHistoryRecord.GetFullName = GetFullName
return BuildingOfficialHistoryRecord
