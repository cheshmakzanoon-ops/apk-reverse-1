local LWTrainManager = BaseClass("LWTrainManager")
local Train = require("Scene.LWRailway.Train.Train")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject

function LWTrainManager:__init(owner)
  self.allTrains = {}
  self.transparentMat = {}
  self.transparentAsset = {}
end

function LWTrainManager:__delete()
  self:Destroy()
  if self.effectNode then
    GameObject.Destroy(self.effectNode.gameObject)
    self.effectNode = nil
  end
end

function LWTrainManager:Startup()
  self.effectNode = GameObject("TrainEffect").transform
end

function LWTrainManager:Destroy()
  self:RemoveListeners()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  for _, v in pairs(self.allTrains) do
    v:Destroy()
  end
  self.allTrains = {}
  if self.transparentAsset then
    for i = 1, #self.transparentAsset do
      self.transparentMat[i] = nil
      self.transparentAsset[i]:Release()
    end
  end
  self.transparentMat = {}
  self.transparentAsset = {}
  if self.transparentReq then
    for i = 1, #self.transparentReq do
      self.transparentReq[i]:Release()
      self.transparentReq[i].completed = nil
    end
  end
  self.transparentReq = nil
end

function LWTrainManager:AddListeners()
  if self.onChangeCameraLod == nil then
    function self.onChangeCameraLod(lod)
      self:OnChangeCameraLod(lod)
    end
    
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.onChangeCameraLod)
  end
end

function LWTrainManager:RemoveListeners()
  if self.onChangeCameraLod ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.onChangeCameraLod)
    self.onChangeCameraLod = nil
  end
end

function LWTrainManager:EnterWorld()
  local trainActivityIsOpen = DataCenter.LWAllyStationDataManager:IsTrainActivityOpen()
  if not trainActivityIsOpen then
    return
  end
  self:AddListeners()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.transparentReq = {}
  self:LoadAssetAsyncTrainTransparent(1, "Assets/Main/Material/Train/A_build_Train_02_transparent.mat")
  self:LoadAssetAsyncTrainTransparent(2, "Assets/Main/Material/Train/A_build_Damagedtrain_01_transparent.mat")
  self:LoadAssetAsyncTrainTransparent(3, "Assets/Main/Material/Train/A_build_Train_01_transparent.mat")
  self:LoadAssetAsyncTrainTransparent(4, "Assets/Main/Material/Train/O_env_huocheur_transparent.mat")
  self:LoadAssetAsyncTrainTransparent(5, "Assets/Main/Material/Train/O_env_jinchexiang_transparent.mat")
  self:LoadAssetAsyncTrainTransparent(6, "Assets/Main/Material/Train/O_env_huocheur_transparent_dao.mat")
end

function LWTrainManager:LoadAssetAsyncTrainTransparent(index, loadPath)
  if self.transparentReq[index] == nil then
    self.transparentReq[index] = Resource:LoadAssetAsync(loadPath, typeof(CS.UnityEngine.Material))
    self.transparentReq[index].completed = function(asset)
      if self.transparentReq == nil then
        return
      end
      local matObj = self.transparentReq[index].asset
      self.transparentMat[index] = matObj
    end
  end
end

function LWTrainManager:ExitWorld()
  self:Destroy()
end

function LWTrainManager:OnUpdate()
  for _, v in pairs(self.allTrains) do
    v:OnUpdate()
  end
end

function LWTrainManager:CreateTrain(march, parent)
  local uuid = march.train.uuid
  self:RemoveTrain(uuid)
  local trainData = DataCenter.LWTrainDataManager:GetOneTrain(uuid)
  if trainData == nil then
    trainData = DataCenter.LWAllyStationDataManager:GetAllyTrainByUuid(uuid)
  end
  if trainData then
    local newTrain = Train.New(trainData, march, parent)
    self.allTrains[newTrain.uuid] = newTrain
  end
end

function LWTrainManager:RemoveTrain(uuid)
  local train = self:GetTrain(uuid)
  if train then
    EventManager:GetInstance():Broadcast(EventId.HideTroopName, train.trainData.marchUid)
    train:Destroy()
    self.allTrains[uuid] = nil
  end
end

function LWTrainManager:RefreshTrain(march)
  local uuid = march.train.uuid
  local train = self:GetTrain(uuid)
  if train then
    train:Refresh(uuid, march)
  end
end

function LWTrainManager:GetTrain(uuid)
  return self.allTrains[uuid]
end

function LWTrainManager:SetPosition(uuid, pos)
  local train = self.allTrains[uuid]
end

function LWTrainManager:GetTransparentMat(index)
  return self.transparentMat[index]
end

function LWTrainManager:GetURTransparentMat(index)
  return self.transparentMat[index + 3]
end

function LWTrainManager:OnChangeCameraLod(lod)
  for _, v in pairs(self.allTrains) do
    v:OnChangeCameraLod(lod)
  end
end

return LWTrainManager
