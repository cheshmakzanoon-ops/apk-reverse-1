local BanquetAttackMonsterLevelRewardCtrl = BaseClass("BanquetAttackMonsterLevelRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BanquetAttackMonsterLevelReward)
end

BanquetAttackMonsterLevelRewardCtrl.CloseSelf = CloseSelf
return BanquetAttackMonsterLevelRewardCtrl
