local FreeRewardReceiveMessage = BaseClass("FreeRewardReceiveMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FreeRewardReceiveMessage:OnCreate(type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

function FreeRewardReceiveMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward then
      DataCenter.RewardManager:ShowCommonReward(t)
      DataCenter.RewardManager:AddRewardsAndRes(t)
    end
    DataCenter.RechargeManager:UpdateFreeRewardInfo(t.type, t.lastTime)
    EventManager:GetInstance():Broadcast(EventId.RechargeFreeRewardReceiveStateUpdate, t.type)
    EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
  end
end

return FreeRewardReceiveMessage
