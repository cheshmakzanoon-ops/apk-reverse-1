local PushQueueAddMessage = BaseClass("PushQueueAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.queue ~= nil then
    for k, v in pairs(t.queue) do
      DataCenter.QueueDataManager:UpdateQueueData(v)
      local list = DataCenter.QueueDataManager:GetAllQueueByType(v.type)
      if list ~= nil and table.count(list) == 1 then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.GetNewAnim, tostring(v.type))
      end
    end
  end
end

PushQueueAddMessage.OnCreate = OnCreate
PushQueueAddMessage.HandleMessage = HandleMessage
return PushQueueAddMessage
