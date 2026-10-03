local PushPowerWorkerCreateMessage = BaseClass("PushPowerWorkerCreateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPowerWorkerCreateMessage:OnCreate(allianceId)
  base.OnCreate(self)
  self.sfsObj:PutInt("openHide", 1)
  self.sfsObj:PutUtfString("allianceId", allianceId)
end

function PushPowerWorkerCreateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t ~= nil and t.uuid ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdatePowerWorker(t)
    EventManager:GetInstance():Broadcast(EventId.PowerWorkerUpdated)
    EventManager:GetInstance():Broadcast(EventId.UPDATE_BUILD_DATA, t.buildUuid)
    if t.buildUuid ~= nil then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerHouse)
      DataCenter.SeasonPowerWorkerManager:ShowWorkerMan(t.buildUuid)
    end
  end
end

return PushPowerWorkerCreateMessage
