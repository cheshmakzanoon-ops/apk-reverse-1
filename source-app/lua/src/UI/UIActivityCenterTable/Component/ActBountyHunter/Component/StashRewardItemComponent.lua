local StashRewardItemComponent = BaseClass("StashRewardItemComponent", UIBaseContainer)
DOTween = CS.DG.Tweening.DOTween
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "Root/UICommonResItem"
local special_eff_path = "Root/SpecialEff"
local StateType = {
  Hide = 1,
  InList = 2,
  Jump = 3,
  Fly = 4
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.resItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.bornEff = self:AddComponent(UIBaseComponent, "Root/BornEffect")
  self.tailEff = self:AddComponent(UIBaseComponent, "Root/TailEffect")
  self.bornEff:SetActive(false)
  self.tailEff:SetActive(false)
  self.specialEff = self:AddComponent(UIBaseComponent, special_eff_path)
end

local function ComponentDestroy(self)
  self.resItem = nil
  self.bornEff = nil
  self.tailEff = nil
end

local function DataDefine(self)
  self.curState = StateType.Hide
end

local function DataDestroy(self)
  if self.hideTimer then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  if self.delayPlayFlyTimer then
    self.delayPlayFlyTimer:Stop()
    self.delayPlayFlyTimer = nil
  end
  if self.flySeq then
    self.flySeq:Kill()
  end
  if self.popNextCheckTimer then
    self.popNextCheckTimer:Stop()
    self.popNextCheckTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function StashRewardItemComponent:ReInit(index, rewardData, holderTrans, getTargetWorldPosFunc, flyFinishCallback, startFlyCallback)
  if not self.resItem then
    return
  end
  self.index = index
  self.resItem:ParseInfo(rewardData)
  self.holderTrans = holderTrans
  self.getTargetWorldPosFunc = getTargetWorldPosFunc
  self.flyFinishCallback = flyFinishCallback
  self.startFlyCallback = startFlyCallback
end

function StashRewardItemComponent:PlayFlyAni(startWorldPos, time, playJumpAnim, showBornEffect)
  self:SetActive(true)
  self.simpleAni:Play("Show")
  local progressVal = 0
  
  local function Setter(value)
    progressVal = value
  end
  
  local function Getter()
    return progressVal
  end
  
  self.transform.position = startWorldPos
  self.flySeq = DOTween.Sequence()
  math.randomseed(SafeLocalOsTime())
  local hasJump = true
  if playJumpAnim ~= nil and playJumpAnim == false then
    hasJump = false
  end
  if hasJump then
    local randomJumpDisX = (math.random(0, 1) == 0 and -1 or 1) * math.random(40, 50)
    startWorldPos = startWorldPos + Vector3(randomJumpDisX, 0, 0)
    local jumpTween = self.transform:DOJump(startWorldPos, 50, 1, 0.5):SetEase(CS.DG.Tweening.Ease.OutQuad):OnStart(function(x)
      if self.bornEff and showBornEffect then
        self.bornEff:SetActive(true)
      end
      self.curState = StateType.Jump
    end)
    self.flySeq:Append(jumpTween)
    self.flySeq:AppendInterval(math.random(3, 7) / 10)
  end
  self.flyTween = DOTween.To(Getter, Setter, 1, time):SetEase(CS.DG.Tweening.Ease.OutCubic)
  
  function self.flyTween.onUpdate(x)
    local p0 = startWorldPos
    local p2 = self.getTargetWorldPosFunc(self.index) or self.holderTrans.position
    local p1 = Vector3(p2.x, p0.y, 0)
    local targetWorldPos = self:CalculateCubicBezierPointFor2C(progressVal, p0, p1, p2)
    self.transform.position = targetWorldPos
  end
  
  self.flyTween:OnStart(function()
    if self.bornEff then
      self.bornEff:SetActive(false)
    end
    if self.tailEff then
      self.tailEff:SetActive(true)
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Shangjin_Items_Fly, false)
    self.curState = StateType.Fly
    if self.startFlyCallback then
      self.startFlyCallback()
    end
    self.simpleAni:Play("StartFly")
  end)
  self.flyTween:OnComplete(function()
    if self.tailEff then
      self.tailEff:SetActive(false)
    end
    self.flyTween = nil
  end)
  self.flySeq:Append(self.flyTween)
  self.flySeq:OnComplete(function()
    if self.flyFinishCallback then
      self.flyFinishCallback()
    end
    self.flySeq = nil
    self.curState = StateType.InList
  end)
  self.specialEff:SetActive(showBornEffect)
end

function StashRewardItemComponent:IsFlyAniFinish()
  return not self.flySeq and not self.delayPlayFlyTimer
end

function StashRewardItemComponent:DelayPlayFlyAni(startWorldPos, time, delay, playJumpAnim, showBornEffect)
  self:SetActive(false)
  self.curState = StateType.Hide
  if self.delayPlayFlyTimer then
    self.delayPlayFlyTimer:Stop()
    self.delayPlayFlyTimer = nil
  end
  self.delayPlayFlyTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayFlyAni(startWorldPos, time, playJumpAnim, showBornEffect)
    self.delayPlayFlyTimer = nil
  end, delay)
end

function StashRewardItemComponent:ChangeState(state)
  self.curState = state
end

function StashRewardItemComponent:ShowPushAni(callback)
  if self.showTimer then
    self.showTimer:Stop()
    self.showTimer = nil
  end
  local ret, time = self.simpleAni:Play("Show")
  if not ret then
    time = 1
  end
  self.showTimer = TimerManager:GetInstance():DelayInvoke(function()
    if callback then
      callback()
    end
  end, time)
end

function StashRewardItemComponent:ShowPopAni(cycleFunc, nextItemCheckFunc)
  if self.hideTimer then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
  if self.curState == StateType.InList then
    local ret, time = self.simpleAni:PlayAnimationReturnTime("Hide")
    self.hideTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.hideTimer = nil
      if cycleFunc then
        cycleFunc()
      end
      self.specialEff:SetActive(false)
    end, time)
    self.popNextCheckTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.popNextCheckTimer = nil
      if nextItemCheckFunc then
        nextItemCheckFunc()
      end
    end, 0.2)
  else
    if cycleFunc then
      cycleFunc()
    end
    if nextItemCheckFunc then
      nextItemCheckFunc()
    end
    self.specialEff:SetActive(false)
  end
  self.curState = StateType.Hide
end

function StashRewardItemComponent:CalculateCubicBezierPointFor2C(t, p0, p1, p2)
  local u = 1 - t
  local tt = t * t
  local uu = u * u
  local p = uu * p0
  p = p + 2 * u * t * p1
  p = p + tt * p2
  return p
end

function StashRewardItemComponent:IsInList()
  return self.curState == StateType.InList
end

StashRewardItemComponent.OnCreate = OnCreate
StashRewardItemComponent.OnDestroy = OnDestroy
StashRewardItemComponent.OnEnable = OnEnable
StashRewardItemComponent.OnDisable = OnDisable
StashRewardItemComponent.ComponentDefine = ComponentDefine
StashRewardItemComponent.ComponentDestroy = ComponentDestroy
StashRewardItemComponent.DataDefine = DataDefine
StashRewardItemComponent.DataDestroy = DataDestroy
StashRewardItemComponent.OnAddListener = OnAddListener
StashRewardItemComponent.OnRemoveListener = OnRemoveListener
return StashRewardItemComponent
