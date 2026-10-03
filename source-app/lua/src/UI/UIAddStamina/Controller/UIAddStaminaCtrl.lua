local UIAddStaminaCtrl = BaseClass("UIAddStaminaCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAddStamina)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAddStaminaCtrl.CloseSelf = CloseSelf
UIAddStaminaCtrl.Close = Close
return UIAddStaminaCtrl
