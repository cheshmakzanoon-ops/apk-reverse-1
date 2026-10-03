local SeasonCampDestroyZoneDetailCtrl = BaseClass("SeasonCampDestroyZoneDetailCtrl", UIBaseCtrl)

function SeasonCampDestroyZoneDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyZoneDetail)
end

return SeasonCampDestroyZoneDetailCtrl
