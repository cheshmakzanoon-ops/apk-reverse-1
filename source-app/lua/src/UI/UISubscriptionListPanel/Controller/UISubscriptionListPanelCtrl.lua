local UISubscriptionListPanelCtrl = BaseClass("UISubscriptionListPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISubscriptionListPanel)
end

UISubscriptionListPanelCtrl.CloseSelf = CloseSelf
return UISubscriptionListPanelCtrl
