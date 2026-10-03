local UIOfficialMessageBarCtrl = BaseClass("UIOfficialMessageBarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIOfficialMessageBar, {anim = true, playEffect = false})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIOfficialMessageBarCtrl.CloseSelf = CloseSelf
UIOfficialMessageBarCtrl.Close = Close
return UIOfficialMessageBarCtrl
