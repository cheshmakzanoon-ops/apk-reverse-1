local AllianceBaseInfo = BaseClass("AllianceBaseInfo")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.uid = ""
  self.country = ""
  self.icon = "1"
  self.allianceName = ""
  self.language = ""
  self.abbr = ""
  self.fightPower = 0
  self.intro = ""
  self.curMember = 0
  self.maxMember = 0
  self.announce = ""
  self.rename = 0
  self.abbrRename = 0
  self.reIcon = 0
  self.createTime = 0
  self.allianceTaskEndTime = 0
  self.unLockFlag = 0
  self.alliancePoint = 0
  self.accPoint = 0
  self.lastRecruitTime = 0
  self.resStone = 0
  self.resCoal = 0
  self.resFarmerExp = 0
  self.ownerServerId = -1
  self.crossFightSrcServerId = -1
  self.leaderUid = ""
  self.leaderName = ""
  self.leaderPic = ""
  self.leaderPicVer = 0
  self.leaderMonthCardEndTime = 0
  self.recruitTotal = 0
  self.recruit = 0
  self.averageLevel = 0
  self.averagePower = 0
  self.castleRestrictionN = 0
  self.powerRestrictionN = 0
  self.recommendFunc = 0
  self.joinTime = 0
  self.rank = 0
  self.applied = 0
  self.elected = false
  self.voted = false
  self.sysAlState = SysAlState.Normal
  self.stateEndTime = 0
  self.waitMerge = nil
  self.register = 0
  self.voteList = {}
  self.rankTime = 0
  self.lookForCareers = {}
  self.admiralNum = 0
  self.giftLevel = 0
  self.translateMsg = ""
  self.isTranslating = false
  self.tanslateFinish = 0
  self.translatedLang = ""
  self.sendMailTime = 0
  self.noticeNotifyOpenTime = 0
  self.translateAnnounceTitile = ""
  self.announceTitile = ""
  self.announceTitileTranslating = false
  self.applyLevelLimit = 0
  self.applyPowerLimit = 0
  self.autoKickInactiveMember = false
  self.zombieRushPoint = 0
  self.autoScienceResearch = false
  self.averagePower = 0
  self.editTime = 0
  self.editCount = 0
  self.allianceEngagementPoint = 0
  self.allianceScore = 0
  self.powerScore = 0
  self.rewardScore = 0
  self.dailyTaskScore = 0
  self.r4LimitScore = 0
  self.blackIndustryScore = 0
  self.comprehensiveScore = 0
end

local function __delete(self)
  self.uid = nil
  self.country = nil
  self.icon = nil
  self.allianceName = nil
  self.language = nil
  self.abbr = nil
  self.fightPower = nil
  self.intro = nil
  self.curMember = nil
  self.maxMember = nil
  self.announce = nil
  self.abbrRename = nil
  self.rename = nil
  self.reIcon = nil
  self.createTime = nil
  self.allianceTaskEndTime = nil
  self.unLockFlag = nil
  self.alliancePoint = nil
  self.accPoint = nil
  self.ownerServerId = nil
  self.crossFightSrcServerId = nil
  self.giftLevel = nil
  self.leaderUid = nil
  self.leaderName = nil
  self.leaderPic = nil
  self.leaderPicVer = nil
  self.recruitTotal = nil
  self.recommendFunc = nil
  self.recruit = nil
  self.averageLevel = nil
  self.averagePower = nil
  self.castleRestriction = nil
  self.powerRestriction = nil
  self.joinTime = nil
  self.rank = nil
  self.applied = nil
  self.elected = nil
  self.voted = nil
  self.sysAlState = nil
  self.stateEndTime = nil
  self.waitMerge = nil
  self.register = nil
  self.voteList = nil
  self.lookForCareers = nil
  self.admiralNum = nil
  self.sendMailTime = nil
  self.translateMsg = nil
  self.isTranslating = nil
  self.tanslateFinish = nil
  self.translatedLang = nil
  self.announceTitileTranslating = nil
  self.translateAnnounceTitile = nil
  self.announceTitile = nil
  self.noticeNotifyOpenTime = nil
  self.applyLevelLimit = nil
  self.applyPowerLimit = nil
  self.autoKickInactiveMember = nil
  self.zombieRushPoint = nil
  self.autoScienceResearch = nil
  self.averagePower = nil
  self.editTime = nil
  self.editCount = nil
  self.allianceEngagementPoint = nil
  self.allianceScore = nil
  self.powerScore = nil
  self.rewardScore = nil
  self.dailyTaskScore = nil
  self.r4LimitScore = nil
  self.blackIndustryScore = nil
  self.comprehensiveScore = nil
  self.allyInfo = nil
