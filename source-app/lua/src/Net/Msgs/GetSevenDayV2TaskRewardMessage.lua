local GetSevenDayV2TaskRewardMessage = BaseClass("GetSevenDayV2TaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutUtfString("taskId", param.id)
    self.sfsObj:PutInt("activityId", param.activityId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.activityId then
    DataCenter.ActSevenDayV2Data:UpdateTaskData(t.activityId, t)
  end
  if not table.IsNullOrEmpty(t.reward) then
    DataCenter.RewardManager:ShowGiftReward(t)
    DataCenter.RewardManager:AddRewardsAndRes(t)
  end
  DataCenter.ActSevenDayV2Data:UpdateDayActScore(t)
  EventManager:GetInstance():Broadcast(EventId.ActivitySevenDayV2TaskGetSuccess)
end

GetSevenDayV2TaskRewardMessage.OnCreate = OnCreate
GetSevenDayV2TaskRewardMessage.HandleMessage = HandleMessage
return GetSevenDayV2TaskRewardMessage
