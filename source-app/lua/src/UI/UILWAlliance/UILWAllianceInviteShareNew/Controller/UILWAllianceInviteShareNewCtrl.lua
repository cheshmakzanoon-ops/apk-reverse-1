local UILWAllianceInviteShareNewCtrl = BaseClass("UILWAllianceInviteShareNewCtrl", UIBaseCtrl)

function UILWAllianceInviteShareNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceInviteShareNew)
end

return UILWAllianceInviteShareNewCtrl
