local UIActContinuePayRewardNoticePanelCtrl = BaseClass("UIActContinuePayRewardNoticePanelCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActContinuePayRewardNoticePanel)
end

UIActContinuePayRewardNoticePanelCtrl.CloseSelf = CloseSelf
return UIActContinuePayRewardNoticePanelCtrl
