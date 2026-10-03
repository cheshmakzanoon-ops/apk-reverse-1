local NewPeakArenaKOFBattleResultCtrl = BaseClass("NewPeakArenaKOFBattleResultCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.NewPeakArenaKOFBattleResult)
end

NewPeakArenaKOFBattleResultCtrl.CloseSelf = CloseSelf
return NewPeakArenaKOFBattleResultCtrl
