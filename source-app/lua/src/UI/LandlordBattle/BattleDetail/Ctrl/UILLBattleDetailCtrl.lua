local UILLBattleDetailCtrl = BaseClass("UILLBattleDetailCtrl", UIBaseCtrl)

function UILLBattleDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLBattleDetail)
end

return UILLBattleDetailCtrl
