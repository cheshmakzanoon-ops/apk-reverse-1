local UITacticalEquipItemTipsCtrl = BaseClass("UITacticalEquipItemTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipItemTips)
end

UITacticalEquipItemTipsCtrl.CloseSelf = CloseSelf
return UITacticalEquipItemTipsCtrl
