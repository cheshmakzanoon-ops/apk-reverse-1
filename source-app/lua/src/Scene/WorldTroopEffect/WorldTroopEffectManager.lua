local WorldTroopEffectManager = BaseClass("WorldTroopEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource

function WorldTroopEffectManager:__init()
  self.allEffect = {}
  self.startMarchEff = {}
  self.effectShowMaxLod = 2
  self.effectShow = false
  self:AddListener()
end

function WorldTroopEffectManager:__delete()
  for k, v in pairs(self.allEffect) do
    for k1, v1 in pairs(v) do
      v1.request:Destroy()
      v1.effectObj = nil
    end
  end
  self.effectShowMaxLod = nil
  self.effectShow = nil
  self.allEffect = nil
  self:RemoveListener()
  for _, v in pairs(self.startMarchEff) do
    v:Destroy()
  end
  self.startMarchEff = nil
end

function WorldTroopEffectManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.WorldTroopGameObjectCreateFinish, self.BuildInViewSignal)
  EventManager:GetInstance():AddListener(EventId.WorldTroopGameObjectDestroy, self.BuildOutViewSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceWarDataChange, self.AllianceWarDataChange)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():AddListener(EventId.AllianceWarDataInit, self.AllianceWarDataInit)
  EventManager:GetInstance():AddListener(EventId.TroopPositionChange, self.TroopPositionChange)
  EventManager:GetInstance():AddListener(EventId.StartMarch, self.ShowStartMarchEffect)
end

function WorldTroopEffectManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.WorldTroopGameObjectCreateFinish, self.BuildInViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.WorldTroopGameObjectDestroy, self.BuildOutViewSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceWarDataChange, self.AllianceWarDataChange)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.ChangeCameraLodSignal)
  EventManager:GetInstance():RemoveListener(EventId.AllianceWarDataInit, self.AllianceWarDataInit)
  EventManager:GetInstance():RemoveListener(EventId.TroopPositionChange, self.TroopPositionChange)
  EventManager:GetInstance():RemoveListener(EventId.StartMarch, self.ShowStartMarchEffect)
end

function WorldTroopEffectManager:CheckShowEffect(bUuid)
  if CS.SceneManager.World == nil then
    return
  end
  local info = CS.SceneManager.World:GetTroop(bUuid)
  if info ~= nil then
    local warUuid = DataCenter.AllianceWarDataManager:GetPlayerLeaderWar(bUuid)
    if warUuid then
      local worldPos = info:GetPosition()
      self:AddEffect(bUuid, worldPos, UIAssets.LWFocusEffect)
    end
  end
end

function WorldTroopEffectManager:AddEffect(bUuid, pos, effectName)
  local prefabName = effectName
  local data = self.allEffect[bUuid]
  if not data then
    data = {}
    self.allEffect[bUuid] = data
  end
  if data then
    local tData = data[prefabName]
    if not tData then
      local tItem = {}
      local request = ResourceManager:InstantiateAsync(prefabName)
      tItem.request = request
      data[prefabName] = tItem
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        if CS.SceneManager.World ~= nil then
          local info = CS.SceneManager.World:GetTroop(bUuid)
          if info then
            pos = info:GetPosition()
          else
            request:Destroy()
            if data and data[prefabName] then
              data[prefabName] = nil
            end
            Logger.LogError("WorldTroopEffectManager AddEffect, trooop info is nil")
            return
          end
        end
        request.gameObject.transform.position = pos
        tItem.effectObj = request.gameObject
      end)
    elseif tData.effectObj and tData.effectObj.transform then
      tData.effectObj.transform.position = pos
    end
  end
end

function WorldTroopEffectManager:RemoveEffect(bUuid, effectName)
  local data = self.allEffect[bUuid]
  if data ~= nil then
    if effectName then
      local effectData = data[effectName]
      if effectData then
        effectData.request:Destroy()
        data[effectName] = nil
        if table.count(data) == 0 then
          self.allEffect[bUuid] = nil
        end
      end
    else
      for i, v in pairs(data) do
        v.request:Destroy()
      end
      self.allEffect[bUuid] = nil
    end
  end
