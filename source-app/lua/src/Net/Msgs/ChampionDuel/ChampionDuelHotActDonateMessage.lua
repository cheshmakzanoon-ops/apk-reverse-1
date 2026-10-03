local ChampionDuelHotActDonateMessage = BaseClass("ChampionDuelHotActDonateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.reward then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ChampionDuelManager:HandleDonateActDonate(t)
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelDonateActDonate)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ChampionDuelHotActDonateMessage.OnCreate = OnCreate
ChampionDuelHotActDonateMessage.HandleMessage = HandleMessage
return ChampionDuelHotActDonateMessage
