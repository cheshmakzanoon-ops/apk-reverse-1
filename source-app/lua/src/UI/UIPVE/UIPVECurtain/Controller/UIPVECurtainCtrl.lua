local UIPVECurtainCtrl = BaseClass("UIPVECurtainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVECurtain)
end

UIPVECurtainCtrl.CloseSelf = CloseSelf
return UIPVECurtainCtrl
