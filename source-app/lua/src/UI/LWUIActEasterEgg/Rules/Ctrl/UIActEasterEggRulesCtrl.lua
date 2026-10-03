local UIActEasterEggRulesCtrl = BaseClass("UIActEasterEggRulesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEasterEggRules)
end

UIActEasterEggRulesCtrl.CloseSelf = CloseSelf
return UIActEasterEggRulesCtrl
