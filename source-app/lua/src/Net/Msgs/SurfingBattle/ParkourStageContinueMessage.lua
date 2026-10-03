local ParkourStageContinueMessage = BaseClass("ParkourStageContinueMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourStageContinueMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function ParkourStageContinueMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.SurfingFightOnRefreshIds, t)
  end
end

return ParkourStageContinueMessage
