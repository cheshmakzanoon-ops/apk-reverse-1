local FirstPayGetExpHistoryPopViewCtrl = BaseClass("FirstPayGetExpHistoryPopViewCtrl", UIBaseCtrl)

function FirstPayGetExpHistoryPopViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FirstPayGetExpHistoryPopView)
end

return FirstPayGetExpHistoryPopViewCtrl
