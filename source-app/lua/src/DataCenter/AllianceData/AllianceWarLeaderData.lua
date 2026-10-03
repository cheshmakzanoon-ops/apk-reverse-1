local AllianceWarLeaderData = BaseClass("AllianceWarLeaderData")

local function __init(self)
  self.uuid = 0
  self.ownerUid = ""
  self.ownerName = ""
  self.status = MarchStatus.DEFAULT
  self.startTime = 0
  self.endTime = 0
  self.teamUuid = 0
  self.ownerIcon = ""
  self.ownerIconVer = 0
  self.armyInfo = {}
  self.startId = 0
  self.monthCardEndTime = 0
  self.power = 0
  self.headSkinId = nil
  self.headSkinET = nil
end

local function __delete(self)
  self.uuid = nil
  self.ownerUid = nil
  self.ownerName = nil
  self.status = nil
  self.startTime = nil
  self.endTime = nil
  self.teamUuid = nil
  self.ownerIcon = nil
  self.ownerIconVer = nil
  self.armyInfo = nil
  self.startId = nil
  self.monthCardEndTime = nil
  self.power = nil
  self.headSkinId = nil
  self.headSkinET = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.uuid ~= nil then
    self.uuid = message.uuid
  end
  if message.ownerUid ~= nil then
    self.ownerUid = message.ownerUid
  end
  if message.ownerName ~= nil then
    self.ownerName = message.ownerName
  end
  if message.status ~= nil then
    self.status = message.status
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime
  end
  if message.teamUuid ~= nil then
    self.teamUuid = message.teamUuid
  end
  if message.ownerIcon ~= nil then
    self.ownerIcon = message.ownerIcon
  end
  if message.ownerIconVer ~= nil then
    self.ownerIconVer = message.ownerIconVer
  end
  if message.startId ~= nil then
    self.startId = message.startId
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.armyInfo ~= nil then
    local armyCombatUnit = PBController.ParsePb1(message.armyInfo, "protobuf.ArmyCombatUnit")
    if armyCombatUnit then
      self.armyInfo.soldiers = armyCombatUnit.armyInfo.soldiers or {}
      self.armyInfo.heros = armyCombatUnit.armyInfo.heroes or {}
    end
  end
  if message.monthCardEndTime then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

AllianceWarLeaderData.__init = __init
AllianceWarLeaderData.__delete = __delete
AllianceWarLeaderData.ParseData = ParseData
AllianceWarLeaderData.GetHeadBgImg = GetHeadBgImg
return AllianceWarLeaderData
