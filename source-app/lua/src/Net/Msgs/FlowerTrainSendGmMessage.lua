local FlowerTrainSendGmMessage = BaseClass("FlowerTrainSendGmMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainSendGmMessage:OnCreate(pointId, itemId, senderUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("itemId", itemId)
  self.sfsObj:PutInt("pointId", pointId)
  self.sfsObj:PutUtfString("senderUid", senderUid)
end

function FlowerTrainSendGmMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return FlowerTrainSendGmMessage
