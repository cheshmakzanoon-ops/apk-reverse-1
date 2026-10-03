local UIAttackUnitsTipsCtrl = BaseClass("UIAttackUnitsTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAttackUnitsTips)
end

UIAttackUnitsTipsCtrl.CloseSelf = CloseSelf
return UIAttackUnitsTipsCtrl
