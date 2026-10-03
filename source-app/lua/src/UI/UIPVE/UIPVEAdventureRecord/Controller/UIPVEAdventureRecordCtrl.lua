local UIPVEAdventureRecordCtrl = BaseClass("UIPVEAdventureRecordCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEAdventureRecord)
end

UIPVEAdventureRecordCtrl.CloseSelf = CloseSelf
return UIPVEAdventureRecordCtrl
