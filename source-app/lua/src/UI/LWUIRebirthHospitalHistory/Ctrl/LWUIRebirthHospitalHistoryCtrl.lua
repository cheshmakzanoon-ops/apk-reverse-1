local LWUIRebirthHospitalHistoryCtrl = BaseClass("LWUIRebirthHospitalHistoryCtrl", UIBaseCtrl)

function LWUIRebirthHospitalHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRebirthHospitalHistory)
end

return LWUIRebirthHospitalHistoryCtrl
