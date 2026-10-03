local BuildTrainEffectManager = BaseClass("BuildTrainEffectManager")
local BuildTrainTimeFinishEffect = require("Scene.BuildTrainEffect.BuildTrainTimeFinishEffect")
local BuildTrainCompleteEffect = require("Scene.BuildTrainEffect.BuildTrainCompleteEffect")
local EffectType = {TimeFinish = 1, Complete = 2}

function BuildTrainEffectManager:__init()
  self.allEffect = {}
  self.isShow = true
  self:AddListener()
end

function BuildTrainEffectManager:__delete()
  self:RemoveAll()
  self.isShow = true
  self.allEffect = {}
  self:RemoveListener()
end

function BuildTrainEffectManager:Startup()
end

function BuildTrainEffectManager:AddListener()
  if self.trainingArmyFinishSignal == nil then
    function self.trainingArmyFinishSignal(id)
      self:TrainingArmyFinishSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.TrainingArmyFinish, self.trainingArmyFinishSignal)
  end
  if self.queueTimeEndSignal == nil then
    function self.queueTimeEndSignal(id)
      self:QueueTimeEndSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
  end
  if self.changeCameraLodSignal == nil then
    function self.changeCameraLodSignal(id)
      self:ChangeCameraLodSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
  end
  if self.updateBuildDataSignal == nil then
    function self.updateBuildDataSignal(id)
      self:UpdateBuildDataSignal(id)
    end
    
    EventManager:GetInstance():AddListener(EventId.UPDATE_BUILD_DATA, self.updateBuildDataSignal)
  end
end

function BuildTrainEffectManager:RemoveListener()
  if self.trainingArmyFinishSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.TrainingArmyFinish, self.trainingArmyFinishSignal)
    self.trainingArmyFinishSignal = nil
  end
  if self.queueTimeEndSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.QUEUE_TIME_END, self.queueTimeEndSignal)
    self.queueTimeEndSignal = nil
  end
  if self.changeCameraLodSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.changeCameraLodSignal)
    self.changeCameraLodSignal = nil
  end
  if self.updateBuildDataSignal ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.UPDATE_BUILD_DATA, self.updateBuildDataSignal)
    self.updateBuildDataSignal = nil
  end
end

function BuildTrainEffectManager:RemoveAll()
  for k, v in pairs(self.allEffect) do
    v:Destroy()
  end
  self.allEffect = {}
end

function BuildTrainEffectManager:RemoveOneEffect(bUuid)
  if self.allEffect[bUuid] ~= nil then
    self.allEffect[bUuid]:Destroy()
    self.allEffect[bUuid] = nil
  end
end

function BuildTrainEffectManager:CheckShowTimeFinishEffect(bUuid)
  local param = self:GetEffectParam(bUuid, EffectType.TimeFinish)
  if param == nil then
    self:RemoveOneEffect(bUuid)
  else
    self:ShowOneTimeFinishEffect(param)
  end
end

function BuildTrainEffectManager:CheckShowCompleteEffect(bUuid)
  local param = self:GetEffectParam(bUuid, EffectType.Complete)
  if param == nil then
    self:RemoveOneEffect(bUuid)
  else
    self:RemoveOneEffect(bUuid)
    self:ShowOneCompleteEffect(param)
  end
end

function BuildTrainEffectManager:GetEffectParam(bUuid, effectType)
  if DataCenter.BuildManager:IsBuildInView(bUuid) then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil and not buildData:IsInFix() then
      local buildId = buildData.itemId
      local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(buildId)
      if queueType ~= NewQueueType.Default then
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if buildTemplate ~= nil then
          local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
          if queue ~= nil then
            if effectType == EffectType.TimeFinish then
              if queue:GetQueueState() == NewQueueState.Finish then
                local param = {}
                param.uuid = bUuid
                param.position = buildData:GetCenterVec()
                param.isShow = self.isShow
                return param
              end
            elseif effectType == EffectType.Complete then
              local param = {}
              param.uuid = bUuid
              param.position = buildData:GetCenterVec()
              param.isShow = self.isShow
              return param
            end
          end
        end
      end
    end
  end
end

function BuildTrainEffectManager:ShowOneTimeFinishEffect(param)
  if self.allEffect[param.uuid] == nil then
    local effect = BuildTrainTimeFinishEffect.New()
    effect:ReInit(param)
    self.allEffect[param.uuid] = effect
  else
    self.allEffect[param.uuid]:ReInit(param)
  end
end

function BuildTrainEffectManager:ShowOneCompleteEffect(param)
  if self.allEffect[param.uuid] == nil then
    local effect = BuildTrainCompleteEffect.New()
    effect:ReInit(param)
    self.allEffect[param.uuid] = effect
  else
    self.allEffect[param.uuid]:ReInit(param)
  end
end

function BuildTrainEffectManager:TrainingArmyFinishSignal(queueType)
  local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
  local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
  if list ~= nil then
    for k, v in pairs(list) do
      self:CheckShowCompleteEffect(v.uuid)
    end
  end
end

function BuildTrainEffectManager:QueueTimeEndSignal(queueType)
  if queueType == NewQueueType.BowSoldier or queueType == NewQueueType.CarSoldier or queueType == NewQueueType.FootSoldier then
    local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
    if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
      local buildId = DataCenter.BuildManager:GetBuildIdByNewQueue(queueType)
      local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
      if list ~= nil then
        for k, v in pairs(list) do
          self:CheckShowTimeFinishEffect(v.uuid)
        end
      end
    end
  end
end

function BuildTrainEffectManager:ChangeCameraLodSignal(lod)
  local show = lod <= 1
  if self.isShow ~= show then
    self.isShow = show
    for k, v in pairs(self.allEffect) do
      v:SetVisible(self.isShow)
    end
  end
end

function BuildTrainEffectManager:UpdateBuildDataSignal(uuid)
  self:CheckShowTimeFinishEffect(uuid)
end

return BuildTrainEffectManager
