local BanquetAttackMonsterTaskCtrl = BaseClass("BanquetAttackMonsterTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BanquetAttackMonsterTask)
end

BanquetAttackMonsterTaskCtrl.CloseSelf = CloseSelf
return BanquetAttackMonsterTaskCtrl
