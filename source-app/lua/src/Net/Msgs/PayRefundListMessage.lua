local PayRefundListMessage = BaseClass("PayRefundListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PayRefundListMessage:OnCreate(pf)
  base.OnCreate(self)
  if not string.IsNullOrEmpty(pf) then
    self.sfsObj:PutUtfString("pf", pf)
  else
    self.sfsObj:PutUtfString("pf", "google")
  end
end

function PayRefundListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWRefundManager:OnReceivePayRefundList(t)
  end
end

return PayRefundListMessage
