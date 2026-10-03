local LWSeasonTrendsMainCtrl = BaseClass("LWSeasonTrendsMainCtrl", UIBaseCtrl)

function LWSeasonTrendsMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonTrendsMain)
end

return LWSeasonTrendsMainCtrl
