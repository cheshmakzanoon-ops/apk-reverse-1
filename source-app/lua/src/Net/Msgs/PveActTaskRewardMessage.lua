local PveActTaskRewardMessage = BaseClass("PveActTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActTaskRewardMessage:OnCreate(actId, pve, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
  if pve then
    self.sfsObj:PutInt("level", pve)
  end
  self.sfsObj:PutInt("taskId", taskId)
end

function PveActTaskRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleTaskReward(message)
end

return PveActTaskRewardMessage
