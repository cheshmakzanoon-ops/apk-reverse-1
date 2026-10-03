local UIAttackCityS0BattleResultPopCtrl = BaseClass("UIAttackCityS0BattleResultPopCtrl", UIBaseCtrl)

function UIAttackCityS0BattleResultPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAttackCityS0BattleResultPopView)
end

return UIAttackCityS0BattleResultPopCtrl
