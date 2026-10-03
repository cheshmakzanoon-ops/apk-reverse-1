local PresidentHistoryCtrl = BaseClass("PresidentHistoryCtrl", UIBaseCtrl)

function PresidentHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentPresidentHistory)
end

return PresidentHistoryCtrl