end

function AllianceBaseInfo:GetFullName()
  return UIUtil.FormatServerAllianceName(self.createServer or self.ownerServerId, self.abbr, self.allianceName)
end

function AllianceBaseInfo:GetBaseName()
  return UIUtil.FormatServerAllianceName(self.createServer or self.ownerServerId, self.abbr)
end

local function ParseData(self, message, isSelfAlliance)
  if message == nil then
    return
  end
  if message.alliancename ~= nil then
    self.allianceName = message.alliancename
  end
  if message.createServer ~= nil then
    self.createServer = message.createServer
  end
  if message.createTime ~= nil then
    self.createTime = message.createTime
  end
  if message.fightpower ~= nil then
    self.fightPower = message.fightpower
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.language ~= nil then
    self.language = message.language
  end
  if message.curMember ~= nil then
    self.curMember = message.curMember
  end
  if message.icon ~= nil then
    self.icon = string.IsNullOrEmpty(message.icon) and "1" or message.icon
  end
  if message.applied ~= nil then
    self.applied = message.applied
  end
  if message.learderName ~= nil then
    self.leaderName = message.learderName
  end
  if message.learderUid ~= nil then
    self.leaderUid = message.learderUid
    local myUid = LuaEntry.Player.uid
    if myUid == self.leaderUid then
      self.rank = 5
    end
  end
  if message.learderPic ~= nil then
    self.leaderPic = message.learderPic
  end
  if message.learderPicVer ~= nil then
    self.leaderPicVer = message.learderPicVer
  end
  if message.learderMonthCardEndTime then
    self.leaderMonthCardEndTime = message.learderMonthCardEndTime
  end
  if message.country ~= nil then
    self.country = message.country
  end
  if message.recruit ~= nil then
    self.recruit = message.recruit
  end
  if message.recruitTotal ~= nil then
    self.recruitTotal = message.recruitTotal
  end
  if message.recommendFunc then
    self.recommendFunc = message.recommendFunc
  end
  if message.rank ~= nil then
    self.rank = message.rank
  end
  if message.intro ~= nil then
    self.intro = message.intro
  end
  if message.jointime ~= nil then
    self.joinTime = message.jointime
  end
  if message.announce ~= nil then
    self.announce = message.announce
  end
  if message.noticeNotifyOpenTime ~= nil then
    self.noticeNotifyOpenTime = message.noticeNotifyOpenTime
  end
  if message.lastRecruitTime then
    self.lastRecruitTime = message.lastRecruitTime
  end
  if message.curMember ~= nil then
    self.curMember = message.curMember
  end
  if message.maxMember ~= nil then
    self.maxMember = message.maxMember
  end
  if message.abbrRename ~= nil then
    self.abbrRename = message.abbrRename
  end
  if message.rename then
    self.rename = message.rename
  end
  if message.reicon ~= nil then
    self.reIcon = message.reicon
  end
  if message.createtime then
    self.createTime = message.createtime
  end
  if message.ownerServerId ~= nil then
    self.ownerServerId = message.ownerServerId
  end
  if message.crossFightSrcServerId ~= nil then
    self.crossFightSrcServerId = message.crossFightSrcServerId
  end
  if message.ownerServerId ~= nil then
    self.ownerServerId = message.ownerServerId
  end
  if message.powerRestrictionN ~= nil then
    self.powerRestrictionN = message.powerRestrictionN
  end
  if message.castleRestrictionN ~= nil then
    self.castleRestrictionN = message.castleRestrictionN
  end
  if message.allianceTaskEndTime then
    self.allianceTaskEndTime = message.allianceTaskEndTime
  end
  if message.unLockFlag then
    self.unLockFlag = message.unLockFlag
  end
  if message.editTime then
    self.editTime = message.editTime
  end
  if message.editCount then
    self.editCount = message.editCount
  end
  if message.alliancepoint ~= nil then
    DataCenter.AllianceShopDataManager:SetAlliancePoint(message.alliancepoint)
    self.alliancePoint = message.alliancepoint
  end
  if message.accPoint ~= nil then
    DataCenter.AllianceShopDataManager:SetAccPoint(message.accPoint)
    self.accPoint = message.accPoint
  end
  if message.averageLevel ~= nil then
    self.averageLevel = message.averageLevel
  end
  if message.averagePower ~= nil then
    self.averagePower = message.averagePower
  end
  if message.candidate ~= nil then
    self.elected = message.candidate
  end
  if message.vote then
    self.voted = message.vote
  end
  if message.waitMerge then
    self.waitMerge = message.waitMerge
  end
  if message.register then
    self.register = message.register
  end
  if message.voteList then
    self.voteList = message.voteList
  end
  if message.system then
    self.createdByPlayer = message.system == 1
  end
  if message.rankTime then
    self.rankTime = message.rankTime
  end
  if message.militaryNum ~= nil and isSelfAlliance then
    DataCenter.AllianceWarDataManager:SetAllianceWarCount(message.militaryNum)
  end
  if message.helpcount ~= nil and isSelfAlliance then
    DataCenter.AllianceHelpDataManager:SetHelpNum(message.helpcount)
  end
  if message.giftlevel ~= nil then
    if isSelfAlliance then
      DataCenter.AllianceGiftDataManager:SetCurLevel(message.giftlevel)
    end
    self.giftLevel = message.giftlevel
  end
  if message.lookingForCareers then
    self.lookForCareers = {}
    for _, str in ipairs(string.split(message.lookingForCareers, ";")) do
      table.insert(self.lookForCareers, tonumber(str))
    end
  end
  if message.admiralNum then
    self.admiralNum = message.admiralNum
  end
  if message.sendMailTimeStamp then
    self.sendMailTime = message.sendMailTimeStamp
  end
  if message.applyLevelLimit then
    self.applyLevelLimit = message.applyLevelLimit
  end
  if message.applyPowerLimit then
    self.applyPowerLimit = message.applyPowerLimit
  end
  if message.autoKickInactiveMember then
    self.autoKickInactiveMember = message.autoKickInactiveMember == 1
  end
  if message.autoScienceResearch then
    self.autoScienceResearch = message.autoScienceResearch == 1
  end
  if message.zombieRushPoint then
    self:UpdateZombieRushPoint(message.zombieRushPoint)
  end
  self:ParseScoreData(message)
  self:RefreshAveragePower()
