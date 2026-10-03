local LWUIRollTreasureCtrl = BaseClass("LWUIRollTreasureCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIRollTreasure)
end

LWUIRollTreasureCtrl.CloseSelf = CloseSelf
return LWUIRollTreasureCtrl
