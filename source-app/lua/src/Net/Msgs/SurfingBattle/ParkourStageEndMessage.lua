local ParkourStageEndMessage = BaseClass("ParkourStageEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourStageEndMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutLong("distance", param.distance)
  self.sfsObj:PutLong("addCoin", param.score)
  self.sfsObj:PutInt("box", param.box)
  self.sfsObj:PutSFSArray("inviteUsers", param.inviteUsers)
end

function ParkourStageEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.SurfingFightEndRefresh, t.uuid)
  end
end

return ParkourStageEndMessage
