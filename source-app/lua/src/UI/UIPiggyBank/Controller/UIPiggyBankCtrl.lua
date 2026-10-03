local UIPiggyBankCtrl = BaseClass("UIPiggyBankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPiggyBank)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIPiggyBankCtrl.CloseSelf = CloseSelf
UIPiggyBankCtrl.Close = Close
return UIPiggyBankCtrl
