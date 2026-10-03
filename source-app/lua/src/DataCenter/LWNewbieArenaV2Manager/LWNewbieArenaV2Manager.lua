local LWNewbieArenaV2Manager = BaseClass("LWNewbieArenaV2Manager")

function LWNewbieArenaV2Manager:__init()
  function self.__onGetArenaRankList(tbl)
    self:OnGetArenaRankList(tbl)
  end
  
  EventManager:GetInstance():AddListener(EventId.ActivityArenaRankListBack, self.__onGetArenaRankList)
  self.notRecordRank = IntMaxValue
  self.cfgMap_rankhigh = {}
  local cfgTbl = LocalController:instance():getTable(TableName.LW_Newbie_Arena_V2)
  for id, _ in pairs(cfgTbl.data) do
    local cfg = LocalController:instance():getLine(TableName.LW_Newbie_Arena_V2, id)
    self.cfgMap_rankhigh[cfg.rank_high] = cfg
    if tonumber(cfg.not_record) == 1 then
      local rank = tonumber(cfg.rank_low)
      if rank < self.notRecordRank then
        self.notRecordRank = rank
      end
    end
  end
end

function LWNewbieArenaV2Manager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.ActivityArenaRankListBack, self.__onGetArenaRankList)
  self.__onGetArenaRankList = nil
end

function LWNewbieArenaV2Manager:OnGetArenaInfo(info)
  self.info = info
  self.info.state = ActivityArenaState.None
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime >= info.frontEndTime then
    if serverTime >= info.runEndTime then
      if serverTime >= info.endViewTime then
      else
        self.info.state = ActivityArenaState.Over
        self.info.targetTime = info.endViewTime
        self.countDown = info.endViewTime - serverTime
      end
    else
      self.info.state = ActivityArenaState.Fight
      self.info.targetTime = info.runEndTime
      self.countDown = info.runEndTime - serverTime
    end
  else
    self.info.state = ActivityArenaState.Wait
    self.info.targetTime = info.frontEndTime
    self.countDown = info.frontEndTime - serverTime
  end
  if self.info.state == ActivityArenaState.Fight or self.info.state == ActivityArenaState.Over then
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2RankList, self.info.id, 1, self.info.state == ActivityArenaState.Fight and 100 or 10)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaInfoUpdate, self.info.id)
  end
end

function LWNewbieArenaV2Manager:OnGetArenaRankList(rankInfo)
  assert(rankInfo, "LWNewbieArenaV2Manager:OnGetArenaRankList rankInfo is nil")
  if self.info and tonumber(self.info.id) == tonumber(rankInfo.activityId) then
    rankInfo.needPlayRankAnim = rankInfo.myRank > 0 and self.myPreRank ~= rankInfo.myRank
    self.info.rankInfo = rankInfo
    self.info.rankInfo.myPreRank = self.myPreRank
    self.myPreRank = rankInfo.myRank
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaInfoUpdate, self.info.id)
  end
end

function LWNewbieArenaV2Manager:GetRedDotCount()
  if not self.info then
    return 0
  end
  if self.info.state == ActivityArenaState.Wait then
    return 0
  end
  local achieveRewards = self.info.hasAchieveReward or 0
  local freeChallenges = self.info.state == ActivityArenaState.Fight and self.info.remainFree or 0
  return achieveRewards + freeChallenges, achieveRewards, freeChallenges
end

function LWNewbieArenaV2Manager:GetState()
  if not self.info then
    return ActivityArenaState.None
  end
  return self.info.state
end

function LWNewbieArenaV2Manager:GetArenaInfoId()
  if not self.info then
    return 0
  end
  return tonumber(self.info.id)
end

function LWNewbieArenaV2Manager:GetMyPower()
  local myPower
  if self.info ~= nil and self.info.rankInfo ~= nil and self.info.rankInfo.dataList ~= nil then
    local dataList = self.info.rankInfo.dataList
    for rank = 4, #dataList do
      local rankData = dataList[rank]
      if self.info.rankInfo.myRank ~= nil and rank == self.info.rankInfo.myRank then
        myPower = rankData.formationPower
      end
    end
    myPower = myPower or self.info.rankInfo.myFormationPower
  end
  if myPower and 0 < myPower then
    return myPower
  else
    local playerPower = LuaEntry.Player.power
    return playerPower
  end
end

function LWNewbieArenaV2Manager:SetBattleListDataCache(msg)
  self.battleListDataCache = msg
end

function LWNewbieArenaV2Manager:GetBattleListDataByPlayerRank(rank)
  if self.battleListDataCache ~= nil and self.battleListDataCache.battleList ~= nil and not table.IsNullOrEmpty(self.battleListDataCache.battleList) then
    for i, v in pairs(self.battleListDataCache.battleList) do
      if v.rank == rank then
        return v
      end
    end
  end
end

return LWNewbieArenaV2Manager
