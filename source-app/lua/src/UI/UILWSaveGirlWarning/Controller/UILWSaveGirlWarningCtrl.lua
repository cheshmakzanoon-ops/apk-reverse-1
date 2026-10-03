local UILWSaveGirlWarningCtrl = BaseClass("UILWSaveGirlWarningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSaveGirlWarning, {anim = false})
end

UILWSaveGirlWarningCtrl.CloseSelf = CloseSelf
return UILWSaveGirlWarningCtrl
