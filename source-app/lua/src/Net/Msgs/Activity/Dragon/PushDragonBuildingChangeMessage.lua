local PushDragonBuildingChangeMessage = BaseClass("PushDragonBuildingChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDragonBuildingChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushDragonBuildingChangeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil then
    EventManager:GetInstance():Broadcast(EventId.DragonBuildingChange, t)
  end
end

return PushDragonBuildingChangeMessage
