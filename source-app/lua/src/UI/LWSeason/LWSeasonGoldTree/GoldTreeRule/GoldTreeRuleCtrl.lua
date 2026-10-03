local GoldTreeRuleCtrl = BaseClass("GoldTreeRuleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.GoldTreeRule)
end

GoldTreeRuleCtrl.CloseSelf = CloseSelf
return GoldTreeRuleCtrl
