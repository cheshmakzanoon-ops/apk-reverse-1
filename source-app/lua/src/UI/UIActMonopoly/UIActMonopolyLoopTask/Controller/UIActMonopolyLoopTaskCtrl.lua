local UIActMonopolyLoopTaskCtrl = BaseClass("UIActMonopolyLoopTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyLoopTask)
end

UIActMonopolyLoopTaskCtrl.CloseSelf = CloseSelf
return UIActMonopolyLoopTaskCtrl
