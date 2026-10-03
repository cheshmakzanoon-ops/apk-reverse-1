local CollectStrongholdResourceMessage = BaseClass("CollectStrongholdResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CollectStrongholdResourceMessage:OnCreate(serverId, strongholdId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("strongholdId", strongholdId)
end

function CollectStrongholdResourceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_s2_tips_004" then
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
      EventManager:GetInstance():Broadcast(EventId.CollectStrongholdResourceSuccess, t)
    end
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
  EventManager:GetInstance():Broadcast(EventId.CollectStrongholdResourceSuccess, t)
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
end

return CollectStrongholdResourceMessage
