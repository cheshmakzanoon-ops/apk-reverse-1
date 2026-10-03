local UILWSalaHeroPopCtrl = BaseClass("UILWSalaHeroPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSalaHeroPop)
end

UILWSalaHeroPopCtrl.CloseSelf = CloseSelf
return UILWSalaHeroPopCtrl
