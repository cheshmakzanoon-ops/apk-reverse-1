local UIPveBattleSoldierListCtrl = BaseClass("UIPveBattleSoldierListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPveBattleSoldierList)
end

UIPveBattleSoldierListCtrl.CloseSelf = CloseSelf
return UIPveBattleSoldierListCtrl
