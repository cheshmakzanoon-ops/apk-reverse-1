local UIDesertBattleEnterTipCtrl = BaseClass("UIDesertBattleEnterTipCtrl", UIBaseCtrl)

function UIDesertBattleEnterTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleEnterTip, {anim = true})
end

return UIDesertBattleEnterTipCtrl
