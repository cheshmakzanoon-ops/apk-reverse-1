local UILWArena3V3PopupCtrl = BaseClass("UILWArena3V3PopupCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArena3V3Popup)
end

UILWArena3V3PopupCtrl.CloseSelf = CloseSelf
return UILWArena3V3PopupCtrl
