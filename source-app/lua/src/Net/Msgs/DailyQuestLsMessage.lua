local DailyQuestLsMessage = BaseClass("DailyQuestLsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.DailyTaskManager:DailyQuestLsMessageHandle(t)
end

DailyQuestLsMessage.OnCreate = OnCreate
DailyQuestLsMessage.HandleMessage = HandleMessage
return DailyQuestLsMessage
