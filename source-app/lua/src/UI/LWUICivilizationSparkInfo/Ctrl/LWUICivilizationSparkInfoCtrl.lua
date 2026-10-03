local LWUICivilizationSparkInfoCtrl = BaseClass("LWUICivilizationSparkInfoCtrl", UIBaseCtrl)

function LWUICivilizationSparkInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUICivilizationSparkInfo)
end

return LWUICivilizationSparkInfoCtrl
