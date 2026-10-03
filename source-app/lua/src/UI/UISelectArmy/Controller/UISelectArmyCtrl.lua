local UISelectArmyCtrl = BaseClass("UISelectArmyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISelectArmy)
end

UISelectArmyCtrl.CloseSelf = CloseSelf
return UISelectArmyCtrl
