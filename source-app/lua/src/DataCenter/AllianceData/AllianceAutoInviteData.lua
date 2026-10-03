local AllianceAutoInviteData = BaseClass("AllianceAutoInviteData")

local function __init(self)
  self.allianceId = ""
  self.allianceName = ""
  self.abbr = ""
  self.announce = ""
  self.icon = ""
  self.intro = ""
  self.language = ""
  self.country = DefaultNation
  self.curMember = 0
  self.maxMember = 0
  self.createTime = 0
  self.inviteTime = 0
  self.playerUid = ""
  self.playerName = ""
  self.pic = ""
  self.picVer = 0
  self.playerNation = DefaultNation
  self.monthCardEndTime = 0
  self.headSkinId = 0
  self.headSkinET = 0
  self.playerGender = nil
  self.alliancePower = 0
end

local function __delete(self)
  self.allianceId = nil
  self.allianceName = nil
  self.abbr = nil
  self.announce = nil
  self.icon = nil
  self.intro = nil
  self.language = nil
  self.country = nil
  self.curMember = nil
  self.maxMember = nil
  self.createTime = nil
  self.inviteTime = nil
  self.playerUid = nil
  self.playerName = nil
  self.pic = nil
  self.picVer = nil
  self.playerNation = nil
  self.monthCardEndTime = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.playerGender = nil
  self.alliancePower = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.allianceId then
    self.allianceId = message.allianceId
  end
  if message.alliancename then
    self.allianceName = message.alliancename
  end
  if message.abbr then
    self.abbr = message.abbr
  end
  if message.announce then
    self.announce = message.announce
  end
  if message.icon then
    self.icon = message.icon
  end
  if message.intro then
    self.intro = message.intro
  end
  if message.language then
    self.language = message.language
  end
  if message.country then
    self.country = message.country
  end
  if message.curMember then
    self.curMember = message.curMember
  end
  if message.maxMember then
    self.maxMember = message.maxMember
  end
  if message.createtime then
    self.createTimee = message.createtime
  end
  if message.inviteTime then
    self.inviteTime = message.inviteTime
  end
  if message.power then
    self.alliancePower = message.power
  end
  if message.leaderInfo then
    local leaderInfo = message.leaderInfo
    if leaderInfo.userName then
      self.playerName = leaderInfo.userName
    end
    if leaderInfo.uid then
      self.playerUid = leaderInfo.uid
    end
    if leaderInfo.pic then
      self.pic = leaderInfo.pic
    end
    if leaderInfo.picVer then
      self.picVer = leaderInfo.picVer
    end
    if leaderInfo.countryFlag then
      self.playerNation = leaderInfo.countryFlag
    end
    if leaderInfo.monthCardEndTime then
      self.monthCardEndTime = leaderInfo.monthCardEndTime
    end
    if leaderInfo.headSkinId then
      self.headSkinId = leaderInfo.headSkinId
    end
    if leaderInfo.headSkinET then
      self.headSkinET = leaderInfo.headSkinET
    end
    if leaderInfo.playerGender then
      self.playerGender = leaderInfo.gender
    end
  end
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function CheckIfIsValid(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local confT = LuaEntry.DataConfig:TryGetNum("union_control", "k6")
  local expireTime = curTime + confT * 3600000
  if curTime < expireTime then
    return true
  else
    return false
  end
end

AllianceAutoInviteData.__init = __init
AllianceAutoInviteData.__delete = __delete
AllianceAutoInviteData.ParseData = ParseData
AllianceAutoInviteData.GetHeadBgImg = GetHeadBgImg
AllianceAutoInviteData.CheckIfIsValid = CheckIfIsValid
return AllianceAutoInviteData
