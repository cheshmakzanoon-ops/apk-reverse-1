local BaseBuildingDiscoManager = BaseClass("BaseBuildingDiscoManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local PrefabType = {
  DiscoEffect = "DiscoEffect",
  FireworkEffect = "FireworkEffect"
}
local PrefabPath = {
  [PrefabType.DiscoEffect] = "Assets/Main/SeasonRes/S4/Prefabs/Effect/Eff_S4_bengdi.prefab",
  [PrefabType.FireworkEffect] = "Assets/Main/Prefabs/UI/Act2025Halloween/Effect/Eff_ljw_2025wanshengjie_yanhua_Variant.prefab"
}

function BaseBuildingDiscoManager:__init()
  self.allEffect = {}
  self.effectShowMaxLod = 2
  self.effectShow = false
  self.effectTimers = {}
  self.displayLvLog = false
  self:AddListener()
end

function BaseBuildingDiscoManager:__delete()
  for k, v in pairs(self.allEffect) do
    for k1, v1 in pairs(v) do
      if v1 then
        if v1.request then
          v1.request:Destroy()
          v1.request = nil
        end
        if v1.timer then
          v1.timer:Stop()
          v1.timer = nil
        end
        v1.effectObj = nil
      end
    end
  end
  self:ClearTimers()
  self.displayLvLog = false
  self.effectShowMaxLod = nil
  self.effectShow = nil
  self.allEffect = nil
  self.effectTimers = nil
  self:RemoveListener()
end

function BaseBuildingDiscoManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function BaseBuildingDiscoManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
end

function BaseBuildingDiscoManager:RemoveBaseBuildEffect(bUuid, effectName)
  local data = self.allEffect[bUuid]
  if data ~= nil then
    if effectName then
      local effectData = data[effectName]
      if effectData then
        if effectData.request then
          effectData.request:Destroy()
          effectData.request = nil
        end
        if effectData.timer then
          effectData.timer:Stop()
          effectData.timer = nil
        end
        data[effectName] = nil
      end
    else
      for i, v in pairs(data) do
        if v then
          if v.request then
            v.request:Destroy()
            v.request = nil
          end
          if v.timer then
            v.timer:Stop()
            v.timer = nil
          end
          data[i] = nil
        end
      end
    end
  end
  if self.bossEffectCtrl then
    self.bossEffectCtrl:RemoveBaseEffect(bUuid)
  end
end

local function LoadInstantiateAsync(item, prefabName)
  local request = ResourceManager:InstantiateAsync(prefabName)
  item.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    if not IsNull(CS.SceneManager.World) then
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    end
    local pos = SceneUtils.TileIndexToWorld(item.pointIndex, ForceChangeScene.World, LuaEntry.Player.serverId)
    request.gameObject.transform.position = pos
    item.effectObj = request.gameObject
  end)
end

function BaseBuildingDiscoManager:AddBaseBuildEffect(bUuid, pointIndex, effectName)
  local prefabName = effectName
  local data = self.allEffect[bUuid]
  if not data then
    data = {}
    self.allEffect[bUuid] = data
  end
  local currentLod = DisplaySettings.currentLod
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if displayLv < 0 then
    if not self.displayLvLog then
      Logger.LogWarning("BaseBuildingDiscoManager AddBaseBuildEffect displayLvLog < 0")
      self.displayLvLog = true
    end
  elseif currentLod <= self.effectShowMaxLod then
    if not data[prefabName] then
      local tItem = {}
      tItem.pointIndex = pointIndex
      data[prefabName] = tItem
      LoadInstantiateAsync(tItem, prefabName)
    end
  elseif not data[prefabName] then
    local tItem = {}
    tItem.request = nil
    tItem.pointIndex = pointIndex
    data[prefabName] = tItem
  end
  if effectName == PrefabPath[PrefabType.DiscoEffect] then
    CS.LightDataManager.GetInstance():AddDiscoLight(pointIndex)
  end
end

function BaseBuildingDiscoManager:OnCameraChangeLod(lod)
  local show = lod <= self.effectShowMaxLod
  if show ~= self.effectShow then
    self.effectShow = show
    if self.allEffect ~= nil then
      for k, v in pairs(self.allEffect) do
        for k1, v1 in pairs(v) do
          if v1 and not IsNull(v1.effectObj) then
            v1.effectObj:SetActive(show)
          end
          if show and v1.request == nil then
            LoadInstantiateAsync(v1, k1)
          end
        end
      end
    end
  end
end

