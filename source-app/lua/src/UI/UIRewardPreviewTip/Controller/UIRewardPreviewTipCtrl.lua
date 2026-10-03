local UIRewardPreviewTipCtrl = BaseClass("UIRewardPreviewTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRewardPreviewTip)
end

UIRewardPreviewTipCtrl.CloseSelf = CloseSelf
return UIRewardPreviewTipCtrl
