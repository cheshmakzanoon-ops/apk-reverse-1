local UILWSurfingBattleBuffPopCtrl = BaseClass("UILWSurfingBattleBuffPopCtrl", UIBaseCtrl)

function UILWSurfingBattleBuffPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSurfingBattleBuffPopView)
end

return UILWSurfingBattleBuffPopCtrl
