local CollectAllianceCityResourceMessage = BaseClass("CollectAllianceCityResourceMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CollectAllianceCityResourceMessage:OnCreate(serverId, cityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
  self.sfsObj:PutInt("cityId", cityId)
end

function CollectAllianceCityResourceMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if errCode == "season_s5_city_no_reward_get" then
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      EventManager:GetInstance():Broadcast(EventId.CollectAllianceCityResourceSuccess, t)
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
  EventManager:GetInstance():Broadcast(EventId.CollectAllianceCityResourceSuccess, t)
  SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
end

return CollectAllianceCityResourceMessage
