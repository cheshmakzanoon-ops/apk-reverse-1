local SeasonCampDestroyMainCtrl = BaseClass("SeasonCampDestroyMainCtrl", UIBaseCtrl)

function SeasonCampDestroyMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyMain)
end

return SeasonCampDestroyMainCtrl
