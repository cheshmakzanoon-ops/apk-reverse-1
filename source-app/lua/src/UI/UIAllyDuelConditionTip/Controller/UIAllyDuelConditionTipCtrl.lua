local UIAllyDuelConditionTipCtrl = BaseClass("UIAllyDuelConditionTip", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelConditionTip)
end

UIAllyDuelConditionTipCtrl.CloseSelf = CloseSelf
return UIAllyDuelConditionTipCtrl