end

function WorldTroopEffectManager:CheckMonsterFocus(data)
  if data.update then
    self:CheckShowEffect(data.targetUuid)
  else
    self:RemoveEffect(data.targetUuid)
  end
end

function WorldTroopEffectManager:OnCameraChangeLod(lod)
  local show = lod <= self.effectShowMaxLod
  if show ~= self.effectShow then
    self.effectShow = show
    if self.allEffect ~= nil then
      for k, v in pairs(self.allEffect) do
        for k1, v1 in pairs(v) do
          if v1.effectObj then
            v1.effectObj:SetActive(show)
          end
        end
      end
    end
  end
end

function WorldTroopEffectManager:DeleteAllEffect()
  if self.allEffect then
    for k, v in pairs(self.allEffect) do
      for k1, v1 in pairs(v) do
        v1.request:Destroy()
        v1.effectObj = nil
      end
    end
  end
  self.allEffect = {}
end

function WorldTroopEffectManager:ChangeEffectPos(uuid)
  if CS.SceneManager.World == nil then
    return
  end
  local data = self.allEffect[uuid]
  if data ~= nil then
    local effectData = data[UIAssets.LWFocusEffect]
    if effectData then
      local info = CS.SceneManager.World:GetTroop(uuid)
      if info and not IsNull(effectData.request.gameObject) then
        local worldPos = info:GetPosition()
        effectData.request.gameObject.transform.position = worldPos
      end
    end
  end
end

function WorldTroopEffectManager:ShowStartMarchEff(param)
  local effectPath = param.effectPath
  local worldPos = param.worldPos
  if self.startMarchEff[effectPath] then
    local req = self.startMarchEff[effectPath]
    if not IsNull(req.gameObject) then
      req.gameObject:SetActive(true)
      req.gameObject.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    end
  else
    self.startMarchEff[effectPath] = ResourceManager:InstantiateAsync(effectPath)
    self.startMarchEff[effectPath]:completed("+", function(request)
      if IsNull(request.gameObject) then
        return
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      request.gameObject.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    end)
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self.startMarchEff and self.startMarchEff[effectPath] then
      local req = self.startMarchEff[effectPath]
      if not IsNull(req.gameObject) then
        req.gameObject:SetActive(false)
      end
    end
  end, 1)
end

local function BuildInViewSignal(uuid)
  WorldTroopEffectManager:GetInstance():CheckShowEffect(tonumber(uuid))
end

local function BuildOutViewSignal(uuid)
  WorldTroopEffectManager:GetInstance():RemoveEffect(tonumber(uuid))
end

local function AllianceWarDataChange(data)
  WorldTroopEffectManager:GetInstance():CheckMonsterFocus(data)
end

local function ChangeCameraLodSignal(lod)
  WorldTroopEffectManager:GetInstance():OnCameraChangeLod(lod)
end

local function AllianceWarDataInit(lod)
  WorldTroopEffectManager:GetInstance():DeleteAllEffect(lod)
end

local function TroopPositionChange(uuid)
  WorldTroopEffectManager:GetInstance():ChangeEffectPos(uuid)
end

local function ShowStartMarchEffect(param)
  WorldTroopEffectManager:GetInstance():ShowStartMarchEff(param)
end

WorldTroopEffectManager.BuildInViewSignal = BuildInViewSignal
WorldTroopEffectManager.BuildOutViewSignal = BuildOutViewSignal
WorldTroopEffectManager.AllianceWarDataChange = AllianceWarDataChange
WorldTroopEffectManager.ChangeCameraLodSignal = ChangeCameraLodSignal
WorldTroopEffectManager.AllianceWarDataInit = AllianceWarDataInit
WorldTroopEffectManager.TroopPositionChange = TroopPositionChange
WorldTroopEffectManager.ShowStartMarchEffect = ShowStartMarchEffect
return WorldTroopEffectManager
