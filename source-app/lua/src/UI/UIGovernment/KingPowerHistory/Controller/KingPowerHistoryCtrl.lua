local KingPowerHistoryCtrl = BaseClass("KingPowerHistoryCtrl", UIBaseCtrl)

function KingPowerHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentKingPowerHistory)
end

return KingPowerHistoryCtrl
