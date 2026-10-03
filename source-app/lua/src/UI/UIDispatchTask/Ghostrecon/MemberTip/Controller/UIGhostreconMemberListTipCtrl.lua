local UIGhostreconMemberListTipCtrl = BaseClass("UIGhostreconMemberListTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconMemberListTip)
end

UIGhostreconMemberListTipCtrl.CloseSelf = CloseSelf
return UIGhostreconMemberListTipCtrl
