local UIAnimator = BaseClass("UIAnimator", UIBaseContainer)
local base = UIBaseContainer
local UnityAnimator = typeof(CS.UnityEngine.Animator)
local ResourceManager = CS.GameEntry.Resource

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_animator = self.gameObject:GetComponent(UnityAnimator)
end

local function OnDestroy(self)
  if self.animControllerAsset then
    self.animControllerAsset:Release()
    self.animControllerAsset = nil
  end
  self.unity_animator = nil
  base.OnDestroy(self)
end

local function Play(self, name, layer, normalizedTime)
  if layer == nil then
    layer = 0
  end
  if normalizedTime == nil then
    normalizedTime = 0
  end
  if IsNotNull(self.unity_animator) and self.gameObject and self.unity_animator.enabled and self.gameObject.activeSelf and self.gameObject.activeInHierarchy then
    self.unity_animator:Play(name, layer, normalizedTime)
  end
end

local function Enable(self, value)
  if IsNotNull(self.unity_animator) then
    self.unity_animator.enabled = value
  end
end

local function SetBool(self, name, val)
  self.unity_animator:SetBool(name, val)
end

local function SetTrigger(self, name)
  if IsNotNull(self.unity_animator) then
    self.unity_animator:SetTrigger(name)
  end
end

local function ResetTrigger(self, name)
  if IsNotNull(self.unity_animator) then
    self.unity_animator:ResetTrigger(name)
  end
end

function UIAnimator:Rebind()
  if IsNotNull(self.unity_animator) then
    self.unity_animator:Rebind()
  end
end

local function PlayAnimationReturnTime(self, animName)
  local duration = 0
  if self.unity_animator and IsNotNull(self.unity_animator.runtimeAnimatorController) then
    local clips = self.unity_animator.runtimeAnimatorController.animationClips
    if IsNotNull(clips) then
      for i = 0, clips.Length - 1 do
        if string.endswith(clips[i].name, animName) then
          duration = clips[i].length
          self:Play(animName, 0, 0)
          return true, duration
        end
      end
    end
  end
  return false
end

local function GetFloat(self, name)
  return self.unity_animator:GetFloat(name)
end

local function GetAnimationReturnTime(self, animName)
  local duration = 0
  local clips = self.unity_animator.runtimeAnimatorController.animationClips
  for i = 0, clips.Length - 1 do
    if string.endswith(clips[i].name, animName) then
      duration = clips[i].length
      return true, duration
    end
  end
  return false
end

local function SetSpeed(self, speed)
  self.unity_animator.speed = speed
end

local function GetSpeed(self)
  return self.unity_animator.speed
end

local function SampleAnimationAtTime(self, animName, time)
  if self.unity_animator and self.unity_animator.runtimeAnimatorController then
    local clips = self.unity_animator.runtimeAnimatorController.animationClips
    for i = 0, clips.Length - 1 do
      if string.endswith(clips[i].name, animName) then
        local clip = clips[i]
        clip:SampleAnimation(self.gameObject, time)
        return true
      end
    end
  end
  return false
end

local function TryLoadAnimation(self, animPath, callback)
  if self.unity_animator ~= nil and self.unity_animator.runtimeAnimatorController == nil then
    self.animControllerAsset = ResourceManager:LoadAssetAsync(animPath, typeof(CS.UnityEngine.RuntimeAnimatorController))
    
    function self.animControllerAsset.completed(_)
      if self.animControllerAsset == nil then
        return
      end
      if IsNull(self.transform) or IsNull(self.unity_animator) then
        ResourceManager:UnloadAsset(self.animControllerAsset)
        self.animControllerAsset = nil
        return
      end
      local anim = self.animControllerAsset.asset
      cast(anim, typeof(CS.UnityEngine.RuntimeAnimatorController))
      self.unity_animator.runtimeAnimatorController = anim
      if callback and type(callback) == "function" then
        CommonUtil.ProtectCall(callback)
      end
    end
  elseif self.unity_animator ~= nil and self.unity_animator.runtimeAnimatorController ~= nil and callback and type(callback) == "function" then
    CommonUtil.ProtectCall(callback)
  end
end

function UIAnimator:CanUse()
  return IsNotNull(self.unity_animator) and self.unity_animator.runtimeAnimatorController ~= nil
end

UIAnimator.OnCreate = OnCreate
UIAnimator.OnDestroy = OnDestroy
UIAnimator.Play = Play
UIAnimator.Enable = Enable
UIAnimator.SetBool = SetBool
UIAnimator.PlayAnimationReturnTime = PlayAnimationReturnTime
UIAnimator.GetFloat = GetFloat
UIAnimator.GetAnimationReturnTime = GetAnimationReturnTime
UIAnimator.SetTrigger = SetTrigger
UIAnimator.ResetTrigger = ResetTrigger
UIAnimator.SetSpeed = SetSpeed
UIAnimator.GetSpeed = GetSpeed
UIAnimator.SampleAnimationAtTime = SampleAnimationAtTime
UIAnimator.TryLoadAnimation = TryLoadAnimation
return UIAnimator
