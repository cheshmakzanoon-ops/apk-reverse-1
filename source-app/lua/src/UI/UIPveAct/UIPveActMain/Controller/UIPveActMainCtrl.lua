local UIPveActMainCtrl = BaseClass("UIPveActMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveActMain)
end

UIPveActMainCtrl.CloseSelf = CloseSelf
return UIPveActMainCtrl
