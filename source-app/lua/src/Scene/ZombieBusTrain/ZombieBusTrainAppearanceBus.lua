local ZombieBusTrainAppearanceBus = BaseClass("ZombieBusTrainAppearanceBus")
local ResourceManager = CS.GameEntry.Resource
local fireEffectPath = "Assets/Main/Prefabs/World/Eff_daditu_zhucheng_fire.prefab"
local explodeEffectPath = "Assets/Main/Prefabs/World/Eff_s_Dabache_leida_boom.prefab"
local defaultAnimName = "run"
local detectZombieBus = "detect_zombie_bus"

function ZombieBusTrainAppearanceBus:__init(busData, parent)
  self.parent = parent
  self.busData = busData
  self.fireEffects = {}
  self.busCfgId = busData.busId
  local prefabPath = LocalController:instance():getValue(detectZombieBus, self.busCfgId, "model_path")
  if prefabPath then
    self.busPrefabReq = ResourceManager:InstantiateAsync(prefabPath)
    self.busPrefabReq:completed("+", function()
      if self.busPrefabReq.isError then
        return
      end
      local go = self.busPrefabReq.gameObject
      go.transform:SetParent(self.parent)
      go.transform:Set_localRotation(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go:SetActive(true)
      self.gameObject = go
      self.transform = go.transform
      self:RefreshView()
    end)
  end
end

function ZombieBusTrainAppearanceBus:__delete()
  self.busCfgId = nil
  if self.busPrefabReq then
    self.busPrefabReq:Destroy()
  end
  self:ClearDelayPlayDeadTimer()
  for i, fireEffect in ipairs(self.fireEffects) do
    fireEffect:Destroy()
  end
  if self.explodeEffectReq then
    self.explodeEffectReq:Destroy()
  end
  self.fireEffects = nil
  self.gameObject = nil
  self.busPrefabReq = nil
  self.busData = nil
  self.parent = nil
  self.explodeEffectReq = nil
end

function ZombieBusTrainAppearanceBus:RefreshView()
  self.fireRoot = self.transform:Find("trainFire")
  self.animation = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self:PlayAnim(self.cacheAnimationName or defaultAnimName)
  self:RefreshBusFireEffects()
end

function ZombieBusTrainAppearanceBus:PlayAnim(animName)
  self.cacheAnimationName = animName
  if not self.animation then
    return
  end
  self.animation:ForceCleanAllQueuedStates()
  if animName == "run" then
    self.animation:Play(animName)
  elseif animName == "dead" then
    self.animation:CrossFade(animName, 0.1)
  elseif animName == "idle" then
    self.animation:Play(animName)
  elseif animName == "style" then
    self.animation:CrossFade(animName, 0.1)
    self.animation:CrossFadeQueued("run", 0.1, CS.UnityEngine.QueueMode.CompleteOthers)
  end
end

function ZombieBusTrainAppearanceBus:RefreshBusFireEffects()
  local isPass = self.busData.isPass == 1
  if self.isOnFire == isPass then
    return
  end
  if not self.fireParents then
    local childCount = self.transform.childCount
    self.fireParents = {}
    if 0 < childCount then
      for i = 0, childCount - 1 do
        table.insert(self.fireParents, self.transform:GetChild(i))
      end
    end
  end
  for i, fireEffect in ipairs(self.fireEffects) do
    if fireEffect and IsNotNull(fireEffect.gameObject) then
      fireEffect.gameObject:SetActive(isPass == true)
    end
  end
  if isPass == true and #self.fireEffects < #self.fireParents then
    for i = #self.fireEffects + 1, #self.fireParents do
      self:SetBusFireEffect(i)
    end
  end
  self.isOnFire = isPass
end

function ZombieBusTrainAppearanceBus:DoDelayDead(delayTime)
  self:ClearDelayPlayDeadTimer()
  self.delayPlayDeadTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayAnim("dead")
    self:SetBusExplodeEffect()
    self:ClearDelayPlayDeadTimer()
  end, delayTime)
  return 2.3 + delayTime
end

function ZombieBusTrainAppearanceBus:ClearDelayPlayDeadTimer()
  if self.delayPlayDeadTimer then
    self.delayPlayDeadTimer:Stop()
    self.delayPlayDeadTimer = nil
  end
end

function ZombieBusTrainAppearanceBus:SetBusFireEffect(firePointIndex)
  local fireParent = self.fireRoot:Find("fire" .. firePointIndex)
  local fireEffect = ResourceManager:InstantiateAsync(fireEffectPath)
  fireEffect:completed("+", function()
    if fireEffect.isError then
      return
    end
    local go = fireEffect.gameObject
    go.transform:SetParent(fireParent)
    go.transform:Set_localRotation(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
    go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    go:SetActive(self.isOnFire == true)
  end)
  self.fireEffects[firePointIndex] = fireEffect
end

function ZombieBusTrainAppearanceBus:SetBusExplodeEffect()
  if self.explodeEffectReq and IsNotNull(self.explodeEffectReq.gameObject) then
    self.explodeEffectReq.gameObject:SetActive(true)
    return
  end
  if not self.explodeEffectReq then
    local explodeEffectParent = self.transform
    local explodeEffectReq = ResourceManager:InstantiateAsync(explodeEffectPath)
    explodeEffectReq:completed("+", function()
      if explodeEffectReq.isError then
        return
      end
      local go = explodeEffectReq.gameObject
      go.transform:SetParent(explodeEffectParent)
      go.transform:Set_localRotation(ResetEulerAngles.x, ResetEulerAngles.y, ResetEulerAngles.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go:SetActive(true)
    end)
    self.explodeEffectReq = explodeEffectReq
  end
end

return ZombieBusTrainAppearanceBus
