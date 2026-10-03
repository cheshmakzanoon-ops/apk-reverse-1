local UIGhostreconTeamUpSpecialCtrl = BaseClass("UIGhostreconTeamUpSpecialCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTeamUpSpecial)
end

UIGhostreconTeamUpSpecialCtrl.CloseSelf = CloseSelf
return UIGhostreconTeamUpSpecialCtrl
