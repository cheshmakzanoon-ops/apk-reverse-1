local LWActivityArenaRulesCtrl = BaseClass("LWActivityArenaRulesCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRules)
end

LWActivityArenaRulesCtrl.CloseSelf = CloseSelf
return LWActivityArenaRulesCtrl
