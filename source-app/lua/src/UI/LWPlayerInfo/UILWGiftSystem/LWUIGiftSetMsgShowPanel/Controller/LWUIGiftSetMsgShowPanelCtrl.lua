local LWUIGiftSetMsgShowPanelCtrl = BaseClass("LWUIGiftSetMsgShowPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftSetMsgShowPanel)
end

LWUIGiftSetMsgShowPanelCtrl.CloseSelf = CloseSelf
return LWUIGiftSetMsgShowPanelCtrl
