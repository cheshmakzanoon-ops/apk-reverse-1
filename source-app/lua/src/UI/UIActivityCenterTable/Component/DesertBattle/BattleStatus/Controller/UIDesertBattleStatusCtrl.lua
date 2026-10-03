local UIDesertBattleStatusCtrl = BaseClass("UIDesertBattleStatusCtrl", UIBaseCtrl)

function UIDesertBattleStatusCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleStatus)
end

return UIDesertBattleStatusCtrl
