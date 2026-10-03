local UIDesertBattleSoldierTipCtrl = BaseClass("UIDesertBuildDetailCtrl", UIBaseCtrl)

function UIDesertBattleSoldierTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleSoldierTip)
end

return UIDesertBattleSoldierTipCtrl
