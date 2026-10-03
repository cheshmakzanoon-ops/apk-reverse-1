local ParkourRebirthInfoMessage = BaseClass("ParkourRebirthInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourRebirthInfoMessage:OnCreate(uuid, coin, distance)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutLong("coin", coin)
  self.sfsObj:PutLong("distance", distance)
end

function ParkourRebirthInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  end
  EventManager:GetInstance():Broadcast(EventId.SurfingOnGetRebirthInfo, t)
end

return ParkourRebirthInfoMessage
