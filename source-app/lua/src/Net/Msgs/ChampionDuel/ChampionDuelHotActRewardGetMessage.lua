local ChampionDuelHotActRewardGetMessage = BaseClass("ChampionDuelHotActRewardGetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, rewardIdx)
  base.OnCreate(self)
  self.sfsObj:PutInt("rewardIdx", rewardIdx)
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
  DataCenter.ChampionDuelManager:HandleDonateActRewardGet(t)
  EventManager:GetInstance():Broadcast(EventId.ChampionDuelDonateActRewardGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ChampionDuelHotActRewardGetMessage.OnCreate = OnCreate
ChampionDuelHotActRewardGetMessage.HandleMessage = HandleMessage
return ChampionDuelHotActRewardGetMessage
