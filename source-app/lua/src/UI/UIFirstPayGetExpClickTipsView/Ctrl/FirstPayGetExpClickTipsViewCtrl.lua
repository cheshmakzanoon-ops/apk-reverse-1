local FirstPayGetExpClickTipsViewCtrl = BaseClass("FirstPayGetExpClickTipsViewCtrl", UIBaseCtrl)

function FirstPayGetExpClickTipsViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.FirstPayGetExpClickTipsView)
end

return FirstPayGetExpClickTipsViewCtrl
