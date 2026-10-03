local LFChampionBattleBettingrecordController = BaseClass("LFChampionBattleBettingrecordController", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ChampionBattleBettingrecord)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

LFChampionBattleBettingrecordController.CloseSelf = CloseSelf
LFChampionBattleBettingrecordController.Close = Close
return LFChampionBattleBettingrecordController
