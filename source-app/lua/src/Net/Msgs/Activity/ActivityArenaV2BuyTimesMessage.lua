local ActivityArenaV2BuyTimesMessage = BaseClass("ActivityArenaV2BuyTimesMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, num)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("num", num)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaV2BuyTimes)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaBuyTimesBack, t)
    EventManager:GetInstance():Broadcast(EventId.ArenaRefreshRedPoint)
  end
end

ActivityArenaV2BuyTimesMessage.OnCreate = OnCreate
ActivityArenaV2BuyTimesMessage.HandleMessage = HandleMessage
return ActivityArenaV2BuyTimesMessage
