local UIAttackCityS0ParkourBonusResultCtrl = BaseClass("UIAttackCityS0ParkourBonusResultCtrl", UIBaseCtrl)

function UIAttackCityS0ParkourBonusResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAttackCityS0ParkourBonusResultView)
end

return UIAttackCityS0ParkourBonusResultCtrl
