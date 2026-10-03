local UIItemRevertHistoryCtrl = BaseClass("UIItemRevertHistoryCtrl", UIBaseCtrl)

function UIItemRevertHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemRevertHistory)
end

return UIItemRevertHistoryCtrl
