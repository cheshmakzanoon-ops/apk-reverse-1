local UISplinterExchangeConfirmCtrl = BaseClass("_TEMPLATE_NAME_Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISplinterExchangeConfirm)
end

UISplinterExchangeConfirmCtrl.CloseSelf = CloseSelf
return UISplinterExchangeConfirmCtrl
