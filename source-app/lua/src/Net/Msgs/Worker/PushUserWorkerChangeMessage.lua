local PushUserWorkerChangeMessage = BaseClass("PushHeroEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.worker then
    if message.action == "VISITOR_RECRUIT" then
      UIUtil.ShowTipsId(110010)
    end
    DataCenter.WorkerDataManager:AddOneWorker(message.worker)
    EventManager:GetInstance():Broadcast(EventId.AcquireWorker)
  end
end

PushUserWorkerChangeMessage.OnCreate = OnCreate
PushUserWorkerChangeMessage.HandleMessage = HandleMessage
return PushUserWorkerChangeMessage
