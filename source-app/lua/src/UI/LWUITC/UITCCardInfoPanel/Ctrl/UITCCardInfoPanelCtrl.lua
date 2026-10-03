local UITCCardInfoPanelCtrl = BaseClass("UITCCardInfoPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardInfoPanel)
end

UITCCardInfoPanelCtrl.CloseSelf = CloseSelf
return UITCCardInfoPanelCtrl
