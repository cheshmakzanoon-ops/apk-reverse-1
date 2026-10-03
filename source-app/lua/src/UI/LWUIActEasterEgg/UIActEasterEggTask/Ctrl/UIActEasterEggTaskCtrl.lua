local UIActEasterEggTaskCtrl = BaseClass("UIActEasterEggTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEasterEggTask)
end

UIActEasterEggTaskCtrl.CloseSelf = CloseSelf
return UIActEasterEggTaskCtrl