end

local function ParseDataNew(self, message, isSelfAlliance)
  if message == nil then
    return
  end
  if message.createServer ~= nil then
    self.createServer = message.createServer
  end
  if message.createTime ~= nil then
    self.createTime = message.createTime
  end
  if message.name ~= nil then
    self.allianceName = message.name
  end
  if message.fightPower ~= nil then
    self.fightPower = message.fightPower
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.language ~= nil then
    self.language = message.language
  end
  if message.curMember ~= nil then
    self.curMember = message.curMember
  end
  if message.icon ~= nil then
    self.icon = string.IsNullOrEmpty(message.icon) and "1" or message.icon
  end
  if message.leaderName ~= nil then
    self.leaderName = message.leaderName
  end
  if message.leaderUid ~= nil then
    self.leaderUid = message.leaderUid
  end
  if message.leaderPic ~= nil then
    self.leaderPic = message.leaderPic
  end
  if message.leaderPicVer ~= nil then
    self.leaderPicVer = message.leaderPicVer
  end
  if message.country ~= nil then
    self.country = message.country
  end
  if message.recruit ~= nil then
    self.recruit = message.recruit
  end
  if message.recruitTotal ~= nil then
    self.recruitTotal = message.recruitTotal
  end
  if message.rank ~= nil then
    self.rank = message.rank
  end
  if message.rankTime then
    self.rankTime = message.rankTime
  end
  if message.intro ~= nil then
    self.intro = message.intro
  end
  if message.announce ~= nil then
    self.announce = message.announce
  end
  if message.curMember ~= nil then
    self.curMember = message.curMember
  end
  if message.maxMember ~= nil then
    self.maxMember = message.maxMember
  end
  if message.abbrRename ~= nil then
    self.abbrRename = message.abbrRename
  end
  if message.rename then
    self.rename = message.rename
  end
  if message.reicon ~= nil then
    self.reIcon = message.reicon
  end
  if message.createTime then
    self.createTime = message.createTime
  end
  if message.ownerServerId ~= nil then
    self.ownerServerId = message.ownerServerId
  end
  if message.crossFightSrcServerId ~= nil then
    self.crossFightSrcServerId = message.crossFightSrcServerId
  end
  if message.ownerServerId ~= nil then
    self.ownerServerId = message.ownerServerId
  end
  if message.powerRestrictionN ~= nil then
    self.powerRestrictionN = message.powerRestrictionN
  end
  if message.castleRestrictionN ~= nil then
    self.castleRestrictionN = message.castleRestrictionN
  end
  if message.allianceTaskEndTime then
    self.allianceTaskEndTime = message.allianceTaskEndTime
  end
  if message.unLockFlag then
    self.unLockFlag = message.unLockFlag
  end
  if message.alliancepoint ~= nil then
    DataCenter.AllianceShopDataManager:SetAlliancePoint(message.alliancepoint)
    self.alliancePoint = message.alliancepoint
  end
  if message.accPoint ~= nil then
    DataCenter.AllianceShopDataManager:SetAccPoint(message.accPoint)
    self.accPoint = message.accPoint
  end
  if message.averageLevel ~= nil then
    self.averageLevel = message.averageLevel
  end
  if message.averagePower ~= nil then
    self.averagePower = message.averagePower
  end
  if message.candidate ~= nil then
    self.elected = message.candidate
  end
  if message.vote then
    self.voted = message.vote
  end
  if message.waitMerge then
    self.waitMerge = message.waitMerge
  end
  if message.register then
    self.register = message.register
  end
  if message.voteList then
    self.voteList = message.voteList
  end
  if message.system then
    self.createdByPlayer = message.system == 1
  end
  if message.militaryNum ~= nil and isSelfAlliance then
    DataCenter.AllianceWarDataManager:SetAllianceWarCount(message.militaryNum)
  end
  if message.helpcount ~= nil and isSelfAlliance then
    DataCenter.AllianceHelpDataManager:SetHelpNum(message.helpcount)
  end
  if message.giftLevel ~= nil then
    if isSelfAlliance then
      DataCenter.AllianceGiftDataManager:SetCurLevel(message.giftLevel)
    end
    self.giftLevel = message.giftLevel
  end
  if message.lookingForCareers then
    self.lookForCareers = {}
    for _, str in ipairs(string.split(message.lookingForCareers, ";")) do
      table.insert(self.lookForCareers, tonumber(str))
    end
  end
  if message.admiralNum then
    self.admiralNum = message.admiralNum
  end
  if message.applyLevelLimit then
    self.applyLevelLimit = message.applyLevelLimit
  end
  if message.applyPowerLimit then
    self.applyPowerLimit = message.applyPowerLimit
  end
  if message.autoKickInactiveMember then
    self.autoKickInactiveMember = message.autoKickInactiveMember == 1
  end
  if message.autoScienceResearch then
    self.autoScienceResearch = message.autoScienceResearch == 1
  end
  if message.zombieRushPoint then
    self:UpdateZombieRushPoint(message.zombieRushPoint)
  end
  self:ParseScoreData(message)
  self:RefreshAveragePower()
  self.allyInfo = message.allyInfo
