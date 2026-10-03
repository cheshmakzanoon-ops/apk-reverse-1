local UIFunctionOnAnimCtrl = BaseClass("UIFunctionOnAnimCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFunctionOnAnim)
end

UIFunctionOnAnimCtrl.CloseSelf = CloseSelf
return UIFunctionOnAnimCtrl
