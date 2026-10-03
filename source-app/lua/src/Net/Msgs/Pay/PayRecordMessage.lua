local PayRecordMessage = BaseClass("PayRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, exchangeId, pf)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("exchangeId", exchangeId)
  self.sfsObj:PutUtfString("pf", pf)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
end

PayRecordMessage.OnCreate = OnCreate
PayRecordMessage.HandleMessage = HandleMessage
return PayRecordMessage
