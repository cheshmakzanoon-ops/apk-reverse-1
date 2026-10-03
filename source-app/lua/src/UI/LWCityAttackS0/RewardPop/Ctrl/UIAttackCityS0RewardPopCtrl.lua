local UIAttackCityS0RewardPopCtrl = BaseClass("UIAttackCityS0RewardPopCtrl", UIBaseCtrl)

function UIAttackCityS0RewardPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAttackCityS0RewardPopView)
end

return UIAttackCityS0RewardPopCtrl
