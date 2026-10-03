local UIActCrazyRockRewardPreviewCtrl = BaseClass("UIActCrazyRockRewardPreviewCtrl", UIBaseCtrl)

function UIActCrazyRockRewardPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActCrazyRockRewardPreview)
end

return UIActCrazyRockRewardPreviewCtrl
