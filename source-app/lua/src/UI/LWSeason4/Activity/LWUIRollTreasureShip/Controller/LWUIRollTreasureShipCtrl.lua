local LWUIRollTreasureShipCtrl = BaseClass("LWUIRollTreasureShipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIRollTreasureShip)
end

LWUIRollTreasureShipCtrl.CloseSelf = CloseSelf
return LWUIRollTreasureShipCtrl
