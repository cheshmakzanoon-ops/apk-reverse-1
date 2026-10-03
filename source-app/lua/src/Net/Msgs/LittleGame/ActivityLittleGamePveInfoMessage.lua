local ActivityLittleGamePveInfoMessage = BaseClass("ActivityLittleGamePveInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityType)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityType", activityType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWGGGoDataManager:UpdateInfo(t)
    EventManager:GetInstance():Broadcast(EventId.SeasonGetGGGoInfo)
  end
end

ActivityLittleGamePveInfoMessage.OnCreate = OnCreate
ActivityLittleGamePveInfoMessage.HandleMessage = HandleMessage
return ActivityLittleGamePveInfoMessage
