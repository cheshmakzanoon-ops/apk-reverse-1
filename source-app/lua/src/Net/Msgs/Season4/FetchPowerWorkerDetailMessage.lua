local FetchPowerWorkerDetailMessage = BaseClass("FetchPowerWorkerDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchPowerWorkerDetailMessage:OnCreate()
  base.OnCreate(self)
end

function FetchPowerWorkerDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t and t.powerWorker then
    for k, v in pairs(t.powerWorker) do
      if v ~= nil and v.uuid ~= nil then
        DataCenter.SeasonPowerWorkerManager:UpdatePowerWorker(v)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.PowerWorkerUpdated)
  end
end

return FetchPowerWorkerDetailMessage
