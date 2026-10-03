local ActivityLittleGamePvpShareMessage = BaseClass("ActivityLittleGamePvpShareMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, channel, touid, activityType)
  base.OnCreate(self)
  self.sfsObj:PutInt("channel", channel)
  if touid then
    self.sfsObj:PutUtfString("touid", touid)
  end
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
    UIUtil.ShowTipsId(120061)
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoChatShared)
  end
end

ActivityLittleGamePvpShareMessage.OnCreate = OnCreate
ActivityLittleGamePvpShareMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpShareMessage
