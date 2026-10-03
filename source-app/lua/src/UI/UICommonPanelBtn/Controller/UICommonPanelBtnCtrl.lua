local UICommonPanelBtnCtrl = BaseClass("UICommonPanelBtnCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonPanelBtn)
end

UICommonPanelBtnCtrl.CloseSelf = CloseSelf
return UICommonPanelBtnCtrl
