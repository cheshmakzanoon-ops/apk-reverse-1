local ActivityLittleGamePvpReadyMessage = BaseClass("ActivityLittleGamePvpReadyMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, latencies, activityType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("latencies", latencies)
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
  end
  local room = DataCenter.LWGGGoDataManager:GetRoom(t.activityType)
  room:RespReady(t, errCode)
end

ActivityLittleGamePvpReadyMessage.OnCreate = OnCreate
ActivityLittleGamePvpReadyMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpReadyMessage
