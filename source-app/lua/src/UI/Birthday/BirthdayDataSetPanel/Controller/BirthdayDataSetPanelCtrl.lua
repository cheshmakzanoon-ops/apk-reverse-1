local BirthdayDataSetPanelCtrl = BaseClass("BirthdayDataSetPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function BirthdayDataSetPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BirthdayDataSetPanel)
end

return BirthdayDataSetPanelCtrl
