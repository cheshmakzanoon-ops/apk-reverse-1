local WorldDesertSelectEffectManager = BaseClass("WorldDesertSelectEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local WaitTime = 2.5
local ModelPathList = {}

function WorldDesertSelectEffectManager:__init()
  self:AddListener()
  self.effectInstance = nil
  self.timerList = {}
  self.effectList = {}
  ModelPathList[1] = "Assets/Main/Prefabs/CityScene/WorldDesertEffectSelf.prefab"
  ModelPathList[3] = "Assets/Main/Prefabs/CityScene/WorldDesertEffectAllianceBuild.prefab"
  ModelPathList[5] = "Assets/Main/Prefabs/CityScene/WorldDesertCityEffectScene5.prefab"
  ModelPathList[7] = "Assets/Main/Prefabs/CityScene/WorldDesertCityEffectScene7.prefab"
end

function WorldDesertSelectEffectManager:__delete()
  self:RemoveListener()
  self:RemoveAllEffect()
end

function WorldDesertSelectEffectManager.RemoveAllTips()
  WorldDesertSelectEffectManager:GetInstance():RemoveAllEffect()
end

function WorldDesertSelectEffectManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, WorldDesertSelectEffectManager.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, WorldDesertSelectEffectManager.RemoveAllTips)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, WorldDesertSelectEffectManager.RemoveAllTips)
end

function WorldDesertSelectEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, WorldDesertSelectEffectManager.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, WorldDesertSelectEffectManager.RemoveAllTips)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, WorldDesertSelectEffectManager.RemoveAllTips)
end

function WorldDesertSelectEffectManager:ShowPos(pointId)
  if self.effectInstance ~= nil then
    if self.effectInstance.gameObject ~= nil then
      self.effectInstance.gameObject:SetActive(true)
      self.effectInstance.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
    end
  else
    local pointIndex = pointId
    local request = ResourceManager:InstantiateAsync(UIAssets.BuildBlock)
    self.effectInstance = request
    request:completed("+", function()
      if request.isError then
        self.effectInstance = nil
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World)
    end)
  end
end

function WorldDesertSelectEffectManager:HidePos()
  if self.effectInstance ~= nil and self.effectInstance.gameObject ~= nil then
    self.effectInstance.gameObject:SetActive(false)
  end
end

function WorldDesertSelectEffectManager:RemoveEffect()
  if self.effectInstance ~= nil then
    self.effectInstance:Destroy()
    self.effectInstance = nil
  end
end

function WorldDesertSelectEffectManager:RemoveAllEffect()
  if self.timerList then
    for _, timer in ipairs(self.timerList) do
      if timer ~= nil then
        timer:Stop()
        timer = nil
      end
    end
    self.timerList = {}
  end
  if self.effectList then
    for _, effectInstance in ipairs(self.effectList) do
      if effectInstance ~= nil then
        effectInstance:Destroy()
        effectInstance = nil
      end
    end
    self.effectList = {}
  end
  self:RemoveEffect()
end

function WorldDesertSelectEffectManager:RemoveWarnEffect(tileSize)
  local effectWarnInstance = self.effectList[tileSize]
  if effectWarnInstance ~= nil then
    effectWarnInstance:Destroy()
    effectWarnInstance = nil
    self.effectList[tileSize] = nil
  end
end

function WorldDesertSelectEffectManager:ResetTime(tileSize)
  local timer = self.timerList[tileSize]
  if timer ~= nil then
    timer:Stop()
    timer = nil
  end
  self.timerList[tileSize] = TimerManager:GetInstance():DelayInvoke(function()
    self.timerList[tileSize] = nil
    self:RemoveWarnEffect(tileSize)
  end, WaitTime)
end

function WorldDesertSelectEffectManager:ShowWarnPos(pointId, tileSize, offset)
  local effectWarnInstance = self.effectList[tileSize]
  if effectWarnInstance ~= nil then
    if effectWarnInstance.gameObject ~= nil then
      effectWarnInstance.gameObject:SetActive(true)
      effectWarnInstance.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      self:ResetTime(tileSize)
    end
  else
    local pointIndex = pointId
    local request = ResourceManager:InstantiateAsync(ModelPathList[tileSize])
    request:completed("+", function()
      if request.isError then
        self.effectList[tileSize] = nil
        return
      end
      local offsetPos
      if offset == nil then
        offsetPos = Vector3.New(tileSize - 1, 0, tileSize - 1)
      else
        offsetPos = Vector3.New(offset, 0, offset)
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointIndex, ForceChangeScene.World) + offsetPos
      self:ResetTime(tileSize)
    end)
    self.effectList[tileSize] = request
  end
end

return WorldDesertSelectEffectManager
