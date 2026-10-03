local PushShumeiExceptionLevelMessage = BaseClass("PushShumeiExceptionLevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AccountManager:OnPushShumeiExceptionLevel(t)
  end
end

PushShumeiExceptionLevelMessage.OnCreate = OnCreate
PushShumeiExceptionLevelMessage.HandleMessage = HandleMessage
return PushShumeiExceptionLevelMessage
