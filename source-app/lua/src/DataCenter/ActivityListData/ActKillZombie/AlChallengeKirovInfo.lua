local AlChallengeKirovInfo = BaseClass("AlChallengeKirovInfo")

local function __init(self)
  self.configId = 0
  self.bossId = 0
  self.bossUuid = 0
  self.bossPointId = 0
  self.personalDamage = 0
  self.allianceDamage = 0
  self.stage = 0
  self.stageStartTime = nil
  self.weaknessLevel = 0
  self.endTime = 0
  self.isRewarded = nil
  self.keyNum = 0
  self.oldAllianceId = nil
  self.lastDamage = 0
  self.lastConfigId = 0
end

local function __delete(self)
  self.configId = nil
  self.bossId = nil
  self.bossUuid = nil
  self.bossPointId = nil
  self.personalDamage = nil
  self.allianceDamage = nil
  self.stage = nil
  self.stageStartTime = nil
  self.weaknessLevel = nil
  self.endTime = nil
  self.isRewarded = nil
  self.keyNum = nil
  self.oldAllianceId = nil
  self.lastDamage = nil
  self.lastConfigId = nil
end

local function ParseData(self, message)
  if message == nil then
    return
  end
  self.bossUuid = message.bossUuid or 0
  local configId = message.configId
  self.configId = configId or 0
  local bossId = configId and GetTableData(TableName.activity_challenge_zombie, configId, "advanced_challenge_boss")
  self.bossId = bossId or 0
  self.bossPointId = message.bossPointId or 0
  self.bossServerId = message.bossServerId or LuaEntry.Player:GetSourceServerId()
  self.stage = message.stage or 0
  self.weaknessLevel = message.count or 0
  self.stageStartTime = message.stageStartTime or 0
  self.personalDamage = message.personalDamage or 0
  self.allianceDamage = message.allianceDamage or 0
  self.endTime = message.endTime or 0
  self.isRewarded = message.isRewarded
  self.keyNum = message.keyNum or 0
  self.oldAllianceId = message.oldAllianceId
  if message.planTime then
    self.planTime = message.planTime
  end
  if message.lastPlanTime then
    self.lastPlanTime = message.lastPlanTime
  end
  if message.lastConfigId then
    self.lastConfigId = message.lastConfigId
  end
  if message.lastDamage then
    self.lastDamage = message.lastDamage
  end
end

AlChallengeKirovInfo.__init = __init
AlChallengeKirovInfo.__delete = __delete
AlChallengeKirovInfo.ParseData = ParseData
return AlChallengeKirovInfo