end

local function SetApplyState(self, state)
  self.applied = state
end

local function CheckIfIsVirtualLeader(self)
  return self.leaderUid == ""
end

local function GetHeadBgImg_Leader(self)
  local headBgImg
  local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
  if self.leaderMonthCardEndTime and serverTimeS < self.leaderMonthCardEndTime then
    headBgImg = "Common_playerbg_golloes"
  end
  if headBgImg and headBgImg ~= "" then
    return string.format(LoadPath.CommonNewPath, headBgImg)
  end
end

local function RefreshAllianceSetting(self, message)
  if message.intro ~= nil then
    self.intro = message.intro
  end
  if message.name ~= nil then
    self.allianceName = message.name
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.rename then
    self.rename = message.rename
  end
  if message.abbrRename then
    self.abbrRename = message.abbrRename
  end
  if message.recruitTotal ~= nil then
    self.recruitTotal = message.recruitTotal
  end
  if message.language ~= nil then
    self.language = message.language
  end
  if message.powerRestrictionN ~= nil then
    self.powerRestrictionN = message.powerRestrictionN
  end
  if message.castleRestrictionN ~= nil then
    self.castleRestrictionN = message.castleRestrictionN
  end
  if message.lookingForCareers then
    self.lookForCareers = {}
    for _, str in ipairs(string.split(message.lookingForCareers, ";")) do
      table.insert(self.lookForCareers, tonumber(str))
    end
  end
  if message.admiralNum then
    self.admiralNum = message.admiralNum
  end
  if message.country ~= nil then
    self.country = message.country
  end
  if message.applyLevelLimit then
    self.applyLevelLimit = message.applyLevelLimit
  end
  if message.applyPowerLimit then
    self.applyPowerLimit = message.applyPowerLimit
  end
  if message.autoKickInactiveMember then
    self.autoKickInactiveMember = message.autoKickInactiveMember == 1
  end
  if message.autoScienceResearch then
    self.autoScienceResearch = message.autoScienceResearch == 1
  end
