local base = UIBaseContainer
local BountyHunterLogCardRewardComponent = BaseClass("BountyHunterLogCardRewardComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function BountyHunterLogCardRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function BountyHunterLogCardRewardComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BountyHunterLogCardRewardComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.compEffect = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
end

function BountyHunterLogCardRewardComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compUICommonResItem = nil
  self.compEffect = nil
end

function BountyHunterLogCardRewardComponent:DataDefine()
end

function BountyHunterLogCardRewardComponent:DataDestroy()
end

function BountyHunterLogCardRewardComponent:OnAddListener()
  base.OnAddListener(self)
end

function BountyHunterLogCardRewardComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BountyHunterLogCardRewardComponent:ParseInfo(data)
  self.compUICommonResItem:ParseInfo(data)
end

function BountyHunterLogCardRewardComponent:SetEffect(value)
  self.compEffect:SetActive(value)
end

return BountyHunterLogCardRewardComponent
