local UIPVEAdventureBuffDetailCtrl = BaseClass("UIPVEAdventureBuffDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventureBuffDetail)
end

UIPVEAdventureBuffDetailCtrl.CloseSelf = CloseSelf
return UIPVEAdventureBuffDetailCtrl
