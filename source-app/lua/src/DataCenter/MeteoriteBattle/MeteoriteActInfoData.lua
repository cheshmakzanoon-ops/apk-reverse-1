local MeteoriteActInfoData = BaseClass("MeteoriteActInfoData")
local MeteoriteData = require("DataCenter.MeteoriteBattle.MeteoriteData")

function MeteoriteActInfoData:__init()
  self.beginTime = 0
  self.stage = MeteoriteState.SHOW
  self.stageEndTime = 0
  self.servers = {}
  self.serverSet = {}
  self.grabLimit = 0
  self.grabTimes = 0
  self.rewards = {}
  self.count = 0
  self.counts = {}
  self.myAllianceRank = 0
  self.myRank = 0
  self.myArea = 0
  self.blackLandAllianceMember = 0
  self.yellowLandAllianceMember = 0
  self.meteorites = {}
  self.highestAllianceRankServer = 0
  self.highestAllianceRank = 0
  self.highestPersonRankServer = 0
  self.highestPersonRank = 0
  self.meteoriteFreeMoveCdEndTime = -1
end

function MeteoriteActInfoData:__delete()
  self.beginTime = 0
  self.stage = MeteoriteState.SHOW
  self.stageEndTime = 0
  self.servers = {}
  self.serverSet = {}
  self.grabLimit = 0
  self.grabTimes = 0
  self.rewards = {}
  self.count = 0
  self.counts = {}
  self.myAllianceRank = 0
  self.myRank = 0
  self.myArea = 0
  self.blackLandAllianceMember = 0
  self.yellowLandAllianceMember = 0
  self.meteorites = {}
  self.highestAllianceRankServer = 0
  self.highestAllianceRank = 0
  self.highestPersonRankServer = 0
  self.highestPersonRank = 0
end

function MeteoriteActInfoData:ParseData(t)
  if t == nil then
    return
  end
  if t.beginTime ~= nil then
    self.beginTime = t.beginTime
  end
  if t.stage ~= nil then
    self.stage = t.stage
  end
  if t.stageEndTime ~= nil then
    self.stageEndTime = t.stageEndTime
  end
  local servers = t.servers
  if servers ~= nil then
    self.servers = {}
    self.serverSet = {}
    for _, v in pairs(servers) do
      table.insert(self.servers, v)
      self.serverSet[v] = true
    end
  end
  if t.grabLimit ~= nil then
    self.grabLimit = t.grabLimit
  end
  if t.grabTimes ~= nil then
    self.grabTimes = t.grabTimes
  end
  local rewards = t.rewards
  if rewards ~= nil then
    self.rewards = {}
    for _, v in pairs(rewards) do
      self.rewards[v] = true
    end
  end
  if t.count ~= nil then
    self.count = t.count
  end
  if t.myAllianceRank ~= nil then
    self.myAllianceRank = t.myAllianceRank
  end
  if t.myRank ~= nil then
    self.myRank = t.myRank
  end
  if t.myArea ~= nil then
    self.myArea = t.myArea
  end
  if t.blackLandAllianceMember ~= nil then
    self.blackLandAllianceMember = t.blackLandAllianceMember
  end
  if t.yellowLandAllianceMember ~= nil then
    self.yellowLandAllianceMember = t.yellowLandAllianceMember
  end
  if t.meteoriteFreeMoveCdEndTime ~= nil then
    self.meteoriteFreeMoveCdEndTime = t.meteoriteFreeMoveCdEndTime
  end
  local meteorites = t.meteorites
  if meteorites ~= nil then
    local list = {}
    self.counts = {}
    self.highestAllianceRankServer = 0
    self.highestAllianceRank = 0
    self.highestPersonRankServer = 0
    self.highestPersonRank = 0
    local tmpPRank, tmpARank = 99999, 99999
    for _, v in pairs(meteorites) do
      local oneData = MeteoriteData.New()
      oneData:ParseData(v)
      table.insert(list, oneData)
      table.insert(self.counts, oneData.count)
      if oneData.personRank ~= 0 and tmpPRank > oneData.personRank then
        self.highestPersonRankServer = oneData.serverId
        self.highestPersonRank = oneData.personRank
        tmpPRank = oneData.personRank
      end
      if oneData.allianceRank ~= 0 and tmpARank > oneData.allianceRank then
        self.highestAllianceRankServer = oneData.serverId
        self.highestAllianceRank = oneData.allianceRank
        tmpARank = oneData.allianceRank
      end
    end
    self.meteorites = list
  end
end

function MeteoriteActInfoData:CheckServerInGroup(serverId)
  return self.serverSet and self.serverSet[serverId]
end

function MeteoriteActInfoData:UpdateMoveCityFreeEndTime(time)
  self.meteoriteFreeMoveCdEndTime = time
end

function MeteoriteActInfoData:Description()
  local sb = StringBuilder.New()
  local MeteoriteStateName = {
    [1] = "MATCH",
    [2] = "PREVIEW",
    [3] = "GRAB",
    [4] = "REST",
    [5] = "SHOW"
  }
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  sb:AppendFormatLine("\229\189\147\229\137\141\230\151\182\233\151\180: %s[%s]", os.date("%Y-%m-%d %H:%M:%S", curSec), curSec)
  sb:AppendFormatLine("beginTime: %s[%s]", os.date("%Y-%m-%d %H:%M:%S", self.beginTime), self.beginTime)
  sb:AppendFormatLine("stageEndTime: %s[%s]", os.date("%Y-%m-%d %H:%M:%S", self.stageEndTime), self.stageEndTime)
  sb:AppendFormatLine("meteoriteFreeMoveCdEndTime: %s", os.date("%Y-%m-%d %H:%M:%S", math.floor(self.meteoriteFreeMoveCdEndTime / 1000)))
  sb:AppendFormatLine("stage: %s[%s]", MeteoriteStateName[self.stage], self.stage)
  sb:AppendFormatLine("grabTimes: %s", self.grabTimes)
  return sb:ToString()
end

return MeteoriteActInfoData
