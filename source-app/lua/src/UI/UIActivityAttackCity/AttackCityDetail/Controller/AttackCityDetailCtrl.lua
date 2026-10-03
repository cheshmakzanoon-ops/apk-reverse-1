local AttackCityDetailCtrl = BaseClass("AttackCityDetailCtrl", UIBaseCtrl)

function AttackCityDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityAttackCityDetail)
end

return AttackCityDetailCtrl
