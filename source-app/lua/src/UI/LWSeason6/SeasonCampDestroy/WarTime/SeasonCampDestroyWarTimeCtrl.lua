local SeasonCampDestroyWarTimeCtrl = BaseClass("SeasonCampDestroyWarTimeCtrl", UIBaseCtrl)

function SeasonCampDestroyWarTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyWarTimeView)
end

return SeasonCampDestroyWarTimeCtrl
