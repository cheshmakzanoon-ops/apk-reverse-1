local LWUIGiftAnimPanelCtrl = BaseClass("LWUIGiftAnimPanelCtrl", UIBaseCtrl)

function LWUIGiftAnimPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftAnimPanel)
end

function LWUIGiftAnimPanelCtrl:OnCustomKeyCodeEscape()
  DataCenter.GiftSystemManager:ExitSendGiftAnim(true)
end

return LWUIGiftAnimPanelCtrl
