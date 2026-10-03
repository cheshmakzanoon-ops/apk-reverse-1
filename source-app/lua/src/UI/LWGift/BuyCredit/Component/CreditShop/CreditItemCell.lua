local CreditItemCell = BaseClass("CreditItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function CreditItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CreditItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function CreditItemCell:OnEnable()
  base.OnEnable(self)
end

function CreditItemCell:OnDisable()
  base.OnDisable(self)
end

function CreditItemCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "bg")
  self.price = self:AddComponent(UIText, "bg/price")
  self.reward = self:AddComponent(UIText, "bg/reward")
  self.btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.btn:SetSafeClickMode(true)
end

function CreditItemCell:ComponentDestroy()
  self.btn = nil
  self.price = nil
  self.reward = nil
end

function CreditItemCell:DataDefine()
end

function CreditItemCell:DataDestroy()
end

function CreditItemCell:Refresh(param)
  self.data = param
  self.price:SetText(param:getPriceText())
  self.reward:SetText(string.format("%s%s", Localization:GetString("credit_prop_name"), tostring(param:getCredit())))
end

function CreditItemCell:OnShowClick(param)
  if not self.data then
    return
  end
  local curCredit = DataCenter.CreditManager:GetCreditValue()
  if 0 <= curCredit then
    return
  end
  local giftPackCredit = self.data:getCredit()
  local curCredit = DataCenter.CreditManager:GetCreditValue()
  if giftPackCredit > -curCredit then
    UIUtil.ShowMessage(Localization:GetString("credit_popup_content_03", curCredit, giftPackCredit), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.PayManager:BuyGift(self.data)
    end, nil, nil, "100378")
  else
    DataCenter.PayManager:BuyGift(self.data)
  end
end

return CreditItemCell
