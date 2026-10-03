local HeroTrialRewardItem = BaseClass("HeroTrialRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function HeroTrialRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroTrialRewardItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function HeroTrialRewardItem:ComponentDefine()
  self._uiCommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self._effect = self:AddComponent(UIBaseContainer, "Effect")
end

function HeroTrialRewardItem:ComponentDestroy()
  self._uiCommonResItem = nil
  self._effect = nil
end

function HeroTrialRewardItem:DataDefine()
end

function HeroTrialRewardItem:DataDestroy()
end

function HeroTrialRewardItem:ReInit(param, isReach)
  self._effect:SetActive(isReach)
  self._uiCommonResItem:ReInit(param)
end

function HeroTrialRewardItem:SetGray(isGray, canClick)
  if self._uiCommonResItem then
    self._uiCommonResItem:SetGray(isGray, canClick)
  end
end

return HeroTrialRewardItem
