local LWUIPopupActivityDataPanelCtrl = BaseClass("LWUIPopupActivityDataPanelCtrl", UIBaseCtrl)

function LWUIPopupActivityDataPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIPopupActivityDataPanel)
end

return LWUIPopupActivityDataPanelCtrl
