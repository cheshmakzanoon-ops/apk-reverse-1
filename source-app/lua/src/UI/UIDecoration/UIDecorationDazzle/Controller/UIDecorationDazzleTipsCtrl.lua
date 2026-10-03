local UIDecorationDazzleTipsCtrl = BaseClass("UIDecorationDazzleTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDecorationDazzleTips)
end

UIDecorationDazzleTipsCtrl.CloseSelf = CloseSelf
return UIDecorationDazzleTipsCtrl
