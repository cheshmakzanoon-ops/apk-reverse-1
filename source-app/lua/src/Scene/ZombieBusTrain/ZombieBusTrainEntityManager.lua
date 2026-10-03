local ZombieBusTrainEntityManager = BaseClass("ZombieBusTrainEntityManager")
local ZombieBusTrainEntity = require("Scene.ZombieBusTrain.ZombieBusTrainEntity")
local fakePrefabPath = "Assets/Main/Prefabs/March/WorldTroopZombieBusTrain.prefab"
local ResourceManager = CS.GameEntry.Resource

function ZombieBusTrainEntityManager:__init(owner)
end

function ZombieBusTrainEntityManager:__delete()
  self:Destroy()
end

function ZombieBusTrainEntityManager:Destroy()
  for _, v in pairs(self.allZombieBusTrainEntity) do
    v:Delete()
  end
  self.allZombieBusTrainEntity = {}
  self:ClearFakeZombieBus()
end

function ZombieBusTrainEntityManager:EnterWorld()
  self.allZombieBusTrainEntity = {}
end

function ZombieBusTrainEntityManager:ExitWorld()
  self:Destroy()
end

function ZombieBusTrainEntityManager:ClearFakeZombieBus()
  if self.fakeZombieBusTrainEntity then
    self.fakeZombieBusTrainEntity:Delete()
  end
  self.fakeZombieBusTrainEntity = nil
  if self.fakeZombieBusTrainPrefabReq then
    self.fakeZombieBusTrainPrefabReq:Destroy()
  end
  self.fakeZombieBusTrainPrefabReq = nil
end

function ZombieBusTrainEntityManager:DoPlayFakeZombieBusDead(position, euler, busList, eventUuid)
  self:ClearFakeZombieBus()
  self.fakeZombieBusTrainPrefabReq = ResourceManager:InstantiateAsync(fakePrefabPath)
  self.fakeZombieBusTrainPrefabReq:completed("+", function()
    if self.fakeZombieBusTrainPrefabReq.isError then
      return
    end
    local go = self.fakeZombieBusTrainPrefabReq.gameObject
    go.transform:Set_eulerAngles(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    go.transform:Set_position(position.x, position.y, position.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go:SetActive(true)
    local transform = go.transform:Find("Model")
    transform:Set_eulerAngles(euler.x, euler.y, euler.z)
    self.fakeZombieBusTrainEntity = ZombieBusTrainEntity.New(nil, busList, go.transform)
    local timeToDisappear = self.fakeZombieBusTrainEntity:DoDelayDead() + 1
    self:ClearFakeDeadTimer()
    self.fakeDeadTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClearFakeDeadTimer()
      self:ClearFakeZombieBus()
      local completeData = {}
      completeData.uuid = eventUuid
      completeData.position = position
      EventManager:GetInstance():Broadcast(EventId.DetectEventComp, completeData)
    end, timeToDisappear)
  end)
end

function ZombieBusTrainEntityManager:ClearFakeDeadTimer()
  if self.fakeDeadTimer then
    self.fakeDeadTimer:Stop()
    self.fakeDeadTimer = nil
  end
end

function ZombieBusTrainEntityManager:CreateTroopZombieBusTrain(march, transform)
  local uuid = march.uuid
  local busList = self:GetMarchBusList(march)
  local zombieBusTrainEntity = self.allZombieBusTrainEntity[uuid]
  if zombieBusTrainEntity then
    zombieBusTrainEntity:Refresh(march, busList)
  else
    self.allZombieBusTrainEntity[uuid] = ZombieBusTrainEntity.New(march, busList, transform)
  end
end

function ZombieBusTrainEntityManager:DeleteTroopZombieBusTrain(uuid)
  local zombieBusTrainEntity = self.allZombieBusTrainEntity[uuid]
  if zombieBusTrainEntity then
    zombieBusTrainEntity:Delete()
    self.allZombieBusTrainEntity[uuid] = nil
  end
end

function ZombieBusTrainEntityManager:RefreshTroopZombieBusTrain(march)
  local zombieBusTrainEntity = self.allZombieBusTrainEntity[march.uuid]
  if zombieBusTrainEntity then
    local busList = self:GetMarchBusList(march)
    zombieBusTrainEntity:Refresh(march, busList)
  end
end

function ZombieBusTrainEntityManager:GetMarchBusList(march)
  local marchBusList = march:GetZombieBusList()
  local busList = {}
  if marchBusList then
    local count = marchBusList.Count
    if 0 < count then
      for i = 0, count - 1 do
        table.insert(busList, marchBusList[i])
      end
    end
  end
  return busList
end

function ZombieBusTrainEntityManager:GetZombieBusTrainEntity(uuid)
  return self.allZombieBusTrainEntity[uuid]
end

return ZombieBusTrainEntityManager
