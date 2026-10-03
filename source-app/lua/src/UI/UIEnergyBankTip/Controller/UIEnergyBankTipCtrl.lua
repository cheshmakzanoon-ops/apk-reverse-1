local UIEnergyBankTipCtrl = BaseClass("UIEnergyBankTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEnergyBankTip)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Info, false)
end

UIEnergyBankTipCtrl.CloseSelf = CloseSelf
UIEnergyBankTipCtrl.Close = Close
return UIEnergyBankTipCtrl
