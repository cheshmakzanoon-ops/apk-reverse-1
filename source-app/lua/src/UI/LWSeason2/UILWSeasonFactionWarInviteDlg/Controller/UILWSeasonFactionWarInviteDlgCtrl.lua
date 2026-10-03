local UILWSeasonFactionWarInviteDlgCtrl = BaseClass("UILWSeasonFactionWarInviteDlgCtrl", UIBaseCtrl)

function UILWSeasonFactionWarInviteDlgCtrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionWarInviteSendUpdate, nil)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarInviteDlg)
end

return UILWSeasonFactionWarInviteDlgCtrl
