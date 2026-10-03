local UIActCrazyRockGameSettlementCtrl = BaseClass("UIActCrazyRockGameSettlementCtrl", UIBaseCtrl)

function UIActCrazyRockGameSettlementCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCrazyRockGameSettlement)
end

return UIActCrazyRockGameSettlementCtrl
