local ActivityTorchRelayClaimFreeMessage = BaseClass("ActivityTorchRelayClaimFreeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.RewardManager:ShowCommonReward(t)
    local newUserData = {
      activityId = t.activity,
      lastReceiveFreeTime = t.lastReceiveFreeTime
    }
    DataCenter.ActivityTorchRelayManager:OnReceiveActivityData(newUserData)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    EventManager:GetInstance():Broadcast(EventId.CommonActivityGiftPackageViewRefresh)
  end
end

ActivityTorchRelayClaimFreeMessage.OnCreate = OnCreate
ActivityTorchRelayClaimFreeMessage.HandleMessage = HandleMessage
return ActivityTorchRelayClaimFreeMessage
