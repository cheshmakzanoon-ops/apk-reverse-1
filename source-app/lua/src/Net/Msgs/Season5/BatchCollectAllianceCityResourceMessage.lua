local BatchCollectAllianceCityResourceMessage = BaseClass("BatchCollectAllianceCityResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BatchCollectAllianceCityResourceMessage:OnCreate()
  base.OnCreate(self)
end

function BatchCollectAllianceCityResourceMessage:HandleMessage(t)
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
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo = nil
  EventManager:GetInstance():Broadcast(EventId.BatchCollectAllianceCityResourceSuccess, t.serverId)
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
end

return BatchCollectAllianceCityResourceMessage
