local PushArmyChangeMessage = BaseClass("PushArmyChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.powerWorker_formation ~= nil then
    DataCenter.SeasonPowerWorkerManager:UpdatePowerWorkerFormation(t.powerWorker_formation)
  end
  DataCenter.ArmyManager:PushArmyChangeHandle(t)
end

PushArmyChangeMessage.OnCreate = OnCreate
PushArmyChangeMessage.HandleMessage = HandleMessage
return PushArmyChangeMessage
