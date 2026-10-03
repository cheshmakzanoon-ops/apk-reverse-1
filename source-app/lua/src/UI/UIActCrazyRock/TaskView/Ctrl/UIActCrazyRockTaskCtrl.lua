local UIActCrazyRockTaskCtrl = BaseClass("UIActCrazyRockTaskCtrl", UIBaseCtrl)

function UIActCrazyRockTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCrazyRockTask)
end

return UIActCrazyRockTaskCtrl
