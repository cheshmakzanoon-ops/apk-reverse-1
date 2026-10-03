local UIActEasterEggRulesGamePlayCtrl = BaseClass("UIActEasterEggRulesGamePlayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEasterEggRulesGamePlay)
end

UIActEasterEggRulesGamePlayCtrl.CloseSelf = CloseSelf
return UIActEasterEggRulesGamePlayCtrl
