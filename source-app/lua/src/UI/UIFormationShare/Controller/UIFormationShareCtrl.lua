local UIFormationShareCtrl = BaseClass("UIFormationShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationShare)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIFormationShareCtrl.CloseSelf = CloseSelf
UIFormationShareCtrl.Close = Close
return UIFormationShareCtrl
