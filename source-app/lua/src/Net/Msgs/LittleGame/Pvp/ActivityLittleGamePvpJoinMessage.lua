local ActivityLittleGamePvpJoinMessage = BaseClass("ActivityLittleGamePvpJoinMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, version, activityType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("version", version)
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
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom(t.activityType)
    room:Join(t)
  end
end

ActivityLittleGamePvpJoinMessage.OnCreate = OnCreate
ActivityLittleGamePvpJoinMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpJoinMessage
