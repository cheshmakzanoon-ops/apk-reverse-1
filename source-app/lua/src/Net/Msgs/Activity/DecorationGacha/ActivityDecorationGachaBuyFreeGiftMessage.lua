local ActivityDecorationGachaBuyFreeGiftMessage = BaseClass("ActivityDecorationGachaBuyFreeGiftMessage", SFSBaseMessage)
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
      activityId = t.activityId,
      freeState = t.freeState,
      nextResetTime = t.nextResetTime
    }
    DataCenter.ActivityDecorationGachaManager:OnReceiveActivityData(newUserData)
    EventManager:GetInstance():Broadcast(EventId.CommonActivityGiftPackageViewRefresh)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

ActivityDecorationGachaBuyFreeGiftMessage.OnCreate = OnCreate
ActivityDecorationGachaBuyFreeGiftMessage.HandleMessage = HandleMessage
return ActivityDecorationGachaBuyFreeGiftMessage
