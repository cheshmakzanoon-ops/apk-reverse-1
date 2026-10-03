local LWNewbieArenaManager = BaseClass("LWNewbieArenaManager")

function LWNewbieArenaManager:__init()
  function self.__onGetArenaRankList(tbl)
    self:OnGetArenaRankList(tbl)
  end
  
  EventManager:GetInstance():AddListener(EventId.ActivityArenaRankListBack, self.__onGetArenaRankList)
  self.cfgMap_rankhigh = {}
  local cfgTbl = LocalController:instance():getTable(TableName.LW_Newbie_Arena)
  for id, _ in pairs(cfgTbl.data) do
    local cfg = LocalController:instance():getLine(TableName.LW_Newbie_Arena, id)
    self.cfgMap_rankhigh[cfg.rank_high] = cfg
  end
end

function LWNewbieArenaManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.ActivityArenaRankListBack, self.__onGetArenaRankList)
  self.__onGetArenaRankList = nil
end

function LWNewbieArenaManager:OnGetArenaInfo(info)
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
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaRankList, self.info.id, 1, self.info.state == ActivityArenaState.Fight and 500 or 10)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaInfoUpdate, self.info.id)
  end
end

function LWNewbieArenaManager:OnGetArenaRankList(rankInfo)
  assert(rankInfo, "LWNewbieArenaManager:OnGetArenaRankList rankInfo is nil")
  if self.info and tonumber(self.info.id) == tonumber(rankInfo.activityId) then
    rankInfo.needPlayRankAnim = rankInfo.myRank > 0 and self.myPreRank ~= rankInfo.myRank
    self.info.rankInfo = rankInfo
    self.info.rankInfo.myPreRank = self.myPreRank
    self.myPreRank = rankInfo.myRank
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaInfoUpdate, self.info.id)
  end
end

function LWNewbieArenaManager:GetRedDotCount()
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

function LWNewbieArenaManager:GetState()
  if not self.info then
    return ActivityArenaState.None
  end
  return self.info.state
end

function LWNewbieArenaManager:GetArenaInfoId()
  if not self.info then
    return 0
  end
  return tonumber(self.info.id)
end

return LWNewbieArenaManager
