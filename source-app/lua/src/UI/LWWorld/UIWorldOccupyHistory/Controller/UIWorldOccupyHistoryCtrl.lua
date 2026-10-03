local UIWorldOccupyHistoryCtrl = BaseClass("UIWorldOccupyHistoryCtrl", UIBaseCtrl)

function UIWorldOccupyHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldOccupyHistory)
end

return UIWorldOccupyHistoryCtrl
