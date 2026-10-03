local WorkerExchangeAssignMessage = BaseClass("WorkerExchangeAssignMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, slotId, itemId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("slotId", slotId)
  self.sfsObj:PutUtfString("itemId", itemId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
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

WorkerExchangeAssignMessage.OnCreate = OnCreate
WorkerExchangeAssignMessage.HandleMessage = HandleMessage
return WorkerExchangeAssignMessage
