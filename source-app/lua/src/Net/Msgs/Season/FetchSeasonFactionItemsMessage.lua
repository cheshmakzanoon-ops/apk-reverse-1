local FetchSeasonFactionItemsMessage = BaseClass("FetchSeasonFactionItemsMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function FetchSeasonFactionItemsMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionItemsMessage:HandleMessage(t)
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
    if t.num then
      UIUtil.ShowTips(Localization:GetString("season_s2_camp_choose_15", t.num))
    end
  end
  if t.resources ~= nil then
    LuaEntry.Resource:UpdateResource(t.resources)
  end
  if t.gold ~= nil then
    LuaEntry.Player.gold = t.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
end

return FetchSeasonFactionItemsMessage
