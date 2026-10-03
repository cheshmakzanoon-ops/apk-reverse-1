local ActivityDecorationGachaBuyGoldGiftMessage = BaseClass("ActivityDecorationGachaBuyGoldGiftMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  self.sfsObj:PutInt("index", param.index)
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
      diamondState = t.diamondState,
      nextResetTime = t.nextResetTime
    }
    DataCenter.ActivityDecorationGachaManager:OnReceiveActivityData(newUserData)
    EventManager:GetInstance():Broadcast(EventId.CommonActivityGiftPackageViewRefresh)
  end
end

ActivityDecorationGachaBuyGoldGiftMessage.OnCreate = OnCreate
ActivityDecorationGachaBuyGoldGiftMessage.HandleMessage = HandleMessage
return ActivityDecorationGachaBuyGoldGiftMessage