end

local function UpdateVoteList(self, voteList)
  self.voteList = voteList
end

local function UpdateRegister(self, register)
  self.register = register
end

local function CheckIfAllianceFuncOpen(self, funcType)
  local temp = 10 ^ (funcType - 1)
  local num = self.unLockFlag / temp
  local numIsOpen = math.modf(num % 10)
  return numIsOpen == 1
end

local function GetCountryFlagTemplate(self)
  local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
  return DataCenter.NationTemplateManager:GetNationTemplate(country)
end

local function SetTranslationMsg(self, translateMsg)
  self.translateMsg = translateMsg
end

local function GetTranslationMsg(self)
  return self.translateMsg
end

local function SetIsTranslating(self, translatingFlag)
  self.isTranslating = translatingFlag
end

local function GetIsTranslating(self)
  return self.isTranslating
end

local function SetTranslateLanguage(self, language)
  self.language = language
end

local function SetTranslateFinishState(self, state)
  self.tanslateFinish = state
end

local function GetTranslateFinishState(self)
  return self.tanslateFinish
end

local function GetMessage(self)
  return self.announce
end

local function UpdateZombieRushPoint(self, point)
  self.zombieRushPoint = point
end

function AllianceBaseInfo:GeTranstAnnounceTitle()
  return self.translateAnnounceTitile
end

function AllianceBaseInfo:SetTransAnnounceTitle(titleMsg)
  self.translateAnnounceTitile = titleMsg
end

function AllianceBaseInfo:SetAnnounceTitle(announceTitle)
  self.announceTitile = announceTitle
end

function AllianceBaseInfo:GetAnnounceTitle()
  return self.announceTitile
end

function AllianceBaseInfo:SetAnnounceTitleTranslateing(doing)
  self.announceTitileTranslating = doing
end

function AllianceBaseInfo:GetAnnounceTitleTranslateing()
  return self.announceTitileTranslating
end

function AllianceBaseInfo:CheckEditCDPass()
  local isPass = false
  local time = 0
  local cfgData = DataCenter.AllianceBaseDataManager:GetNoticeEditCDCfg()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.editTime + cfgData.time * 1000 then
    isPass = true
  elseif self.editCount < cfgData.num then
    isPass = true
  else
    time = self.editTime + cfgData.time * 1000 - curTime
  end
  return isPass, time
end

function AllianceBaseInfo:RefreshAveragePower()
  if self.curMember and self.curMember > 0 then
    self.averagePower = self.fightPower / self.curMember
  else
    self.averagePower = 0
  end
end

function AllianceBaseInfo:ParseScoreData(msg)
  if msg.allianceEngagementPoint then
    self.allianceEngagementPoint = msg.allianceEngagementPoint
  end
  local scoreInfo = msg.scoreInfo
  if scoreInfo then
    if scoreInfo.allianceScore then
      self.allianceScore = scoreInfo.allianceScore
    end
    if scoreInfo.powerScore then
      self.powerScore = scoreInfo.powerScore
    end
    if scoreInfo.rewardScore then
      self.rewardScore = scoreInfo.rewardScore
    end
    if scoreInfo.dailyTaskScore then
      self.dailyTaskScore = scoreInfo.dailyTaskScore
    end
    if scoreInfo.r4LimitScore then
      self.r4LimitScore = scoreInfo.r4LimitScore
    end
    if scoreInfo.blackIndustryScore then
      self.blackIndustryScore = scoreInfo.blackIndustryScore
    end
    if scoreInfo.comprehensiveScore then
      self.comprehensiveScore = Mathf.RoundTo(scoreInfo.comprehensiveScore, 1)
    end
  end
end

function AllianceBaseInfo:GetAllianceFullName()
  return "[" .. self.abbr .. "]" .. self.allianceName
