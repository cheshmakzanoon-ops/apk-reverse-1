local PushNewNoticeMessage = BaseClass("PushNewNoticeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldNoticeManager:NewNoticeHandle(t)
  end
end

PushNewNoticeMessage.OnCreate = OnCreate
PushNewNoticeMessage.HandleMessage = HandleMessage
return PushNewNoticeMessage
