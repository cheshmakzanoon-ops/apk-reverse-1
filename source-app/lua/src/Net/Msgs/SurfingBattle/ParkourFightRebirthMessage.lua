local ParkourFightRebirthMessage = BaseClass("ParkourFightRebirthMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourFightRebirthMessage:OnCreate(param)
  base.OnCreate(self)
  if param then
    self.sfsObj:PutLong("uuid", param.uuid)
    self.sfsObj:PutDouble("distance", param.distance)
    self.sfsObj:PutLong("coin", param.coin)
    self.sfsObj:PutInt("box", param.box)
    self.sfsObj:PutInt("times", param.times)
    self.sfsObj:PutInt("curIndex", param.curIndex)
  end
end

function ParkourFightRebirthMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  end
  EventManager:GetInstance():Broadcast(EventId.SurfingFightOnFailed, t)
end

return ParkourFightRebirthMessage
