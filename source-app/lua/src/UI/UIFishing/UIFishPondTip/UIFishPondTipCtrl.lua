local UIFishPondTipCtrl = BaseClass("UIFishPondTipCtrl", UIBaseCtrl)

function UIFishPondTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFishPondTip)
end

return UIFishPondTipCtrl
