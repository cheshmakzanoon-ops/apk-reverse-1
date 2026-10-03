local UIActContinuePayRewardPreviewPanelCtrl = BaseClass("UIActContinuePayRewardPreviewPanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActContinuePayRewardPreviewPanel)
end

UIActContinuePayRewardPreviewPanelCtrl.CloseSelf = CloseSelf
return UIActContinuePayRewardPreviewPanelCtrl
