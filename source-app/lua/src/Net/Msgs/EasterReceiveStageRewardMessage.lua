local EasterReceiveStageRewardMessage = BaseClass("EasterReceiveStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterReceiveStageRewardMessage:OnCreate(activityId, index)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("index", tonumber(index))
end

function EasterReceiveStageRewardMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggTaskManager:OnStageGetReward(t)
  end
end

return EasterReceiveStageRewardMessage
