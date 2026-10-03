local UILWDominatorGorillaTreatmentCtrl = BaseClass("UILWDominatorGorillaTreatmentCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UILWDominatorGorillaTreatmentCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorGorillaTreatment)
end

return UILWDominatorGorillaTreatmentCtrl
