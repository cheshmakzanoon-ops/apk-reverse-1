local UILWSeasonFactionWarInviteSendDlgCtrl = BaseClass("UILWSeasonFactionWarInviteSendDlgCtrl", UIBaseCtrl)

function UILWSeasonFactionWarInviteSendDlgCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarInviteSendDlg)
end

return UILWSeasonFactionWarInviteSendDlgCtrl
