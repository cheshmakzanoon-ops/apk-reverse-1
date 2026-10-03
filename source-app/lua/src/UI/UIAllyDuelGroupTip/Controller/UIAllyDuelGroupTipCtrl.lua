local UIAllyDuelGroupTipCtrl = BaseClass("UIAllyDuelGroupTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDuelGroupTip)
end

UIAllyDuelGroupTipCtrl.CloseSelf = CloseSelf
return UIAllyDuelGroupTipCtrl
