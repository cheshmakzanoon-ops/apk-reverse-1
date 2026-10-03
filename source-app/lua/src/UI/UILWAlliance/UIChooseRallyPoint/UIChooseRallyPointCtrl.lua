local UIChooseRallyPointCtrl = BaseClass("UIChooseRallyPointCtrl", UIBaseCtrl)

function UIChooseRallyPointCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChooseRallyPoint)
end

return UIChooseRallyPointCtrl
