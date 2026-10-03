local UIGiftScoreTipsController = BaseClass("UIGiftScoreTipsController", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGiftScoreTips)
end

UIGiftScoreTipsController.CloseSelf = CloseSelf
return UIGiftScoreTipsController
