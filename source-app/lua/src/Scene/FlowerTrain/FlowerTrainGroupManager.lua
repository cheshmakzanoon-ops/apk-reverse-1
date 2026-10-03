local FlowerTrainGroupManager = BaseClass("FlowerTrainGroupManager")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local FlowerTrainGroup = require("Scene.FlowerTrain.FlowerTrainGroup")

function FlowerTrainGroupManager:__init()
  self.flowerTrainItemDic = {}
end

function FlowerTrainGroupManager:__delete()
  self:Destroy()
  if self.flowerTrainNode then
    GameObject.Destroy(self.flowerTrainNode.gameObject)
    self.flowerTrainNode = nil
  end
end

function FlowerTrainGroupManager:Startup()
  self.flowerTrainNode = GameObject("FlowerTrainRoot").transform
end

function FlowerTrainGroupManager:Destroy()
  if self.flowerTrainItemDic then
    for _, flowerTrain in pairs(self.flowerTrainItemDic) do
      flowerTrain:Destroy()
    end
    self.flowerTrainItemDic = nil
  end
end

function FlowerTrainGroupManager:AddListeners()
  if self.onChangeCameraLod == nil then
    function self.onChangeCameraLod(lod)
      self:OnChangeCameraLod(lod)
    end
    
    EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.onChangeCameraLod)
  end
  if self.onChangeDisplayMode == nil then
    function self.onChangeDisplayMode(lod)
      self:OnDisplayModeUpdate()
    end
    
    EventManager:GetInstance():AddListener(EventId.WorldMarchUpdateDisplayMode, self.onChangeDisplayMode)
  end
end

function FlowerTrainGroupManager:RemoveListeners()
  if self.onChangeCameraLod ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.onChangeCameraLod)
    self.onChangeCameraLod = nil
  end
  if self.onChangeDisplayMode ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.WorldMarchUpdateDisplayMode, self.onChangeDisplayMode)
  end
end

function FlowerTrainGroupManager:EnterWorld()
  self:AddListeners()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.isInWorld = true
  self.lastSyncTime = UITimeManager:GetInstance():GetServerTime()
end

function FlowerTrainGroupManager:ExitWorld()
  self.isInWorld = false
  self:Destroy()
end

function FlowerTrainGroupManager:OnUpdate()
  if not self.isInWorld then
    return
  end
  if self.flowerTrainItemDic then
    local now = UITimeManager:GetInstance():GetServerTime()
    for _, v in pairs(self.flowerTrainItemDic) do
      v:OnUpdate(now)
    end
  end
  local serverNow = UITimeManager:GetInstance():GetServerTime()
  if serverNow - self.lastSyncTime >= 1000 then
    self:Update1000MS()
  end
end

function FlowerTrainGroupManager:CreateFlowerTrain(marchInfo, marchModelPoint, cameraFollowTransform)
  local uuid = marchInfo.uuid
  local flowerTrainData = DataCenter.FlowerTrainDataManager:GetFlowerTrainGroupDataByMarchUuid(uuid)
  if not flowerTrainData then
    Logger.LogError("CreateFlowerTrain failed, flowerTrainData not found, uuid: " .. uuid)
    return
  end
  local flowerTrainGroup = self:GetFlowerTrain(uuid)
  if flowerTrainGroup then
    self:RefreshFlowerTrain(marchInfo)
    return
  end
  flowerTrainGroup = FlowerTrainGroup.New()
  flowerTrainGroup:Init(flowerTrainData, marchInfo, marchModelPoint, cameraFollowTransform, self.flowerTrainNode)
  self.flowerTrainItemDic[uuid] = flowerTrainGroup
end

function FlowerTrainGroupManager:RefreshFlowerTrain(march)
  local uuid = march.flowerTrain.uuid
  local flowerTrain = self:GetFlowerTrain(uuid)
  if flowerTrain then
    local flowerTrainData = DataCenter.FlowerTrainDataManager:GetFlowerTrainGroupDataByMarchUuid(uuid)
    if not flowerTrainData then
      Logger.LogError("RefreshFlowerTrain failed, flowerTrainData not found, uuid: " .. uuid)
      return
    end
    flowerTrain:Refresh(flowerTrainData)
  else
    Logger.LogError("RefreshFlowerTrain failed, flowerTrain not found, uuid: " .. uuid)
  end
end

function FlowerTrainGroupManager:RemoveFlowerTrain(uuid)
  local flowerTrain = self:GetFlowerTrain(uuid)
  if flowerTrain then
    flowerTrain:Destroy()
    self.flowerTrainItemDic[uuid] = nil
  end
end

function FlowerTrainGroupManager:GetFlowerTrain(uuid)
  if self.flowerTrainItemDic[uuid] then
    return self.flowerTrainItemDic[uuid]
  end
  return nil
end

function FlowerTrainGroupManager:OnChangeCameraLod(lod)
  self.lod = lod
  if self.flowerTrainItemDic then
    for _, v in pairs(self.flowerTrainItemDic) do
      v:OnChangeCameraLod(lod)
    end
  end
end

function FlowerTrainGroupManager:OnDisplayModeUpdate()
  if self.flowerTrainItemDic then
    local displayLv = DisplaySettings.GetCurrentDisplayLevel()
    for _, v in pairs(self.flowerTrainItemDic) do
      v:OnDisplayModeUpdate(displayLv)
    end
  end
end

local function GetFlowerTrainItemDic(self)
  self.flowerTrainItemDic = {}
  return self.flowerTrainItemDic
end

local function GetLod(self)
  self.lod = CS.SceneManager.World:GetLodLevel()
  return self.lod
end

function FlowerTrainGroupManager:Update1000MS()
  self.lastSyncTime = UITimeManager:GetInstance():GetServerTime()
  if self.flowerTrainItemDic then
    for _, v in pairs(self.flowerTrainItemDic) do
      v:Update1000MS()
    end
  end
end

FlowerTrainGroupManager.getters.flowerTrainItemDic = GetFlowerTrainItemDic
FlowerTrainGroupManager.getters.lod = GetLod
return FlowerTrainGroupManager
