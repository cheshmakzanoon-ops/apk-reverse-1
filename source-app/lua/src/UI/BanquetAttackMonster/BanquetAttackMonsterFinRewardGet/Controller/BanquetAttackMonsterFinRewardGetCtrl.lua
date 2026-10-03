local BanquetAttackMonsterFinRewardGetCtrl = BaseClass("BanquetAttackMonsterFinRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.BanquetAttackMonsterFinRewardGet)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function OnCustomKeyCodeEscape(self)
end

BanquetAttackMonsterFinRewardGetCtrl.CloseSelf = CloseSelf
BanquetAttackMonsterFinRewardGetCtrl.Close = Close
BanquetAttackMonsterFinRewardGetCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return BanquetAttackMonsterFinRewardGetCtrl
