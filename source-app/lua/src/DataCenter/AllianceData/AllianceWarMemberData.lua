local AllianceWarMemberData = BaseClass("AllianceWarMemberData")

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
  self.armyInfos = {}
  self.monthCardEndTime = 0
  self.power = 0
  self.curHp = 0
  self.maxHp = 0
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
  self.armyInfos = nil
  self.monthCardEndTime = nil
  self.power = nil
  self.curHp = nil
  self.maxHp = nil
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
  if message.power ~= nil then
    self.power = message.power
  end
  if message.curHp ~= nil then
    self.curHp = message.curHp
  end
  if message.maxHp ~= nil then
    self.maxHp = message.maxHp
  end
  if message.armyInfo ~= nil then
    local armyCombatUnit = PBController.ParsePb1(message.armyInfo, "protobuf.ArmyCombatUnit")
    if armyCombatUnit then
      self.armyInfos.soldiers = armyCombatUnit.armyInfo.soldiers or {}
      self.armyInfos.heros = armyCombatUnit.armyInfo.heroes or {}
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
  if message.playerServerId then
    self.playerServerId = message.playerServerId
  end
  if not string.IsNullOrEmpty(message.allianceId) then
    self.allianceId = message.allianceId
    self.allianceAbbr = message.allianceAbbr
    self.allianceName = message.allianceName
    self.allianceIcon = message.allianceIcon
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

AllianceWarMemberData.__init = __init
AllianceWarMemberData.__delete = __delete
AllianceWarMemberData.ParseData = ParseData
AllianceWarMemberData.GetHeadBgImg = GetHeadBgImg
return AllianceWarMemberData
