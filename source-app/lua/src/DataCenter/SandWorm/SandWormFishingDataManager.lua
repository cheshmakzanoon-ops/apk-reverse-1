local SandWormFishingDataManager = BaseClass("SandWormFishingDataManager")

function SandWormFishingDataManager:__init()
  self.rank = {
    {},
    {}
  }
  self.lastTimeFetch = {
    {},
    {}
  }
  self.reward = {}
end

function SandWormFishingDataManager:__delete()
  self:Destroy()
end

function SandWormFishingDataManager:Destroy()
  self.rank = nil
  self.lastTimeFetch = nil
  self.reward = nil
end

function SandWormFishingDataManager:GetFirstSeenRedPoint()
  return false
end

function SandWormFishingDataManager:FetchRankList(rankType, weekDay)
  local lastTimeFetch = self.lastTimeFetch[rankType][weekDay]
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if lastTimeFetch == nil or now > lastTimeFetch + 60 then
    self.lastTimeFetch[rankType][weekDay] = now
    SFSNetwork.SendMessage(MsgDefines.SeasonSandFishActivityRank, rankType, weekDay)
  end
end

function SandWormFishingDataManager:HandleSandWormFishingRankList(msg)
  local rankType = msg.type
  local weekDay = msg.weekNum
  if rankType == nil or weekDay == nil then
    return
  end
  self.rank[rankType][weekDay] = msg
  EventManager:GetInstance():Broadcast(EventId.OnSandWormFishingRankRefresh)
end

function SandWormFishingDataManager:GetRankList(rankType, weekDay)
  if self.rank[rankType][weekDay] and self.rank[rankType][weekDay].rankArray then
    return self.rank[rankType][weekDay].rankArray
  end
  return {}
end

function SandWormFishingDataManager:GetMyRank(rankType, weekDay)
  if self.rank[rankType][weekDay] and self.rank[rankType][weekDay].selfRank and self.rank[rankType][weekDay].selfScore then
    return self.rank[rankType][weekDay].selfRank, self.rank[rankType][weekDay].selfScore
  end
  return 0, 0
end

function SandWormFishingDataManager:FetchRewardList(rewardType)
  if self.reward[rewardType] == nil then
    SFSNetwork.SendMessage(MsgDefines.GetSeasonRankRewardInfo, rewardType == 1 and 370 or 371)
  end
end

function SandWormFishingDataManager:HandleSandWormFishingRewardList(msg, rewardType)
  self.reward[rewardType] = msg
  EventManager:GetInstance():Broadcast(EventId.OnSandWormFishingRewardRefresh)
end

function SandWormFishingDataManager:GetRewardList(rewardType)
  return self.reward[rewardType] or {}
end

function SandWormFishingDataManager:InitData(initMsg)
  if initMsg.sandworm and initMsg.sandworm.popUp == 1 then
    local monsterId = initMsg.sandworm.popMonsterId
    if DataCenter.JungleTrialDataManager:IsChomper(monsterId) then
      return
    end
    local isFunctionOn = DataCenter.LWPopupManager:IsFunctionOnNewPopupStyle()
    if not isFunctionOn then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UISandWormPopup, {anim = true}, monsterId)
    else
      DataCenter.LWPopupManager:TryAddPopupNotification(PopupNotificationType.SandWorm, monsterId)
    end
  end
end

return SandWormFishingDataManager
