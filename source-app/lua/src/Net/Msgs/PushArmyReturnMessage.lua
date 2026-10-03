local PushArmyReturnMessage = BaseClass("PushArmyReturnMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.powerWorker_formation ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkerFormation(t.powerWorker_formation)
    SFSNetwork.SendMessage(MsgDefines.FetchPowerWorkerDetail)
  end
  DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
  DataCenter.ArmyFormationDataManager:FetchFormationSoldier()
  EventManager:GetInstance():Broadcast(EventId.FormationSoldierUpdate)
end

PushArmyReturnMessage.OnCreate = OnCreate
PushArmyReturnMessage.HandleMessage = HandleMessage
return PushArmyReturnMessage
