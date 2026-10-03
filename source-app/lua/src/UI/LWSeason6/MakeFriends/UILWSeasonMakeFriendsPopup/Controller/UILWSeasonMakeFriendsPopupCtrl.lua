local UILWSeasonMakeFriendsPopupCtrl = BaseClass("UILWSeasonMakeFriendsPopupCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsPopup)
end

return UILWSeasonMakeFriendsPopupCtrl
