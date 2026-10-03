local UIHeroUniqueWeaponPreviewCtrl = BaseClass("UIHeroUniqueWeaponPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroUniqueWeaponPreview)
end

UIHeroUniqueWeaponPreviewCtrl.CloseSelf = CloseSelf
return UIHeroUniqueWeaponPreviewCtrl
