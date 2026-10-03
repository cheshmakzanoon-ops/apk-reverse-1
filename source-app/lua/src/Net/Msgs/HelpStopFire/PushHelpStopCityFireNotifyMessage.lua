local PushHelpStopCityFireNotifyMessage = BaseClass("PushHelpStopCityFireNotifyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t ~= nil then
    if t.errorCode == nil then
      DataCenter.BuildHelpStopFireManager:PushHelpStopCityFireNotifyHandler(t)
    else
      UIUtil.ShowTipsId(t.errorCode)
    end
  end
end

PushHelpStopCityFireNotifyMessage.OnCreate = OnCreate
PushHelpStopCityFireNotifyMessage.HandleMessage = HandleMessage
return PushHelpStopCityFireNotifyMessage
