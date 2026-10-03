local UIPVESelectBuffCtrl = BaseClass("UIPVESelectBuffCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectBuff)
end

UIPVESelectBuffCtrl.CloseSelf = CloseSelf
return UIPVESelectBuffCtrl
