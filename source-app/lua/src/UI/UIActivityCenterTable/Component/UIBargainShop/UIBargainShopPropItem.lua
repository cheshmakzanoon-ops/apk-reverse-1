local base = UIBaseContainer
local UIBargainShopPropItem = BaseClass("UIBargainShopPropItem", base)
local RemainingKey = "activity_bargain_shop_desc4"
local UIGray = CS.UIGray

function UIBargainShopPropItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBargainShopPropItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainProp, self.OnRefreshBargainProp)
end

function UIBargainShopPropItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainProp, self.OnRefreshBargainProp)
  base.OnRemoveListener(self)
end

function UIBargainShopPropItem:OnRefreshBargainProp(propData)
  if self.data.uuid == propData.uuid then
    self:UpdateData(propData)
  end
end

function UIBargainShopPropItem:ComponentDefine()
  self.curPrice_text = self:AddComponent(UIText, "Bg/buyBtn/layout/priceLayout/curPrice")
  self.beforePrice_text = self:AddComponent(UIText, "Bg/buyBtn/layout/beforePrice")
  self.propName_text = self:AddComponent(UIText, "Bg/propName")
  self.leftTimes_text = self:AddComponent(UIText, "Bg/leftTimes")
  self.priceIcon = self:AddComponent(UIImage, "Bg/buyBtn/layout/priceLayout/priceIcon")
  self.resItem = self:AddComponent(UICommonResItem, "Bg/UICommonResItem")
  self.layoutBtnCom = self:AddComponent(UIBaseContainer, "Bg/buyBtn/layout")
  self.buyBtn = self:AddComponent(UIButton, "Bg/buyBtn")
  self.sellOutText = self:AddComponent(UIText, "Bg/sellOut")
  self.tipCom = self:AddComponent(UIBaseContainer, "Bg/tip")
  self.baseCom = self:AddComponent(UIBaseContainer, "")
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClck()
  end)
end

function UIBargainShopPropItem:ComponentDestroy()
  self.curPrice_text = nil
  self.beforePrice_text = nil
  self.propName_text = nil
  self.leftTimes_text = nil
  self.priceIcon = nil
  self.resItem = nil
  self.layoutBtnCom = nil
  self.buyBtn = nil
  self.sellOutText = nil
  self.tipCom = nil
  self.baseCom = nil
  self.data = nil
end

function UIBargainShopPropItem:OnBuyBtnClck()
  if self.data == nil then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWBargainShopShare, {anim = true}, self.data)
end

function UIBargainShopPropItem:UpdateData(propData)
  self.data = propData
  self.curPrice_text:SetText(self.data.template.price - self.data:GetReducePrice())
  if table.count(self.data.helpPlayers) > 0 then
    self.beforePrice_text:SetActive(true)
  else
    self.beforePrice_text:SetActive(false)
  end
  self.beforePrice_text:SetText(self.data.template.price)
  self.propName_text:SetText(DataCenter.RewardManager:GetNameByType(self.data.template.rewardType, self.data.template.itemId))
  self.priceIcon:LoadSprite(self.data.template:GetCurrencyIconPath())
  self.count = self.data.template.buyTimeLimit - self.data.buyNum
  self.leftTimes_text:SetLocalText(RemainingKey, self.count)
  self.tipCom:SetActive(self.data:GetIsSuper())
  if self.count > 0 then
    self.layoutBtnCom:SetActive(true)
    self.sellOutText:SetActive(false)
    UIGray.SetGray(self.baseCom.transform, false, true)
  else
    self.layoutBtnCom:SetActive(false)
    self.sellOutText:SetActive(true)
    UIGray.SetGray(self.baseCom.transform, true, false)
  end
  self.resItem:ReInit(self.data.template)
end

function UIBargainShopPropItem:RefreshTimerCountdown()
end

function UIBargainShopPropItem:AddTimer()
end

function UIBargainShopPropItem:DeleteTimer()
end

function UIBargainShopPropItem:OnDestroy()
  self:ComponentDestroy()
end

function UIBargainShopPropItem:DataDestroy()
end

return UIBargainShopPropItem
