local UIEpidemicBattleMapCtrl = BaseClass("UIEpidemicBattleMapCtrl", UIBaseCtrl)

function UIEpidemicBattleMapCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleMap)
end

return UIEpidemicBattleMapCtrl
