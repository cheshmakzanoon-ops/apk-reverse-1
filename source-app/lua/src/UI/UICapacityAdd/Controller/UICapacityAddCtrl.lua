local UICapacityAddCtrl = BaseClass("UICapacityAddCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityAdd)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Dialog)
end

UICapacityAddCtrl.CloseSelf = CloseSelf
UICapacityAddCtrl.Close = Close
return UICapacityAddCtrl
