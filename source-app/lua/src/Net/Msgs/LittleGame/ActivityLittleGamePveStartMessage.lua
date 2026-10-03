local ActivityLittleGamePveStartMessage = BaseClass("ActivityLittleGamePveStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, version, activityType)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("version", version)
  self.sfsObj:PutInt("activityType", activityType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:VersionDiff()
  else
    DataCenter.LWGGGoDataManager:UpdateInfo(t)
    EventManager:GetInstance():Broadcast(EventId.SeasonGGGoPveStart)
  end
end

ActivityLittleGamePveStartMessage.OnCreate = OnCreate
ActivityLittleGamePveStartMessage.HandleMessage = HandleMessage
return ActivityLittleGamePveStartMessage
