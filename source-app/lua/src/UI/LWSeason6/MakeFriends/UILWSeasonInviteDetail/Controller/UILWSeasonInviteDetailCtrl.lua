local UILWSeasonInviteDetailCtrl = BaseClass("UILWSeasonInviteDetailCtrl", UIBaseCtrl)

function UILWSeasonInviteDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonInviteDetail)
end

return UILWSeasonInviteDetailCtrl
