local CrossKingServerRewardWinMessage = BaseClass("CrossKingServerRewardWinMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CrossKingServerRewardWinMessage:OnCreate()
  base.OnCreate(self)
end

function CrossKingServerRewardWinMessage:HandleMessage(t)
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
  SFSNetwork.SendMessage(MsgDefines.CrossKingFightInfo)
end

return CrossKingServerRewardWinMessage
