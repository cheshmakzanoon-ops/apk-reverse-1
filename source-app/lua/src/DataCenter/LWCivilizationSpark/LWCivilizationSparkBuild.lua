local LWCivilizationSparkBuild = BaseClass("LWCivilizationSparkBuild")
local CSSkeletonAnimation = typeof(CS.Spine.Unity.SkeletonAnimation)
local lv_effect_path = "ModelGo/Normal/A_Build_ziyounvshen_s0/root/lv_effect_"
local lv_effect_fire_path = "ModelGo/Normal/A_Build_ziyounvshen_s0/lv_effect_fire"
local lv_effect_smoke_path = "ModelGo/Normal/A_Build_ziyounvshen_s0/lv_effect_smoke"

function LWCivilizationSparkBuild:__init()
  self.createShowInAnim = false
  self.lvEffects = nil
  self.lvEffectTimers = nil
  self.lvEffectFire = nil
  self.lvEffectSmoke = nil
  self.bUuid = nil
end

function LWCivilizationSparkBuild:__delete()
  self:Clear()
  self.createShowInAnim = nil
end

function LWCivilizationSparkBuild:BindGameObject(gameObject, level, bUuid)
  self.gameObject = gameObject
  self.bUuid = bUuid
  self.skeletonAnimation = self.gameObject:GetComponentInChildren(CSSkeletonAnimation)
  if self.skeletonAnimation then
    self.animationState = self.skeletonAnimation.state
  end
  if self.lvEffects == nil then
    self.lvEffects = {}
  end
  for i = 2, 6 do
    local obj = self.gameObject.transform:Find(lv_effect_path .. i)
    if obj then
      self.lvEffects[i] = obj.gameObject
    end
  end
  local fireTrans = self.gameObject.transform:Find(lv_effect_fire_path)
  if fireTrans then
    self.lvEffectFire = fireTrans.gameObject
  end
  local smokeTrans = self.gameObject.transform:Find(lv_effect_smoke_path)
  if smokeTrans then
    self.lvEffectSmoke = smokeTrans.gameObject
  end
  if self.createShowInAnim then
    self:PlayInAnim(level)
  else
    self:PlayLoopAnim(level)
  end
end

function LWCivilizationSparkBuild:Clear()
  self:ClearPer()
  if self.lvEffects then
    for _, v in pairs(self.lvEffects) do
      if IsNotNull(v) then
        v:SetActive(false)
      end
    end
    self.lvEffects = nil
  end
  if self.lvEffectTimers then
    for _, v in pairs(self.lvEffectTimers) do
      v:Stop()
    end
    self.lvEffectTimers = nil
  end
  if self.lvEffectFire then
    self.lvEffectFire:SetActive(false)
    self.lvEffectFire = nil
  end
  if self.lvEffectSmoke then
    self.lvEffectSmoke:SetActive(false)
    self.lvEffectSmoke = nil
  end
  if self.animationState and self.__handleCompleteEvent then
    self.animationState:Complete("-", self.__handleCompleteEvent)
  end
  self.__handleCompleteEvent = nil
  self.gameObject = nil
  self.bUuid = nil
  self.skeletonAnimation = nil
  self.animationState = nil
end

function LWCivilizationSparkBuild:PlayInAnim(level)
  if level <= 0 then
    return
  end
  local template = DataCenter.LWCivilizationSparkManager:GetTemplate(level)
  local delay = 0
  if template then
    delay = template.animationDelay
  end
  if self.gameObject then
    self.createShowInAnim = false
    self:PerInAnimStart(level, delay)
  else
    self.createShowInAnim = true
  end
end

function LWCivilizationSparkBuild:ClearPer()
  if self.inPer then
    if self.inAnimTimer then
      self.inAnimTimer:Stop()
      self.inAnimTimer = nil
    end
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
    DataCenter.BuildBubbleManager:ClearOneNoRefresh(self.bUuid)
    EventManager:GetInstance():Broadcast(EventId.ShowBuildDetail, self.bUuid)
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
    self.inPer = false
  end
end

function LWCivilizationSparkBuild:PlayLoopAnim(level)
  if level <= 0 then
    return
  end
  self.createShowInAnim = false
  if self.gameObject then
    self:SetAnimation("lv" .. level .. "_loop", true)
  end
end

function LWCivilizationSparkBuild:PlayLvEffect(level)
  if self.lvEffects and self.lvEffects[level] then
    self.lvEffects[level]:SetActive(true)
    if self.lvEffectFire then
      self.lvEffectFire:SetActive(true)
    end
    if self.lvEffectTimers == nil then
      self.lvEffectTimers = {}
    end
    local timer = self.lvEffectTimers[level]
    if timer then
      timer:Stop()
    end
    self.lvEffectTimers[level] = TimerManager:GetInstance():DelayInvoke(function()
      if self.lvEffects and self.lvEffects[level] then
        self.lvEffects[level]:SetActive(false)
      end
      if self.lvEffectFire then
        self.lvEffectFire:SetActive(false)
      end
    end, 2)
  end
end

function LWCivilizationSparkBuild:SetAnimation(animationName, loop)
  if self.skeletonAnimation then
    self.skeletonAnimation.loop = loop
    self.skeletonAnimation.AnimationName = animationName
  end
end

function LWCivilizationSparkBuild:PerInAnimStart(level, delay)
  self:ClearPer()
  self.inPer = true
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  GoToUtil.GoToCivilizationSparkBuild(135)
  EventManager:GetInstance():Broadcast(EventId.HideBuildDetail, self.bUuid)
  DataCenter.BuildBubbleManager:SetNoRefresh(self.bUuid)
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  if 1 < level and self.lvEffectSmoke then
    self.lvEffectSmoke:SetActive(true)
  end
  self.inAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:SetAnimation("lv" .. level .. "_in", false)
    self:SetCompleteEvent(function(trackEntry, spineEvent)
      self:SetCompleteEvent(nil)
      self:PlayLoopAnim(level)
      self:PerInAnimEnd(level)
    end)
  end, delay)
end

function LWCivilizationSparkBuild:PerInAnimEnd(level)
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
  if 1 < level then
    if self.lvEffectSmoke then
      self.lvEffectSmoke:SetActive(false)
    end
    self:PlayLvEffect(level)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUICivilizationSparkBuffTipBanner, {anim = true}, level, function()
      self:PerInTipClose()
      if CS.SceneManager.World then
        CS.SceneManager.World:AutoZoom(CS.SceneManager.World.InitZoom, 0.5)
      end
    end)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {100015}
    })
    self:PerInTipClose(level)
  end
end

function LWCivilizationSparkBuild:PerInTipClose()
  self:ClearPer()
end

function LWCivilizationSparkBuild:SetCompleteEvent(action)
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

return LWCivilizationSparkBuild
