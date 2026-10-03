local UIGhostreconTaskSpecialRuningCtrl = BaseClass("UIGhostreconTaskSpecialRuningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTaskSpecialRuning)
end

UIGhostreconTaskSpecialRuningCtrl.CloseSelf = CloseSelf
return UIGhostreconTaskSpecialRuningCtrl
