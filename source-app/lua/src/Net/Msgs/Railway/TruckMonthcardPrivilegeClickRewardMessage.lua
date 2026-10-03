local TruckMonthcardPrivilegeClickRewardMessage = BaseClass("TruckMonthcardPrivilegeClickRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function TruckMonthcardPrivilegeClickRewardMessage:OnCreate(param)
  base.OnCreate(self)
end

function TruckMonthcardPrivilegeClickRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewards(t.clickReward)
    DataCenter.RewardManager:ShowCommonReward({
      reward = t.clickReward
    })
    DataCenter.MonthCardNewManager:UpdateMonthCardPrivilege(t)
    EventManager:GetInstance():Broadcast(EventId.GetTruckInsuranceReward)
  end
end

return TruckMonthcardPrivilegeClickRewardMessage
