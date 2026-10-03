local PushDragonScoreExplodeMessage = BaseClass("PushDragonScoreExplodeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonScoreExplodeMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonScoreExplodeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    EventManager:GetInstance():Broadcast(EventId.DragonScoreExplode, t)
  end
end

return PushDragonScoreExplodeMessage
