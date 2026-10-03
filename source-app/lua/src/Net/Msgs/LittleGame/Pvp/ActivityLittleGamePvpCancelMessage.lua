local ActivityLittleGamePvpCancelMessage = BaseClass("ActivityLittleGamePvpCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, activityType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  if activityType == nil then
    activityType = DataCenter.LWGGGoDataManager:GetActivityType()
  end
  self.sfsObj:PutInt("activityType", activityType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPvpDestroyRoom)
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:RespCancel()
    UIUtil.ShowTipsId("season_s5_activity_1200045_desc54")
  end
end

ActivityLittleGamePvpCancelMessage.OnCreate = OnCreate
ActivityLittleGamePvpCancelMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpCancelMessage
