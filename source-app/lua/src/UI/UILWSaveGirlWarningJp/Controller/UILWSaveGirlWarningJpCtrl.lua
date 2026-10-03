local UILWSaveGirlWarningJpCtrl = BaseClass("UILWSaveGirlWarningJpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirlWarningJp, {anim = false})
end

UILWSaveGirlWarningJpCtrl.CloseSelf = CloseSelf
return UILWSaveGirlWarningJpCtrl
