local UISeasonOfficialLeaderHistoryCtrl = BaseClass("UISeasonOfficialLeaderHistoryCtrl", UIBaseCtrl)

function UISeasonOfficialLeaderHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialLeaderHistory)
end

return UISeasonOfficialLeaderHistoryCtrl
