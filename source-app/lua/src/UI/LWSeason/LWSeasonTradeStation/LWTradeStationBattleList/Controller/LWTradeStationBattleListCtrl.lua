local LWTradeStationBattleListCtrl = BaseClass("LWTradeStationBattleListCtrl", UIBaseCtrl)

function LWTradeStationBattleListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWTradeStationBattleList)
end

return LWTradeStationBattleListCtrl
