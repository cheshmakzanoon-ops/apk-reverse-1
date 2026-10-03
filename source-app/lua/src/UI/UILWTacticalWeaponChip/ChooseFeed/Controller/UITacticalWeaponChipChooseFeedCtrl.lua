local UITacticalWeaponChipChooseFeedCtrl = BaseClass("UITacticalWeaponChipChooseFeedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponChipChooseFeed)
  EventManager:GetInstance():Broadcast(EventId.TacticalChipSaveFeed)
end

UITacticalWeaponChipChooseFeedCtrl.CloseSelf = CloseSelf
return UITacticalWeaponChipChooseFeedCtrl
