local UILWSeasonMakeFriendsLinkedCityCtrl = BaseClass("UILWSeasonMakeFriendsLinkedCityCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsLinkedCityCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsLinkedCity)
end

return UILWSeasonMakeFriendsLinkedCityCtrl
