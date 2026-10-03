local AllianceCongratulationThumbsUpMessage = BaseClass("AllianceCongratulationThumbsUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceCongratulationThumbsUpMessage:OnCreate(targetUid, configId, type)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutUtfString("configId", configId)
  self.sfsObj:PutInt("type", type)
end

function AllianceCongratulationThumbsUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.AllianceCongratulationBtnState)
  elseif t then
    if t.reward then
      local rewards = t.reward
      DataCenter.RewardManager:AddRewards(rewards)
      DataCenter.AllianceCongratulationDataManager:PlayFlyAni(rewards)
    end
    if t.count then
      local count = tonumber(t.count) or 0
      DataCenter.AllianceCongratulationDataManager:UpdateRemainRewardCount(count)
    end
    DataCenter.AllianceCongratulationDataManager:SendGetAllianceCongratulationList()
  end
end

return AllianceCongratulationThumbsUpMessage
