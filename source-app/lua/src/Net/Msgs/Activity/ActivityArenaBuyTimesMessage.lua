local ActivityArenaBuyTimesMessage = BaseClass("ActivityArenaBuyTimesMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaBuyTimes)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaBuyTimesBack, t)
  end
end

ActivityArenaBuyTimesMessage.OnCreate = OnCreate
ActivityArenaBuyTimesMessage.HandleMessage = HandleMessage
return ActivityArenaBuyTimesMessage
