local CareerEffectManager = BaseClass("CareerEffectManager")
local ResourceManager = CS.GameEntry.Resource
local CareerEffect = require("UI.UIFarm.Component.CareerEffect")

local function __init(self)
  self.allEffects = {}
  self.request = {}
end

local function __delete(self)
  self:RemoveAll()
  self.allEffects = nil
  self.request = nil
end

local function RefreshOne(self, queueUid, onlyRefresh)
  local queueData = DataCenter.QueueDataManager:GetQueueByUuid(queueUid)
  if queueData == nil then
    return
  end
  local canIrrigate = DataCenter.PlayerCareerManager:CheckIfIrrigateAvailable(IrrigationType.Farmland)
  if canIrrigate then
    if onlyRefresh ~= true then
      local isIrrigated = queueData:CheckIfIrrigated()
      if isIrrigated then
        self:AddOne(queueUid)
      end
    end
    if self.allEffects[queueUid] ~= nil then
      self.allEffects[queueUid]:RefreshView()
    end
  else
    self:RemoveOne(queueUid)
  end
end

local function RefreshAll(self, onlyRefresh)
  local allFarmQueue = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Field)
  for k, v in pairs(allFarmQueue) do
    if v ~= nil and v:GetQueueState() == NewQueueState.Work then
      self:RefreshOne(k, onlyRefresh)
    end
  end
end

local function AddOne(self, queueUid)
  if self.allEffects[queueUid] ~= nil or self.request[queueUid] ~= nil then
    return
  end
  self.request[queueUid] = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/UIFarm/UIFarmIrrigateEffect.prefab")
  self.request[queueUid]:completed("+", function()
    if self.request[queueUid].isError then
      return
    end
    self.request[queueUid].gameObject:SetActive(true)
    self.request[queueUid].gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(queueUid)
    if queueData ~= nil then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(queueData.funcUuid)
      if buildData ~= nil and buildData.state ~= BuildingStateType.FoldUp then
        local worldPointPos = SceneUtils.TileIndexToWorld(buildData.pointId)
        self.request[queueUid].gameObject.transform.position = worldPointPos
      end
    end
    local effect = CareerEffect.New()
    effect:OnCreate(self.request[queueUid])
    effect:ReInit(queueUid)
    self.allEffects[queueUid] = effect
  end)
end

local function RemoveOne(self, queueUid)
  if self.allEffects[queueUid] ~= nil then
    self.allEffects[queueUid]:OnDestroy()
    self.allEffects[queueUid] = nil
  end
  if self.request[queueUid] ~= nil then
    self.request[queueUid]:Destroy()
    self.request[queueUid] = nil
  end
end

local function RemoveAll(self)
  table.walk(self.allEffects, function(_, v)
    v:OnDestroy()
  end)
  self.allEffects = {}
  table.walk(self.request, function(_, v)
    v:Destroy()
  end)
  self.request = {}
end

CareerEffectManager.__init = __init
CareerEffectManager.__delete = __delete
CareerEffectManager.RefreshOne = RefreshOne
CareerEffectManager.RefreshAll = RefreshAll
CareerEffectManager.AddOne = AddOne
CareerEffectManager.RemoveOne = RemoveOne
CareerEffectManager.RemoveAll = RemoveAll
return CareerEffectManager
