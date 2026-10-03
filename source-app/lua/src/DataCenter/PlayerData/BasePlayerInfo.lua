local BasePlayerInfo = BaseClass("BasePlayerInfo")
local rapidjson = require("rapidjson")

local function __init(self)
  self.moodStr = ""
  self.uid = ""
  self.picVer = 0
  self.pic = ""
  self.name = ""
  self.gender = 0
  self.allianceId = ""
  self.alAbbr = ""
  self.allianceName = ""
  self.playerPower = 0
  self.armyKill = 0
  self.serverId = 0
  self.baseLevel = 1
  self.mainBuildPointId = 0
  self.mainBuildUuid = 0
  self.buildingPower = 0
  self.sciencePower = 0
  self.armyPower = 0
  self.heroPower = 0
  self.squadEquipPower = 0
  self.playerMaxPower = 0
  self.battleWin = 0
  self.battleLose = 0
  self.armyDead = 0
  self.scoutCount = 0
  self.armyKill = 0
  self.updateTime = 0
  self.monthCardEndTime = -1
  self.level = 0
  self.exp = 0
  self.careerType = MasteryHome.None
  self.careerLv = 0
  self.countryFlag = DefaultNation
  self.headSkinId = nil
  self.headSkinET = nil
  self.chatBubbleId = nil
  self.chatBubbleET = nil
  self.allianceRank = -1
  self.isFriendsCircleOpen = nil
  self.isShield = nil
  self.friendsCircleSet = nil
  self.title = 0
  self.titleWall = nil
  self.giftLevel = 0
  self.giftDataList = {}
  self.hasFetchProfileHint = false
  self.birthday = nil
  self.birthdayDisplay = nil
  self.zodDisplay = nil
  self.isKid = 0
  self.unlockShow = nil
  self.extraGiftShowNum = 0
  self.isPlayGiftShowAni = nil
  self.srcServer = nil
end

local function __delete(self)
  self.moodStr = nil
  self.uid = nil
  self.picVer = nil
  self.pic = nil
  self.name = nil
  self.gender = nil
  self.allianceId = nil
  self.alAbbr = nil
  self.allianceName = nil
  self.playerPower = nil
  self.armyKill = nil
  self.serverId = nil
  self.baseLevel = nil
  self.mainBuildPointId = nil
  self.mainBuildUuid = nil
  self.buildingPower = nil
  self.sciencePower = nil
  self.armyPower = nil
  self.heroPower = nil
  self.playerMaxPower = nil
  self.battleWin = nil
  self.battleLose = nil
  self.armyDead = nil
  self.scoutCount = nil
  self.armyKill = nil
  self.updateTime = nil
  self.monthCardEndTime = nil
  self.level = nil
  self.exp = nil
  self.careerType = nil
  self.careerLv = nil
  self.countryFlag = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.chatBubbleId = nil
  self.chatBubbleET = nil
  self.allianceRank = -1
  self.title = 0
  self.titleWall = nil
  self.giftLevel = 0
  self.giftDataList = nil
  self.hasFetchProfileHint = false
  self.birthday = nil
  self.birthdayDisplay = nil
  self.zodDisplay = nil
  self.isKid = 0
  self.unlockShow = nil
  self.extraGiftShowNum = 0
  self.isPlayGiftShowAni = nil
  self.srcServer = nil
end

