local UILWSeasonVirusHistoryCtrl = BaseClass("UILWSeasonVirusHistoryCtrl", UIBaseCtrl)

function UILWSeasonVirusHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonVirusHistory)
end

return UILWSeasonVirusHistoryCtrl
