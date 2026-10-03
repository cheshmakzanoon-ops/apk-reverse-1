local PushBuildQueueInfoMessage = BaseClass("PushBuildQueueInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildQueueManager:UpdateQueueData(t.updateQueues, false)
  DataCenter.BuildQueueManager:RemoveQueueData(t.removeQueues)
end

PushBuildQueueInfoMessage.OnCreate = OnCreate
PushBuildQueueInfoMessage.HandleMessage = HandleMessage
return PushBuildQueueInfoMessage
