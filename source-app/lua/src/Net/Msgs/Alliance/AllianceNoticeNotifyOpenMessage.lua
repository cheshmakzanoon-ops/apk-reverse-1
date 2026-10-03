local AllianceNoticeNotifyOpenMessage = BaseClass("AllianceNoticeNotifyOpenMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
  else
    UIUtil.ShowTipsId(120025)
  end
end

AllianceNoticeNotifyOpenMessage.OnCreate = OnCreate
AllianceNoticeNotifyOpenMessage.HandleMessage = HandleMessage
return AllianceNoticeNotifyOpenMessage
