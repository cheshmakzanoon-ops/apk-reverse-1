local ActivityArenaRankListMessage = BaseClass("ActivityArenaRankListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, from, to)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(activityId))
  self.sfsObj:PutInt("from", from)
  self.sfsObj:PutInt("to", to)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaRankList)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaRankListBack, t)
  end
end

ActivityArenaRankListMessage.OnCreate = OnCreate
ActivityArenaRankListMessage.HandleMessage = HandleMessage
return ActivityArenaRankListMessage
