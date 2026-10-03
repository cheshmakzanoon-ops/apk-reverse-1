local BountyHunterReceivePhaseRewardMessage = BaseClass("BountyHunterReceivePhaseRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterReceivePhaseRewardMessage:OnCreate(activityId, needScore)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("phaseId", needScore)
end

function BountyHunterReceivePhaseRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.activityId then
    local activityId = toInt(t.activityId)
    local actData = DataCenter.BountyHunterActDataManager:GetActData(activityId)
    if actData then
      local receiveRewardScore = toInt(t.phaseId)
      actData:UpdateHadReceiveRewardInfo(receiveRewardScore)
    end
    if t.phaseReward ~= nil then
      DataCenter.RewardManager:AddRewards(t.phaseReward)
      DataCenter.RewardManager:ShowCommonReward({
        reward = t.phaseReward
      })
    end
    EventManager:GetInstance():Broadcast(EventId.BountyHunterScoreUpdate, activityId)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

return BountyHunterReceivePhaseRewardMessage
