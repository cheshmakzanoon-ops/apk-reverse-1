local TorchRelayTaskGetRewardMessage = BaseClass("TorchRelayTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutUtfString("taskId", tostring(taskId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayTaskManager:OnTaskGetReward(t)
  end
end

TorchRelayTaskGetRewardMessage.OnCreate = OnCreate
TorchRelayTaskGetRewardMessage.HandleMessage = HandleMessage
return TorchRelayTaskGetRewardMessage
