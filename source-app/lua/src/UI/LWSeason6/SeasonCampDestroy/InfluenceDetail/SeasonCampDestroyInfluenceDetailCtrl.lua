local SeasonCampDestroyInfluenceDetailCtrl = BaseClass("SeasonCampDestroyInfluenceDetailCtrl", UIBaseCtrl)

function SeasonCampDestroyInfluenceDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyInfluenceDetail)
end

return SeasonCampDestroyInfluenceDetailCtrl
