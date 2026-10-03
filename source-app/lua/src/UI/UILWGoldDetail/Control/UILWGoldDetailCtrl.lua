local UILWGoldDetailCtrl = BaseClass("UILWGoldDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGoldDetail)
end

UILWGoldDetailCtrl.CloseSelf = CloseSelf
return UILWGoldDetailCtrl
