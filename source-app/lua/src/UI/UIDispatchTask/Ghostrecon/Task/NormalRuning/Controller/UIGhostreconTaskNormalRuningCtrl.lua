local UIGhostreconTaskNormalRuningCtrl = BaseClass("UIGhostreconTaskNormalRuningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTaskNormalRuning)
end

UIGhostreconTaskNormalRuningCtrl.CloseSelf = CloseSelf
return UIGhostreconTaskNormalRuningCtrl