local function ParseData(self, message, forceSyncHeadFrame)
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.gender ~= nil then
    self.gender = message.gender
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  elseif message.picver ~= nil then
    self.picVer = message.picver
  elseif message.headPicVer ~= nil then
    self.picVer = message.headPicVer
  end
  if message.pic ~= nil then
    self.pic = message.pic
  elseif message.headPic ~= nil then
    self.pic = message.headPic
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.abbr ~= nil then
    self.alAbbr = message.abbr
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.armyKill ~= nil then
    self.armyKill = message.armyKill
  end
  if message.moodStr ~= nil then
    self.moodStr = message.moodStr
  end
  if message.monthCardEndTime ~= nil then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.baseLevel then
    self.baseLevel = message.baseLevel
  end
  if message.serverId then
    self.serverId = message.serverId
  end
  if message.mainBuildPointId ~= nil then
    self.mainBuildPointId = message.mainBuildPointId
  end
  if message.mainBuildUuid ~= nil then
    self.mainBuildUuid = message.mainBuildUuid
  end
  if message.buildingPower ~= nil then
    self.buildingPower = message.buildingPower
  end
  if message.sciencePower ~= nil then
    self.sciencePower = message.sciencePower
  end
  if message.armyPower ~= nil then
    self.armyPower = message.armyPower
  end
  if message.heroPower ~= nil then
    self.heroPower = message.heroPower
  end
  if message.squadEquipPower ~= nil then
    self.squadEquipPower = message.squadEquipPower
  end
  if message.playerMaxPower ~= nil then
    self.playerMaxPower = message.playerMaxPower
  end
  if message.battleWin ~= nil then
    self.battleWin = message.battleWin
  end
  if message.battleLose ~= nil then
    self.battleLose = message.battleLose
  end
  if message.armyDead ~= nil then
    self.armyDead = message.armyDead
  end
  if message.scoutCount ~= nil then
    self.scoutCount = message.scoutCount
  end
  if message.countryflag then
    self.countryFlag = message.countryflag
  end
  if message.armyKill ~= nil then
    self.armyKill = message.armyKill
  end
  if message.level ~= nil then
    self.level = message.level
  end
  if message.exp ~= nil then
    self.exp = message.exp
  end
  if message.careerType ~= nil then
    self.careerType = message.careerType
  end
  if message.careerLv ~= nil then
    self.careerLv = message.careerLv
  end
  if message.title ~= nil then
    self.title = message.title
  end
  if message.titleWall ~= nil then
    self.titleWall = {}
    local list = message.titleWall
    for i, v in ipairs(list) do
      self.titleWall[v.position] = v
    end
  end
  if message.giftLevel ~= nil then
    self.giftLevel = message.giftLevel
  end
  if message.unlockShow ~= nil then
    self:SetUnlockShow(message)
  end
  if message.giftShow ~= nil then
    self:InitGiftDic(message)
  end
  if forceSyncHeadFrame or message.headSkinId ~= nil then
    self.headSkinId = message.headSkinId
  end
  if forceSyncHeadFrame or message.headSkinET ~= nil then
    self.headSkinET = message.headSkinET
  end
  if message.chatBubbleId ~= nil then
    self.chatBubbleId = message.chatBubbleId
  end
  if message.chatBubbleET ~= nil then
    self.chatBubbleET = message.chatBubbleET
  end
  if message.is_kid ~= nil then
    self.isKid = message.is_kid
  end
  self.hasFetchProfileHint = false
  if message.thumbsUpCount then
    self.thumbsUpCount = toInt(message.thumbsUpCount)
  else
    self.thumbsUpCount = 0
  end
  if message.thumbsUpInfo then
    self.thumbsUpCountOld = toInt(message.thumbsUpInfo.oldThumbsUpCount)
    self.thumbsUpCountDiff = toInt(message.thumbsUpInfo.allNum)
    self.ThumbsUpPlayerList = message.thumbsUpInfo.list or {}
    self.hasFetchProfileHint = true
  else
    self.thumbsUpCountOld = 0
    self.thumbsUpCountDiff = 0
    self.ThumbsUpPlayerList = {}
  end
  if message.birthdayInteractive then
    self.birthdayThumbsUpCountOld = toInt(message.birthdayInteractive.oldCount)
    self.birthdayThumbsUpCountDiff = toInt(message.birthdayInteractive.upCount)
    self.birthdayThumbsUpPlayerList = message.birthdayInteractive.fromUsers or {}
  else
    self.birthdayThumbsUpCountOld = 0
    self.birthdayThumbsUpCountDiff = 0
    self.birthdayThumbsUpPlayerList = {}
  end
  self.joinAllianceThumbsUpCount = toInt(message.joinAllianceThumbsUpCount)
  if message.joinAllianceThumbsUpInfo then
    self.highFiveCount = toInt(message.joinAllianceThumbsUpInfo.oldThumbsUpCount)
    self.highFiveDiff = toInt(message.joinAllianceThumbsUpInfo.allNum)
    self.highFivePlayerList = message.joinAllianceThumbsUpInfo.list or {}
  else
    self.highFiveCount = 0
    self.highFiveDiff = 0
    self.highFivePlayerList = {}
  end
  if message.giftInfo then
    self.newGiftCount = toInt(message.giftInfo.newGiftCount)
    self.oldGiftCount = toInt(message.giftInfo.oldGiftCount)
  end
  if message.followHint then
    self.payFollowHint = {
      countOld = toInt(message.followHint.payOldCount),
      countDiff = toInt(message.followHint.payUpCount),
      playerList = message.followHint.payFollow or {},
      gifts = message.followHint.payGifts or {}
    }
    self.freeFollowHint = {
      countOld = toInt(message.followHint.freeOldCount),
      countDiff = toInt(message.followHint.freeUpCount),
      playerList = message.followHint.freeFollow or {},
      gifts = message.followHint.freeGifts or {}
    }
    self.followUser = message.followUser or {}
  else
    self.payFollowHint = nil
    self.freeFollowHint = nil
    self.followUser = nil
  end
  if message.photoAlbumStrDes ~= nil then
    self.photoAlbumStrDes = message.photoAlbumStrDes
    local slotInfo = {}
    for picVer in string.gmatch(self.photoAlbumStrDes, "([^,]+),?") do
      table.insert(slotInfo, toInt(picVer))
    end
    self.slotInfo = slotInfo
  else
    self.slotInfo = nil
  end
  if message.allianceRank ~= nil then
    self.allianceRank = message.allianceRank
  end
  if message.isFriendsCircleOpen ~= nil then
    self.isFriendsCircleOpen = message.isFriendsCircleOpen == 1
    if self.uid == LuaEntry.Player.uid then
      ChatInterface.getMoment():SetMomentIsOpen(self.isFriendsCircleOpen)
    end
  end
  if message.chatShield ~= nil then
    self.isShield = message.chatShield == 1
  end
  if message.friendsCircleSet ~= nil then
    self.friendsCircleCommentIsOn = message.friendsCircleSet[1] == 1
    self.friendsCircleAllianceVisibleIsOn = message.friendsCircleSet[2] == 1
    self.friendsCircleAllianceMomentIsOn = message.friendsCircleSet[3] == 1
  end
  if message.birthday ~= nil then
    self.birthday = message.birthday
  end
  if message.birthdayDisplay ~= nil then
    self.birthdayDisplay = message.birthdayDisplay
  end
  if message.zodDisplay ~= nil then
    self.zodDisplay = message.zodDisplay
  end
  if message.extraGiftShowNum ~= nil then
    self.extraGiftShowNum = message.extraGiftShowNum
  end
  if message.isPlayGiftShowAni ~= nil then
    self.isPlayGiftShowAni = message.isPlayGiftShowAni
  end
  if message.srcServer ~= nil then
    self.srcServer = message.srcServer
  end
