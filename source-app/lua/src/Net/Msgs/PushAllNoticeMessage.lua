local PushAllNoticeMessage = BaseClass("PushAllNoticeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  NoticeTipsManager:GetInstance():NetPush(t)
end

PushAllNoticeMessage.OnCreate = OnCreate
PushAllNoticeMessage.HandleMessage = HandleMessage
return PushAllNoticeMessage
