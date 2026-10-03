local UIBoxItemTipsController = BaseClass("UIBoxItemTipsController", UIBaseCtrl)

function UIBoxItemTipsController:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardChoiceBoxTips)
end

return UIBoxItemTipsController
