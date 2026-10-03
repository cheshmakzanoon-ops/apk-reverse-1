local SeasonCampDestroyWarHistoryCtrl = BaseClass("SeasonCampDestroyWarHistoryCtrl", UIBaseCtrl)

function SeasonCampDestroyWarHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonCampDestroyWarHistory)
end

return SeasonCampDestroyWarHistoryCtrl
