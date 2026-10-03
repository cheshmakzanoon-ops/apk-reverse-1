local LWPropUsePanelCtrl = BaseClass("LWMainUICtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWPropUsePanel)
end

LWPropUsePanelCtrl.CloseSelf = CloseSelf
return LWPropUsePanelCtrl
