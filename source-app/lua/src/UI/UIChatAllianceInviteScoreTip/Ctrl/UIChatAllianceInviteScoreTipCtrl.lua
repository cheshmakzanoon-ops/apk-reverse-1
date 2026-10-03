local UIChatAllianceInviteScoreTipCtrl = BaseClass("UIChatAllianceInviteScoreTipCtrl", UIBaseCtrl)

function UIChatAllianceInviteScoreTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatAllianceInviteScoreTip)
end

return UIChatAllianceInviteScoreTipCtrl
