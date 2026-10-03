local UILWSeasonMakeFriendsDetailCDCtrl = BaseClass("UILWSeasonMakeFriendsDetailCDCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsDetailCDCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsDetailCD)
end

return UILWSeasonMakeFriendsDetailCDCtrl
