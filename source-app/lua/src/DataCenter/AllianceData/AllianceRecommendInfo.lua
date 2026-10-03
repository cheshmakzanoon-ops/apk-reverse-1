local AllianceRecommendInfo = BaseClass("AllianceRecommendInfo")
local Localization = CS.GameEntry.Localization

function AllianceRecommendInfo:__init()
  self:Clear()
end

function AllianceRecommendInfo:Clear()
  self.allianceId = ""
  self.abbr = ""
  self.alliancename = ""
  self.country = ""
  self.icon = ""
  self.language = ""
  self.curMember = 0
  self.maxMember = 0
  self.power = 0
  self.giftLevel = 0
  self.allianceEngagementPoint = 0
  self.allianceScore = 0
  self.powerScore = 0
  self.rewardScore = 0
  self.dailyTaskScore = 0
  self.r4LimitScore = 0
  self.blackIndustryScore = 0
  self.comprehensiveScore = nil
  self.recruitTotal = 0
  self.applied = nil
end

function AllianceRecommendInfo:__delete()
  self.allianceId = nil
  self.abbr = nil
  self.alliancename = nil
  self.country = nil
  self.icon = nil
  self.language = nil
  self.curMember = nil
  self.maxMember = nil
  self.power = nil
  self.giftLevel = nil
  self.allianceEngagementPoint = nil
  self.allianceScore = nil
  self.powerScore = nil
  self.rewardScore = nil
  self.dailyTaskScore = nil
  self.r4LimitScore = nil
  self.blackIndustryScore = nil
  self.comprehensiveScore = nil
  self.recruitTotal = nil
  self.applied = nil
end

function AllianceRecommendInfo:ParseMsg(msg)
  local allianceInfo = msg.allianceInfo
  if allianceInfo then
    if allianceInfo.allianceId then
      self.allianceId = allianceInfo.allianceId
    end
    if allianceInfo.abbr then
      self.abbr = allianceInfo.abbr
    end
    if allianceInfo.alliancename then
      self.alliancename = allianceInfo.alliancename
    end
    if allianceInfo.country then
      self.country = allianceInfo.country
    end
    if allianceInfo.icon then
      self.icon = allianceInfo.icon
    end
    if allianceInfo.language then
      self.language = allianceInfo.language
    end
    if allianceInfo.curMember then
      self.curMember = allianceInfo.curMember
    end
    if allianceInfo.maxMember then
      self.maxMember = allianceInfo.maxMember
    end
    if allianceInfo.power then
      self.power = allianceInfo.power
    end
    if allianceInfo.giftLevel then
      self.giftLevel = allianceInfo.giftLevel
    end
    if allianceInfo.allianceEngagementPoint then
      self.allianceEngagementPoint = allianceInfo.allianceEngagementPoint
    end
    if allianceInfo.recruitTotal then
      self.recruitTotal = allianceInfo.recruitTotal
    end
    if allianceInfo.applied then
      self.applied = allianceInfo.applied
    end
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

function AllianceRecommendInfo:GetAllianceFullName()
  return "[" .. self.abbr .. "]" .. self.alliancename
end

function AllianceRecommendInfo:GetCountryFlagPath()
  local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
  local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
  if nationTemplate then
    local flagPath = nationTemplate:GetNationFlagPath()
    return flagPath
  end
  return nil
end

function AllianceRecommendInfo:GetAllianceFlagPath()
  return string.format(AL_FLAG_SPRITE_PATH, self.icon)
end

function AllianceRecommendInfo:GetMemberStr()
  return self.curMember .. "/" .. self.maxMember
end

function AllianceRecommendInfo:GetPowerStr()
  return string.GetFormattedStr0(self.power or 0)
end

function AllianceRecommendInfo:GetGiftLevelStr()
  return Localization:GetString("140002", self.giftLevel or 0)
end

function AllianceRecommendInfo:GetAllianceEngagementPointStr()
  return string.GetFormattedStr0(self.allianceEngagementPoint or 0)
end

function AllianceRecommendInfo:GetLanguageStr()
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

function AllianceRecommendInfo:GetScoreSetting()
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

function AllianceRecommendInfo:NeedShowFireByScoreType(scoreType)
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

return AllianceRecommendInfo
