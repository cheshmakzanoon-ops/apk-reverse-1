local base = UIBaseContainer
local LWUIPlayerPackageRewardChangeRewardItemComponent = BaseClass("LWUIPlayerPackageRewardChangeRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIPlayerPackageRewardChangeRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.animatorLWUIPlayerPackageRewardChangeRewardItem = self:AddComponent(UIAnimator, "")
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:ComponentDestroy()
  self.compUICommonResItem = nil
  self.animatorLWUIPlayerPackageRewardChangeRewardItem = nil
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:DataDefine()
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:DataDestroy()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWUIPlayerPackageRewardChangeRewardItemComponent:ReInit(reward, delayShowTime)
  self.compUICommonResItem:ReInit(reward)
  self.compUICommonResItem:SetActive(false)
  self.animatorLWUIPlayerPackageRewardChangeRewardItem:Play("V_ui_RewardChange_Rewardcell_idle")
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.compUICommonResItem:SetActive(true)
    self.animatorLWUIPlayerPackageRewardChangeRewardItem:Play("V_ui_RewardChange_Rewardcell_in")
  end, delayShowTime)
end

return LWUIPlayerPackageRewardChangeRewardItemComponent