function BaseBuildingDiscoManager:DeleteAllEffect()
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      for k1, v1 in pairs(v) do
        if v1 then
          if v1.request then
            v1.request:Destroy()
            v1.request = nil
          end
          if v1.timer then
            v1.timer:Stop()
            v1.timer = nil
          end
          v1.ownerUid = nil
          v1.effectObj = nil
        end
      end
    end
  end
  self:ClearTimers()
  self.allEffect = {}
  self.effectTimers = {}
end

local function CheckSelectEffectIsShow(self, uuid, prefabName)
  local data = uuid and self.allEffect and self.allEffect[uuid]
  if data and data[prefabName] then
    return true
  end
  return false
end

local function AddDiscoBuildEffectTimer(self, buildingUuid, pointId, delay)
  self:RemoveTimer(buildingUuid, PrefabType.DiscoEffect)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:RemoveBaseBuildEffect(buildingUuid, PrefabPath[PrefabType.DiscoEffect])
    CS.LightDataManager.GetInstance():RemoveDiscoLight(pointId)
    self:RemoveTimer(buildingUuid, PrefabType.DiscoEffect)
  end, delay)
  self:AddEffectTimer(buildingUuid, PrefabType.DiscoEffect, timer)
end

function BaseBuildingDiscoManager:AddDiscoBuildEffect(buildingUuid, pointId, endTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delay = endTime - curTime
  delay = delay / 1000
  if 0 < delay then
    if self:CheckSelectEffectIsShow(buildingUuid, PrefabPath[PrefabType.DiscoEffect]) then
      return
    end
    self:AddBaseBuildEffect(buildingUuid, pointId, PrefabPath[PrefabType.DiscoEffect])
    AddDiscoBuildEffectTimer(self, buildingUuid, pointId, delay)
    return
  end
end

function BaseBuildingDiscoManager:AddFireworkEffect(buildingUuid, pointId, endTime)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delay = endTime - curTime
  delay = delay / 1000
  if 0 < delay then
    if self:CheckSelectEffectIsShow(buildingUuid, PrefabPath[PrefabType.FireworkEffect]) then
      return
    end
    self:AddBaseBuildEffect(buildingUuid, pointId, PrefabPath[PrefabType.FireworkEffect])
    self:AddEffectTimerByType(PrefabType.FireworkEffect, buildingUuid, pointId, delay)
    return
  end
end

function BaseBuildingDiscoManager:AddEffectTimerByType(prefabType, buildingUuid, pointId, delay)
  self:RemoveTimer(buildingUuid, prefabType)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    self:RemoveBaseBuildEffect(buildingUuid, PrefabPath[prefabType])
    self:RemoveTimer(buildingUuid, prefabType)
  end, delay)
  self:AddEffectTimer(buildingUuid, prefabType, timer)
end

local function ChangeCameraLodSignal(lod)
  BaseBuildingDiscoManager:GetInstance():OnCameraChangeLod(lod)
end

local function AddEffectTimer(self, uuid, prefabName, timer)
  if uuid == nil or string.IsNullOrEmpty(prefabName) or timer == nil then
    return
  end
  if not self.effectTimers then
    self.effectTimers = {
      [uuid] = {
        [prefabName] = timer
      }
    }
  elseif not self.effectTimers[uuid] then
    self.effectTimers[uuid] = {
      [prefabName] = timer
    }
  elseif not self.effectTimers[uuid][prefabName] then
    self.effectTimers[uuid][prefabName] = timer
  else
    self.effectTimers[uuid][prefabName]:Stop()
    self.effectTimers[uuid][prefabName] = timer
  end
end

local function RemoveTimer(self, uuid, key)
  if self.effectTimers and uuid and key and self.effectTimers[uuid] and self.effectTimers[uuid][key] then
    self.effectTimers[uuid][key]:Stop()
    self.effectTimers[uuid][key] = nil
  end
end

local function ClearTimers(self)
  if self.effectTimers then
    for i, v in pairs(self.effectTimers) do
      if v then
        for k, v1 in pairs(v) do
          if v1 then
            v1:Stop()
            self.effectTimers[i][k] = nil
          end
        end
      end
    end
  end
end

BaseBuildingDiscoManager.ChangeCameraLodSignal = ChangeCameraLodSignal
BaseBuildingDiscoManager.InstantiateAsync = InstantiateAsync
BaseBuildingDiscoManager.InstanceEffect = InstanceEffect
BaseBuildingDiscoManager.AddEffectTimer = AddEffectTimer
BaseBuildingDiscoManager.RemoveTimer = RemoveTimer
BaseBuildingDiscoManager.CheckSelectEffectIsShow = CheckSelectEffectIsShow
BaseBuildingDiscoManager.RemoveTween = RemoveTween
BaseBuildingDiscoManager.ClearTimers = ClearTimers
return BaseBuildingDiscoManager
