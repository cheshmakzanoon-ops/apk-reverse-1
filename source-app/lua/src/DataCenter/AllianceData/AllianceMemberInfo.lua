local AllianceMemberInfo = BaseClass("AllianceMemberInfo")

local function __init(self)
  self.mainCityLv = 0
  self.pic = ""
  self.picVer = 0
  self.uid = ""
  self.offLineTime = 0
  self.pointId = 0
  self.serverId = ""
  self.name = ""
  self.rank = 0
  self.online = false
  self.power = 0
  self.playerSelf = ""
  self.monthCardEndTime = -1
  self.armyKill = 0
  self.careerType = CareerType.None
  self.careerLv = 0
  self.careerPos = AllianceCareerPosType.No
  self.lastOnlineTime = 0
  self.donateTodayProgress = 0
  self.donateWeeklyProgress = 0
  self.donateTime = 0
  self.weeklyDonateTime = 0
  self.joinTime = 0
  self.gender = -1
  self.level = 1
  self.headSkinId = nil
  self.headSkinET = nil
  self.curServerId = nil
  self.rankTime = nil
  self.isFar = false
  self.isHonorMember = false
end

local function __delete(self)
  self.mainCityLv = nil
  self.pic = nil
  self.picVer = nil
  self.uid = nil
  self.offLineTime = nil
  self.pointId = nil
  self.serverId = nil
  self.name = nil
  self.rank = nil
  self.online = nil
  self.power = nil
  self.playerSelf = nil
  self.monthCardEndTime = nil
  self.armyKill = nil
  self.careerType = nil
  self.careerLv = nil
  self.careerPos = nil
  self.gender = nil
  self.level = nil
  self.joinTime = nil
  self.donateTodayProgress = nil
  self.donateWeeklyProgress = nil
  self.donateTime = nil
  self.weeklyDonateTime = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.rankTime = nil
  self.curServerId = nil
  self.isFar = nil
  self.isHonorMember = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  if message.joinTime ~= nil then
    self.joinTime = message.joinTime
  end
  if message.mainCityLv ~= nil then
    self.mainCityLv = message.mainCityLv
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.offLineTime ~= nil then
    self.offLineTime = message.offLineTime
  end
  if message.pointId ~= nil then
    self.pointId = toInt(message.pointId)
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.rank ~= nil then
    self:SetRank(message.rank)
  end
  if message.online ~= nil then
    self.online = message.online
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.playerSelf ~= nil then
    self.playerSelf = message.playerSelf
  end
  if message.playerName ~= nil then
    self.name = message.playerName
  end
  if message.userId ~= nil then
    self.uid = message.userId
  end
  if message.monthCardEndTime then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.armyKill then
    self.armyKill = message.armyKill
  end
  if message.careerType then
    self.careerType = message.careerType
  end
  if message.careerLv then
    self.careerLv = message.careerLv
  end
  if message.careerPos then
    self.careerPos = message.careerPos
  end
  if message.careerPos then
    self.careerPos = message.careerPos
  end
  if message.gender then
    self.gender = message.gender
  end
  if message.level then
    self.level = message.level
  end
  if message.todayProgress then
    self.donateTodayProgress = message.todayProgress
  end
  if message.weeklyProgress then
    self.donateWeeklyProgress = message.weeklyProgress
  end
  if message.donateTime then
    self.donateTime = message.donateTime
  end
  if message.weeklyDonateTime then
    self.weeklyDonateTime = message.weeklyDonateTime
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  if message.curServerId then
    self.curServerId = message.curServerId
  end
  if message.rankTime then
    self.rankTime = message.rankTime
  end
  self.isHonorMember = message.isHonorMember
  self:RefreshMemberIsFarRallyPoint()
end

local function SetRank(self, rank)
  self.rank = rank
end

local function GetRank(self)
  return self.rank
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function CheckIfIsInactivePlayer(self)
  if self.online then
    return false
  end
  local confTimeH = DataCenter.AllianceMemberDataManager:GetInactiveConfTime(self.power)
  local offlineInterval = UITimeManager:GetInstance():GetServerTime() - self.offLineTime
  if offlineInterval >= confTimeH * 3600000 then
    return true
  end
end

local function SetCareerPos(self, pos)
  self.careerPos = pos
end

local function RefreshMemberIsFarRallyPoint(self)
  if self.pointId ~= nil and self.curServerId ~= nil then
    self.isFar = DataCenter.AllianceRallyPointDataManager:CheckPointIsFarRallyPoint(self.pointId, self.curServerId)
  end
end

local function CheckIfInactiveV2Player(self)
  if self.online then
    return false
  end
  if self.isHonorMember then
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return
  end
  local confTimeH = DataCenter.AllianceMemberDataManager:GetInactiveConfTime(self.power)
  local offlineInterval = UITimeManager:GetInstance():GetServerTime() - self.offLineTime
  if offlineInterval >= confTimeH * 3600000 then
    return true
  end
end

local function GetJoinDay(self)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  return UITimeManager:GetInstance():GetBetweenDaysForServerTime(now, self.joinTime / 1000)
end

AllianceMemberInfo.__init = __init
AllianceMemberInfo.__delete = __delete
AllianceMemberInfo.ParseData = ParseData
AllianceMemberInfo.SetRank = SetRank
AllianceMemberInfo.GetRank = GetRank
AllianceMemberInfo.GetHeadBgImg = GetHeadBgImg
AllianceMemberInfo.SetCareerPos = SetCareerPos
AllianceMemberInfo.CheckIfIsInactivePlayer = CheckIfIsInactivePlayer
AllianceMemberInfo.RefreshMemberIsFarRallyPoint = RefreshMemberIsFarRallyPoint
AllianceMemberInfo.CheckIfInactiveV2Player = CheckIfInactiveV2Player
AllianceMemberInfo.GetJoinDay = GetJoinDay
return AllianceMemberInfo
