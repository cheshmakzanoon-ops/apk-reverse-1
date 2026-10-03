local PushAlZombieRushPointChangeMessage = BaseClass("PushAlZombieRushPointChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAlZombieRushPointChangeMessage:OnCreate()
  base.OnCreate(self)
end

function PushAlZombieRushPointChangeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.allianceId then
    local allianceId = message.allianceId
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData and allianceData.uid == allianceId then
      allianceData:UpdateZombieRushPoint(message.zombieRushPoint)
      EventManager:GetInstance():Broadcast(EventId.UpdateZombieRushPointData)
    end
  end
end

return PushAlZombieRushPointChangeMessage
