local ActivityLittleGamePvpInfoMessage = BaseClass("ActivityLittleGamePvpInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, opt, activityType)
  base.OnCreate(self)
  self.sfsObj:PutInt("opt", opt)
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
    room:UpdateMsg(t, true)
  end
end

ActivityLittleGamePvpInfoMessage.OnCreate = OnCreate
ActivityLittleGamePvpInfoMessage.HandleMessage = HandleMessage
return ActivityLittleGamePvpInfoMessage
