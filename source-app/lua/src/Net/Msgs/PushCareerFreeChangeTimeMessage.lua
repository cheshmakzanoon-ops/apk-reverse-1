local PushCareerFreeChangeTimeMessage = BaseClass("PushCareerFreeChangeTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, careerType)
  base.OnCreate(self)
  self.sfsObj:PutInt("careerType", careerType)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.careerFreeChangeEndTime then
    DataCenter.PlayerCareerManager:UpdateCareerFreeChangeEndTime(t.careerFreeChangeEndTime)
  end
  EventManager:GetInstance():Broadcast(EventId.PlayerCareerFreeChangeUpdate)
end

PushCareerFreeChangeTimeMessage.OnCreate = OnCreate
PushCareerFreeChangeTimeMessage.HandleMessage = HandleMessage
return PushCareerFreeChangeTimeMessage
