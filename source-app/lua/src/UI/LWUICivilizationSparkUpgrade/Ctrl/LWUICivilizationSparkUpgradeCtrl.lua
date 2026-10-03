local LWUICivilizationSparkUpgradeCtrl = BaseClass("LWUICivilizationSparkUpgradeCtrl", UIBaseCtrl)

function LWUICivilizationSparkUpgradeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUICivilizationSparkUpgrade)
end

return LWUICivilizationSparkUpgradeCtrl
