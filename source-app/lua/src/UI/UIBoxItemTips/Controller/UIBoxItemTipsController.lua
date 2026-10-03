local UIBoxItemTipsController = BaseClass("UIBoxItemTipsController", UIBaseCtrl)

function UIBoxItemTipsController:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBoxItemTips)
end

return UIBoxItemTipsController
