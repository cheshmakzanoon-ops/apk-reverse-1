local GetCityAttachmentALLRewardMessage = BaseClass("GetCityAttachmentALLRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityAttachmentALLRewardMessage:OnCreate()
  base.OnCreate(self)
end

function GetCityAttachmentALLRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.CityAttachmentALLRewardFinish, t)
end

return GetCityAttachmentALLRewardMessage
