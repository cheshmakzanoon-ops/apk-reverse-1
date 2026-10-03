local UIActContinuePayLackPanelCtrl = BaseClass("UIActContinuePayLackPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActContinuePayLackPanel)
end

UIActContinuePayLackPanelCtrl.CloseSelf = CloseSelf
return UIActContinuePayLackPanelCtrl
