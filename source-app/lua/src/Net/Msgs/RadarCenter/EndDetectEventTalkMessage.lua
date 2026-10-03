local EndDetectEventTalkMessage = BaseClass("EndDetectEventTalkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.DetectEventRewardGet, t.uuid)
    DataCenter.RadarCenterDataManager:GetDetectEventRewardBack(t)
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

EndDetectEventTalkMessage.OnCreate = OnCreate
EndDetectEventTalkMessage.HandleMessage = HandleMessage
return EndDetectEventTalkMessage
