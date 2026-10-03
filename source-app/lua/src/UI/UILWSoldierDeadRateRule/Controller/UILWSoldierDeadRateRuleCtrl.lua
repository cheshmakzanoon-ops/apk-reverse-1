local UILWSoldierDeadRateRuleCtrl = BaseClass("UILWSoldierDeadRateRuleCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSoldierDeadRateRule, {anim = useAnimation})
end

UILWSoldierDeadRateRuleCtrl.CloseSelf = CloseSelf
return UILWSoldierDeadRateRuleCtrl
