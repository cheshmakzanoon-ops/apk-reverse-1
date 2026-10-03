local WorkerAssignAllMessage = BaseClass("WorkerAssignAllMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local changeBuildCount = table.count(message.buildingInfo)
  if 1 <= changeBuildCount then
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
  if 1 <= changeBuildCount then
    UIUtil.ShowTipsId("worker_hall_tips1")
  else
    UIUtil.ShowTipsId("worker_hall_tips2")
  end
end

WorkerAssignAllMessage.OnCreate = OnCreate
WorkerAssignAllMessage.HandleMessage = HandleMessage
return WorkerAssignAllMessage
