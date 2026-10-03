local PushCreditUpdateMessage = BaseClass("PushCreditUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.CreditManager:OnUpdateCreditValue(t)
  end
end

PushCreditUpdateMessage.OnCreate = OnCreate
PushCreditUpdateMessage.HandleMessage = HandleMessage
return PushCreditUpdateMessage
