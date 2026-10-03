local UILWSeasonInviteMailPopupCtrl = BaseClass("UILWSeasonInviteMailPopupCtrl", UIBaseCtrl)

function UILWSeasonInviteMailPopupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonInviteMailPopup)
end

return UILWSeasonInviteMailPopupCtrl
