local UIGhostreconAllianceTaskCtrl = BaseClass("UIGhostreconAllianceTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconAllianceTask)
end

UIGhostreconAllianceTaskCtrl.CloseSelf = CloseSelf
return UIGhostreconAllianceTaskCtrl
