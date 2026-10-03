local UINpcTalkLayerCtrl = BaseClass("UINpcTalkLayerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UINpcTalkLayer)
end

UINpcTalkLayerCtrl.CloseSelf = CloseSelf
return UINpcTalkLayerCtrl
