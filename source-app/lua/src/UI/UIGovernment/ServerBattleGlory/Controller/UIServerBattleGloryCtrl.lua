local UIServerBattleGloryCtrl = BaseClass("UIServerBattleGloryCtrl", UIBaseCtrl)

function UIServerBattleGloryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIServerBattleGlory)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIQuickGift)
end

return UIServerBattleGloryCtrl
