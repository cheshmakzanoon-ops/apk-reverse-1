local PayRefundRequestMessage = BaseClass("PayRefundRequestMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PayRefundRequestMessage:OnCreate(orderId, pf)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("orderId", orderId)
  self.sfsObj:PutUtfString("pf", pf)
end

function PayRefundRequestMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return PayRefundRequestMessage
