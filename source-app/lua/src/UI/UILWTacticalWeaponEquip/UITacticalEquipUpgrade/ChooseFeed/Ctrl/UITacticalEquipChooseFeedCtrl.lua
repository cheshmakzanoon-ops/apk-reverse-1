local UITacticalEquipChooseFeedCtrl = BaseClass("UITacticalEquipChooseFeedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalEquipChooseFeed)
end

UITacticalEquipChooseFeedCtrl.CloseSelf = CloseSelf
return UITacticalEquipChooseFeedCtrl
