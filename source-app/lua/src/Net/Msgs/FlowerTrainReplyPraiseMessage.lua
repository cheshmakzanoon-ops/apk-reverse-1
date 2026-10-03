local FlowerTrainReplyPraiseMessage = BaseClass("FlowerTrainReplyPraiseMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FlowerTrainReplyPraiseMessage:OnCreate(uids)
  base.OnCreate(self)
  local uidArr = SFSArray.New()
  for i, v in ipairs(uids) do
    uidArr:AddLong(v)
  end
  self.sfsObj:PutSFSArray("uuidArr", uidArr)
end

function FlowerTrainReplyPraiseMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return FlowerTrainReplyPraiseMessage
