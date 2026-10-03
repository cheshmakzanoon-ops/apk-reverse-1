local UIGMLogPanelCtrl = BaseClass("UIGMLogPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMLogPanel)
end

UIGMLogPanelCtrl.CloseSelf = CloseSelf
return UIGMLogPanelCtrl