end

function AllianceBaseInfo:GetAllianceServerName()
  return UIUtil.FormatServerAllianceName(self.createServer or self.ownerServerId, self.abbr, nil)
end

function AllianceBaseInfo:GetCountryFlagPath()
  local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
  if nationTemplate then
    local flagPath = nationTemplate:GetNationFlagPath()
    return flagPath
  end
  return nil
end

function AllianceBaseInfo:GetAllianceFlagPath()
  return string.format(AL_FLAG_SPRITE_PATH, self.icon)
end

function AllianceBaseInfo:GetMemberStr()
  return self.curMember .. "/" .. self.maxMember
end

function AllianceBaseInfo:GetPowerStr()
  return string.GetFormattedStr0(tonumber(self.fightPower) or 0)
end

function AllianceBaseInfo:GetGiftLevelStr()
  return Localization:GetString("140002", self.giftLevel or 0)
end

function AllianceBaseInfo:GetAllianceEngagementPointStr()
  return string.GetFormattedStr0(self.allianceEngagementPoint or 0)
end

function AllianceBaseInfo:GetLanguageStr()
  local text = ""
  local languageId = SuportedLanguagesLocalName[Localization:GetLanguage()] or ""
  if languageId == self.language then
    text = "<color=#099b4a>" .. Localization:GetString("migration_activity_interface_10037") .. "</color>"
  else
    for k, v in pairs(SuportedLanguagesLocalName) do
      if v == self.language then
        text = SuportedLanguagesName[k]
      end
    end
  end
  return text
end

function AllianceBaseInfo:GetScoreSetting()
  local setting
  if self.comprehensiveScore then
    for i, v in ipairs(DataCenter.AllianceFeatureManager.goldStarScoreList) do
      if v <= self.comprehensiveScore then
        setting = AllianceScoreUISetting[i]
      end
    end
  end
  return setting or AllianceScoreUISetting[1]
end

function AllianceBaseInfo:NeedShowFireByScoreType(scoreType)
  local alInfoFireScore = DataCenter.AllianceFeatureManager.alInfoFireScore
  if scoreType == AllianceInvite_CellType.Member then
    return alInfoFireScore <= self.allianceScore
  elseif scoreType == AllianceInvite_CellType.Power then
    return alInfoFireScore <= self.powerScore
  elseif scoreType == AllianceInvite_CellType.Gift then
    return alInfoFireScore <= self.rewardScore
  elseif scoreType == AllianceInvite_CellType.Engagement then
    return alInfoFireScore <= self.dailyTaskScore
  elseif scoreType == AllianceInvite_CellType.R4Limit then
    return false
  elseif scoreType == AllianceInvite_CellType.BlackIndustry then
    return false
  end
end

AllianceBaseInfo.__init = __init
AllianceBaseInfo.__delete = __delete
AllianceBaseInfo.ParseData = ParseData
AllianceBaseInfo.SetApplyState = SetApplyState
AllianceBaseInfo.RefreshAllianceSetting = RefreshAllianceSetting
AllianceBaseInfo.CheckIfIsVirtualLeader = CheckIfIsVirtualLeader
AllianceBaseInfo.UpdateVoteList = UpdateVoteList
AllianceBaseInfo.UpdateRegister = UpdateRegister
AllianceBaseInfo.CheckIfAllianceFuncOpen = CheckIfAllianceFuncOpen
AllianceBaseInfo.GetHeadBgImg_Leader = GetHeadBgImg_Leader
AllianceBaseInfo.GetCountryFlagTemplate = GetCountryFlagTemplate
AllianceBaseInfo.ParseDataNew = ParseDataNew
AllianceBaseInfo.SetTranslationMsg = SetTranslationMsg
AllianceBaseInfo.GetTranslationMsg = GetTranslationMsg
AllianceBaseInfo.SetIsTranslating = SetIsTranslating
AllianceBaseInfo.GetIsTranslating = GetIsTranslating
AllianceBaseInfo.SetTranslateLanguage = SetTranslateLanguage
AllianceBaseInfo.SetTranslateFinishState = SetTranslateFinishState
AllianceBaseInfo.GetTranslateFinishState = GetTranslateFinishState
AllianceBaseInfo.GetMessage = GetMessage
AllianceBaseInfo.UpdateZombieRushPoint = UpdateZombieRushPoint
return AllianceBaseInfo