end

function BasePlayerInfo:SetUnlockShow(message)
  if message.unlockShow ~= nil then
    self.unlockShow = message.unlockShow
  end
end

function BasePlayerInfo:InitGiftDic(message)
  local tempStr = message.giftShow
  local unlockShowStr = self.unlockShow
  local unlockShowTab = {}
  if not string.IsNullOrEmpty(unlockShowStr) then
    unlockShowTab = rapidjson.decode(unlockShowStr)
  end
  self.giftDataList = {}
  if not string.IsNullOrEmpty(tempStr) then
    tempStr = string.split(tempStr, "|")
    local tempData
    for i = 1, #tempStr do
      if not string.IsNullOrEmpty(tempStr[i]) then
        local giftData = {}
        tempData = string.split(tempStr[i], ";")
        giftData.pos = tonumber(tempData[1])
        giftData.itemId = tonumber(tempData[2])
        giftData.count = tonumber(tempData[3])
        if unlockShowTab[tostring(giftData.itemId)] then
          giftData.unlockNum = tonumber(unlockShowTab[tostring(giftData.itemId)])
        end
        table.insert(self.giftDataList, giftData)
      end
      table.sort(self.giftDataList, function(a, b)
        return a.pos < b.pos
      end)
    end
  end
end

local function ChangeMoodStr(self, str)
  self.moodStr = str
end

local function ChangeSelfName(self, name)
  self.name = name
end

local function ChangeSelfGender(self, gender)
  self.gender = gender
end

local function ChangeTitle(self, title)
  self.title = title
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function GetCountryFlagTemplate(self)
  local country = string.IsNullOrEmpty(self.countryFlag) and DefaultNation or self.countryFlag
  return DataCenter.NationTemplateManager:GetNationTemplate(country)
end

function BasePlayerInfo:GetFullName()
  if not string.IsNullOrEmpty(self.alAbbr) then
    return "[" .. self.alAbbr .. "] " .. self.name
  end
  return self.name
end

function BasePlayerInfo:ChangeTitlePosition(title, pos)
  title = title or 0
  pos = pos or 0
  if pos == 0 then
    if not self.titleWall then
      return
    end
    local titleData
    for i = 1, TitleShowCount do
      titleData = self.titleWall[i]
      if titleData and titleData.title == title then
        self.titleWall[i] = nil
      end
    end
    return
  end
  if not self.titleWall then
    self.titleWall = {}
  end
  if title == 0 then
    self.titleWall[pos] = nil
  elseif not self.titleWall[pos] or self.titleWall[pos].title ~= title then
    self.titleWall[pos] = {title = title, position = pos}
  end
end

BasePlayerInfo.__init = __init
BasePlayerInfo.__delete = __delete
BasePlayerInfo.ParseData = ParseData
BasePlayerInfo.ChangeSelfName = ChangeSelfName
BasePlayerInfo.ChangeSelfGender = ChangeSelfGender
BasePlayerInfo.ChangeMoodStr = ChangeMoodStr
BasePlayerInfo.GetHeadBgImg = GetHeadBgImg
BasePlayerInfo.ChangeTitle = ChangeTitle
BasePlayerInfo.GetCountryFlagTemplate = GetCountryFlagTemplate
return BasePlayerInfo
