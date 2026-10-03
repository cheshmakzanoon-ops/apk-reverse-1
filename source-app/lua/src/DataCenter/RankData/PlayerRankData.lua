local PlayerRankData = BaseClass("PlayerRankData")

local function __init(self)
  self.uid = ""
  self.name = ""
  self.allianceAbbr = ""
  self.allianceName = ""
  self.power = 0
  self.kill = 0
  self.baseLevel = 0
  self.rank = 0
  self.type = RankType.None
  self.pic = ""
  self.picVer = 0
  self.monthCardEndTime = 0
  self.country = DefaultNation
  self.headSkinId = nil
  self.headSkinET = nil
  self.score = 0
  self.stageGroup = ""
  self.stageOrder = ""
  self.lootNum = 0
  self.wasteland_time = 0
  self.showName = nil
  self.language = nil
end

local function __delete(self)
  self.uid = nil
  self.name = nil
  self.allianceAbbr = nil
  self.allianceName = nil
  self.power = nil
  self.kill = nil
  self.baseLevel = nil
  self.rank = nil
  self.type = nil
  self.pic = nil
  self.picVer = nil
  self.monthCardEndTime = nil
  self.country = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.score = nil
  self.stageGroup = nil
  self.stageOrder = nil
  self.lootNum = nil
  self.showName = nil
  self.wasteland_time = nil
  self.language = nil
end

local function ParseData(self, message, type)
  self.type = type
  if message == nil then
    return
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
    self.allianceAbbr = message.abbr
  end
  if message.alliancename ~= nil then
    self.allianceName = message.alliancename
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.armyKill ~= nil then
    self.kill = message.armyKill
  end
  if message.rank ~= nil then
    self.rank = message.rank
  end
  if message.level ~= nil then
    self.baseLevel = message.level
  end
  if message.pic ~= nil then
    self.pic = message.pic
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  elseif message.picver ~= nil then
    self.picVer = message.picver
  end
  if message.monthCardEndTime then
    self.monthCardEndTime = message.monthCardEndTime
  end
  if message.country then
    self.country = message.country
  end
  if message.heroId then
    self.heroId = message.heroId
  end
  if message.heroPower then
    self.heroPower = message.heroPower
  end
  if message.pveMaxStage then
    local stageId = message.pveMaxStage
    self.pveMaxStage = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId, "order", 0) or 0
  end
  if message.dominatorId then
    local cfg = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(message.dominatorId)
    if cfg and cfg.idle_reward_stageid then
      self.dominatorId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), cfg.idle_reward_stageid, "order", 0) or 0
    end
  end
  if message.srcServer then
    self.srcServer = message.srcServer
  end
  if not self.srcServer then
    self.srcServer = message.serverId
  end
  if message.headSkinId then
    self.headSkinId = message.headSkinId
  end
  if message.headSkinET then
    self.headSkinET = message.headSkinET
  end
  if message.score then
    self.score = message.score
  end
  if message.group then
    self.stageGroup = message.group
  end
  if message.order then
    self.stageOrder = message.order
  end
  if message.loot_num then
    self.lootNum = message.loot_num
  end
  if message.wasteland_time then
    self.wasteland_time = message.wasteland_time
  end
  if message.language then
    self.language = message.language
  end
  if message.costTimeInMills then
    self.costTimeInMills = message.costTimeInMills
  end
  if message.trytimes then
    self.trytimes = message.trytimes
  end
  if message.idleGameLevel then
    self.idleGameLevel = message.idleGameLevel
  end
  if message.idleGameBoss then
    self.idleGameBoss = message.idleGameBoss
  end
end

local function SetRank(self, rank)
  self.rank = rank
end

local function GetHeadBgImg(self)
  local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, false)
  return headBgImg
end

local function GetCountryFlagTemplate(self)
  local country = string.IsNullOrEmpty(self.country) and DefaultNation or self.country
  return DataCenter.NationTemplateManager:GetNationTemplate(country)
end

local function GetShowName(self)
  if not self.showName and self.name then
    if self.abbr == nil or self.abbr == "" then
      self.showName = self.name
    elseif self.uid == LuaEntry.Player.uid then
      if LuaEntry.Player:IsInAlliance() then
        self.showName = "[" .. self.abbr .. "] " .. self.name
      else
        self.showName = self.name
      end
    else
      self.showName = "[" .. self.abbr .. "] " .. self.name
    end
  end
  return self.showName
end

PlayerRankData.__init = __init
PlayerRankData.__delete = __delete
PlayerRankData.ParseData = ParseData
PlayerRankData.SetRank = SetRank
PlayerRankData.GetHeadBgImg = GetHeadBgImg
PlayerRankData.GetCountryFlagTemplate = GetCountryFlagTemplate
PlayerRankData.GetShowName = GetShowName
return PlayerRankData
