local UIHeroExchangeLevelReportCtrl = BaseClass("UIHeroExchangeLevelReportCtrl", UIBaseCtrl)

function UIHeroExchangeLevelReportCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonHeroLevelChangeReport)
end

return UIHeroExchangeLevelReportCtrl
