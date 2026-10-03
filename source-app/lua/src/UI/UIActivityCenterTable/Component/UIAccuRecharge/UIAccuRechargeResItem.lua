local base = UIBaseContainer
local UIAccuRechargeResItem = BaseClass("UIAccuRechargeResItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAccuRechargeResItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAccuRechargeResItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAccuRechargeResItem:ComponentDefine()
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.compRewardChangeNew = self:AddComponent(UIBaseComponent, "RewardChangeNew")
  self.compEffAccuRechargeJiantou = self:AddComponent(UIBaseComponent, "Eff_AccuRecharge_jiantou")
  self.compEffUiAccuRechargeNew01 = self:AddComponent(UIBaseComponent, "Eff_ui_AccuRecharge_new01")
end

function UIAccuRechargeResItem:ComponentDestroy()
  self.compUICommonResItem = nil
  self.compRewardChangeNew = nil
  self.compEffAccuRechargeJiantou = nil
  self.compEffUiAccuRechargeNew01 = nil
end

function UIAccuRechargeResItem:DataDefine()
  self.data = nil
end

function UIAccuRechargeResItem:DataDestroy()
  self.data = nil
end

function UIAccuRechargeResItem:OnAddListener()
  base.OnAddListener(self)
end

function UIAccuRechargeResItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAccuRechargeResItem:ReInit(data)
  self.data = data
  self.compUICommonResItem:ReInit(data)
  self.compEffAccuRechargeJiantou:SetActive(false)
  self.compEffUiAccuRechargeNew01:SetActive(false)
  self.compRewardChangeNew:SetActive(false)
end

function UIAccuRechargeResItem:GetIconTrans()
  return self.compUICommonResItem.gameObject.transform:Find("clickBtn/ItemIcon")
end

function UIAccuRechargeResItem:PlayUpdateEffect()
  self.compEffAccuRechargeJiantou:SetActive(false)
  self.compEffUiAccuRechargeNew01:SetActive(false)
  self.compEffAccuRechargeJiantou:SetActive(true)
  self.compEffUiAccuRechargeNew01:SetActive(true)
end

function UIAccuRechargeResItem:PlayNewEffect()
  self.compRewardChangeNew:SetActive(false)
  self.compRewardChangeNew:SetActive(true)
end

function UIAccuRechargeResItem:GetItemId()
  if self.data then
    return self.data.itemId
  end
  return nil
end

return UIAccuRechargeResItem
