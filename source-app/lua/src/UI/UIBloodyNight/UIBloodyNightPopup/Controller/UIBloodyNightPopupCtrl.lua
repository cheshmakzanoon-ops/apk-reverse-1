local UIBloodyNightPopupCtrl = BaseClass("UIBloodyNightPopupCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBloodyNightPopup)
end

UIBloodyNightPopupCtrl.CloseSelf = CloseSelf
return UIBloodyNightPopupCtrl
