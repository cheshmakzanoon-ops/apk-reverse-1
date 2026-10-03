local GetSeasonFactionBattleWinRewardMessage = BaseClass("GetSeasonFactionBattleWinRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonFactionBattleWinRewardMessage:OnCreate()
  base.OnCreate(self)
end

function GetSeasonFactionBattleWinRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionBattleWinRewardFinish)
end

return GetSeasonFactionBattleWinRewardMessage
