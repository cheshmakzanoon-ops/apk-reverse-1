local base = UIBaseContainer
local UIRewardItemComponent = BaseClass("UIRewardItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIRewardItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIRewardItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRewardItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.uICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.effUiDuobaoJiangliFaguang = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.effAccuRechargeJiantou = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.effUiAccuRechargeNew01 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.rewardChangeNew = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
end

function UIRewardItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.uICommonResItem = nil
  self.effUiDuobaoJiangliFaguang = nil
  self.effAccuRechargeJiantou = nil
  self.effUiAccuRechargeNew01 = nil
  self.rewardChangeNew = nil
end

function UIRewardItemComponent:DataDefine()
end

function UIRewardItemComponent:DataDestroy()
end

function UIRewardItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIRewardItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRewardItemComponent:ReInit(data)
  local param = self.uICommonResItem:ParseInfo(data)
  self.uICommonResItem:ReInit(param)
  self.effUiDuobaoJiangliFaguang:SetActive(false)
  self.effAccuRechargeJiantou:SetActive(false)
  self.effUiAccuRechargeNew01:SetActive(false)
  self.rewardChangeNew:SetActive(false)
end

return UIRewardItemComponent
