local BanquetAttackMonsterRateRewardCtrl = BaseClass("BanquetAttackMonsterRateRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BanquetAttackMonsterRateReward)
end

BanquetAttackMonsterRateRewardCtrl.CloseSelf = CloseSelf
return BanquetAttackMonsterRateRewardCtrl
