local ActivityFoodPartyV2ExtraRewardMessage = BaseClass("ActivityFoodPartyV2ExtraRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("aid", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
    end
    EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterDamageRewardGet, t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActivityFoodPartyV2ExtraRewardMessage.OnCreate = OnCreate
ActivityFoodPartyV2ExtraRewardMessage.HandleMessage = HandleMessage
return ActivityFoodPartyV2ExtraRewardMessage
