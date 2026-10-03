local LWCompleteImmdiatelyPanelCtrl = BaseClass("LWCompleteImmdiatelyPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.CompleteImmdiatelyPanel)
end

LWCompleteImmdiatelyPanelCtrl.CloseSelf = CloseSelf
return LWCompleteImmdiatelyPanelCtrl
