local UISunriseFoundationPopUpPanelCtrl = BaseClass("UISunriseFoundationPopUpPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISunriseFoundationPopUpPanel)
end

UISunriseFoundationPopUpPanelCtrl.CloseSelf = CloseSelf
return UISunriseFoundationPopUpPanelCtrl
