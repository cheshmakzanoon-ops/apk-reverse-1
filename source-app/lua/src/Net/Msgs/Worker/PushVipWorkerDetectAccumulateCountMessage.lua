local PushVipWorkerDetectAccumulateCountMessage = BaseClass("PushVipWorkerDetectAccumulateCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, itemId)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorkerDataManager:UpdateVipWorkerAccumulateCount(message)
  end
end

PushVipWorkerDetectAccumulateCountMessage.OnCreate = OnCreate
PushVipWorkerDetectAccumulateCountMessage.HandleMessage = HandleMessage
return PushVipWorkerDetectAccumulateCountMessage
