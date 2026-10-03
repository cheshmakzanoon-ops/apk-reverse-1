local UILWSeasonFactionHistoryCtrl = BaseClass("UILWSeasonFactionHistoryCtrl", UIBaseCtrl)

function UILWSeasonFactionHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionHistory)
end

return UILWSeasonFactionHistoryCtrl
