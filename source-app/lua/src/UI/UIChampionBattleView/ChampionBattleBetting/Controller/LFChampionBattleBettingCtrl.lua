local LFChampionBattleBettingCtrl = BaseClass("LFChampionBattleBettingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ChampionBattleBetting)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LFChampionBattleBettingCtrl.CloseSelf = CloseSelf
LFChampionBattleBettingCtrl.Close = Close
return LFChampionBattleBettingCtrl
