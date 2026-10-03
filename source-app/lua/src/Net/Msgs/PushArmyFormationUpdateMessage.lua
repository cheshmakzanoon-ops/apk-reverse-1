local PushArmyFormationUpdateMessage = BaseClass("PushArmyFormationUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.powerWorker_formation ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkerFormation(t.powerWorker_formation)
  end
  DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
end

PushArmyFormationUpdateMessage.OnCreate = OnCreate
PushArmyFormationUpdateMessage.HandleMessage = HandleMessage
return PushArmyFormationUpdateMessage
