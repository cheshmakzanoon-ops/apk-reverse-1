local TorchRelayMilestonesGetProgressRewardMessage = BaseClass("TorchRelayMilestonesGetProgressRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("index", tonumber(taskId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayTaskManager:OnMilesGetReward(t)
  end
end

TorchRelayMilestonesGetProgressRewardMessage.OnCreate = OnCreate
TorchRelayMilestonesGetProgressRewardMessage.HandleMessage = HandleMessage
return TorchRelayMilestonesGetProgressRewardMessage
