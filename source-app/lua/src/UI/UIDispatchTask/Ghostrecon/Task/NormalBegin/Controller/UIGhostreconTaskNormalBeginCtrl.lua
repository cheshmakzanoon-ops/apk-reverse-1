local UIGhostreconTaskNormalBeginCtrl = BaseClass("UIGhostreconTaskNormalBeginCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTaskNormalBegin)
end

UIGhostreconTaskNormalBeginCtrl.CloseSelf = CloseSelf
return UIGhostreconTaskNormalBeginCtrl
