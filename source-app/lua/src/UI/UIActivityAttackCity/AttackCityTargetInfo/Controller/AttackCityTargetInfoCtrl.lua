local AttackCityTargetInfoCtrl = BaseClass("AttackCityTargetInfoCtrl", UIBaseCtrl)

function AttackCityTargetInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityAttackCityTargetInfo)
end

return AttackCityTargetInfoCtrl
