local PushActivityExtraMessage = BaseClass("PushActivityExtraMessage", SFSBaseMessage)
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
    DataCenter.ActivityListDataManager:RetEventData(t)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

PushActivityExtraMessage.OnCreate = OnCreate
PushActivityExtraMessage.HandleMessage = HandleMessage
return PushActivityExtraMessage
