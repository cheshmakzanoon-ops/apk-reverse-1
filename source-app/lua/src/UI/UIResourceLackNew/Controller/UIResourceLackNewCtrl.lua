local UIResourceLackNewCtrl = BaseClass("UIResourceLackNewCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceLackNew, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIResourceLackNewCtrl.CloseSelf = CloseSelf
UIResourceLackNewCtrl.Close = Close
return UIResourceLackNewCtrl
