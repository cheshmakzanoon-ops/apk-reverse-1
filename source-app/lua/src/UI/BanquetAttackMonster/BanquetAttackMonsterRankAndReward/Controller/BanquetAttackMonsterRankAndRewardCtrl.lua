local BanquetAttackMonsterRankAndRewardCtrl = BaseClass("BanquetAttackMonsterRankAndRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.BanquetAttackMonsterRankAndReward)
end

BanquetAttackMonsterRankAndRewardCtrl.CloseSelf = CloseSelf
return BanquetAttackMonsterRankAndRewardCtrl
