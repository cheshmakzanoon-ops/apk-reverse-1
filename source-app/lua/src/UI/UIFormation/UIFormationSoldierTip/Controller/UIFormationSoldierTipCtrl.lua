local UIFormationSoldierTipCtrl = BaseClass("UIFormationSoldierTipCtrl", UIBaseCtrl)
local base = UIBaseCtrl

function UIFormationSoldierTipCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFormationSoldierTip)
end

return UIFormationSoldierTipCtrl
