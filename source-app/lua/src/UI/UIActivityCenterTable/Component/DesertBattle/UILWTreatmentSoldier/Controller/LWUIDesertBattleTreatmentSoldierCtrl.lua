local LWUIDesertBattleTreatmentSoldierCtrl = BaseClass("LWUIDesertBattleTreatmentSoldierCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIDesertBattleTreatmentSoldierCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDesertBattleTreatmentSoldier)
end

return LWUIDesertBattleTreatmentSoldierCtrl
