local SeasonCampDestroyBuffDetailCtrl = BaseClass("SeasonCampDestroyBuffDetailCtrl", UIBaseCtrl)

function SeasonCampDestroyBuffDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyBuffDetail)
end

return SeasonCampDestroyBuffDetailCtrl
