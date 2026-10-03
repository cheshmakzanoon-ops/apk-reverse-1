local PushVipWorkerDetectRewardTimesMessage = BaseClass("PushVipWorkerDetectRewardTimesMessage", SFSBaseMessage)
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
    DataCenter.WorkerDataManager:GetVipWorkerGetRewardTimesCurDay(message)
  end
end

PushVipWorkerDetectRewardTimesMessage.OnCreate = OnCreate
PushVipWorkerDetectRewardTimesMessage.HandleMessage = HandleMessage
return PushVipWorkerDetectRewardTimesMessage
