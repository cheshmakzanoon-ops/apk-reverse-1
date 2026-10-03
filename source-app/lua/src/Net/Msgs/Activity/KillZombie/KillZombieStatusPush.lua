local KillZombieStatusPush = BaseClass("KillZombieStatusPush", SFSBaseMessage)
local base = SFSBaseMessage

function KillZombieStatusPush:OnCreate()
  base.OnCreate(self)
end

function KillZombieStatusPush:HandleMessage(data)
  base.HandleMessage(self, data)
  if data ~= nil then
    EventManager:GetInstance():Broadcast(EventId.MonsterChallenged)
    SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
  end
end

return KillZombieStatusPush
