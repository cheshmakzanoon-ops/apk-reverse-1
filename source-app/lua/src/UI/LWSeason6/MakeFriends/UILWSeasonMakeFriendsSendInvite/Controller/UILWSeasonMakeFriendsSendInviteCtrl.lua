local UILWSeasonMakeFriendsSendInviteCtrl = BaseClass("UILWSeasonMakeFriendsSendInviteCtrl", UIBaseCtrl)

function UILWSeasonMakeFriendsSendInviteCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMakeFriendsSendInvite)
end

return UILWSeasonMakeFriendsSendInviteCtrl
