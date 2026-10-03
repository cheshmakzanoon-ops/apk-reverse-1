local UILostSoldierTipCtrl = BaseClass("UILostSoldierTipCtrl", UIBaseCtrl)
local base = UIBaseCtrl

function UILostSoldierTipCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UILostSoldierTip)
end

return UILostSoldierTipCtrl
