local PushPowerWorkerUpdateMessage = BaseClass("PushPowerWorkerUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPowerWorkerUpdateMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("openHide", 1)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function PushPowerWorkerUpdateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t ~= nil and t.list ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkers(t.list)
    EventManager:GetInstance():Broadcast(EventId.PowerWorkerUpdated)
  end
end

return PushPowerWorkerUpdateMessage
