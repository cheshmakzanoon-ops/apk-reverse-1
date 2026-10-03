local PveActStageRewardMessage = BaseClass("PveActStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveActStageRewardMessage:OnCreate(actId, pve, stage)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", actId)
  if pve then
    self.sfsObj:PutInt("level", pve)
  end
  self.sfsObj:PutInt("stage", stage)
end

function PveActStageRewardMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.PveActManager:HandleStageReward(message)
end

return PveActStageRewardMessage
