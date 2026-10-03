local WorkerChangeStateMessgae = BaseClass("WorkerChangeStateMessgae", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid, state)
  self.sfsObj:PutLong("uid", uid)
  self.sfsObj:PutInt("state", state)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  if message.worker then
    DataCenter.GainWorkerManager:OnWorkerStateChangeMessageBack()
    DataCenter.WorkerDataManager:AddOneWorker(message.worker)
    EventManager:GetInstance():Broadcast(EventId.GF_worker_rescued)
  end
end

WorkerChangeStateMessgae.OnCreate = OnCreate
WorkerChangeStateMessgae.HandleMessage = HandleMessage
return WorkerChangeStateMessgae
