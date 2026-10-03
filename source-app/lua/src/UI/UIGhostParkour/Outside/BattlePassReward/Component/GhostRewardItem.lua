local base = UIBaseContainer
local GhostRewardItem = BaseClass("GhostRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function GhostRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GhostRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GhostRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.uICommonResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.effUiDuobaoJiangliFaguang = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.effAccuRechargeJiantou = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.effUiAccuRechargeNew01 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.rewardChangeNew = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
end

function GhostRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.uICommonResItem = nil
  self.effUiDuobaoJiangliFaguang = nil
  self.effAccuRechargeJiantou = nil
  self.effUiAccuRechargeNew01 = nil
  self.rewardChangeNew = nil
end

function GhostRewardItem:DataDefine()
end

function GhostRewardItem:DataDestroy()
end

function GhostRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function GhostRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GhostRewardItem:ReInit(data)
  local param = self.uICommonResItem:ParseInfo(data)
  self.uICommonResItem:ReInit(param)
  self.effUiDuobaoJiangliFaguang:SetActive(false)
  self.effAccuRechargeJiantou:SetActive(false)
  self.effUiAccuRechargeNew01:SetActive(false)
  self.rewardChangeNew:SetActive(false)
end

return GhostRewardItem
