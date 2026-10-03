local GhostParkourStageEndMessage = BaseClass("GhostParkourStageEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourStageEndMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", param.uuid)
  self.sfsObj:PutInt("index", param.index)
  self.sfsObj:PutInt("id", param.id)
  self.sfsObj:PutLong("distance", param.distance)
  self.sfsObj:PutLong("addCoin", param.score)
end

function GhostParkourStageEndMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.GhostParkourOnStageEndCheck, t.uuid)
  end
end

return GhostParkourStageEndMessage
