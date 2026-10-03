local UIResourceCostCtrl = BaseClass("UIResourceCostCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceCost)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Scene)
end

UIResourceCostCtrl.CloseSelf = CloseSelf
UIResourceCostCtrl.Close = Close
return UIResourceCostCtrl
