local ThanksgivingRecommendeMessage = BaseClass("ThanksgivingRecommendeMessage", SFSBaseMessage)
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
  DataCenter.ActGiftGivingDataManager:ReceiveRecommendeMsg(t)
  EventManager:GetInstance():Broadcast(EventId.ActGiftGivingRecommandGetMsg)
end

ThanksgivingRecommendeMessage.OnCreate = OnCreate
ThanksgivingRecommendeMessage.HandleMessage = HandleMessage
return ThanksgivingRecommendeMessage
