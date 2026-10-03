local PushGoogleConsumeOrderMessage = BaseClass("PushGoogleConsumeOrderMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.orderId then
    local PayOrderData = CS.GameEntry.PayOrderData
    if PayOrderData then
      PayOrderData:AddOrderToConsumedList(t.orderId)
    end
  end
end

PushGoogleConsumeOrderMessage.OnCreate = OnCreate
PushGoogleConsumeOrderMessage.HandleMessage = HandleMessage
return PushGoogleConsumeOrderMessage
