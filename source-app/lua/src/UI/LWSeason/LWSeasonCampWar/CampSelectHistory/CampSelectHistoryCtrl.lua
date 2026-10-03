local CampSelectHistoryCtrl = BaseClass("CampSelectHistoryCtrl", UIBaseCtrl)

function CampSelectHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CampSelectHistory)
end

return CampSelectHistoryCtrl
