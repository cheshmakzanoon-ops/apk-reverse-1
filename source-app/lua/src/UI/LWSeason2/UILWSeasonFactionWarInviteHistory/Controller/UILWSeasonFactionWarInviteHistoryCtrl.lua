local UILWSeasonFactionWarInviteHistoryCtrl = BaseClass("UILWSeasonFactionWarInviteHistoryCtrl", UIBaseCtrl)

function UILWSeasonFactionWarInviteHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarInviteHistory)
end

return UILWSeasonFactionWarInviteHistoryCtrl
