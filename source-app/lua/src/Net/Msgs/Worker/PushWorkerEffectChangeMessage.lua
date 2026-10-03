local PushWorkerEffectChangeMessage = BaseClass("PushHeroEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local workerUid = message.workerUid
  local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(workerUid)
  if workerData ~= nil then
    workerData:HandleEffect(message.effect)
  end
end

PushWorkerEffectChangeMessage.OnCreate = OnCreate
PushWorkerEffectChangeMessage.HandleMessage = HandleMessage
return PushWorkerEffectChangeMessage
