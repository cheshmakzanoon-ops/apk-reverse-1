local PushFirstRechargeRewardMessage = BaseClass("PushFirstRechargeRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFirstRechargeRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFirstRechargeRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.FirstPayManager:SetFirstPayLastRewardCacheFlag(t.reward)
    EventManager:GetInstance():Broadcast(EventId.FirstRechargeExpBigRewardReceived)
  end
end

return PushFirstRechargeRewardMessage
