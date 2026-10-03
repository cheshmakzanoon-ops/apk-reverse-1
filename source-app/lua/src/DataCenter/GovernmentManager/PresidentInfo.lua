local PresidentInfo = BaseClass("PresidentInfo")

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
  self.country = ""
  self.declaration = ""
  self.occupyAllianceId = ""
  self.assignFinishTime = 0
  self.finishTime = 0
  self.level = 0
end

local function __delete(self)
  self.uid = ""
  self.serverId = 0
  self.pic = ""
  self.picVer = 0
  self.name = ""
  self.allianceAbbr = ""
  self.country = ""
  self.headSkinId = 0
  self.headSkinET = 0
  self.beKingTime = 0
  self.declaration = ""
  self.occupyAllianceId = ""
  self.assignFinishTime = 0
  self.finishTime = 0
  self.level = 0
end

local function ParseData(self, message, kingInfo)
  if message == nil then
    return
  end
  local theKingInfo = kingInfo or message.kingInfo
  if message.finishTime then
    self.finishTime = message.finishTime
  end
  if theKingInfo then
    if theKingInfo.uid then
      self.uid = theKingInfo.uid
    end
    if theKingInfo.serverId then
      self.serverId = theKingInfo.serverId
    end
    if theKingInfo.pic then
      self.pic = theKingInfo.pic
    end
    if theKingInfo.picVer then
      self.picVer = theKingInfo.picVer
    end
    if theKingInfo.name then
      self.name = theKingInfo.name
    end
    if theKingInfo.headSkinId then
      self.headSkinId = theKingInfo.headSkinId
    end
    if theKingInfo.headSkinET then
      self.headSkinET = theKingInfo.headSkinET
    end
    if theKingInfo.allianceAbbr then
      self.allianceAbbr = theKingInfo.allianceAbbr
    end
    if theKingInfo.allianceName then
      self.allianceName = theKingInfo.allianceName
    end
    if theKingInfo.beKingTime then
      self.beKingTime = theKingInfo.beKingTime
    end
    if theKingInfo.country then
      self.country = theKingInfo.country
    end
    if theKingInfo.gender then
      self.gender = theKingInfo.gender
    end
    if theKingInfo.level then
      self.level = theKingInfo.level
    end
    if theKingInfo.power then
      self.power = theKingInfo.power
    end
    if theKingInfo.mailCount then
      self.mailCount = theKingInfo.mailCount
    end
    if theKingInfo.mailMaxCount then
      self.mailMaxCount = theKingInfo.mailMaxCount
    end
    if theKingInfo.mailCost then
      self.mailCost = theKingInfo.mailCost
    end
    self.srcServerId = theKingInfo.srcServerId or self.serverId
    if self.srcServerId == nil or self.srcServerId == 0 or self.srcServerId == "" then
      self.srcServerId = self.serverId
    end
  else
    self.uid = ""
    self.serverId = 0
    self.pic = ""
    self.picVer = 0
    self.name = ""
    self.allianceAbbr = ""
    self.country = ""
    self.headSkinId = 0
    self.headSkinET = 0
    self.beKingTime = 0
  end
  local k4 = LuaEntry.DataConfig:TryGetNum("wonder", "k4") * 60 * 1000
  if message.finishTime ~= nil then
    self.assignFinishTime = message.finishTime + k4
  end
  self.declaration = message.declaration or ""
  self.fakeKing = false
end

local function SetDeclaration(self, declaration)
  self.declaration = declaration
end

function PresidentInfo:HavePresident()
  return self.uid ~= nil and self.uid ~= ""
end

function PresidentInfo:GetFullName()
  local playerName = self.name
  if self.allianceAbbr ~= nil and self.allianceAbbr ~= "" then
    playerName = "[" .. self.allianceAbbr .. "] " .. self.name
  end
  return playerName
end

function PresidentInfo:CheckIsEnd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.finishTime ~= 0 and curTime >= self.finishTime then
    return true
  end
  return false
end

function PresidentInfo:GetHeadBgImg()
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

PresidentInfo.__init = __init
PresidentInfo.__delete = __delete
PresidentInfo.ParseData = ParseData
PresidentInfo.SetDeclaration = SetDeclaration
return PresidentInfo
