local UIGhostreconTeamUpNormalCtrl = BaseClass("UIGhostreconTeamUpNormalCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTeamUpNormal)
end

UIGhostreconTeamUpNormalCtrl.CloseSelf = CloseSelf
return UIGhostreconTeamUpNormalCtrl
