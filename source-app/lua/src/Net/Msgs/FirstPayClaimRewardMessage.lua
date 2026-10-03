local FirstPayClaimRewardMessage = BaseClass("FirstPayClaimRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PayManager:UpdateFirstPayStatus(t.state)
    local cacheRewards = DataCenter.PayManager:GetCacheFirstPayReward()
    if cacheRewards and cacheRewards.reward then
      table.insertto(t.reward, cacheRewards.reward)
    end
    DataCenter.RewardManager:ShowCommonReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
    Setting:SetInt(LuaEntry.Player.uid .. LuaEntry.Player.pushMark .. SettingKeys.FIRST_PAY_BUY_CLICK, 1)
    EventManager:GetInstance():Broadcast(EventId.PlayerChangeHeadRedPot)
    EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
    UIUtil.PveSceneHeroListRefresh()
  end
end

FirstPayClaimRewardMessage.OnCreate = OnCreate
FirstPayClaimRewardMessage.HandleMessage = HandleMessage
return FirstPayClaimRewardMessage
