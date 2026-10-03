local PushAllianceNoticePinnedChangeMessage = BaseClass("PushAllianceNoticePinnedChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceNoticeManager:UpdateNoticePinned(t.notices[1])
    DataCenter.AllianceNoticeManager:UpdateNoticePinned(t.notices[2])
  end
end

PushAllianceNoticePinnedChangeMessage.OnCreate = OnCreate
PushAllianceNoticePinnedChangeMessage.HandleMessage = HandleMessage
return PushAllianceNoticePinnedChangeMessage
