local UpgradeWorkerStarMessage = BaseClass("UpgradeWorkerStarMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorkerDataManager:AddOneWorker(message.worker)
    EventManager:GetInstance():Broadcast(EventId.WorkerInfoUpdate)
  end
end

UpgradeWorkerStarMessage.OnCreate = OnCreate
UpgradeWorkerStarMessage.HandleMessage = HandleMessage
return UpgradeWorkerStarMessage
