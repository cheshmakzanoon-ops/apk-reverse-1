local ActLotteryPreOpenRewardView = BaseClass("ActLotteryPreOpenRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local open_btn_path = "Root/MachineContent/openBtn"
local reward_path = "Root/MachineContent/rewardContent/Reward"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:CloseTimer()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.open_btn = self:AddComponent(UIButton, open_btn_path)
  self.reward = self:AddComponent(UIRawImage, reward_path)
  self.open_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.open_btn = nil
  self.reward = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function RefreshView(self)
  self.message = self:GetUserData()
  self:CloseTimer()
end

local function OnBtnClick(self)
  if self.timer then
    return
  end
  local delayTime = 0.1
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.message and self.message.win then
      if self.message.win == 0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActLotteryBigRewardOpen, {anim = false}, self.message)
      elseif self.message.win == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.ActLotteryBigRewardSpecialShow, {anim = false}, self.message)
      end
    end
    self.ctrl:CloseSelf()
  end, delayTime)
end

local function CloseTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

ActLotteryPreOpenRewardView.OnCreate = OnCreate
ActLotteryPreOpenRewardView.OnDestroy = OnDestroy
ActLotteryPreOpenRewardView.ComponentDefine = ComponentDefine
ActLotteryPreOpenRewardView.ComponentDestroy = ComponentDestroy
ActLotteryPreOpenRewardView.RefreshView = RefreshView
ActLotteryPreOpenRewardView.OnAddListener = OnAddListener
ActLotteryPreOpenRewardView.OnRemoveListener = OnRemoveListener
ActLotteryPreOpenRewardView.OnBtnClick = OnBtnClick
ActLotteryPreOpenRewardView.CloseTimer = CloseTimer
return ActLotteryPreOpenRewardView
