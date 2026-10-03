local SlotsTaskRewardMessage = BaseClass("SlotsTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("taskId", taskId)
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
    DataCenter.ActSlotMachineDataManager:GetOneTaskReward(t)
    EventManager:GetInstance():Broadcast(EventId.ActSlotTaskDataUpdate)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

SlotsTaskRewardMessage.OnCreate = OnCreate
SlotsTaskRewardMessage.HandleMessage = HandleMessage
return SlotsTaskRewardMessage
