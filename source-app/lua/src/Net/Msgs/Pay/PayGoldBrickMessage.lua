local PayGoldBrickMessage = BaseClass("PayGoldBrickMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("orderId", param.orderId)
  if param.selfOrderId ~= nil and param.selfOrderId ~= "" then
    self.sfsObj:PutUtfString("selfOrderId", param.selfOrderId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PayManager:PayMessageHandle(t)
end

PayGoldBrickMessage.OnCreate = OnCreate
PayGoldBrickMessage.HandleMessage = HandleMessage
return PayGoldBrickMessage
