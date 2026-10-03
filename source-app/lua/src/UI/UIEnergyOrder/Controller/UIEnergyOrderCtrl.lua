local UIEnergyOrderCtrl = BaseClass("UIEnergyOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEnergyOrder)
end

UIEnergyOrderCtrl.CloseSelf = CloseSelf
return UIEnergyOrderCtrl
