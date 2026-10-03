local UITacticalEquipBagCtrl = BaseClass("UITacticalEquipBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipBag)
end

UITacticalEquipBagCtrl.CloseSelf = CloseSelf
return UITacticalEquipBagCtrl
