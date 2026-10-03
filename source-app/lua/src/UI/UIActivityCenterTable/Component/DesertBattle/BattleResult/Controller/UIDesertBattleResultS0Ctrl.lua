local UIDesertBattleResultS0Ctrl = BaseClass("UIDesertBattleResultS0Ctrl", UIBaseCtrl)

function UIDesertBattleResultS0Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleResultS0)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIQuickGift)
  BattleFieldUtil.BackToCity(BattleFieldType.Desert)
end

return UIDesertBattleResultS0Ctrl
