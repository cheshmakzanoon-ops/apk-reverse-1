local PushQueueDeleteMessage = BaseClass("PushQueueDeleteMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.queueUuids then
    for _, queueUuid in ipairs(t.queueUuids) do
      DataCenter.QueueDataManager:DeleteQueueByUuid(queueUuid)
    end
  end
end

PushQueueDeleteMessage.OnCreate = OnCreate
PushQueueDeleteMessage.HandleMessage = HandleMessage
return PushQueueDeleteMessage
