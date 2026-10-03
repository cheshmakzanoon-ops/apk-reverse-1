local LWDecorationBookUpgradeCtrl = BaseClass("LWDecorationBookUpgradeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWDecorationBookUpgrade)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

LWDecorationBookUpgradeCtrl.CloseSelf = CloseSelf
LWDecorationBookUpgradeCtrl.Close = Close
return LWDecorationBookUpgradeCtrl
