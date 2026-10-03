local SeasonAllianceRankDataManager = BaseClass("SeasonAllianceRankDataManager")
local rewardLogData = require("DataCenter.SeasonAllianceRank.SeasonAllianceLootRewardData")

function SeasonAllianceRankDataManager:__init()
  self.rankMap = {}
  self.lootTotal = 0
  self.lootRewardLogByIndex = {}
end

function SeasonAllianceRankDataManager:__delete()
  self.rankMap = nil
  self.lootTotal = nil
  self.lootRewardLogByIndex = nil
end

function SeasonAllianceRankDataManager:UpdataRankData(message)
  local msg = message
  local eventId = msg.event_id
  self.lootTotal = msg.loot_total
  local day = msg.day
  local selfRank = msg.self
  if eventId and day then
    if not self.rankMap[eventId] then
      self.rankMap[eventId] = {}
    end
    if not self.rankMap[eventId][day] then
      self.rankMap[eventId][day] = {}
    end
    if message.ranks ~= nil then
      local rankList = {}
      local arr = message.ranks
      for k, v in pairs(arr) do
        local oneData = PlayerRankData.New()
        oneData:ParseData(v)
        oneData:SetRank(k)
        table.insert(rankList, oneData)
      end
      self.rankMap[eventId][day].ranks = rankList
      self.rankMap[eventId][day].selfRank = selfRank
    end
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceRankDataUpdate, {eventId = eventId, subType = day})
end

function SeasonAllianceRankDataManager:DevotesAllocationHandle(message)
  if message then
    local eventId = message.event_id
    local day = message.day
    self.lootTotal = message.loot_total
    local toUid = message.to_uid or "0"
    local count = message.count or 0
    local flag = false
    if self.rankMap and self.rankMap[eventId] and self.rankMap[eventId][day] and self.rankMap[eventId][day].ranks then
      local ranks = self.rankMap[eventId][day].ranks
      for index, value in ipairs(ranks) do
        if value.uid == toUid then
          value.lootNum = value.lootNum + count
          flag = true
          break
        end
      end
      if not flag then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceDevotesRankInfo, eventId, day, 1, -1)
      end
    else
      SFSNetwork.SendMessage(MsgDefines.LWSeasonAllianceDevotesRankInfo, eventId, day, 1, -1)
    end
    EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceLootTotalUpdate, toUid)
  end
end

function SeasonAllianceRankDataManager:RequestSeasonLootReward()
  local now = UITimeManager:GetInstance():GetServerTime()
  if table.IsNullOrEmpty(self.lootRewardLogByIndex) or now - toInt(self.lastRequestSeasonLootReward) > 15000 then
    self.lootRewardLogByIndex = {}
    self.curPage = 0
    SFSNetwork.SendMessage(MsgDefines.LWSeasonLootRewardLog, 0, SeasonAllianceRewardLogRequestCount)
  end
end

function SeasonAllianceRankDataManager:SeasonLootRewardLogHandle(message)
  if message and self.lootRewardLogByIndex ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local logs = message.logs
    local page = message.page_num
    local page_size = message.page_size
    if logs and page and page_size then
      local logCount = #logs
      if 0 < logCount then
        local logData = {}
        for i, v in ipairs(logs) do
          local tRecordData = rewardLogData.New()
          tRecordData:ParseMsg(v)
          table.insert(logData, tRecordData)
        end
        self.lootRewardLogByIndex = table.mergeArray(self.lootRewardLogByIndex, logData)
        if logCount == page_size and self.curPage == page then
          self.curPage = page + 1
          SFSNetwork.SendMessage(MsgDefines.LWSeasonLootRewardLog, self.curPage, SeasonAllianceRewardLogRequestCount)
        end
      end
    end
    self.lastRequestSeasonLootReward = now
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonAllianceLootRewardInfoUpate)
end

function SeasonAllianceRankDataManager:GetRankData(eventId, subType)
  if self.rankMap and self.rankMap[eventId] then
    return self.rankMap[eventId][subType]
  end
  return nil
end

function SeasonAllianceRankDataManager:GetLootTotal()
  return self.lootTotal
end

function SeasonAllianceRankDataManager:GetLootRewardLogList()
  return self.lootRewardLogByIndex
end

return SeasonAllianceRankDataManager
