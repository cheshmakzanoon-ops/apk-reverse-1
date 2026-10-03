local UILWGoldBrickDetailCtrl = BaseClass("UILWGoldBrickDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGoldBrickDetail)
end

UILWGoldBrickDetailCtrl.CloseSelf = CloseSelf
return UILWGoldBrickDetailCtrl
