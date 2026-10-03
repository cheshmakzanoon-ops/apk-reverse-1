local UIPiggyBankTipCtrl = BaseClass("UIPiggyBankTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPiggyBankTip)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Info, false)
end

UIPiggyBankTipCtrl.CloseSelf = CloseSelf
UIPiggyBankTipCtrl.Close = Close
return UIPiggyBankTipCtrl
