local ParkourFightEndMessage = BaseClass("ParkourFightEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourFightEndMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutDouble("distance", param.distance)
  self.sfsObj:PutLong("addCoin", param.score)
  self.sfsObj:PutInt("box", param.box)
  self.sfsObj:PutSFSArray("inviteUsers", param.inviteUsers)
  self.sfsObj:PutDouble("totalRunTime", param.totalRunTime)
end

function ParkourFightEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.SurfingOnBattleFinished, t)
end

return ParkourFightEndMessage
