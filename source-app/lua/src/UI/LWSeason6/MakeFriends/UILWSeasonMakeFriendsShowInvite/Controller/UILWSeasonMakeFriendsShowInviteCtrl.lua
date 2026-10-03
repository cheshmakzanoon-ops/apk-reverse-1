local UILWSeasonMakeFriendsShowInviteCtrl = BaseClass("UILWSeasonMakeFriendsShowInviteCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsShowInviteCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsShowInvite)
end

return UILWSeasonMakeFriendsShowInviteCtrl
