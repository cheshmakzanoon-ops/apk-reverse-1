local NewPeakArenaFirstOpenTipCtrl = BaseClass("NewPeakArenaFirstOpenTipCtrl", UIBaseCtrl)

local function CloseSelf(self, pvpArenaType)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.NewPeakArenaFirstOpenTip)
  if pvpArenaType == PVPArenaType.NewGaleArena then
    DataCenter.NewPeakArenaManager.arenaMainGotoTab = PVPArenaType.NewGaleArena
  else
    DataCenter.NewPeakArenaManager.arenaMainGotoTab = PVPArenaType.NewPeakArena
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PVP_ARENA, WorldTileBtnType.PVPArena)
end

NewPeakArenaFirstOpenTipCtrl.CloseSelf = CloseSelf
return NewPeakArenaFirstOpenTipCtrl
