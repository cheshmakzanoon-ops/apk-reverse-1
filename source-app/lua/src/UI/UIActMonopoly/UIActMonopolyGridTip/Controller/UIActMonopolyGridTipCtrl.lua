local UIActMonopolyGridTipCtrl = BaseClass("UIActMonopolyGridTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyGridTip)
end

UIActMonopolyGridTipCtrl.CloseSelf = CloseSelf
return UIActMonopolyGridTipCtrl
