local UIAllyDuelPopupCtrl = BaseClass("UIAllyDuelPopupCtrl", UIBaseCtrl)

function UIAllyDuelPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelPopup)
end

return UIAllyDuelPopupCtrl
