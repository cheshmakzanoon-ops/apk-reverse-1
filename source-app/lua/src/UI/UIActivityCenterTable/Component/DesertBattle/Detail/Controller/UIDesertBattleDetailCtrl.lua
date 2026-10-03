local UIDesertBattleDetailCtrl = BaseClass("UIDesertBattleDetailCtrl", UIBaseCtrl)

function UIDesertBattleDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleDetail)
end

return UIDesertBattleDetailCtrl
