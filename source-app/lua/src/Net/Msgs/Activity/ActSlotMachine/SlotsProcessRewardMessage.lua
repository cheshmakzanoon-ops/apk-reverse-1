local SlotsProcessRewardMessage = BaseClass("SlotsProcessRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
    DataCenter.ActSlotMachineDataManager:UpdateProgressRewardMessage(t)
    EventManager:GetInstance():Broadcast(EventId.ActSlotProgressReward, t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

SlotsProcessRewardMessage.OnCreate = OnCreate
SlotsProcessRewardMessage.HandleMessage = HandleMessage
return SlotsProcessRewardMessage
