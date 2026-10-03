local UIPVEHeroAppearCtrl = BaseClass("UIPVEHeroAppearCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEHeroAppear)
end

UIPVEHeroAppearCtrl.CloseSelf = CloseSelf
return UIPVEHeroAppearCtrl
