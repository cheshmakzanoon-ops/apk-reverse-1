local StashRewardItemComponent = BaseClass("StashRewardItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "Root/UICommonResItem"
local StateType = {
  StartAppear = 1,
  FlyToTargetSlot = 2,
  FlyToNextSlot = 3
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
end

local function ComponentDestroy(self)
  self.resItem = nil
end

local function DataDefine(self)
  self.curState = StateType.StartAppear
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
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function StashRewardItemComponent:ReInit(index, rewardData)
  if not self.resItem then
    return
  end
  self.index = index
  self.resItem:ParseInfo(rewardData)
  self:ShowPushAni()
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

function StashRewardItemComponent:ShowPopAni(callback)
  if self.hideTimer then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
  local ret, time = self.simpleAni:PlayAnimationReturnTime("Hide")
  if not ret then
    time = 1
  end
  self.hideTimer = TimerManager:GetInstance():DelayInvoke(function()
    if callback then
      callback()
    end
  end, time)
end

function StashRewardItemComponent:KillHideTimer()
  if self.hideTimer then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
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
