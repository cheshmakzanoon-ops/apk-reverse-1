local DetectEventCompletePushMessage = BaseClass("DetectEventCompletePushMessage", SFSBaseMessage)
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
    DataCenter.RadarFakeUIMarchManager:RemoveMarchedTask(t.uuid)
    DataCenter.RadarCenterDataManager:UpdateOneDetectEventInfo(t)
    EventManager:GetInstance():Broadcast(EventId.DetectInfoChange)
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    if t.uuid ~= nil then
      local uuid = t.uuid
      local completeData = {}
      completeData.uuid = uuid
      EventManager:GetInstance():Broadcast(EventId.DetectEventComp, completeData)
    end
  end
end

DetectEventCompletePushMessage.OnCreate = OnCreate
DetectEventCompletePushMessage.HandleMessage = HandleMessage
return DetectEventCompletePushMessage
