local PushBuildingInfoMessage = BaseClass("PushBuildingInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.BuildManager:PushBuildingInfoHandle(t)
  if t.workerInfo then
    DataCenter.WorkerDataManager:UpdateWorkerDataListByBuild(t.workerInfo)
    EventManager:GetInstance():Broadcast(EventId.BuildingHeroDispatching)
  end
end

PushBuildingInfoMessage.OnCreate = OnCreate
PushBuildingInfoMessage.HandleMessage = HandleMessage
return PushBuildingInfoMessage
