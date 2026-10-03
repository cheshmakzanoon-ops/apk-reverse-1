local UIMysteryTreasureChestInfoCtrl = BaseClass("UIMysteryTreasureChestInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMysteryTreasureChest)
end

local function Close(self)
end

UIMysteryTreasureChestInfoCtrl.CloseSelf = CloseSelf
UIMysteryTreasureChestInfoCtrl.Close = Close
return UIMysteryTreasureChestInfoCtrl
