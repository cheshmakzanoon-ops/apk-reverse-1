local PushDispatchOneTaskMessage = BaseClass("PushDispatchOneTaskMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function PushDispatchOneTaskMessage:OnCreate()
  base.OnCreate(self)
end

function PushDispatchOneTaskMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.ls ~= nil then
    for _, v in ipairs(message.ls) do
      DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(v, false)
    end
    EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateSingle)
    local action = message.action
    if not string.IsNullOrEmpty(action) and action == "HERO_DISPATCH_MISSION_ON_FIRST_BUILD" then
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskFirstPush)
    end
  end
end

return PushDispatchOneTaskMessage
