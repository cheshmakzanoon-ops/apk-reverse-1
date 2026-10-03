local UIResourceLackCtrl = BaseClass("UIResourceLackCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceLack)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIResourceLackCtrl.CloseSelf = CloseSelf
UIResourceLackCtrl.Close = Close
return UIResourceLackCtrl
