local AllyDrillUpdateBossTipCtrl = BaseClass("AllyDrillUpdateBossTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.AllyDrillUpdateBoss)
end

AllyDrillUpdateBossTipCtrl.CloseSelf = CloseSelf
return AllyDrillUpdateBossTipCtrl
