local BatchCollectStrongholdResourceMessage = BaseClass("BatchCollectStrongholdResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BatchCollectStrongholdResourceMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function BatchCollectStrongholdResourceMessage:HandleMessage(t)
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
  DataCenter.SeasonDataManager.CrossOccupyStrongholdRewardInfo = nil
  EventManager:GetInstance():Broadcast(EventId.BatchCollectStrongholdResourceSuccess, t.serverId)
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
end

return BatchCollectStrongholdResourceMessage
