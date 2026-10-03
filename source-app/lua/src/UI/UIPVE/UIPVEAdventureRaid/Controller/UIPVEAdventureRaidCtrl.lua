local UIPVEAdventureRaidCtrl = BaseClass("UIPVEAdventureRaidCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventureRaid)
end

UIPVEAdventureRaidCtrl.CloseSelf = CloseSelf
return UIPVEAdventureRaidCtrl
