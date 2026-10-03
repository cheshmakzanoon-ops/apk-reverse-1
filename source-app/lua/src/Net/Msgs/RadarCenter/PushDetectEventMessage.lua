local PushDetectEventMessage = BaseClass("PushDetectEventMessage", SFSBaseMessage)
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
    DataCenter.RadarCenterDataManager:UpdateDetectEventInfo(t)
    EventManager:GetInstance():Broadcast(EventId.GetAllDetectInfo)
  end
end

PushDetectEventMessage.OnCreate = OnCreate
PushDetectEventMessage.HandleMessage = HandleMessage
return PushDetectEventMessage
