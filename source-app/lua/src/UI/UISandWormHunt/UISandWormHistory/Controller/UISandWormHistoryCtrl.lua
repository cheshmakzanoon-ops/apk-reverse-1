local UISandWormHistoryCtrl = BaseClass("UISandWormHistoryCtrl", UIBaseCtrl)

function UISandWormHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISandWormHistory)
end

return UISandWormHistoryCtrl
