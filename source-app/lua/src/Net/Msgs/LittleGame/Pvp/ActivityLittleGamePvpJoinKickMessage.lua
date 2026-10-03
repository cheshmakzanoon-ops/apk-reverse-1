local ActivityLittleGamePvpJoinKickMessage = BaseClass("ActivityLittleGamePvpJoinKickMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, sid, uid, activityType)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("sid", sid)
  self.sfsObj:PutUtfString("uid", uid)
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
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:RespJoinKick(t)
    UIUtil.ShowTipsId("season_s6_minigame_pvp_limit5")
  end
end

ActivityLittleGamePvpJoinKickMessage.OnCreate = OnCreate
ActivityLittleGamePvpJoinKickMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpJoinKickMessage
