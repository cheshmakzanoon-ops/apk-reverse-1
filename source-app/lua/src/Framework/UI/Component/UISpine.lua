local UISpine = BaseClass("UISpine", UIBaseContainer)
local base = UIBaseContainer
local ResourceManager = CS.GameEntry.Resource
local CSSkeletonGraphic = typeof(CS.Spine.Unity.SkeletonGraphic)
local CSSkeletonUtility = typeof(CS.Spine.Unity.SkeletonUtility)

local function OnCreate(self)
  base.OnCreate(self)
  self.skeletonGraphic = self.gameObject:GetComponent(CSSkeletonGraphic)
  if self.skeletonGraphic then
    self.animationState = self.skeletonGraphic.AnimationState
    self.SkeletonUtility = self.gameObject:GetComponent(CSSkeletonUtility)
  end
  self.__handleCustomEvent = nil
  self.__handleCompleteEvent = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
  if self.req then
    self.skeletonGraphic.skeletonDataAsset = nil
    self.req:Release()
    self.req = nil
  end
  if self.animationState then
    if self.__handleCustomEvent then
      self.animationState:Event("-", self.__handleCustomEvent)
    end
    if self.__handleCompleteEvent then
      self.animationState:Complete("-", self.__handleCompleteEvent)
    end
  end
  self.__handleCustomEvent = nil
  self.__handleCompleteEvent = nil
  self.animationState = nil
  self.skeletonGraphic = nil
end

local function SetCustomEvent(self, action)
  if action then
    if self.__handleCustomEvent then
      self.animationState:Event("-", self.__handleCustomEvent)
    end
    self.__handleCustomEvent = action
    self.animationState:Event("+", self.__handleCustomEvent)
  elseif self.__handleCustomEvent then
    self.animationState:Event("-", self.__handleCustomEvent)
    self.__handleCustomEvent = nil
  end
end

local function SetCompleteEvent(self, action)
  if action then
    if self.__handleCompleteEvent then
      self.animationState:Complete("-", self.__handleCompleteEvent)
    end
    self.__handleCompleteEvent = action
    self.animationState:Complete("+", self.__handleCompleteEvent)
  elseif self.__handleCompleteEvent then
    self.animationState:Complete("-", self.__handleCompleteEvent)
    self.__handleCompleteEvent = nil
  end
end

local function SetAnimation(self, trackIndex, animationName, loop)
  if self.animationState then
    self.animationState:SetAnimation(trackIndex, animationName, loop)
  end
end

local function ClearTracks(self)
  if self.animationState then
    self.animationState:ClearTracks()
  end
end

local function JumpToEnd(self)
  if self.animationState then
    local trackEntry = self.animationState:GetCurrent(0)
    if trackEntry ~= nil then
      trackEntry.TrackTime = trackEntry.AnimationEnd
      self.animationState:Update(0)
      self.skeletonGraphic:Update(0)
    end
  end
end

local function JumpToStart(self)
  if self.animationState then
    local trackEntry = self.animationState:GetCurrent(0)
    if trackEntry ~= nil then
      trackEntry.TrackTime = trackEntry.AnimationStart
      self.animationState:Update(0)
      self.skeletonGraphic:Update(0)
    end
  end
end

local function IsComplete(self)
  local isComplete = true
  if self.animationState then
    local trackEntry = self.animationState:GetCurrent(0)
    if trackEntry ~= nil and not trackEntry.IsComplete then
      isComplete = false
    end
  end
  return isComplete
end

local function GetBoneTransByName(self, name)
  if self.SkeletonUtility and self.SkeletonUtility.boneComponents then
    for key, value in pairs(self.SkeletonUtility.boneComponents) do
      if value.name == name then
        return value.transform
      end
    end
  end
  return nil
end

local function GetAnimationStateName(self)
  if self.animationState then
    local track = self.animationState:GetCurrent(0)
    if track then
      return track.Animation.Name
    end
  end
  return ""
end

local function GetAnimationDuration(self, animName)
  if self.animationState and not string.IsNullOrEmpty(animName) then
    local skeletonData = self.animationState.Data.SkeletonData
    if skeletonData then
      local animation = skeletonData:FindAnimation(animName)
      if animation then
        return animation.Duration
      end
    end
  end
  return 0
end

local function LoadSkeletonDataAsset(self, skeletonDataName, callback)
  if self.skeletonGraphic and not string.IsNullOrEmpty(skeletonDataName) then
    local assetName = PathUtil.GetFileNameWithoutExtension(skeletonDataName)
    if IsNotNull(self.skeletonGraphic.SkeletonDataAsset) and self.skeletonGraphic.SkeletonDataAsset.name == assetName then
      if callback and type(callback) == "function" then
        CommonUtil.ProtectCall(callback)
      end
    else
      if self.req then
        self.req:Release()
        self.req = nil
      end
      self.req = ResourceManager:LoadAssetAsync(skeletonDataName, typeof(CS.Spine.Unity.SkeletonDataAsset))
      if self.req ~= nil then
        function self.req.completed()
          if self.req == nil then
            return
          end
          if self.req.isError then
            Logger.LogError("LoadSkeletonDataAsset Error err:", tostring(self.req.isError))
            return
          end
          local anim = self.req.asset
          cast(anim, typeof(CS.Spine.Unity.SkeletonDataAsset))
          self.skeletonGraphic.skeletonDataAsset = self.req.asset
          self.skeletonGraphic:Initialize(true)
          self.skeletonGraphic = self.gameObject:GetComponent(CSSkeletonGraphic)
          if self.skeletonGraphic then
            self.animationState = self.skeletonGraphic.AnimationState
            self.SkeletonUtility = self.gameObject:GetComponent(CSSkeletonUtility)
          end
          self.__handleCustomEvent = nil
          self.__handleCompleteEvent = nil
          if callback and type(callback) == "function" then
            CommonUtil.ProtectCall(callback)
          end
        end
      end
    end
  end
end

local function SetEmptyAnimation(self, trackIndex, time)
  if self.animationState then
    self.animationState:SetEmptyAnimation(trackIndex, time)
  end
end

local function HasAnimation(animationState, animName)
  if animationState and not string.IsNullOrEmpty(animName) then
    local skeletonData = animationState.Data.SkeletonData
    if skeletonData then
      local animation = skeletonData:FindAnimation(animName)
      return animation ~= nil
    end
  end
  return false
end

UISpine.OnCreate = OnCreate
UISpine.OnEnable = OnEnable
UISpine.OnDisable = OnDisable
UISpine.OnDestroy = OnDestroy
UISpine.SetAnimation = SetAnimation
UISpine.ClearTracks = ClearTracks
UISpine.JumpToEnd = JumpToEnd
UISpine.JumpToStart = JumpToStart
UISpine.SetCustomEvent = SetCustomEvent
UISpine.SetCompleteEvent = SetCompleteEvent
UISpine.IsComplete = IsComplete
UISpine.GetBoneTransByName = GetBoneTransByName
UISpine.GetAnimationStateName = GetAnimationStateName
UISpine.GetAnimationDuration = GetAnimationDuration
UISpine.LoadSkeletonDataAsset = LoadSkeletonDataAsset
UISpine.SetEmptyAnimation = SetEmptyAnimation
UISpine.HasAnimation = HasAnimation
return UISpine
