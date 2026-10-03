local UIArrowFinger_NewCtrl = BaseClass("UIArrowFinger_NewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrowFinger_New)
end

UIArrowFinger_NewCtrl.CloseSelf = CloseSelf
return UIArrowFinger_NewCtrl
