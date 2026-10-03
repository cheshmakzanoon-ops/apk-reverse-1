local UIEnergyBankCtrl = BaseClass("UIEnergyBankCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEnergyBank)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIEnergyBankCtrl.CloseSelf = CloseSelf
UIEnergyBankCtrl.Close = Close
return UIEnergyBankCtrl
