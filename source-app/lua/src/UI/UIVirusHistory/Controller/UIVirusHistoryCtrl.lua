local UIVirusHistoryCtrl = BaseClass("UIVirusHistoryCtrl", UIBaseCtrl)

function UIVirusHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVirusHistory)
end

return UIVirusHistoryCtrl
