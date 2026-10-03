local AttackCityS0RadarEventPopCtrl = BaseClass("AttackCityS0RadarEventPopCtrl", UIBaseCtrl)

function AttackCityS0RadarEventPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AttackCityS0RadarEventPopView)
end

return AttackCityS0RadarEventPopCtrl
