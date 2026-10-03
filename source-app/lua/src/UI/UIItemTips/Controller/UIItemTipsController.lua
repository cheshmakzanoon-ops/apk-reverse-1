local UIItemTipsController = BaseClass("UIItemTipsController", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIItemTips)
end

UIItemTipsController.CloseSelf = CloseSelf
return UIItemTipsController
