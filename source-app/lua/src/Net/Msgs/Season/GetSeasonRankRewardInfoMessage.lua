local GetSeasonRankRewardInfoMessage = BaseClass("GetSeasonRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonRankRewardInfoMessage:OnCreate(rankId)
  base.OnCreate(self)
  self.sfsObj:PutInt("rankId", rankId)
end

function GetSeasonRankRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local reward = t.rankReward or t.rankRewardInfo
  if table.IsNullOrEmpty(reward) then
    return
  end
  for k, v in ipairs(reward) do
    if v and v.rank then
      local rankRange = string.split(v.rank, "-")
      if 1 < #rankRange then
        v.minRanking = toInt(rankRange[1])
        v.maxRanking = toInt(rankRange[2])
      elseif 0 < #rankRange then
        v.minRanking = toInt(rankRange[1])
        v.maxRanking = toInt(rankRange[1])
      end
      v.rewards = DataCenter.RewardManager:ParseRewardsInfo(v.rewards)
    end
  end
  if t.rankId == 370 then
    DataCenter.SandWormFishingDataManager:HandleSandWormFishingRewardList(reward, 1)
  elseif t.rankId == 371 then
    DataCenter.SandWormFishingDataManager:HandleSandWormFishingRewardList(reward, 2)
  elseif t.rankId == 448 then
    DataCenter.LWSheepDataManager:HandleSandWormFishingRewardList(reward, 1)
  elseif t.rankId == 450 then
    DataCenter.SeasonTetrisManager:HandleTetrisRewardList(reward, 1)
  elseif t.rankId == 482 then
    DataCenter.LWBiuBiuDataManager:HandleSandWormFishingRewardList(reward, 1)
  elseif t.rankId == 487 then
    DataCenter.SeasonNineKingManager:HandleRewardList(reward, 1)
  elseif t.rankId == 488 then
    DataCenter.FishingDataManager:HandleFishingMasterRewardList(reward)
  elseif t.rankId == 489 then
    DataCenter.JungleTrialDataManager:HandleRankRewardList(reward)
  elseif t.rankId == 524 then
    DataCenter.LWGGGoDataManager:HandleSandWormFishingRewardList(reward, 1)
  else
    EventManager:GetInstance():Broadcast(EventId.LWSeasonRankRewardUpdate, t)
  end
end

return GetSeasonRankRewardInfoMessage
