local LWBeginnerCityEventTaskRewardMessage = BaseClass("LWBeginnerCityEventTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, eventId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("eventId", eventId)
  self.sfsObj:PutInt("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    DataCenter.LWBeginnerDirectorManager:UpdateRewardedTask(t)
  end
end

LWBeginnerCityEventTaskRewardMessage.OnCreate = OnCreate
LWBeginnerCityEventTaskRewardMessage.HandleMessage = HandleMessage
return LWBeginnerCityEventTaskRewardMessage
