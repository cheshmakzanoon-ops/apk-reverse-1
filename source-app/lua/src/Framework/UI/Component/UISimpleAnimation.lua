local UISimpleAnimation = BaseClass("UISimpleAnimation", UIBaseContainer)
local base = UIBaseContainer
local SimpleAnimation = typeof(CS.SimpleAnimation)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.simpleAnimation = self.gameObject:GetComponent(SimpleAnimation)
end

local function OnDestroy(self)
  self.simpleAnimation = nil
  base.OnDestroy(self)
end

local function Play(self, name)
  self.simpleAnimation:Play(name)
end

local function PlayQueued(self, name)
  self.simpleAnimation:PlayQueued(name)
end

local function Rewind(self, name)
  self.simpleAnimation:Rewind(name)
end

local function Enable(self, value)
  self.simpleAnimation.enabled = value
end

local function PlayAnimationReturnTime(self, animName)
  local anim = self.simpleAnimation:GetState(animName)
  if anim == nil then
    return false
  end
  self.simpleAnimation:Play(animName)
  return true, self.simpleAnimation:GetClipLength(animName)
end

local function GetAnimationReturnTime(self, animName)
  local anim = self.simpleAnimation:GetState(animName)
  if anim == nil then
    return false
  end
  return true, self.simpleAnimation:GetClipLength(animName)
end

local function IsPlaying(self, animName)
  local anim = self.simpleAnimation:GetState(animName)
  if anim == nil then
    return false
  end
  return self.simpleAnimation:IsPlaying(animName)
end

local function Stop(self)
  self.simpleAnimation:Stop()
end

local function SampleAnimationAtTime(self, animName, time)
  local anim = self.simpleAnimation:GetState(animName)
  if anim == nil then
    return false
  end
  return self.simpleAnimation:SampleAnimationAtTime(animName, time)
end

local function SetStateSpeed(self, animName, speed)
  self.simpleAnimation:SetStateSpeed(animName, speed)
end

UISimpleAnimation.OnCreate = OnCreate
UISimpleAnimation.OnDestroy = OnDestroy
UISimpleAnimation.Play = Play
UISimpleAnimation.PlayQueued = PlayQueued
UISimpleAnimation.Rewind = Rewind
UISimpleAnimation.Enable = Enable
UISimpleAnimation.PlayAnimationReturnTime = PlayAnimationReturnTime
UISimpleAnimation.GetAnimationReturnTime = GetAnimationReturnTime
UISimpleAnimation.IsPlaying = IsPlaying
UISimpleAnimation.Stop = Stop
UISimpleAnimation.SampleAnimationAtTime = SampleAnimationAtTime
UISimpleAnimation.SetStateSpeed = SetStateSpeed
return UISimpleAnimation
