local PinPwdCheckMessage = BaseClass("PinPwdCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.PinManager:PinPwdCheckHandle(t)
end

PinPwdCheckMessage.OnCreate = OnCreate
PinPwdCheckMessage.HandleMessage = HandleMessage
return PinPwdCheckMessage
