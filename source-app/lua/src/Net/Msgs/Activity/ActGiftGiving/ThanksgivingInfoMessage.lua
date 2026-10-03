local ThanksgivingInfoMessage = BaseClass("ThanksgivingInfoMessage", SFSBaseMessage)
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
  DataCenter.ActGiftGivingDataManager:RefreshActDetailData(t)
  EventManager:GetInstance():Broadcast(EventId.ActGiftGivingDetailDataGet)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

ThanksgivingInfoMessage.OnCreate = OnCreate
ThanksgivingInfoMessage.HandleMessage = HandleMessage
return ThanksgivingInfoMessage
