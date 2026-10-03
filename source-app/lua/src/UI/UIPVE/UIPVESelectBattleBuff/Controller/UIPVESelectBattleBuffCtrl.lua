local UIPVESelectBattleBuffCtrl = BaseClass("UIPVESelectBattleBuffCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectBattleBuff)
end

UIPVESelectBattleBuffCtrl.CloseSelf = CloseSelf
return UIPVESelectBattleBuffCtrl
