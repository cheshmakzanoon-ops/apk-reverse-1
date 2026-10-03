local FlowerTrainFollowMessage = BaseClass("FlowerTrainFollowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainFollowMessage:OnCreate(targetMarchUuid, selfSingleTrainUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("targetMarchUuid", targetMarchUuid)
  self.sfsObj:PutLong("trainUuid", selfSingleTrainUuid or 0)
end

function FlowerTrainFollowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return FlowerTrainFollowMessage
