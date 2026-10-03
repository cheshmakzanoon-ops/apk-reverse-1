local FirstPayGetExpHistoryTipsViewCtrl = BaseClass("FirstPayGetExpHistoryTipsViewCtrl", UIBaseCtrl)

function FirstPayGetExpHistoryTipsViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FirstPayGetExpHistoryTipsView)
end

return FirstPayGetExpHistoryTipsViewCtrl
