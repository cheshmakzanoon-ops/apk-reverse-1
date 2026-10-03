local FreeBuildingUpNewMessage = BaseClass("FreeBuildingUpNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  DataCenter.BuildManager:SetCurStamina()
  if param ~= nil then
    if param.uuid == "nil" then
      Logger.LogError("uuid is nil")
    end
    if param.uuid then
      self.sfsObj:PutUtfString("uuid", param.uuid)
    end
    if param.clientParam then
      self.sfsObj:PutUtfString("clientParam", param.clientParam)
    end
    if param.gold then
      self.sfsObj:PutInt("gold", param.gold)
    end
    if param.upLevel then
      self.sfsObj:PutInt("upLevel", param.upLevel)
    end
    if param.truckId then
      self.sfsObj:PutInt("truckId", param.truckId)
    end
    if param.pathTime then
      self.sfsObj:PutInt("pathTime", param.pathTime)
    end
    if param.workerId then
      self.sfsObj:PutLong("workerUuid", param.workerId)
    end
    if param.goldCost ~= nil and param.goldCost > 0 then
      self.sfsObj:PutInt("goldCost", param.goldCost)
    end
    if param.robotUuid then
      self.sfsObj:PutLong("robotUuid", param.robotUuid)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  EventManager:GetInstance():Broadcast(EventId.UnLockFreeBuildingUpNewMsg)
  DataCenter.BuildManager:FreeBuildingUpNewHandle(t)
  if t.assignInfo and t.assignInfo.workerInfo then
    DataCenter.WorkerDataManager:UpdateWorkerDataListByBuild(t.assignInfo.workerInfo)
    EventManager:GetInstance():Broadcast(EventId.BuildingHeroDispatching)
  end
  if t.heros then
    for i, info in pairs(t.heros) do
      DataCenter.HeroDataManager:UpdateOneHero(info)
    end
  end
end

FreeBuildingUpNewMessage.OnCreate = OnCreate
FreeBuildingUpNewMessage.HandleMessage = HandleMessage
return FreeBuildingUpNewMessage
