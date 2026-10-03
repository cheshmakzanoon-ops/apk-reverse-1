local UISeasonOfficialAppointmentCtrl = BaseClass("UISeasonOfficialAppointmentCtrl", UIBaseCtrl)

function UISeasonOfficialAppointmentCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialAppointment)
end

return UISeasonOfficialAppointmentCtrl
