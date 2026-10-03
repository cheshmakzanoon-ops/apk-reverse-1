local GhostParkourFightEndMessage = BaseClass("GhostParkourFightEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourFightEndMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutDouble("distance", param.distance)
  self.sfsObj:PutLong("addCoin", param.score)
  self.sfsObj:PutDouble("totalRunTime", param.totalRunTime)
  self.sfsObj:PutUtfString("buffList", param.buffList)
end

function GhostParkourFightEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.GhostParkourOnBattleFinished, t)
end

return GhostParkourFightEndMessage
