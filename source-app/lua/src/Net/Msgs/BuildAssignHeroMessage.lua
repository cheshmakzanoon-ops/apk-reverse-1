local BuildAssignHeroMessage = BaseClass("BuildAssignHeroMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, slotId, heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("slotId", slotId)
  self.sfsObj:PutLong("heroUuid", heroUuid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if table.count(message.buildingInfo) >= 1 then
    for i, v in pairs(message.buildingInfo) do
      if type(v) == "table" then
        DataCenter.BuildManager:AddBuilding(v)
      end
    end
  end
  if message.workerInfo then
    DataCenter.WorkerDataManager:UpdateWorkerDataListByBuild(message.workerInfo)
    EventManager:GetInstance():Broadcast(EventId.BuildingHeroDispatching)
  end
end

BuildAssignHeroMessage.OnCreate = OnCreate
BuildAssignHeroMessage.HandleMessage = HandleMessage
return BuildAssignHeroMessage
