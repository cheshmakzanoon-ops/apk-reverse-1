local UIPVEHeroAppearOtherCtrl = BaseClass("UIPVEHeroAppearOtherCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEHeroAppearOther)
end

UIPVEHeroAppearOtherCtrl.CloseSelf = CloseSelf
return UIPVEHeroAppearOtherCtrl
