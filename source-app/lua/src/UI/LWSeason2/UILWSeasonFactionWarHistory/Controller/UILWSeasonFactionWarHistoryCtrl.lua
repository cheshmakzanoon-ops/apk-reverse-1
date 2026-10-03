local UILWSeasonFactionWarHistoryCtrl = BaseClass("UILWSeasonFactionWarHistoryCtrl", UIBaseCtrl)

function UILWSeasonFactionWarHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarHistory)
end

return UILWSeasonFactionWarHistoryCtrl
