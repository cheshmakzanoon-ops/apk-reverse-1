local UILLGroupInvitationCtrl = BaseClass("UILLGroupInvitationCtrl", UIBaseCtrl)

function UILLGroupInvitationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLGroupInvitation)
end

return UILLGroupInvitationCtrl
