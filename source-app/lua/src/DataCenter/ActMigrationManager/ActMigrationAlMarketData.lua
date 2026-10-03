local ActMigrationAlMarketData = BaseClass("ActMigrationAlMarketData")

function ActMigrationAlMarketData:__init()
  self.allianceId = nil
  self.notice = nil
  self.tags = {}
  self.serverId = nil
  self.allianceName = nil
  self.abbr = nil
  self.rank = nil
  self.curMember = nil
  self.maxMember = nil
  self.icon = nil
  self.language = nil
  self.country = nil
  self.leaderUid = nil
  self.presidentUid = nil
  self.save = nil
  self.power = nil
  self.exist = nil
  self.desertTime = 0
  self.identifyFlag = 0
end

function ActMigrationAlMarketData:__delete()
  self.allianceId = nil
  self.notice = nil
  self.tags = nil
  self.serverId = nil
  self.allianceName = nil
  self.abbr = nil
  self.rank = nil
  self.curMember = nil
  self.maxMember = nil
  self.icon = nil
  self.language = nil
  self.country = nil
  self.leaderUid = nil
  self.presidentUid = nil
  self.save = nil
  self.power = nil
  self.exist = nil
  self.desertTime = nil
  self.identifyFlag = nil
end

function ActMigrationAlMarketData:ParseData(t)
  if t == nil then
    return
  end
  if t.allianceId then
    self.allianceId = t.allianceId
  end
  if t.notice then
    self.notice = t.notice
  end
  if t.tags then
    local tags = t.tags
    if type(tags) == "string" then
      if not string.IsNullOrEmpty(tags) then
        self.tags = string.string2array_i_oneSep(tags, "|")
      else
        self.tags = {}
      end
    elseif type(tags) == "table" then
      self.tags = tags
    end
  end
  if t.serverId then
    self.serverId = t.serverId
  end
  if t.allianceName then
    self.allianceName = t.allianceName
  end
  if t.abbr then
    self.abbr = t.abbr
  end
  if t.rank then
    self.rank = t.rank
  end
  if t.curMember then
    self.curMember = t.curMember
  end
  if t.maxMember then
    self.maxMember = t.maxMember
  end
  if t.icon then
    self.icon = t.icon
  end
  if t.language then
    self.language = t.language
  end
  if t.country then
    self.country = t.country
  end
  if t.leaderUid then
    self.leaderUid = t.leaderUid
  end
  if t.presidentUid then
    self.presidentUid = t.presidentUid
  end
  if t.save then
    self.save = t.save
  end
  if t.power then
    self.power = t.power
  end
  if t.exist then
    self.exist = t.exist
  end
  if t.identifyFlag then
    self.identifyFlag = t.identifyFlag
  end
  if t.desertTime then
    self.desertTime = t.desertTime
  end
  if t.comprehensiveScore then
    self.comprehensiveScore = t.comprehensiveScore
  end
  if t.scoreInfo then
    self.scoreInfo = {}
    self.scoreInfo.dailyTaskScore = t.scoreInfo.dailyTaskScore or 0
    self.scoreInfo.comprehensiveScore = t.scoreInfo.comprehensiveScore or 0
    self.scoreInfo.powerScore = t.scoreInfo.powerScore or 0
    self.scoreInfo.rewardScore = t.scoreInfo.rewardScore or 0
    self.scoreInfo.allianceScore = t.scoreInfo.allianceScore or 0
    self.comprehensiveScore = self.scoreInfo.comprehensiveScore
  end
end

return ActMigrationAlMarketData
