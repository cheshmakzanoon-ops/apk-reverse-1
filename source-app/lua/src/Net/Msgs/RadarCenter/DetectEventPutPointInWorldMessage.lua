local DetectEventPutPointInWorldMessage = BaseClass("DetectEventPutPointInWorldMessage", SFSBaseMessage)
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
    local uuid = t.uuid
    DataCenter.RadarCenterDataManager:UpdateOneDetectEventInfo(t)
    EventManager:GetInstance():Broadcast(EventId.DetectEventGetRealPoint, uuid)
  end
end

DetectEventPutPointInWorldMessage.OnCreate = OnCreate
DetectEventPutPointInWorldMessage.HandleMessage = HandleMessage
return DetectEventPutPointInWorldMessage
