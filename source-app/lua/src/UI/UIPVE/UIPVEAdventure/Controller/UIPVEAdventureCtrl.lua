local UIPVEAdventureCtrl = BaseClass("UIPVEAdventureCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventure, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

UIPVEAdventureCtrl.CloseSelf = CloseSelf
return UIPVEAdventureCtrl
