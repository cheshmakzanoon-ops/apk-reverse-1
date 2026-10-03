local PushSoldierElevenInfoMessage = BaseClass("PushSoldierElevenInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSoldierElevenInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushSoldierElevenInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.soldierElevenInfo then
    DataCenter.T11DataManager:UpdateT11LvData(t.soldierElevenInfo)
    EventManager:GetInstance():Broadcast(EventId.T11DataUpdate)
    if T11Util.IsMaxStage() then
      EventManager:GetInstance():Broadcast(EventId.T11ArriveMaxStage)
    end
  end
end

return PushSoldierElevenInfoMessage
