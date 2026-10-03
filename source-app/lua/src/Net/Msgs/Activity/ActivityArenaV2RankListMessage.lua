local ActivityArenaV2RankListMessage = BaseClass("ActivityArenaV2RankListMessage", SFSBaseMessage)
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
    EventManager:GetInstance():Broadcast(EventId.ServerError, MsgDefines.ActivityArenaV2RankList)
  else
    EventManager:GetInstance():Broadcast(EventId.ActivityArenaRankListBack, t)
  end
end

ActivityArenaV2RankListMessage.OnCreate = OnCreate
ActivityArenaV2RankListMessage.HandleMessage = HandleMessage
return ActivityArenaV2RankListMessage
