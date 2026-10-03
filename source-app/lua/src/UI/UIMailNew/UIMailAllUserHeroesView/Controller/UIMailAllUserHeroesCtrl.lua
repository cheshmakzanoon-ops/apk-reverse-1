local ctrl = BaseClass("ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailAllUserHeroesView)
end

ctrl.CloseSelf = CloseSelf
return ctrl
