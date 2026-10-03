local DominatorTrainSceneIdleMember = BaseClass("DominatorTrainSceneIdleMember")
local ResourceManager = CS.GameEntry.Resource
local Const = require("DataCenter/Dominator/Train/DominatorTrainSceneConstant")

function DominatorTrainSceneIdleMember:__init()
  self.modelPath = nil
  self.worldPos = nil
  self.upgradeEffectDict = nil
  self.upgradeEffectReqDict = nil
end

function DominatorTrainSceneIdleMember:__delete()
  self:Destroy()
end

function DominatorTrainSceneIdleMember:Init(modelPath, worldPos, defaultAnim)
  self.modelPath = modelPath
  self.worldPos = worldPos
  self.upgradeEffectDict = {}
  self.upgradeEffectReqDict = {}
  self:LoadModel(defaultAnim)
end

function DominatorTrainSceneIdleMember:Destroy()
  self:ClearCurDelayPlayAnimTimer()
  self:ReleaseModel()
end

function DominatorTrainSceneIdleMember:ReleaseModel()
  self.model = nil
  self.modelAnim = nil
  self.animHelper = nil
  self.modelPath = nil
  self.isModelLoaded = false
  if self.modelRequest ~= nil then
    self.modelRequest:Destroy()
    self.modelRequest = nil
  end
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
    self.effectRequest = nil
  end
  self.upgradeEffectDict = nil
  if self.upgradeEffectReqDict then
    for i, v in pairs(self.upgradeEffectReqDict) do
      v:Destroy()
    end
    self.upgradeEffectReqDict = nil
  end
end

function DominatorTrainSceneIdleMember:LoadModel(defaultAnim)
  if string.IsNullOrEmpty(self.modelPath) then
    return
  end
  local request = ResourceManager:InstantiateAsync(self.modelPath)
  self.modelRequest = request
  request:completed("+", function()
    if request.isError then
      DataCenter.DominatorManager:PrintRealErrorLog("train template model load error , " .. self.modelPath .. ", Error:" .. request.error)
      return
    end
    self.isModelLoaded = true
    request.gameObject.transform.position = self.worldPos
    request.gameObject.transform:Set_localEulerAngles(Const.DominatorIdleAngle:Split())
    self.model = request.gameObject
    self.model:SetActive(true)
    local animHelper = self.model:GetComponentInChildren(typeof(CS.DominatorTrainSceneIdleModelAnimHelper), true)
    self.animHelper = animHelper
    if IsNotNull(self.animHelper) then
      self.animHelper:Init()
      local anim = self.animHelper:GetMainAnim()
      self.modelAnim = anim
    end
    if defaultAnim then
      self:PlayModelAnimImmediately(defaultAnim)
    end
  end)
  local requestEffect = ResourceManager:InstantiateAsync(Const.DominatorIdleEffectAssetPath)
  self.effectRequest = requestEffect
  requestEffect:completed("+", function()
    if requestEffect.isError then
      DataCenter.DominatorManager:PrintRealErrorLog("train template effect load error , " .. Const.DominatorIdleEffectAssetPath .. ", Error:" .. requestEffect.error)
      return
    end
    requestEffect.gameObject.transform.position = self.worldPos
    requestEffect.gameObject.transform:Set_localScale(Const.DominatorIdleEffectScale:Split())
    self.idleEffect = requestEffect.gameObject
  end)
end

function DominatorTrainSceneIdleMember:GetModelAnimClipLength(anim)
  if not IsNull(self.modelAnim) then
    return self.modelAnim:GetClipLength(anim)
  end
end

function DominatorTrainSceneIdleMember:IsPlayingModelAnim(anim)
  if not IsNull(self.modelAnim) then
    return self.modelAnim:IsPlaying(anim)
  end
  return false
end

function DominatorTrainSceneIdleMember:PlayModelAnimQueue(animImmediately, animLater)
  self:PlayModelAnimImmediately(animImmediately)
  self:ClearCurDelayPlayAnimTimer()
  local animLength = self:GetModelAnimClipLength(animImmediately)
  if animLength then
    self.delayPlayAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:PlayModelAnimImmediately(animLater)
    end, animLength)
  end
end

function DominatorTrainSceneIdleMember:ClearCurDelayPlayAnimTimer()
  if self.delayPlayAnimTimer then
    self.delayPlayAnimTimer:Stop()
    self.delayPlayAnimTimer = nil
  end
end

function DominatorTrainSceneIdleMember:PlayModelAnimImmediately(anim)
  if not IsNull(self.animHelper) then
    self.animHelper:Play(anim)
  end
end

function DominatorTrainSceneIdleMember:PlayUpgradeEffect(trainGroupId)
  if self.upgradeEffectDict == nil or self.upgradeEffectReqDict == nil then
    return
  end
  local trainGroupIdStr = tostring(trainGroupId)
  if self.upgradeEffectDict[trainGroupIdStr] == nil and self.upgradeEffectReqDict[trainGroupIdStr] == nil then
    local path = Const.UpgradeEffectAssetPathDict[trainGroupId]
    if path then
      do
        local requestEffect = ResourceManager:InstantiateAsync(path)
        self.upgradeEffectReqDict[trainGroupId] = requestEffect
        requestEffect:completed("+", function()
          if requestEffect.isError then
            DataCenter.DominatorManager:PrintRealErrorLog("train template upgrade effect load error , " .. path .. ", Error:" .. requestEffect.error)
            return
          end
          requestEffect.gameObject.transform.position = self.worldPos
          local scale = Const.UpgradeEffectScaleDict[trainGroupId]
          if scale then
            requestEffect.gameObject.transform:Set_localScale(scale:Split())
          end
          if self.upgradeEffectDict then
            self.upgradeEffectDict[trainGroupIdStr] = requestEffect.gameObject
          end
        end)
      end
    end
  elseif self.upgradeEffectDict[trainGroupIdStr] ~= nil then
    self.upgradeEffectDict[trainGroupIdStr]:SetActive(false)
    self.upgradeEffectDict[trainGroupIdStr]:SetActive(true)
  end
end

function DominatorTrainSceneIdleMember:PlayIdleEffect()
  if IsNotNull(self.idleEffect) then
    self.idleEffect:SetActive(false)
    self.idleEffect:SetActive(true)
  end
end

return DominatorTrainSceneIdleMember
