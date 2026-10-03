local SunriseInfoMessage = BaseClass("SunriseInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActSunriseFoundationDataManager:RefreshActDetailData(t)
  EventManager:GetInstance():Broadcast(EventId.SunriseInfoGet, t.activityId)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

SunriseInfoMessage.OnCreate = OnCreate
SunriseInfoMessage.HandleMessage = HandleMessage
return SunriseInfoMessage
