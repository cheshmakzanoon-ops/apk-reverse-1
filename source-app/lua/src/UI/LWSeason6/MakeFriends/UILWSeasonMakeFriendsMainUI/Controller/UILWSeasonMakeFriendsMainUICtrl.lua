local UILWSeasonMakeFriendsMainUICtrl = BaseClass("UILWSeasonMakeFriendsMainUICtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsMainUICtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI)
end

return UILWSeasonMakeFriendsMainUICtrl
