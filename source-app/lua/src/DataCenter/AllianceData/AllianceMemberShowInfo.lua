local AllianceMemberShowInfo = BaseClass("AllianceMemberShowInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
end

local function __delete(self)
  self.type = nil
  self.name = nil
  self.gender = nil
  self.power = nil
  self.uid = nil
  self.rank = nil
  self.pic = nil
  self.picVer = nil
  self.headBg = nil
  self.mainCityLv = nil
  self.isSelfAlliance = nil
  self.pointId = nil
  self.officialPic = nil
  self.officialNum = nil
  self.isInactive = nil
  self.online_time = nil
  self.isOnline = nil
  self.isFar = nil
  self.online = nil
  self.offLineTime = nil
  self.showMember = nil
  self.online = nil
  self.all = nil
  self.originData = nil
  self.isHonorMember = nil
end

local function ParseItemData(self, data)
  self.originData = data
  self.type = "AlMemberItem"
  self.rankId = data.rankId
  self.name = data.name
  self.gender = data.gender
  self.power = data.power
  self.uid = data.uid
  self.curServerId = data.curServerId
  self.rank = data.rank
  self.pic = data.pic or ""
  self.picVer = data.picVer or 0
  self.headBg = data:GetHeadBgImg()
  self.mainCityLv = data.mainCityLv
  self.isSelfAlliance = true
  self.pointId = data.pointId
  self.online = data.online
  self.offLineTime = data.offLineTime
  self.isHonorMember = data.isHonorMember
  if data.rank == 4 then
    local officialNum = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(data.uid)
    if officialNum == "" then
      self.officialPic = "Assets/Main/Sprites/UI/UIRank/btn_PlusXS"
      self.officialNum = 0
    elseif officialNum == "1" then
      self.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office1"
      self.officialNum = 1
    elseif officialNum == "2" then
      self.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office2"
      self.officialNum = 2
    elseif officialNum == "3" then
      self.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office3"
      self.officialNum = 3
    elseif officialNum == "4" then
      self.officialPic = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_office4"
      self.officialNum = 4
    end
  end
  self.isInactive = data:CheckIfInactiveV2Player()
  self.online_time = ""
  self.isOnline = data.online
  if data.online then
    self.online_time = Localization:GetString("390188")
  else
    local deltaTime = UITimeManager:GetInstance():GetServerTime() - data.offLineTime
    if 86400000 < deltaTime then
      local day = math.floor(deltaTime / 86400000)
      self.online_time = Localization:GetString("390506", day)
    elseif 3600000 < deltaTime then
      local hour = math.floor(deltaTime / 3600000)
      self.online_time = Localization:GetString("390505", hour)
    elseif 60000 < deltaTime then
      local minute = math.floor(deltaTime / 60000)
      self.online_time = Localization:GetString("390504", minute)
    else
      self.online_time = Localization:GetString("390504", 1)
    end
  end
  self.isFar = data.isFar
end

local function ParseListItemData(self, data)
  self.originData = data
  self.type = "AlMemberListItem"
  self.rankId = data.rankId
  self.showMember = data.showMember
  self.onlineNum = data.onlineInfo.online
  self.allNum = data.onlineInfo.all
  self.originAllNum = data.originAllNum
end

local function RefreshItemDataIsInactive(self)
  if self.originData and self.type == "AlMemberItem" then
    self.isInactive = self.originData:CheckIfInactiveV2Player()
  end
end

AllianceMemberShowInfo.__init = __init
AllianceMemberShowInfo.__delete = __delete
AllianceMemberShowInfo.ParseItemData = ParseItemData
AllianceMemberShowInfo.ParseListItemData = ParseListItemData
AllianceMemberShowInfo.RefreshItemDataIsInactive = RefreshItemDataIsInactive
return AllianceMemberShowInfo
